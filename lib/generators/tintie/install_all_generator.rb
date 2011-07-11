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
  The following Javascript libraries\
  1. Fancybox\
  2. Backbone.js\

  CONTENT

      def add_tintie_routes
        tintie_routes = %(resources :task_lists, :controller => 'tintie/task_lists', :only => [:create, :update, :index, :show]\n)
        tintie_routes << %(  resources :tasks, :controller => 'tintie/tasks', :only => [:create, :update, :index, :show, :new, :edit]\n)
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
      
      def copy_backbone_files
        invoke 'tintie:install_backbone'
        say_status('creating', 'Copying Tintie backbone javascript files', :green)
        copy_file 'lib/tintie/backbone/application.js', 'app/assets/javascripts/backbone/tintie.js'
        copy_file 'lib/tintie/backbone/models/task.js', 'app/assets/javascripts/backbone/models/task.js'
        copy_file 'lib/tintie/backbone/controllers/tasks.js', 'app/assets/javascripts/backbone/controllers/tasks.js'

      end
      
      def copy_fancybox_files
        invoke 'tintie:install_fancybox'
      end
      
      def inject_tintie
        inject_into_file "app/assets/javascripts/application.js", :before => "//= require_tree ." do
          "//= require tintie\n"
        end
      end
      
      def inject_date_formatter
        inject_into_file "app/assets/javascripts/application.js", :before => "//= require_tree ." do
          "//= require date_format\n"
        end
      end
    end
  end
end
