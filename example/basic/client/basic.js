$.cloudinary.config({
	cloud_name:"tester"
});

Template.tester.helpers({
	"stuff":function(){
		return {name:"something",_id:"12345"}
	}
});