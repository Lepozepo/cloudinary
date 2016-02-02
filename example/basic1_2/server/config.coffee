Cloudinary.config
	cloud_name: 'cloud_name',
	api_key: 'api_key',
	api_secret: 'api_secret'

Cloudinary.rules.delete = ->
	# Return true to allow delete
	console.log @userId
	console.log @public_id
	return true

Cloudinary.rules.signature = ->
	# Return true to allow upload
	console.log @options # Options passed through the uploader
	console.log @userId
	return true

Cloudinary.rules.private_resource = ->
	# Return true to allow access to private resource
	console.log @userId
	return true

Cloudinary.rules.download_url = ->
	# Return true to allow access to the resource download url
	console.log @userId
	return true


