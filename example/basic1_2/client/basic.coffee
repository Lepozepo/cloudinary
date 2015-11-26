$.cloudinary.config
	cloud_name: 'cloud_name'
	api_key: 'api_key'

Template.tester.events
	"change input.file_bag": (e) ->
		files = e.currentTarget.files

		Cloudinary.upload files,
			folder:"secret" # optional parameters described in http://cloudinary.com/documentation/upload_images#remote_upload
			type:"private" # optional, makes the image inaccesible after 1 hour at that particular route (if you want full privacy you need to pay for authenticated URLs and use the 'authenticated' option)
			(err,res) -> #optional callback, you can catch with the Cloudinary collection as well
				console.log "Upload Error:"
				console.log err
				console.log "Upload Result:"
				console.log res
				Images.insert res

	"click button.delete": ->
		Cloudinary.delete @public_id, (err,res) ->
			console.log "Upload Error:"
			console.log err
			console.log "Upload Result:"
			console.log res

	"click button.delete_private": ->
		Cloudinary.delete @public_id, "private", (err,res) ->
			console.log "Upload Error:"
			console.log err
			console.log "Upload Result:"
			console.log res

Template.tester.helpers
	"files": ->
		Cloudinary.collection.find()

	"uploaded_images": ->
		Images.find()

	"complete": ->
		@status is "complete"

