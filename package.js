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

	// Core Packages
	api.use(["underscore","coffeescript","mongo"], ["client", "server"]);
	api.use(["templating"], "client");

	// External Packages
	api.use(["matb33:collection-hooks@0.7.3"], ["client", "server"],{weak:true});

	// Cloudinary Client Side
	// api.add_files("lib/jquery.iframe-transport.js","client"); //Compatibility for old browsers, look at this later
	api.add_files("lib/jquery.cloudinary.js","client");

	// Core Files
	api.add_files("server/configuration.coffee", "server");
	api.add_files("server/signature.coffee", "server");

	api.add_files("client/functions.coffee", "client");

	api.export && api.export("Cloudinary",["server","client"]);


	// api.add_files("client/blocks.html", "client");
	// api.add_files("client/helpers.js", "client");
	// api.add_files("client/controllers.js","client");
	// api.add_files("client/collections.js", "client");
	// api.add_files("client/functions.js", "client");

	//Allow user access to Cloudinary server-side
	// api.export && api.export("_cloudinary","client");
	// api.export && api.export("C","client");
});

