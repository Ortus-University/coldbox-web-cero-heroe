component {

    function up( schema, qb ) {
        // crear una tabla
        queryExecute( "
            CREATE TABLE `users` (
                `id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
                `username` VARCHAR(255) NOT NULL UNIQUE,
                `email` VARCHAR(255) NOT NULL UNIQUE,
                `password` VARCHAR(255) NOT NULL,
                `createdDate` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                `modifiedDate` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                CONSTRAINT `pk_users_id` PRIMARY KEY (`id`)
            )
        " );
    }

    function down( schema, qb ) {
        // drop a esa tabla
		queryExecute( "DROP TABLE `users`" );
    }

}
