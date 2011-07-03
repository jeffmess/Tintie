module Tintie
  module Generators
    class InstallFancyboxGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)
  
      desc "This generator installs fancybox.js"
          
      class_option :skip_git, :type => :boolean, :aliases => "-G", :default => false,
                              :desc => "Skip Git ignores and keeps"

      def inject_fancybox
        inject_into_file "app/assets/stylesheets/application.css", :after => "*= require_self" do
          "\n *= require 'fancybox'"
        end
        inject_into_file "app/assets/javascripts/application.js", :before => "//= require_tree ." do
          "//= require fancybox\n"
        end
      end
    
      protected
        def application_name
          if defined?(Rails) && Rails.application
            Rails.application.class.name.split('::').first.underscore
          else
            "application"
          end
        end
    end
  end
end
