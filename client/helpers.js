if (Package.ui) {
	Package.ui.Handlebars.registerHelper('c_image', function (public_id,options) {
		return Spacebars.SafeString(
			$.cloudinary.image(public_id,options.hash)[0].outerHTML
		);
	});
}