class CollectionDecorator < ApplicationDecorator
  decorates :collection
  decorates_association :user
  def name 
    case
    when collection.public? then "Public"
    when collection.private? then "Private"
    else collection.name
    end
  end
end
