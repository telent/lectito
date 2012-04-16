class User < ActiveRecord::Base
  has_many :authorizations
  has_many :shelves,:order=>"name"
  has_many :collections
  has_many :books, :through => :collections
  has_many :borrowed_books, :class_name=>"Book", :foreign_key=>:borrower_id
  has_many :tags

  # this bidirectional relationship appears impossible to do with 
  # hm:t because it assumes the join table always has a primary key
  has_and_belongs_to_many :followers,:join_table=>:followlinks, 
  :class_name=>"User",
  :foreign_key=>:followed_id,
  :association_foreign_key=>:follower_id
  has_and_belongs_to_many :following,:join_table=>:followlinks, 
  :class_name=>"User",
  :foreign_key=>:follower_id,
  :association_foreign_key=>:followed_id

  has_many :following_rel, :foreign_key=>"follower_id",
  :class_name => "Relationship",:dependent=>:destroy
  has_many :follower_rel, :foreign_key=>"followed_id",
  :class_name => "Relationship",:dependent=>:destroy
  has_many :following, :through => :following_rel, :source => :followed
  has_many :followers, :through => :follower_rel, :source => :follower

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
  
  def stories
    s=[]
    story=Story.new
    events=Event.where("actor_id=? or recipient_id=?",self.id,self.id)
    if events then
      story.created_at=events[0].created_at
      events.each do |e|
        if story.accepts_event? e
          story.add_event e
        else
          story.finish
          s << story
          story=Story.new
          story.add_event e
          story.created_at=e.created_at
        end
      end
      story.finish
      s << story
    end
    s
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

  def follow(user)
    # blocked?  don't follow if blocked
    r=Relationship.unscoped.where(:follower_id=>self.id,:followed_id=>user.id).first
    if r && r.blocked? then
      raise "Blocked"
    else
      # once a user has been followed and unfollowed, a *new* relationship
      # is created if they are subsequently followed again.  Just because we 
      # think it would be useful to have the history in case of complaints
      Relationship.find_or_create_by_follower_id_and_followed_id(self.id,user.id)
    end
  end

  def following?(user)
    Relationship.find_by_follower_id_and_followed_id(self.id,user.id) 
  end

  def block(user)
    r=Relationship.unscoped.find_or_create_by_follower_id_and_followed_id(user.id,self.id)
    unless r.blocked?
      r.blocked_at=Time.now
      r.save
    end
  end
end
