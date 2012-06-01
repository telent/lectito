class UserDecorator < ApplicationDecorator
  decorates :user
  decorates_association :following
  decorates_association :followers

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
    a << h.link_to("View", h.user_path(user))
    if user==h.current_user then
      a << h.link_to("Edit", h.edit_user_path(user))
    end
    if h.current_user.following? user then
      a << h.link_to("Message", h.user_path(user))
      a << h.link_to("Unfollow",  h.user_path(user))
    else
      a << h.link_to("Follow",  h.user_path(user))
    end
    if h.current_user.blocking? user then
      a << h.link_to("Unblock",  h.user_path(user))
    else
      a << h.link_to("Block",  h.user_path(user))
    end
    a
  end
end
