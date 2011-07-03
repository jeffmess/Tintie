module Tintie
  module Generators
    class InstallBackboneGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)
  
      desc "This generator installs backbone.js with a default folder layout in app/assets/javascripts/backbone"
          
      class_option :skip_git, :type => :boolean, :aliases => "-G", :default => false,
                              :desc => "Skip Git ignores and keeps"
                                      
      def inject_backbone
        inject_into_file "app/assets/javascripts/application.js", :before => "//= require_tree" do
          "//= require underscore\n//= require backbone\n//= require backbone_rails_sync\n//= require backbone_datalink\n//= require backbone/tintie\n//= require handlebars\n"
        end
      end
    
      def create_dir_layout
        %W{controllers models views templates}.each do |dir|
          empty_directory "app/assets/javascripts/backbone/#{dir}" 
          create_file "app/assets/javascripts/backbone/#{dir}/.gitkeep" unless options[:skip_git]
        end
      end
    
      def create_app_file
        template "app.coffee", "app/assets/javascripts/backbone/tintie.coffee"
      end
      
      def copy_json_false
        backbone_rb =  'config/initializers/backbone.rb'
        create_file backbone_rb
        say_status('creating', 'backbone.rb - excludes root in json return just like Backbone likes it.', :green)
        append_to_file backbone_rb, 'ActiveRecord::Base.include_root_in_json = false'
      end
    end
  end
end
