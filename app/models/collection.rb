class Collection < ActiveRecord::Base
  belongs_to :user
  has_many :books
  has_many :memberships
  has_many :users, :through=>:memberships

  validates_presence_of :name

  def add_member(user)
    raise StandardError if self.private
    self.memberships.create :user=>user
  end
  def visible_for?(user)
    case
    when (user==self.user) then true
    when self.public then true
    when self.private then false
    else self.users.where(id: user.id).exists?
    end
  end
  def self.visible_for(user)
    # ActiveRecord::Relation is frustratingly limited.  Arel is 
    # an implementation detail and effectively "deprecated" for public use.
    # No alternative here but SQL
    id=user.id.to_s
    sql="select * from collections where user_id=#{id} or public='t' or exists(select id from memberships where collection_id=collections.id and user_id=#{id})"
    Collection.find_by_sql sql
  end
end
