# Cloudinary Image/File Uploader
This is a blaze-only package! Cloudinary provides a simple way for uploading files to Cloudinary, which in turn can be set up to sync with your Amazon S3 service. This is useful for uploading and actively manipulating images and files that you want accesible to the public. Cloudinary is built on [Cloudinary (NPM)](https://github.com/cloudinary/cloudinary_npm) and [Cloudinary (JS)](https://github.com/cloudinary/cloudinary_js). Installing this package will make Cloudinary available server-side and cloudinary available client-side (cloudinary_js feels unstable in certain situations).

## Outlook
This is a quick implementation of the uploader, feel free to fork it and improve on it like so many people did for S3 ^_^. I'm always open for pull requests too.

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
{{#cloudinary_upload callback="save_url"}}
	<input type="file">
{{/cloudinary_upload}}
```

### Step 3
Define a callback function that will handle what to do with Cloudinary's response. SERVER SIDE.

``` javascript
Meteor.methods({
	save_url:function(response){
		console.log('Add '+response.upload_data+' to the id of '+response.context);
	}
});
```

## How to read and manipulate
All of Cloudinary's manipulation options are available in the c_url helper. You can access an image by passing a cloudinary public_id and format:

``` handlebars
<img src="{{c_url public_id format=format}}">

```

You can manipulate an image by adding parameters to the helper
``` handlebars
<img width="250" src="{{c_url public_id format=format effect='blur:300' angle=10}}">

```

Here are all the transformations you can apply:
[http://cloudinary.com/documentation/image_transformations#reference](http://cloudinary.com/documentation/image_transformations#reference)

## Notes

I'll try to use a stream instead so we can get a progress bar on this.