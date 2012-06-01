module ActionsHelper
  def actions_dropdown actions
    content_tag(:span, class: 'actions_dropdown') do
      content_tag(:span, "Actions", class: :title) +
      content_tag(:ul) do
        actions.map do |a| 
          concat(content_tag(:li, a))
        end
      end
    end
  end
end
