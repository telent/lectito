class StoriesController < ApplicationController
  def index
    @stories=current_user.stories
  end
end
