Meteor.methods({
	save_url:function(image){
		//image has context and upload_data
		//Save to a collection
		console.log(image);
		Images.insert(image.upload_data);
	}
});