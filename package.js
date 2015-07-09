Package.describe({
	name:"lepozepo:cloudinary",
	summary: "Upload files to Cloudinary",
	version:"4.0.0",
	git:"https://github.com/Lepozepo/cloudinary"
});

Npm.depends({
	cloudinary: "1.2.1"
});

Package.on_use(function (api){
	api.versionsFrom('METEOR@1.0');

	api.use(["underscore","check","coffeescript","service-configuration"], ["client", "server"]);
	api.use(["ui@1.0.0","templating@1.0.0","spacebars@1.0.0"], "client");
	api.use(["matb33:collection-hooks@0.7.3"], ["client", "server"],{weak:true});


	//Image manipulation
	api.add_files("lib/cloudinary.standalone.js","client");

	// api.add_files("client/blocks.html", "client");
	// api.add_files("client/helpers.js", "client");
	// api.add_files("client/controllers.js","client");
	// api.add_files("client/collections.js", "client");
	// api.add_files("client/functions.js", "client");
	// api.add_files("server.js", "server");

	//Allow user access to Cloudinary server-side
	// api.export && api.export("Cloudinary","server");
	// api.export && api.export("_cloudinary","client");
	// api.export && api.export("C","client");
});

