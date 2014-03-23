Cloudinary = Npm.require("cloudinary");
var Future = Npm.require('fibers/future');

Meteor.methods({
	cloudinary_upload:function(file,options){
		this.unblock();
		if(options && _.has(options,"callback")){
			var future = new Future();

			Cloudinary.uploader.upload(file,function(result){
				future.return(result);
			});

			if(future.wait()){
				upload_data = future.wait();
				var callback_options = {
					context:options.context,
					upload_data:upload_data
				}
				Meteor.call(options.callback,callback_options);
			}
		} else {
			console.log("Cloudinary Error: Helper Block needs a callback function to run");
		}
	},
	cloudinary_delete:function(public_id){
		Cloudinary.api.delete_resources([public_id]);
	}
});