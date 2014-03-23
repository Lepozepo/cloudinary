Template.cloudinary_upload.events({
	'change input[type=file]': function (e,helper) {
		var options = {context:this};

		if(helper.data && _.has(helper.data,"callback")){
			options.callback = helper.data.callback;
		} else {
			console.log("Cloudinary Error: Helper Block needs a callback function to run");
			return
		}

		var files = e.currentTarget.files;

		_.each(files,function(file){
			var reader = new FileReader;

			reader.onload = function () {
				Meteor.call("cloudinary_upload",reader.result,options,function(e,r){
					if(!e && r && !_.has(r,"error")){
						Session.set("cloudinary_upload.upload_successful",r);
						Session.set("cloudinary_upload.upload_failed",false);
					} else if (!e && r && _.has(r,"error")){
						Session.set("cloudinary_upload.upload_successful",false);
						Session.set("cloudinary_upload.upload_failed",r);
					} else {
						Session.set("cloudinary_upload.upload_successful",false);
						Session.set("cloudinary_upload.upload_failed",e);
					}
				});
			};

			reader.readAsDataURL(file);

		});
	}
});