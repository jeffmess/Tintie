//= require fancybox

$(document).ready(function() {
	$("a#create_task").fancybox({
		'width' : 750,
		'height' : 500,
		'type': 'iframe',
		'onClosed'		: function() {
		  location.reload();
		}
	});

	$('#create-task').click(function() {
	  $("#create_task_form").submit(function(){
			var params = $(this).serialize();
			var self = this;
       
			$.post("/tasks", params, function(data){
				switch(data.status){
				case 1: //success
					$.fancybox.close();
					break;
				case 0: //failure
					console.log(data);
					// $("#errorMessage").html(data.message);
					break;
				}
			},
			"json"
			);
 
			return false;  
		});
	});
});