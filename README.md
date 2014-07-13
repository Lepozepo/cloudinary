# Cloudinary Image/File Uploader
This is a blaze-only package! Cloudinary provides a simple way for uploading files to Cloudinary, which in turn can be set up to sync with your Amazon S3 service. This is useful for uploading and actively manipulating images and files that you want accesible to the public. Cloudinary is built on [Cloudinary (NPM)](https://github.com/cloudinary/cloudinary_npm) and [Cloudinary (JS)](https://github.com/cloudinary/cloudinary_js). Installing this package will make Cloudinary available server-side and cloudinary available client-side (cloudinary_js feels unstable in certain situations).

## Outlook
This is a quick implementation of the uploader, feel free to fork it and improve on it like so many people did for S3 ^_^. I'm always open for pull requests too.

## BREAKING CHANGES
``` handlebars
{{#cloudinary_upload}} is now {{#c_upload}}

This package does not use Session variables for reactivity anymore. You can identify whether an upload is successful via the new helper c.uploading_images or your own collection.

There is a new global helper that contains all cloudinary helpers, it takes the namespace of "c". This means:
{{c_url}} is now {{c.url}}
```

## NEW FEATURE
You can now upload a stream of data via the c_upload_stream template and view progress via the c.uploading_images helper.

## Installation

``` sh
$ mrt add cloudinary
```

## How to upload

### Step 1
Configure your Cloudinary Credentials. SERVER SIDE AND CLIENT SIDE.

``` javascript
//SERVER
Cloudinary.config({
	cloud_name: 'cloud_name',
	api_key: '1237419',
	api_secret: 'asdf24adsfjk'
});

//CLIENT
$.cloudinary.config({
	cloud_name:"cloud_name"
});

```

### Step 2
Create a Cloudinary input with a callback function. CLIENT SIDE.

``` handlebars
{{#c_upload callback="save_url"}}
	<input type="file">
{{/c_upload}}
```

Or a Cloudinary stream input with a callback function. CLIENT SIDE.

``` handlebars
{{#c_upload_stream callback="save_url"}}
	<input type="file">
{{/c_upload_stream}}

{{#each c.uploading_images}}
	<p>{{percent_uploaded}}</p>
{{/each}}
```

### Step 3
Define a callback function that will handle what to do with Cloudinary's response. Usually just save the url to a collection. SERVER SIDE.

``` javascript
Meteor.methods({
	save_url:function(response){
		console.log('Add '+response.upload_data+' to the id of '+response.context);
	}
});
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

Here are all the transformations you can apply:
[http://cloudinary.com/documentation/image_transformations#reference](http://cloudinary.com/documentation/image_transformations#reference)

## Data of uploading images
Images that are being processed appear under the c.uploading_images helper. This helper only contains percent_uploaded (out of 100) and total_uploaded (in bytes).
``` handlebars
{{#each c.uploading_images}}
	<p>{{percent_uploaded}}</p>
	<p>{{total_uploaded}}</p>
{{/each}}
```

## How to delete from Cloudinary
Just pass the public_id of the image or file through this function (security features pending). It will return an object with a list of the images deleted as a result.

``` javascript
Meteor.call("cloudinary_delete","public_id",function(e,r){
	if(!e){
	  	console.log(r);
	}
});
```


## Notes

This package is not intrusive on your database. It uses meteor-stream to connect to a clients' local collection and modify it. Because of this it is actually faster and more accurate with data. The local collection uses the _cloudinary namespace (so _cloudinary.find()).

I still need to add more configuration options and better error handling.

