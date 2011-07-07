// var App = {
//     Views: {},
//     Controllers: {},
//     init: function() {
//         new App.Controllers.Tasks();
//         Backbone.history.start();
//     }
// };

//jQuery when DOM loads run this
$(function(){
  
  //Backbone Model
	$("#form").slideUp();

  window.Task = Backbone.Model.extend({
    url: function() {
      return this.id ? '/tasks/' + this.id : '/tasks'; //Ternary, look it up if you aren't sure
    },
  
    initialize: function(){
      //Can be used to initialize Model attributes
    },

    toggle: function() {
      this.save({completed: !this.get("completed")});
    },

    togglePriority: function() {
      this.save({priority: !this.get("priority")});
    }
  });

  //Collection

  window.TaskCollection = Backbone.Collection.extend({
    model: Task,
    url: '/tasks',

		comparator: function(task) {
			return task.get('completed') + -task.get('priority') + task.get('due_date');
		},
		
		today: function() {  
		  return this.filter(function(task) {
			  var yesterday = new Date();  
				yesterday.setTime(yesterday.getTime()-86400000);
		    return task.get('due_date') > yesterday;  
		  });  
		},
		
		priority: function(){
			return this.filter(function(task){
				return task.get("priority") === true; 
			});
		}
		
  });

  window.Tasks = new TaskCollection;

	//View

  window.TaskView = Backbone.View.extend({
		tagName: "div",
		className: "task_holder",
  
    events: { 
      //Can be used for handling events on the template
			"click .checkbox"             : "toggleDone",
			"click .flag"                 : "togglePriority"
    },
  
    initialize: function(){
      this.render();
    },
  
    render: function(){
      var task = this.model.toJSON();
      //Template stuff goes here
      $(this.el).html(ich.task_template(task));
      return this;
    },
    

		toggleDone: function(){
			this.model.toggle();
		},
		
		togglePriority: function(){
			this.model.togglePriority();
			var flag = this.$(".flag");
			var task_holder = $(this.el);
			
			if (flag.hasClass('flag-active')){
				// get the great granparent of the .flag-active class 
				// and move it below all the important tasks
				task_holder.hide();
				flag.removeClass('flag-active');
				var last = $('.flag-active').last().parent().parent().parent();
				last.after(task_holder);
				task_holder.slideDown("slow");
			} else {
				flag.addClass('flag-active');
				task_holder.hide();
				task_holder.prependTo('#task_holder');
				task_holder.slideDown("slow");
			}

			return false
		},
		
		filterTasks: function(e) {
			var x = Tasks.filter(function(task) { 
				return task.get("priority") === true; 
			});
			
			// Tasks.render();
			return false;
		}
  });

	window.AppView = Backbone.View.extend({
  
    el: $("#tasks_app"),
  
    events: {
      "submit form#create_task_form": "createTask",
			"click .opener"               : "openTask",
			"click .view"                 : "viewTask",
			"click .edit"                 : "editTask",
			"keypress #search"            : 'filterSearch',
			"click .today"                : "filterTasks",
			"click .btn-close"            : "closeForm",
			"click #task_create"          : "showCreateForm"
    },
  
    initialize: function(){
      _.bindAll(this, 'addOne', 'addAll');
      
      Tasks.bind('add', this.addOne);
      Tasks.bind('refresh', this.addAll);
      Tasks.bind('all', this.render);
      
      Tasks.fetch(); //This Gets the Model from the Server
    },
    
    addOne: function(task) {
      var view = new TaskView({model: task});
			this.$("#task_holder").append(view.render().el);
			
			if (task.attributes.priority){
				this.$('.flag').addClass('flag-active');
			}
    },
    
    addAll: function(){
      Tasks.each(this.addOne);
    },
    
    newAttributes: function(event) {
			
      return { task: {
        task_list_id: event["task[task_list_id]"],
				user_id: event["task[user_id]"],
				created_by: event["task[created_by]"],
				priority: event["task[priority]"],
				completed: event["task[completed]"],
				type: event["type"],
				due_date: event["task[due_date]"],
				title: event["task[title]"],
        description: event["task[description]"]
      }}
    },
    
    createTask: function(e) {
      e.preventDefault(); //This prevents the form from submitting normally

			var values = {};
			$.each($('form#create_task_form').serializeArray(), function(i, field) {
			  values[field.name] = field.value;
			});
      
      var params = this.newAttributes(values);
			// console.log("HERE!");
      
			Tasks.create(params);
			$("#form").slideUp();
    },

		openTask: function(targ) {
			var id = targ.currentTarget.id;
			var opener = this.$("#slide_" + id);
			var slideSpeed = 500;
			var slideHolder = $("task_row_" + id);
			
			if (opener.hasClass('slide-active')){
				opener.css({overflow:'hidden'});
				opener.slideUp(slideSpeed);
				opener.removeClass('slide-active');
			} else {
				opener.slideDown(slideSpeed, function(){
					opener.css({overflow:'visibile'});
				})
				opener.addClass('slide-active');
			}
			
			return false; // Make sure it does not redirect anywhere
		},
		
		viewTask: function(e){
			e.preventDefault();
			$.fancybox({
				'type': 'iframe',
				'width': 650,
				'height': 500,
				'href': "http://" + window.location.host + "/tasks/" + e.currentTarget.id
			});
		},
		
		editTask: function(e){
			e.preventDefault();
			// console.log(e.currentTarget.href);
			$.fancybox({
				'type': 'iframe',
				'width': 750,
				'height': 700,
				'href': e.currentTarget.href
			});
		},
		
		filterTasks: function(e) {
			var x = Tasks.filter(function(task) { 
				return task.get("priority") === true; 
			});
			
			Tasks.render();
			return false;
		},
		
		filterSearch: function(e){
			// console.log(e);
		},
		
		showCreateForm: function(e){
			e.preventDefault();
			$("#form").slideDown("2500");
		},
		
		closeForm: function(){
			$("#form").slideUp("2500");
		}
  });

	window.App = new AppView;

});
