if (Package.ui) {
	Package.ui.Handlebars.registerHelper('c_url', function (public_id,options) {
		if(public_id){
			return $.cloudinary.url(public_id,options.hash);
		}
	});
	Package.ui.Handlebars.registerHelper('c_upload_successful', function() {
		return Session.get("cloudinary_upload.upload_successful");
	});

	Package.ui.Handlebars.registerHelper('c_upload_failed', function() {
		return Session.get("cloudinary_upload.upload_failed");
	});
}