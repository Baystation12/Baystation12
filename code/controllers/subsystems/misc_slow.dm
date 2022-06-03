SUBSYSTEM_DEF(misc_slow)
	name = "Misc Updates (Slow)"
	flags = SS_NO_INIT
	runlevels = RUNLEVEL_LOBBY | RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	wait = 5 MINUTES

	/// The number of times dbcon can fail in a row before being considered dead
	var/static/const/DB_RECONNECTS_ALLOWED = 3

	/// a list of (reconnects succeeded, reconnects failed) for dbcon
	var/static/db_status = list(0, 0)

	/// A convenience cache of db_status for stat_entry
	var/static/db_info = "-"

	/// The number of times dbcon_old can fail in a row before being considered dead
	var/static/const/DB_OLD_RECONNECTS_ALLOWED = 3

	/// a list of (reconnects succeeded, reconnects failed) for dbcon_old
	var/static/db_old_status = list(0, 0)

	/// A convenience cache of db_old_status for stat_entry
	var/static/db_old_info = "-"


/datum/controller/subsystem/misc_slow/VV_static()
	return ..() + list(
		"DB_RECONNECTS_ALLOWED",
		"DB_OLD_RECONNECTS_ALLOWED"
	)


/datum/controller/subsystem/misc_slow/Recover()
	RecoverDoReconnects()


/datum/controller/subsystem/misc_slow/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..({"\
		sql: [sqlenabled ? "Y" : "N"]  |  DB: [db_info]  |  DB Old: [db_old_info]\
	"})


/datum/controller/subsystem/misc_slow/fire(resumed, no_mc_tick)
	DoReconnects()


/// Clear the state of members related to db connection maintenance
/datum/controller/subsystem/misc_slow/proc/RecoverDoReconnects()
	db_status = list(0, 0)
	db_info = "-"
	db_old_status = list(0, 0)
	db_old_info = "-"


/// Run connection maintenance for dbcon and dbcon_old, if sql is enabled correct(ish).
/datum/controller/subsystem/misc_slow/proc/DoReconnects()
	if (!sqlenabled)
		return
	if (!sqladdress || !sqlport || !sqllogin || !sqldb || !sqlfdbklogin || !sqlfdbkdb)
		log_debug("SS [name]: SQL credentials misconfigured.")
		return
	var/db_dsn = "dbi:mysql:[sqlfdbkdb]:[sqladdress]:[sqlport]"
	ReconnectDB("DB", dbcon, db_dsn, sqlfdbklogin, sqlfdbkpass, db_status, DB_RECONNECTS_ALLOWED)
	db_info = "DEAD"
	if (db_status[2] < DB_RECONNECTS_ALLOWED)
		db_info = "R[db_status[1]],F[db_status[2]]"
	var/db_old_dsn = "dbi:mysql:[sqldb]:[sqladdress]:[sqlport]"
	ReconnectDB("Old DB", dbcon_old, db_old_dsn, sqllogin, sqlpass, db_old_status, DB_OLD_RECONNECTS_ALLOWED)
	db_old_info = "DEAD"
	if (db_old_status[2] < DB_OLD_RECONNECTS_ALLOWED)
		db_old_info = "R[db_old_status[1]],F[db_old_status[2]]"


/// An ugly proc that attempts to reopen the passed database's connection if it has timed out or been lost.
/datum/controller/subsystem/misc_slow/proc/ReconnectDB(log_name, DBConnection/db, dsn, user, pass, list/status, limit)
	if (status[2] >= limit) // We've failed too many times.
		return
	if (!isnull(db._db_con))
		if (_dm_db_is_connected(db._db_con))
			var/query = _dm_db_new_query() // Do a little dance to keep the connection interested.
			if (_dm_db_execute(query, "SELECT 1;", db._db_con, null, null))
				return
		log_debug("SS [name]: [log_name] reconnecting.")
		_dm_db_close(dbcon._db_con)
		dbcon._db_con = null
	var/connection = _dm_db_new_con()
	var/success = _dm_db_connect(connection, dsn, user, pass, null, null)
	if (success)
		log_debug("SS [name]: [log_name] reconnected ([++status[1]]\th time).")
		db._db_con = connection
		status[2] = 0
		return
	log_debug("SS [name]: [log_name] reconnect failed ([++status[2]]\th time).")
	if (status[1] < limit)
		return
	log_debug("SS [name]: [log_name] reconnect failed too many times. No more attempts will be made.")
