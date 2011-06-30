module Tintie
  module Generators
    class InstallAllGenerator < Rails::Generators::Base
      source_root File.expand_path("../../../../", __FILE__)
      class_option :app,    :type => :boolean, :default => true,
                            :desc => 'Generate controller and view.'
      class_option :model,  :type => :boolean, :default => true,
                            :desc => 'Generate the Form model.'
      class_option :config, :type => :boolean, :default => true,
                            :desc => 'Generate config files.'

      desc <<-CONTENT
  This will install Tintie's model, controller, view,\
  and assets files accordingly. It will also copy the\
  routes into your routes file.

  CONTENT

      def add_tintie_routes
        tintie_routes = %(resources :task_lists, :controller => 'tintie/task_lists', :only => [:create, :update, :index, :show]\n)
        tintie_routes << %(  resources :tasks, :controller => 'tintie/tasks', :only => [:create, :update, :index, :show, :new]\n)
        route tintie_routes
      end

      def copy_app
        directory('app', 'app') if options.app?
      end
      
      def copy_model
        if options.model?
          copy_file 'lib/tintie/task.rb', 'app/models/task.rb'
          copy_file 'lib/tintie/task_list.rb', 'app/models/task_list.rb'
        end
      end
      
      def copy_config
        invoke 'tintie:install' if options.config?
      end
    end
  end
end
