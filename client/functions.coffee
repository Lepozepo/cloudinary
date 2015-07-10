Cloudinary =
	collection: new Mongo.Collection "_cloudinary"
	upload: (file, callback) ->
		Meteor.call "c.sign", (error,result) ->
			if not error
				# Build form
				form_data = new FormData()
				form_data.append "api_key", result.hidden_fields.api_key
				form_data.append "signature",result.hidden_fields.signature
				form_data.append "timestamp",result.hidden_fields.timestamp
				form_data.append "file",file

				# Create collection document ID
				collection_id = Random.id()

				# Send data
				xhr = new XMLHttpRequest()

				xhr.upload.addEventListener "progress", (event) ->
						Cloudinary.collection.upsert collection_id,
							$set:
								status:"uploading"
								loaded:event.loaded
								total:event.total
								percent_uploaded: Math.floor ((event.loaded / event.total) * 100)
					,false

				xhr.addEventListener "load", ->
					if xhr.status < 400
						Cloudinary.collection.upsert collection_id,
							$set:
								status:"complete"
								percent_uploaded: 100
								response: @responseText

						callback and callback null,@responseText
					else
						Cloudinary.collection.upsert collection_id,
							$set:
								status:"error"
								response: @responseText

						callback and callback @responseText,null

				xhr.addEventListener "error", ->
					Cloudinary.collection.upsert collection_id,
						$set:
							status:"error"
							response: @responseText

					callback and callback @responseText,null

				xhr.addEventListener "abort", ->
					Cloudinary.collection.upsert collection_id,
						$set:
							status:"aborted"

				xhr.open "POST",result.form_attrs.action,true

				xhr.send form_data
