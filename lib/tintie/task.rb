class Task < ActiveRecord::Base
  belongs_to :task_list
  belongs_to :owner, :class_name => 'User'
  belongs_to :create, :class_name => 'User'
  belongs_to :linkable, :polymorphic => true
  
  # Little hack to bypass autoloads
  Dir[File.join(File.dirname(__FILE__),"/","*_task.rb")].each do |f|
    Task.const_get(File.basename(f,'.rb').classify)
  end
  
  # override deprecated method
  def self.subclasses
    direct_descendants.map(&:name)
  end
end
