Cloudinary =
	collection: new Mongo.Collection "_cloudinary", connection:null
	_helpers:
		"url": (public_id,options) ->
			$.cloudinary.url(public_id,options.hash)

	delete: (public_id, callback) ->
		Meteor.call "c.delete_by_public_id", public_id, (error,result) ->
			if error
				return callback and callback error, null
			else
				if result.deleted[public_id] and result.deleted[public_id] is "not_found"
					return callback and callback result, null
				else
					return callback and callback null,result

	upload: (files, ops={}, callback) ->
		_.each files, (file) ->
			reader = new FileReader

			reader.onload = ->
				Cloudinary._upload_file reader.result, ops, callback

			reader.readAsDataURL file

	_upload_file: (file, ops={}, callback) ->
		Meteor.call "c.sign", ops, (error,result) ->
			if not error
				# Build form
				form_data = new FormData()
				form_data.append "api_key", result.hidden_fields.api_key
				form_data.append "signature",result.hidden_fields.signature
				form_data.append "timestamp",result.hidden_fields.timestamp
				form_data.append "file",file

				# Enable options
				_.each ops, (v,k) ->
					form_data.append k,v

				# Create collection document ID
				collection_id = Random.id()

				# Send data
				xhr = new XMLHttpRequest()

				xhr.upload.addEventListener "progress", (event) ->
						Cloudinary.collection.upsert _id:collection_id,
							$set:
								status:"uploading"
								loaded:event.loaded
								total:event.total
								percent_uploaded: Math.floor ((event.loaded / event.total) * 100)
					,false

				xhr.addEventListener "load", ->
					if xhr.status < 400
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

				xhr.addEventListener "error", ->
					response = JSON.parse @response
					Cloudinary.collection.upsert collection_id,
						$set:
							status:"error"
							response: response

					callback and callback response,null

				xhr.addEventListener "abort", ->
					Cloudinary.collection.upsert collection_id,
						$set:
							status:"aborted"

				xhr.open "POST",result.form_attrs.action,true

				xhr.send form_data

			else
				return callback and callback error,null


# Define helpers
Template.registerHelper "c", ->
	Cloudinary._helpers











