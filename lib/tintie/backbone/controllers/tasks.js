App.Controllers.Tasks = Backbone.Controller.extend({
	routes: {
		"tasks/:id":      "edit", 
		"tasks":          "index", 
		"tasks/new":      "newTask"
	},
	
	edit: function(id) {
		var task = new Task({id: id});
		task.fetch({
			success: function(model, resp){
				new App.Views.Edit({model: task});
			},
			error: function(){
				new Error({	message: 'Could not find that Task.'});
				window.location.hash = '#';
			}
		});
	}
	
	index: function(){
		$.getJSON('/tasks', function(data){
			if (data){
				var tasks = _(data).map(function(i) {
					return new Task(i);
				});
			} else {
				new Error({message: 'Error loading Tasks'});
			}
		});
	}
	
	newTask: function(){
		new App.Views.Edit({model: new Task()})
	}
	
});