Meteor.methods
	"c.sign": (ops={}) ->
		@unblock()
		check ops, Object

		# Need to add some way to do custom auth

		signature = Cloudinary.uploader.direct_upload "",ops

		return signature
