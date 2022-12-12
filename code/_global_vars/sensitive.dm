// MySQL configuration
var/global/sqlenabled   = TRUE
var/global/sqladdress   = "localhost"
var/global/sqlport      = "3306"
var/global/sqldb        = "bay12"
var/global/sqllogin     = "root"
var/global/sqlpass      = "1234"

var/global/sqlfdbkdb    = "test"
var/global/sqlfdbklogin = "root"
var/global/sqlfdbkpass  = ""
var/global/sqlfdbkdbutil = "test"
var/global/sqlfdbktableprefix = "erro_"
var/global/db_version = 0
var/global/DBConnection/dbcon = new
var/global/DBConnection/dbcon_old = new
