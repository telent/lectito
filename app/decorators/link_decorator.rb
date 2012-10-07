class LinkDecorator < ApplicationDecorator
  decorates :link
  def actions
    me=h.current_user
    a=[]
    if user==me then
      a << h.link_to("Edit", h.edit_user_link_path(me,link))
      a << h.link_to("Delete", 
                     {id: self.id, action: :destroy, user_id: me.id},
                     {method: :delete})
    end
    a
  end
end
