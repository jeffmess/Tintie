jQuery ->
	($ 'a#create_task').fancybox({
		'width' : 750,
		'height' : 500,
		'type': 'iframe'
	})
	
	($ 'a#submit_form')
		.click( -> 
			$.ajax({
				url: '/tasks',
				type: 'post',
				dataType: 'json',
				data: ($ 'form#create_task_form').serialize(),
				success: ->
					parent.$.fancybox.close();
			})
		)
