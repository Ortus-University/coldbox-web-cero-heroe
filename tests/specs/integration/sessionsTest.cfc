/**
 * 	ColdBox Integration Test
 *
 * 	The 'appMapping' points by default to the '/root ' mapping created in  the test folder Application.cfc.  Please note that this
 * 	Application.cfc must mimic the real one in your root, including ORM  settings if needed.
 *
 *	The 'execute()' method is used to execute a ColdBox event, with the  following arguments
 *	- event : the name of the event
 *	- private : if the event is private or not
 *	- prePostExempt : if the event needs to be exempt of pre post interceptors
 *	- eventArguments : The struct of args to pass to the event
 *	- renderResults : Render back the results of the event
 *
 * You can also use the HTTP executables: get(), post(), put(), path(), delete(), request()
 **/
component extends="tests.resources.BaseIntegrationSpec" appMapping="/"{

	property name="query" 		inject="provider:QueryBuilder@qb";
    property name="bcrypt" 		inject="@BCrypt";
    property name="cbAuth"      inject="authenticationService@cbauth";

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();
		query.from( "users" )
			.insert( values = {
				username : "testuser",
				email : "testuser@tests.com",
				password : bcrypt.hashPassword( "password" )
			} );
	}

	function afterAll(){
		super.afterAll();
		query.from( "users" )
			.where( "username", "=", "testuser" )
			.delete();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "sessions Suite", function(){

			beforeEach(function( currentSpec ){
				// Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
			});

			it( "can present the login screen", function(){
				var event = execute( event="sessions.new", renderResults=true );
				// expectations go here.
				expect( event.getRenderedContent() ).toInclude( "Log In" );
			});

			it( "can log in a valid user", function(){
				var event = post( route="/login", params={ username="testuser", password="password"} );
				// expectations go here.
				expect( event.getValue( "relocate_URI") ).toBe( "/" );
				expect( cbAuth.isLoggedIn() ).toBeTrue();
			});

			it( "can show an invalid message for an invalid user", function(){
				var event = post( route="/login", params={ username="testuser", password="bad"} );
				// expectations go here.
				expect( event.getValue( "relocate_URI") ).toBe( "/login" );
			});

			it( "can logout a user", function(){
				var event = delete( route="/logout" );
				// expectations go here.
				expect( cbAuth.isLoggedIn() ).toBeFalse();
				expect( event.getValue( "relocate_URI") ).toBe( "/" );
			});

		});

	}

}
