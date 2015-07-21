<img src="//img.shields.io/gratipay/lepozepo.svg">
<script data-gratipay-username="lepozepo"
        data-gratipay-widget="button"
        src="//grtp.co/v1.js"></script>

# Cloudinary Image/File Uploader
Cloudinary provides a simple way for uploading files to Cloudinary, which in turn can be set up to sync with your Amazon S3 service. This is useful for uploading and actively manipulating images and files that you want accesible to the public. Cloudinary is built on [Cloudinary (NPM)](https://github.com/cloudinary/cloudinary_npm) and [Cloudinary (JS)](https://github.com/cloudinary/cloudinary_js). Installing this package will make `Cloudinary` available server-side and `$.cloudinary` available client-side.

## BREAKING CHANGES
`{{#c_upload}}` does not exist anymore
All core methods and functions have been renamed and rewritten

This package does not use Streams anymore and uploads directly from the client to cloudinary!


## NEW FEATURE
CLIENT TO CLOUDINARY UPLOADS! Images will not stream to your server anymore, they will stream directly to cloudinary.

## Installation

``` sh
$ meteor add lepozepo:cloudinary
```

## How to upload
### Step 1
Configure your Cloudinary Credentials. SERVER SIDE AND CLIENT SIDE.

``` coffeescript
#SERVER
Cloudinary.config
	cloud_name: 'cloud_name'
	api_key: '1237419'
	api_secret: 'asdf24adsfjk'

#CLIENT
$.cloudinary.config
	cloud_name:"cloud_name"

```

### Step 2
Wire up your `input[type="file"]`. CLIENT SIDE.

``` coffeescript
Template.yourtemplate.events
	"change input[type='file']": (e) ->
		files = e.currentTarget.files

		Cloudinary.upload files,
			folder:"secret" # optional parameters described in http://cloudinary.com/documentation/upload_images#remote_upload
			(err,res) -> #optional callback, you can catch with the Cloudinary collection as well
				console.log "Upload Error: #{err}"
				console.log "Upload Result: #{res}"

```


## How to read and manipulate
All of Cloudinary's manipulation options are available in the c.url helper. You can access an image by passing a cloudinary public_id and format:

``` handlebars
<img src="{{c.url public_id format=format}}">
```

You can manipulate an image by adding parameters to the helper
``` handlebars
<img width="250" src="{{c.url public_id format=format effect='blur:300' angle=10}}">
```

## Compatibility
You can use the collection-hooks package to hook up to the offline collection `Cloudinary.collection`.

Here are all the transformations you can apply:
[http://cloudinary.com/documentation/image_transformations#reference](http://cloudinary.com/documentation/image_transformations#reference)


## How to delete from Cloudinary
Just pass the public_id of the image or file through this function (security features pending). It will return an object with a list of the images deleted as a result.

``` coffeescript
Template.yourtemplate.events
	"click button.delete": ->
		Cloudinary.delete @response.public_id, (err,res) ->
			console.log "Upload Error: #{err}"
			console.log "Upload Result: #{res}"
```


## Notes
A security filter is missing, I know how I want it to work I just haven't had the time to build it. Enjoy the new version!





