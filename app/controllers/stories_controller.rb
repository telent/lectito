class StoriesController < ApplicationController
  def index
    page_size=20
    @page=(params[:page] || 1).to_i 
    # ask for one more than we need, so we know if there's a page following 
    # this one
    @stories=StoryDecorator.decorate(current_user.stories(1+page_size,(@page-1)*page_size).to_a)
    @next=(@stories.length > page_size) && params.merge(:page=>@page+1)
    @prev=(@page>1) &&  params.merge(:page=>@page-1)
    @stories.pop
  end
  def breadcrumb
    @breadcrumbs=[["news",stories_path]]
  end
end
