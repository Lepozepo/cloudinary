Future = Npm.require "fibers/future"

Meteor.methods
	"c.sign": (ops={}) ->
		@unblock()
		check ops, Object

		# Need to add some way to do custom auth
		# signature = Cloudinary.utils.sign_request ops
		signature = Cloudinary.uploader.direct_upload "",ops # This is better than utils.sign_request, it returns a POST url as well and properly manages optional parameters

		return signature


	"c.delete_by_public_id": (public_id) ->
		@unblock()
		if Cloudinary.rules.delete
			auth_function = _.bind Cloudinary.rules.delete,this
			if not auth_function()
				throw new Meteor.Error "Unauthorized", "Delete not allowed"

		check public_id, String

		future = new Future()

		Cloudinary.api.delete_resources [public_id], (result) ->
			future.return result

		return future.wait()

