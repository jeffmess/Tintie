module Tintie
  class TasksController < ::ApplicationController
    
    respond_to :html, :xml, :json
    
    def index
      # Should only respond with tasks for a list.
      respond_with(@tasks = Task.all)
    end
    
    def create
      @task = Task.new(params[:task])
      respond_with(@task)
    end
    
    def update
      @task = Task.find(params[:id])
      respond_with(@task.update_attributes(params[:task]))
    end
    
    def show
      respond_with(@task = Task.find(params[:id]))
    end
  end
end