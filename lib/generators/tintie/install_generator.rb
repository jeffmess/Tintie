module Tintie
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      
      source_root File.expand_path("../../templates", __FILE__)

      desc <<-CONTENT
        Adds the models task.rb and task_list.rb to your 
        app/models folder.
        
        It also adds the migration file. Once you have run 
        the installer please run rake db:migrate

  CONTENT

      def self.next_migration_number(dirname) #:nodoc:
        if ActiveRecord::Base.timestamped_migrations
          Time.now.utc.strftime("%Y%m%d%H%M%S")
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
      end

      def create_migration_file
        migration_template 'migration.rb', 'db/migrate/create_tasks_table.rb'
      end
    end
  end
end
