$.cloudinary.config({
	cloud_name:"tester"
});

Template.tester.created = function(){
	Meteor.call("cloudinary_list_all",function(e,list){
		Session.set("image_list",list);
	});
}

Template.tester.helpers({
	"stuff":function(){
		return {name:"something",_id:"12345"}
	},
	"image_list":function(){
		return Session.get("image_list");
	}
});

Template.tester.events({
	"click .delete":function(){
		Meteor.call("cloudinary_delete",this.public_id,function(e,r){
			if(!e){
				console.log(r);
			}
		});
	}
});