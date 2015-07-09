# $.cloudinary.config
# 	cloud_name:"stuff"


Template.tester.events
	"change input.file_bag": (e) ->
		files = e.currentTarget.files;

		_.each files, (file) ->
			reader = new FileReader

			reader.onload = ->
				Cloudinary.upload reader.result

			reader.readAsDataURL file
