Cloudinary =
	upload: (file, callback) ->
		Meteor.call "c.sign", (error,result) ->
			if not error
				form_data = new FormData()
				form_data.append "api_key", result.hidden_fields.api_key
				form_data.append "signature",result.hidden_fields.signature
				form_data.append "timestamp",result.hidden_fields.timestamp
				form_data.append "file",file

				# Send data
				xhr = new XMLHttpRequest()

				xhr.upload.addEventListener "progress", (event) ->
						console.log event.loaded
						console.log event.total
					,false

				xhr.addEventListener "load", ->
					if xhr.status < 400
						console.log result

					# 	callback and callback null,S3.collection.findOne id
					# else
					# 	callback and callback true,null

				xhr.addEventListener "error", ->
					callback and callback true,null

				xhr.addEventListener "abort", ->
					console.log "aborted by user"

				xhr.open "POST",result.form_attrs.action,true

				xhr.send form_data
