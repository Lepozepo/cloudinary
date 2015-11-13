Future = Npm.require "fibers/future"

Meteor.methods
	"c.sign": (ops={}) ->
		@unblock()
		if Cloudinary.rules.signature
			auth_function = _.bind Cloudinary.rules.signature,this
			if not auth_function()
				throw new Meteor.Error "Unauthorized", "Signature not allowed"

		check ops, Object

		# Need to add some way to do custom auth
		# signature = Cloudinary.utils.sign_request ops
		signature = Cloudinary.uploader.direct_upload "",ops # This is better than utils.sign_request, it returns a POST url as well and properly manages optional parameters

		return signature


	"c.delete_by_public_id": (public_id,type) ->
		@unblock()
		if Cloudinary.rules.delete
			auth_function = _.bind Cloudinary.rules.delete,this
			if not auth_function()
				throw new Meteor.Error "Unauthorized", "Delete not allowed"

		check public_id, String
		check type, Match.OneOf(String,undefined,null)
		if type
			ops =
				type:type

		future = new Future()

		Cloudinary.api.delete_resources [public_id], (result) ->
				future.return result
			,ops

		return future.wait()

	"c.get_private_resource": (public_id,ops={}) ->
		@unblock()
		_.extend ops,
			sign_url:true
			type:"private"

		check public_id, String
		check ops, Object

		if Cloudinary.rules.private_resource
			auth_function = _.bind Cloudinary.rules.private_resource,this
			if not auth_function()
				throw new Meteor.Error "Unauthorized", "Access not allowed"


		Cloudinary.url public_id,ops

