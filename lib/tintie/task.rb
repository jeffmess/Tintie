class Task < ActiveRecord::Base
  belongs_to :task_list
  belongs_to :owner, :class_name => 'User'
  belongs_to :create, :class_name => 'User'
  belongs_to :linkable, :polymorphic => true
end
