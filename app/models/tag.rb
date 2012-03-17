class Tag < ActiveRecord::Base

  # If many users have the same tag, the same tag text will appear on
  # multiple rows in this table.  But: we assume that the average tag
  # name is less than ten chars long, therefore there is no point in
  # normalising them as the foreign key field would take up probably
  # about as much space

  belongs_to :user
  belongs_to :edition
  belongs_to :book
end
