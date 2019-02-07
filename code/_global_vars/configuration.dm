// Bomb cap!
GLOBAL_VAR_INIT(max_explosion_range, 14)


var/href_logfile        = null
var/game_version        = "Baystation12"
var/changelog_hash      = ""
var/game_year           = (text2num(time2text(world.realtime, "YYYY")) + 288)
var/join_motd = null

var/secret_force_mode = "secret"   // if this is anything but "secret", the secret rotation will forceably choose this mode.

var/Debug2 = 0

var/gravity_is_on = 1

// Database connections. A connection is established on world creation.
// Ideally, the connection dies when the server restarts (After feedback logging.).
var/DBConnection/dbcon     = new() // Feedback    database (New database)
var/DBConnection/dbcon_old = new() // /tg/station database (Old database) -- see the files in the SQL folder for information on what goes where.


// For FTP requests. (i.e. downloading runtime logs.)
// However it'd be ok to use for accessing attack logs and such too, which are even laggier.
var/fileaccess_timer = 0
var/custom_event_msg = null

GLOBAL_VAR_INIT(visibility_pref, FALSE)
 // Used for admin shenanigans.
GLOBAL_VAR_INIT(random_players, 0)
GLOBAL_VAR_INIT(triai, 0)