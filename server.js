Cloudinary = Npm.require("cloudinary");
var Future = Npm.require('fibers/future');
var stream_buffers = Npm.require("stream-buffers")

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
				return future.wait();
			}
		} else {
			console.log("Cloudinary Error: Helper Block needs a callback function to run");
		}
	},
	cloudinary_upload_stream:function(file,options){
		this.unblock();

		var file_stream_buffer = new stream_buffers.ReadableStreamBuffer({
			frequency:10,
			chunkSize:2048
		});

		var buffer = new Buffer(file);
		file_stream_buffer.put(buffer);

		var stream = Cloudinary.uploader.upload_stream(function(result){console.log(result);});

		total_buffer_size = buffer.length;
		total_uploaded = 0;

		file_stream_buffer.on("data",function(data){
			total_uploaded += data.length;
			console.log(total_uploaded);
			console.log(total_uploaded / total_buffer_size);
			stream.write(data);
		});

		file_stream_buffer.on("end",stream.end);

/*
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
				return future.wait();
			}
		} else {
			console.log("Cloudinary Error: Helper Block needs a callback function to run");
		}
*/
	},
	cloudinary_delete:function(public_id){
		//This isn't very safe, lol
		this.unblock();

		var future = new Future();

		Cloudinary.api.delete_resources([public_id],function(result){
			future.return(result);
		});

		return future.wait();
	},
	cloudinary_list_all:function(){
		this.unblock();
		var future = new Future();

		Cloudinary.api.resources(function(result){
			if(result && _.has(result,"resources")){
				future.return(result.resources);
			} else {
				future.return([]);
			}
		});

		return future.wait();
	}
});