Package.describe({
	name:'lepozepo:cloudinary',
	summary: 'Upload files to Cloudinary',
	version:'5.0.0',
	git:'https://github.com/Lepozepo/cloudinary'
});

Package.onUse(function (api){
	// api.addFiles('.npm/package/node_modules/cloudinary-jquery/cloudinary-jquery.min.js','client');

	// Core Packages
	api.use('meteor-base');
	api.use('coffeescript');
	api.use('mongo');
	api.use('underscore');
	api.use('templating');
	api.use('check');
	api.use('random');
	api.use('reactive-var');
	api.use('modules');
	api.use('jquery');

	// External Packages
	api.use(['matb33:collection-hooks','audit-argument-checks'], ['client', 'server'],{weak:true});

	// Cloudinary Client Side

	// Core Modules
	api.mainModule('client/functions.coffee', 'client', { lazy: true });
	api.mainModule('server/index.coffee', 'server', { lazy: true });
});

Npm.depends({
	cloudinary: '1.9.1',
	'cloudinary-jquery': '2.3.0'
});
