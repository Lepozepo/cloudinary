Template.cloudinary.events({
	'change input[type=file]': function (e) {
		var files = e.currentTarget.files;
		_.each(files,function(file){
			var reader = new FileReader;

			reader.onload = function () {
				Meteor.call("cloudinary_upload",reader.result);
			};

			reader.readAsDataURL(file);

		});
	}
});

/* SAMPLE GLOBAL HELPERS
if (Package.ui) {
  Package.ui.Handlebars.registerHelper('currentUser', function () {
    return Meteor.user();
  });
  Package.ui.Handlebars.registerHelper('loggingIn', function () {
    return Meteor.loggingIn();
  });
}
*/