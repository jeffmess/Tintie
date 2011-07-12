class Task < ActiveRecord::Base
  belongs_to :task_list
  belongs_to :linkable, :polymorphic => true
  
  # scopes
  
  scope :completed, where(:completed => true)
  scope :incomplete, where(:completed => false)
  scope :today, where(:due_date => Time.now.beginning_of_day..Time.now.end_of_day)
  scope :tomorrow, where(:due_date => Time.now.tomorrow.beginning_of_day..Time.now.tomorrow.end_of_day)
  scope :week, where(:due_date => Time.now.beginning_of_day..7.days.from_now)
  scope :without_date, where(:due_date => nil)
  scope :later, where("due_date > ?", 7.days.from_now)
  scope :overdue, where("due_date <= ?", Time.now)
  
  scope :for_user, lambda {|u_id| where(:user_id => u_id)}
  scope :for_franchise, lambda {|franchise_id| where(:task_list_id => franchise_id)}
  
  # Little hack to bypass autoloads
  Dir[File.join(File.dirname(__FILE__),"/","*_task.rb")].each do |f|
    Task.const_get(File.basename(f,'.rb').classify)
  end
  
  # override deprecated method
  def self.subclasses
    direct_descendants.map(&:name)
  end
  
  def created_by_email
    User.find_by_id(user_id).email
  end
  
  def self.for_context(context)
    return for_franchise(context.id) if context.is_a? Franchise
    return for_user(context.id) if context.is_a? User
  end
  
  def self.for(context, options = {})
    tasks = for_context(context)
    
    if options[:completed]
      return tasks.completed if options[:completed] == "true"
      return tasks.incomplete if options[:completed] == "false"
    elsif options[:date]
      return tasks.today if options[:date] == "today"
      return tasks.tomorrow if options[:date] == "tomorrow"
      return tasks.week if options[:date] == "week"
      return tasks.later if options[:date] == "later"
      return tasks.without_date if options[:date] == "without_date"
      return tasks.overdue if options[:date] == "overdue"
    end
    
    return tasks
  end
  
  def self.search(context, search)
    tasks = for_context(context)
    
    tasks = tasks.send(search[:filter]) if (search[:filter] and search[:filter] != "all")
    if search[:q]
      tasks = tasks.where("title LIKE :q OR description LIKE :q", :q => "%#{search[:q]}%")
    end
    
    tasks
  end
end
