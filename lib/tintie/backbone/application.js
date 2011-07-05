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

  window.Task = Backbone.Model.extend({
    url: function() {
      return this.id ? '/tasks/' + this.id : '/tasks'; //Ternary, look it up if you aren't sure
    },
  
    defaults: { task: {
      title: "Please enter a title",
			task_list_id: "",
			user_id: "",
			created_by: "",
			priority: false,
			completed: false,
			type: "",
			due_date: "",
      description: ""
    }},
  
    initialize: function(){
      //Can be used to initialize Model attributes
    }
  });

  //Collection

  window.TaskCollection = Backbone.Collection.extend({
    model: Task,
    url: '/tasks'
  });

  window.Tasks = new TaskCollection;

	//View

  window.TaskView = Backbone.View.extend({
    // tagName: "tr",
		tagName: "div",
		className: "task_holder",
  
    events: { 
      //Can be used for handling events on the template 
    },
  
    initialize: function(){
      //this.render();
    },
  
    render: function(){
      var task = this.model.toJSON();
      //Template stuff goes here
      $(this.el).html(ich.task_template(task));
      return this;
    }
  });

	window.AppView = Backbone.View.extend({
  
    el: $("#tasks_app"),
  
    events: {
      "submit form#create_task_form": "createTask",
			"click .opener": "openTask"
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
      // this.$("#task_table").append(view.render().el);
			this.$("#task_holder").append(view.render().el);
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
      
			Tasks.create(params);

    },

		openTask: function() {
			// $(this.el)
			var opener = this.$(".slide");
			
		}
  
  });

	window.App = new AppView;

});