Rails.application.routes.draw do
  resources :task_lists, :controller => 'tintie/task_lists', :only => [:create, :update, :index, :show]
  resources :tasks, :controller => 'tintie/tasks', :only => [:create, :update, :index, :show, :new]
end