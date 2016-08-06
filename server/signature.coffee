Future = Npm.require "fibers/future"

Meteor.methods
	"c.sign": (ops={}) ->
		check ops, Match.Optional(Object)
		@unblock()

		if Cloudinary.rules.signature
			@options = ops
			auth_function = _.bind Cloudinary.rules.signature,this
			if not auth_function()
				throw new Meteor.Error "Unauthorized", "Signature not allowed"

		# Need to add some way to do custom auth
		# signature = Cloudinary.utils.sign_request ops
		signature = Cloudinary.uploader.direct_upload "",ops # This is better than utils.sign_request, it returns a POST url as well and properly manages optional parameters

		return signature


	"c.delete_by_public_id": (public_id,type) ->
		check public_id, String
		check type, Match.OneOf(String,undefined,null)
		@unblock()

		if Cloudinary.rules.delete
			@public_id = public_id
			auth_function = _.bind Cloudinary.rules.delete,this
			if not auth_function()
				throw new Meteor.Error "Unauthorized", "Delete not allowed"

		if type
			ops =
				type:type

		future = new Future()

		Cloudinary.api.delete_resources [public_id], (result) ->
				future.return result
			,ops

		return future.wait()

	"c.get_private_resource": (public_id,ops={}) ->
		check public_id, String
		check ops, Match.Optional(Object)
		@unblock()

		_.extend ops,
			sign_url:true
			type:"private"

		if Cloudinary.rules.private_resource
			@public_id = public_id
			auth_function = _.bind Cloudinary.rules.private_resource,this
			if not auth_function()
				throw new Meteor.Error "Unauthorized", "Access not allowed"


		Cloudinary.url public_id,ops

	"c.get_download_url": (public_id,ops={}) ->
		check public_id, String
		check ops, Match.Optional(Object)
		@unblock()

		if Cloudinary.rules.download_url
			@public_id = public_id
			auth_function = _.bind Cloudinary.rules.download_url,this
			if not auth_function()
				throw new Meteor.Error "Unauthorized", "Access not allowed"

		format = ops.format or ""

		Cloudinary.utils.private_download_url public_id,format,_.omit(ops,"format")



