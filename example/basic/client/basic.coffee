# $.cloudinary.config
# 	cloud_name:"stuff"


Template.tester.events
	"change input.file_bag": (e) ->
		files = e.currentTarget.files

		Cloudinary.upload files,
			folder:"secret" # optional parameters described in http://cloudinary.com/documentation/upload_images#remote_upload
			(err,res) -> #optional callback, you can catch with the Cloudinary collection as well
				console.log res

	"click button.delete": ->
		Cloudinary.delete @response.public_id

Template.tester.helpers
	"files": ->
		Cloudinary.collection.find()

