class Task < ActiveRecord::Base
  belongs_to :task_list
  # belongs_to :owner, :class_name => 'User'
  # belongs_to :create, :class_name => 'User'
  belongs_to :linkable, :polymorphic => true
  
  scope :completed, where(:completed => true)
  scope :incomplete, where(:completed => false)
  scope :today, where(:due_date => Time.now.beginning_of_day..Time.now.end_of_day)
  scope :tomorrow, where(:due_date => Time.now.beginning_of_day..Time.now.tomorrow.end_of_day)
  scope :week, where(:due_date => Time.now.beginning_of_day..7.days.from_now)
  scope :without_date, where(:due_date => nil)
  scope :later, where("due_date > ?", 7.days.from_now)
  scope :overdue, where("due_date <= ?", Time.now)
  
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
  
  def self.for_franchise(franchise_id)
    return Task.where(:task_list_id => franchise_id)
  end
  
  def self.for(user, options = {})
    if options[:completed]
      return Task.for_franchise(user.franchise.id).completed if options[:completed] == "true"
      return Task.for_franchise(user.franchise.id).incomplete if options[:completed] == "false"
    elsif options[:date]
      return Task.for_franchise(user.franchise.id).today if options[:date] == "today"
      return Task.for_franchise(user.franchise.id).tomorrow if options[:date] == "tomorrow"
      return Task.for_franchise(user.franchise.id).week if options[:date] == "week"
      return Task.for_franchise(user.franchise.id).later if options[:date] == "later"
      return Task.for_franchise(user.franchise.id).without_date if options[:date] == "without_date"
      return Task.for_franchise(user.franchise.id).overdue if options[:date] == "overdue"
    end
    return Task.where(:task_list_id => user.franchise.id)
  end
  
  def self.search(user, search)
    if search[:filter] and search[:filter] != "all"
      tasks = Task.for_franchise(user.franchise.id).send(search[:filter])
    else
      tasks = Task.for_franchise(user.franchise.id)
    end
    
    if search[:q]
      tasks = tasks.where("title LIKE :q OR description LIKE :q", :q => "%#{search[:q]}%")
    end
    tasks
  end
end
