Meteor.methods
	"c.sign": ->
		@unblock()

		return Cloudinary.uploader.direct_upload()
