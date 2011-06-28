module Tintie
  class TaskListsController < ::ApplicationController
    
    respond_to :html, :xml, :json
    
    def index
      respond_with(@task_lists = TaskList.all)
    end
    
    def create
      @task_list = TaskList.new(params[:task_list])
      respond_with(@task_list)
    end
    
    def update
      @task_list = TaskList.find(params[:id])
      respond_with(@task_list.update_attributes(params[:task_list]))
    end
    
    def show
      respond_with(@task_list = TaskList.find(params[:id]))
    end
  end
end