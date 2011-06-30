module Tintie
  class TasksController < ::ApplicationController
    
    respond_to :html, :xml, :json
    
    def index
      respond_with(@tasks = Task.all)
    end
    
    def new
      respond_with(@task = Task.new(:task_list_id => current_user.franchise.id,
                                    :completed => false,
                                    :priority => false,
                                    :created_by => current_user.id,
                                    :user_id => current_user.id))
    end
    
    def create
      @task = Task.create(params[:task])
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