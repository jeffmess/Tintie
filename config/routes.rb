Rails.application.routes.draw do
  resources :task_lists, :controller => 'tintie/task_lists', :only => [:create, :update, :index, :show]
  
  scope :path => '/tasks', :controller => 'tintie/tasks' do
    match 'due_date' => :due_date
    match 'search/:q' => :search
  end
  
  scope :path => '/my_tasks', :controller => 'tintie/tasks' do
    match '' => :index
    match 'due_date' => :due_date
    match 'search/:q' => :search
  end
  
  resources :tasks, :controller => 'tintie/tasks', :only => [:create, :update, :index, :show, :new, :edit]
end