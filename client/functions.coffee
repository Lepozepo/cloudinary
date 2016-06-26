Cloudinary =
	collection: new Mongo.Collection "_cloudinary", connection:null
	_private_urls:{}
	_expiring_urls:{}
	xhr:null
	_helpers:
		"url": (public_id,options) ->
			if public_id and not _.isEmpty public_id
				$.cloudinary.url(public_id,options.hash)

		"private_url":(public_id,options) ->
			private_url = Cloudinary._private_urls[public_id]
			if not private_url
				Cloudinary._private_urls[public_id] = new ReactiveVar ""
				private_url = Cloudinary._private_urls[public_id]

			if public_id and not _.isEmpty(public_id) and _.isEmpty(private_url.get())
				Meteor.call "c.get_private_resource",public_id,options.hash,(error,result) ->
					if error
						throw new Meteor.Error "Cloudinary","Failed to sign and fetch image"
					else
						private_url.set result

			private_url.get()

		"expiring_url":(public_id,options) ->
			expiring_url = Cloudinary._expiring_urls[public_id]
			if not expiring_url
				Cloudinary._expiring_urls[public_id] = new ReactiveVar ""
				expiring_url = Cloudinary._expiring_urls[public_id]

			if public_id and not _.isEmpty(public_id) and _.isEmpty(expiring_url.get())
				Meteor.call "c.get_download_url",public_id,options.hash,(error,result) ->
					if error
						throw new Meteor.Error "Cloudinary","Failed to sign and fetch image"
					else
						expiring_url.set result

			expiring_url.get()


	delete: (public_id, type, callback) ->
		if _.isFunction type
			callback = type
			type = undefined

		Meteor.call "c.delete_by_public_id", public_id, type, (error,result) ->
			if error
				return callback and callback error, null
			else
				if result.deleted[public_id] and result.deleted[public_id] is "not_found"
					return callback and callback result, null
				else
					return callback and callback null,result

	upload: (files, ops={}, callback) ->
		if _.isFunction ops
			callback = ops
			ops = {}

		_.each files, (file) ->
			reader = new FileReader

			reader.onload = ->
				Cloudinary._upload_file reader.result, ops, callback

			reader.readAsDataURL file

	_upload_file: (file, ops={}, callback) ->
		Meteor.call "c.sign", ops, (error,result) ->
			if error
				return callback and callback error,null

			# Build form
			form_data = new FormData()
			_.each result.hidden_fields, (v,k) ->
				form_data.append k,v

			form_data.append "file",file

			# Create collection document ID
			collection_id = Random.id()

			# Send data
			Cloudinary.xhr = new XMLHttpRequest()

			Cloudinary.collection.insert
				_id:collection_id
				status:"uploading"
				preview:file

			Cloudinary.xhr.upload.addEventListener "progress", (event) ->
					Cloudinary.collection.update _id:collection_id,
						$set:
							loaded:event.loaded
							total:event.total
							percent_uploaded: Math.floor ((event.loaded / event.total) * 100)
				,false

			Cloudinary.xhr.addEventListener "load", ->
				if Cloudinary.xhr.status < 400
					response = JSON.parse @response
					Cloudinary.collection.upsert collection_id,
						$set:
							status:"complete"
							percent_uploaded: 100
							response: response

					callback and callback null,response
				else
					response = JSON.parse @response
					Cloudinary.collection.upsert collection_id,
						$set:
							status:"error"
							response: response

					callback and callback response,null

			Cloudinary.xhr.addEventListener "error", ->
				response = JSON.parse @response
				Cloudinary.collection.upsert collection_id,
					$set:
						status:"error"
						response: response

				callback and callback response,null

			Cloudinary.xhr.addEventListener "abort", ->
				Cloudinary.collection.upsert collection_id,
					$set:
						status:"aborted"

			Cloudinary.xhr.open "POST",result.form_attrs.action,true

			Cloudinary.xhr.send form_data


# Define helpers
Template.registerHelper "c", ->
	Cloudinary._helpers