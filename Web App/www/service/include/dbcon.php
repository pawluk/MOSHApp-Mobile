<?php
class DB_Connect {

    public function connect() {
        require_once 'include/dbdefine.php';
        $con = mysql_connect(DB_HOST, DB_USER, DB_PASSWORD);
        mysql_select_db(DB_DATABASE);

        // return database handler
        return $con;
    }
    public function close() {
        mysql_close();
    }

}
?>