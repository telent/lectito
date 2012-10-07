class User < ActiveRecord::Base
  has_many :authorizations
  has_many :shelves,:order=>"name"
  has_many :collections
  has_many :books, :through => :collections
  has_many :borrowed_books, :class_name=>"Book", :foreign_key=>:borrower_id
  has_many :tags

  has_many :links

  has_one :public_collection, :class_name=>"Collection", 
  :conditions=>{public: true}
  has_one :private_collection, :class_name=>"Collection", 
  :conditions=>{public: true}

  has_many :following_rel, :foreign_key=>"follower_id",
  :class_name => "Relationship",:dependent=>:destroy
  has_many :follower_rel, :foreign_key=>"followed_id",
  :class_name => "Relationship",:dependent=>:destroy
  has_many :following, :through => :following_rel, :source => :followed
  has_many :followers, :through => :follower_rel, :source => :follower

  def initialize(*args)
    # AR finder methods call #allocate not #new so this *shouldn't* 
    # be called on objects that are retrieved from DB, only on 
    # genuinely new ones.  But we will check anyway
    super
    if self.new_record? then
      self.public_collection||=Collection.new(public: true)
      self.private_collection||=Collection.new(private: true)
    end
  end

  def friends
    (self.collections.map(&:users).flatten +
     self.following + self.followers ).uniq
  end

  def name
    "#{nickname} (#{fullname})"
  end

  def welcome!
    Event.publish(:actor=>self,:action=>:join)
  end
  
  def events
    Event.where("actor_id=? or recipient_id=?",self.id,self.id).order("created_at desc")
  end

  def stories(limit=20,offset=0)
    story=Story.new
    Enumerator.new do |y|
      self.events.order('created_at desc').as_batches do |e|
        if story.accepts_event? e then
          story.created_at ||= e.created_at
          story.add_event e
        else
          if offset.zero?
            y << story
            limit-=1
          else
            offset-=1
          end
          break if limit.zero?
          story=Story.new
          story.add_event e
          story.created_at=e.created_at
        end
      end
      y << story
    end
  end


  def all_books
    books + borrowed_books
  end

  def tagnames
    Tagname.all(self)
  end

  def admin?
    false
  end

  def blocking?(user)
    r=Relationship.unscoped.where(removed_at: nil, follower_id: user.id,
                                  followed_id: self.id).first
    r and r.blocked_at 
  end

  def following?(user)
    r=Relationship.find_by_follower_id_and_followed_id(self.id,user.id) 
    r and !r.blocked_at
  end

  def follow(user)
    if user.blocking?(self) || self.blocking?(user) then
      raise "Blocked"
    else
      # once a user has been followed and unfollowed, a *new* relationship
      # is created if they are subsequently followed again.  Just because we 
      # think it would be useful to have the history in case of complaints
      Relationship.
        find_or_create_by_follower_id_and_followed_id(self.id,user.id)
    end
  end

  def unfollow(user)
    r=Relationship.find_by_follower_id_and_followed_id(self.id,user.id)
    r.unfollow
  end

  def block(user)
    r=Relationship.unscoped.where(removed_at: nil).find_or_create_by_follower_id_and_followed_id(user.id,self.id)
    unless r.blocked_at
      r.blocked_at=Time.now
      r.save
    end
  end

  def unblock(user)
    r=Relationship.unscoped.where(removed_at: nil).find_by_follower_id_and_followed_id(user.id,self.id)
    r and r.unblock
  end
end
