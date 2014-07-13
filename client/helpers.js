if (Package.ui) {
	Package.ui.Handlebars.registerHelper('c_url', function (public_id,options) {
		if(public_id){
			return $.cloudinary.url(public_id,options.hash);
		}
	});
}