module Tintie
  class TasksController < ::ApplicationController
    
    respond_to :html, :xml, :json
    
    def index
      @task = Task.new(:task_list_id => current_user.franchise.id,
                                    :completed => false,
                                    :priority => false,
                                    :created_by => current_user.id,
                                    :user_id => current_user.id)
                                    
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
      @task = Task.new(params[:task])

      respond_to do |format|
        if @task.save
          format.html { redirect_to(@task, :notice => 'Task was successfully created.') }
          format.json  { render :json => @task, :status => :created, :location => @task }
        else
          format.html { render :action => "new" }
          format.json  { render :json => @task.errors, :status => :unprocessable_entity }
        end
      end
    end
    
    def update
      # Better way to do this? Quite ugly.
      params.delete(:task)
      params.delete(:action)
      params.delete(:controller)

      @task = Task.find(params[:id])
      respond_with(@task.update_attributes(params))
    end
    
    def show
      respond_with(@task = Task.find(params[:id]))
    end
  end
end