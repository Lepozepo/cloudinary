if (Package.ui) {
	Package.ui.Handlebars.registerHelper('c_image', function (public_id,options) {
		if(public_id){
			return Spacebars.SafeString(
				$.cloudinary.image(public_id,options.hash)[0].outerHTML
			);
		}
	});
	Package.ui.Handlebars.registerHelper('c_upload_successful', function() {
		return Session.get("cloudinary_upload.upload_successful");
	});

	Package.ui.Handlebars.registerHelper('c_upload_failed', function() {
		return Session.get("cloudinary_upload.upload_failed");
	});
}