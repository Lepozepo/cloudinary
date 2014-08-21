Template.c_upload.events({
	'change input[type=file]': function (e,helper) {
		var options = {context:this};

		if(helper.data && _.has(helper.data,"callback")){
			options.callback = helper.data.callback;
		}

		var files = e.currentTarget.files;

		_.each(files,function(file){
			var reader = new FileReader;

			reader.onload = function () {
				options.db_id = _cloudinary.insert({});
				Meteor.call("cloudinary_upload",reader.result,options,function(err,res){
					if(err){
						_cloudinary.remove(options.db_id);
						console.log(err);
					}
				});
			};

			reader.readAsDataURL(file);
		});
	}
});

Template.c_upload_stream.events({
	'change input[type=file]': function (e,helper) {

		var options = {context:this};

		if(helper.data && _.has(helper.data,"callback")){
			options.callback = helper.data.callback;
		}

		var files = e.currentTarget.files;

		_.each(files,function(file){
			var reader = new FileReader;

			reader.onload = function () {
				var file_data = new Uint8Array(reader.result);
				options.db_id = _cloudinary.insert({});
				Meteor.call("cloudinary_upload_stream",file_data,options,function(err,res){
					if(err){
						_cloudinary.remove(options.db_id);
						console.log(err);
					}
				});
			};

			reader.readAsArrayBuffer(file);

		});
	}
});