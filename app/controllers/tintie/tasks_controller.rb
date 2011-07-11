module Tintie
  class TasksController < ::ApplicationController
    
    respond_to :html, :xml, :json
    
    def index
      @task = Task.new(:task_list_id => current_user.franchise.id,
                                    :completed => false,
                                    :priority => false,
                                    :created_by => current_user.id,
                                    :user_id => current_user.id)
      
      respond_with(@tasks = Task.for(current_user, params))
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
      if params[:commit] == 'Update Task'
        @task = Task.find(params[:id])

        if @task.update_attributes(params[:task])
          respond_with(@task, :status => :ok)
        else
          respond_with(@task.errors, :status => :unprocessable_entity)
        end
      else
        # coming from backbone
        params.delete(:task)
        params.delete(:action)
        params.delete(:controller)

        @task = Task.find(params[:id])
        respond_with(@task.update_attributes(params))
      end
    end
    
    def edit
      respond_with(@task = Task.find(params[:id]))
    end
    
    def show
      respond_with(@task = Task.find(params[:id]))
    end

    def due_date
      respond_with(@tasks = Task.for(current_user, params))
    end
    
    def search
      respond_with(@tasks = Task.search(current_user, params))
    end
    
    private
    
    def get_user_details
      
    end
  end
end