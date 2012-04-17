class StoriesController < ApplicationController
  def index
    page_size=20
    @page=params[:p].to_i
    events=current_user.events.order("created_at desc").
      limit(page_size).offset(@page*page_size)
    @stories=Story.for_events events
  end
end
