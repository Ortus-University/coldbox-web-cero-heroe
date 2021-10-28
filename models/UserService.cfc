/**
 * I am a new Model Object
 */
component singleton accessors="true"{

    // To populate objects from data
    property name="populator" inject="wirebox:populator";
    // For encryption
    property name="bcrypt" inject="@BCrypt";


	/**
	 * Constructor
	 */
	UserService function init(){

		return this;
	}



	public array function list() {

		return queryExecute(
			"select * from users",
			{},
			{ returntype="array" }
		);
	}


	/**
	* Create a new user
	*
	* @email
	* @username
	* @password
	*
	* @return The created id of the user
	*/
	function create( required user ){
		queryExecute(
			"
				INSERT INTO `users` (`email`, `username`, `password`)
				VALUES (?, ?, ?)
			",
			[
				user.getEmail(),
				user.getUsername(),
				bcrypt.hashPassword( user.getPassword() )
			],
			{ result = "local.result" }
		);
		user.setId( result.generatedKey );
		return user;
	}

    // What is this FUNKYNESS!!!
    User function new() provider="User";

	User function retrieveUserById( required id ) {
        return populator.populateFromQuery(
            new(),
            queryExecute( "SELECT * FROM `users` WHERE `id` = ?", [ arguments.id ] )
        );
    }

    User function retrieveUserByUsername( required username ) {
        return populator.populateFromQuery(
            new(),
            queryExecute( "SELECT * FROM `users` WHERE `username` = ?", [ arguments.username ] )
        );
    }

    boolean function isValidCredentials( required username, required password ) {
		var oUser = retrieveUserByUsername( arguments.username );
        if( !oUser.isLoaded() ){
            return false;
		}

        return bcrypt.checkPassword( arguments.password, oUser.getPassword() );
    }


}