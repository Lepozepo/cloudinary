Template.body.events
	"change input.cloudinary-upload": (e) ->
		files = e.currentTarget.files;

		_.each files, (file) ->
			reader = new FileReader

			reader.onload = ->
				Cloudinary.upload reader.result

			reader.readAsDataURL file

