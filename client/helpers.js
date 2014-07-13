if (Package.ui) {
	super_scope = {}

	super_scope['url'] = function (public_id,options) {
		if(public_id){
			return $.cloudinary.url(public_id,options.hash);
		}
	};

	super_scope['uploading_images'] = function() {
		return _cloudinary.find({uploading:true});
	};

	Package.ui.Handlebars.registerHelper('c', function () {
		return super_scope;
	});
}