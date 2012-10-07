class UserDecorator < ApplicationDecorator
  decorates :user
  decorates_association :following
  decorates_association :followers
  decorates_association :links

  # *You* did X to Foo
  def name_or_subject_pronoun(capitalize=nil)
    if user==h.current_user then
      capitalize ? "You" : "you"
    else
      user.name
    end
  end
  # Foo did X to *you*
  # these are the same in English, but other languages differ
  def name_or_object_pronoun(capitalize=nil)
    name_or_subject_pronoun capitalize
  end

  def actions
    a=[]
    me=h.current_user
    a << h.link_to("View", h.user_path(user))
    if user==me then
      a << h.link_to("Edit", h.edit_user_path(user))
    end
    if me.following? user then
      a << h.link_to("Message", h.user_path(user))
      a << h.link_to("Unfollow", {action: :unfollow, id: self.id},{method: :post})
    elsif !(me.blocking?(user) || user.blocking?(me))
      a << h.link_to("Follow", {action: :follow, id: self.id},{method: :post})
    end
    if me.blocking? user then
      a << h.link_to("Unblock", {action: :unblock, id: self.id},{method: :post})
    else
      a << h.link_to("Block",{action: :block, id: self.id},{method: :post})
    end
    a
  end
end
