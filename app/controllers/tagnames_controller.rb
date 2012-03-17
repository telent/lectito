class TagnamesController < ApplicationController
  def index
    @tags=Tagnames.all(current_user)
  end
end
