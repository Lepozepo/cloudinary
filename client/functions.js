C = {
	upload_stream: function(files,callback){
		var options = {};

		_.each(files,function(file){
			var reader = new FileReader;

			reader.onload = function () {
				var file_data = new Uint8Array(reader.result);
				options.db_id = _cloudinary.insert({});
				Meteor.call("cloudinary_upload_stream",file_data,options,function(err,res){
					if(err){
						_cloudinary.remove(options.db_id);
						console.log(err);
					} else {
						callback && callback(res);
					}
				});
			};

			reader.readAsArrayBuffer(file);
		});
	},
	upload: function(files,callback){
		var options = {};

		_.each(files,function(file){
			var reader = new FileReader;

			reader.onload = function () {
				options.db_id = _cloudinary.insert({});
				Meteor.call("cloudinary_upload",reader.result,options,function(err,res){
					if(err){
						_cloudinary.remove(options.db_id);
						console.log(err);
					} else {
						callback && callback(res);
					}
				});
			};

			reader.readAsDataURL(file);
		});
	}
}
