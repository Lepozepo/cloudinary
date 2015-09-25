Future = Npm.require "fibers/future"

Meteor.methods
	"c.sign": (ops={}) ->
		@unblock()
		if check
			check ops, Object

		# Need to add some way to do custom auth and a better way to create the signature
		signature = Cloudinary.uploader.direct_upload "",ops

		return signature


	"c.delete_by_public_id": (public_id) ->
		@unblock()
		if check
			check public_id, String

		future = new Future()

		Cloudinary.api.delete_resources [public_id], (result) ->
			future.return result

		return future.wait()

