/**
 * I am a new handler
 */
component{

	//handlers/Registration.cfc
	property name="userService" inject="UserService";

	// OPTIONAL HANDLER PROPERTIES
	this.prehandler_only 	= "";
	this.prehandler_except 	= "";
	this.posthandler_only 	= "";
	this.posthandler_except = "";
	this.aroundHandler_only = "";
	this.aroundHandler_except = "";
	// REST Allowed HTTP Methods Ex: this.allowedMethods = {delete='POST,DELETE',index='GET'}
	this.allowedMethods = {};

	function new( event, rc, prc ) {
		event.setView( "registration/new" );
	}

	// create / save User
	function create( event, rc, prc ) {
		prc.oUser = userService.create( populateModel( "User" ) );
		auth().login( prc.oUser );
		relocate( uri = "/" );
	}


}
