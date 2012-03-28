class Collection < ActiveRecord::Base
  belongs_to :user
  has_many :books
  has_and_belongs_to_many :members, :join_table=>:collection_members,
  :foreign_key=>:owner_id,
  :association_foreign_key=>:member_id,
  :class_name=>"User"
end
