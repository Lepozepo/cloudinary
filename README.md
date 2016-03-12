# Cloudinary Image/File Uploader
Cloudinary provides a simple way for uploading files to Cloudinary, which in turn can be set up to sync with your Amazon S3 service. This is useful for uploading and actively manipulating images and files that you want accesible to the public. Cloudinary is built on [Cloudinary (NPM)](https://github.com/cloudinary/cloudinary_npm) and [Cloudinary (JS)](https://github.com/cloudinary/cloudinary_js). Installing this package will make `Cloudinary` available server-side and `$.cloudinary` available client-side.

# Show your support!
Star my code in github or atmosphere if you like my code or shoot me a dollar or two!

[DONATE HERE](https://cash.me/$lepozepo)

## New Features
- Signed URLs: You can now easily generate a signed url for resources with transformations.
- Expiring URLs: You can now easily generate signed expiring urls for raw resources.
- More Auth Rules: You can now control who can do what easier with the Cloudinary.rules object.
- Improved Uploads: The method for signatures has been improved and now also allows private and authenticated images.
- Download URLs: You can now easily generate temporary download URLs with Meteor.call("c.get_download_url", public_id,ops,callback)

## Previous Features
- Client to Cloudinary Uploads

## Installation

``` sh
$ meteor add lepozepo:cloudinary
```

## How to upload
### Step 1
Configure your Cloudinary Credentials and Delete Authorization Rules. SERVER SIDE AND CLIENT SIDE.

``` coffeescript
#SERVER
Cloudinary.config
	cloud_name: 'cloud_name'
	api_key: '1237419'
	api_secret: 'asdf24adsfjk'

# Rules are all optional
Cloudinary.rules.delete = ->
	@userId is "my_user_id" # The rule must return true to pass validation, if you do not set a rule, the validation will always pass
	@public_id # The public_id that is being deleted

Cloudinary.rules.signature = -> # This one checks whether the user is allowed to upload or not
	@userId is "my_user_id" # The rule must return true to pass validation, if you do not set a rule, the validation will always pass

Cloudinary.rules.private_resource = ->
	@userId is "my_user_id" # The rule must return true to pass validation, if you do not set a rule, the validation will always pass

Cloudinary.rules.download_url = ->
	@userId is "my_user_id" # The rule must return true to pass validation, if you do not set a rule, the validation will always pass

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
			type:"private" # optional: makes the image accessible only via a signed url. The signed url is available publicly for 1 hour.
			(err,res) -> #optional callback, you can catch with the Cloudinary collection as well
				console.log "Upload Error: #{err}"
				console.log "Upload Result: #{res}"

```


## How to read and manipulate
All of Cloudinary's manipulation options are available in the c.url helper. You can access an image by passing a cloudinary public_id:

``` handlebars
<img src="{{c.url public_id}}">
<img src="{{c.private_url public_id}}">
```

You can manipulate an image by adding parameters to the helper
``` handlebars
<img width="250" src="{{c.url public_id effect='blur:300' angle=10}}">
```

Obs: If you want to resize your image in a smaller size you will need to pass the `crop` parameter 
``` handlebars
<img src="{{c.url public_id width=250 height=250 crop="fill"}}">
```
For more information see the cloudinary's documentation:
[http://cloudinary.com/documentation/image_transformations#crop_modes](http://cloudinary.com/documentation/image_transformations#crop_modes)

## How to protect your images
You will need an **Advanced Cloudinary** account before you can make your images fully private. Once you have your account you can do one of 2 things:

- Set up a custom CNAME and ask Cloudinary to whitelist your domains via email
- Upload `type:"authenticated"` images and request them via cloudinary's authentication scheme (I'm working on simplifying this part)

## Compatibility
You can use the collection-hooks package to hook up to the offline collection `Cloudinary.collection`.

If you are using the `browser-policy` package, don't forget to allow images from cloudinary to load on your webapp by using `BrowserPolicy.content.allowImageOrigin("res.cloudinary.com")`

Here are all the transformations you can apply:
[http://cloudinary.com/documentation/image_transformations#reference](http://cloudinary.com/documentation/image_transformations#reference)

### Cordova Android Bug with Meteor 1.2+

Due to a [bug in the Cordova Android version that is used with Meteor 1.2](https://issues.apache.org/jira/browse/CB-8608?jql=project%20%3D%20CB%20AND%20text%20~%20%22FileReader%22), you will need to add the following to your mobile-config.js or you will have problems with this package on Android devices:

```js
App.accessRule("blob:*");
```


## How to delete from Cloudinary
Just pass the public_id of the image or file through this function (security features pending). It will return an object with a list of the images deleted as a result.

``` coffeescript
Template.yourtemplate.events
	"click button.delete": ->
		Cloudinary.delete @response.public_id, (err,res) ->
			console.log "Upload Error: #{err}"
			console.log "Upload Result: #{res}"
```

## How to generate a downloadable link
``` coffeescript
Meteor.call "c.get_download_url", public_id,(err,download_url) ->
	console.log "Upload Error: #{err}"
	console.log "#{download_url}"
```

### API
- Cloudinary.config(options) **(SERVER)** __required__:
	- cloud_name: Name of your cloud
	- api_key: Your Cloudinary API Key
	- api_secret: Your Cloudinary API Secret

- Cloudinary.rules **(SERVER)** __optional__: This is a javascript object of rules as functions
	- Cloudinary.rules.delete: Checks whether deleting a resource is allowed. Return true to allow the action.
	- Cloudinary.rules.signature: Checks whether uploading a resource is allowed. Return true to allow the action.
	- Cloudinary.rules.private_resource: Checks whether getting a private resource is allowed. Return true to allow the action.
	- Cloudinary.rules.download_url: Checks whether fetching a download link for a resource is allowed. Return true to allow the action.

### Helpers
- {{c.url public_id options}}: Generates a url
	- public_id: The public ID returned after uploading a resource
	- options: A set of transformations described here [http://cloudinary.com/documentation/image_transformations#reference](http://cloudinary.com/documentation/image_transformations#reference)

- {{c.private_url public_id options}}: Generates a signed url
	- public_id: The public ID returned after uploading a resource
	- options: A set of transformations described here [http://cloudinary.com/documentation/image_transformations#reference](http://cloudinary.com/documentation/image_transformations#reference)

- {{c.expiring_url public_id}}: Generates a url that will expire in 1 hour, does not take any transformations
	- public_id: The public ID returned after uploading a resource


## Notes
A security filter is missing, I know how I want it to work I just haven't had the time to build it. Enjoy the new version!

### Donations and Sponsors - Thank You's
**If you prefer I list your github account let me know [who you are](https://github.com/Lepozepo/cloudinary/issues/56)!**

- Casey R.
- NetLive IT




