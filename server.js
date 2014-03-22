Cloudinary = Npm.require("cloudinary");
var Future = Npm.require('fibers/future');

Meteor.methods({
	cloudinary_upload:function(file){
		this.unblock();
		var future = new Future();

		Cloudinary.uploader.upload(file,function(result){
			future.return(result);
		});

		if(future.wait()){
			console.log(future.wait());
		}
	}
});