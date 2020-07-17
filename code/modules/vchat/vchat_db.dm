#define VCHAT_FILENAME "data/vchat.db"
GLOBAL_DATUM(vchatdb, /database)

//Boot up db file
/proc/init_vchat()
	//Cleanup previous if exists
	fdel(VCHAT_FILENAME)
	fdel(VCHAT_FILENAME+"-shm") //Shared memory, and
	fdel(VCHAT_FILENAME+"-wal") // write ahead. Only present on unclean stop.

	//Create a new one
	GLOB.vchatdb = new(VCHAT_FILENAME)

	//Build our basic boring tables
	vchat_create_tables()

//Check to see if it's init
/proc/check_vchat()
	if(istype(GLOB.vchatdb))
		return TRUE
	else
		return FALSE

//For INSERT/CREATE/DELETE, etc that return a RowsAffected.
/proc/vchat_exec_update(var/query)
	if(!check_vchat())
		log_world("There's no vchat database open but you tried to query it with: [query]")
		return FALSE

	//Solidify our query
	var/database/query/q = vchat_build_query(query)

	//Run it
	q.Execute(GLOB.vchatdb)

	//Handle errors
	if(q.Error())
		log_world("Query \"[islist(query)?query[1]:query]\" ended in error [q.ErrorMsg()]")
		return FALSE

	return q.RowsAffected()

//For SELECT, that return results.
/proc/vchat_exec_query(var/query)
	if(!check_vchat())
		log_world("There's no vchat database open but you tried to query it!")
		return FALSE

	//Solidify our query
	var/database/query/q = vchat_build_query(query)

	//Run it
	q.Execute(GLOB.vchatdb)

	//Handle errors
	if(q.Error())
		log_world("Query \"[islist(query)?query[1]:query]\" ended in error [q.ErrorMsg()]")
		return FALSE

	//Return any results
	var/list/results = list()
	//Return results if any.
	while(q.NextRow())
		results[++results.len] = q.GetRowData()

	return results

//Create a query from string or list with params
/proc/vchat_build_query(var/query)
	var/database/query/q

	if(islist(query))
		q = new(arglist(query))
	else
		q = new(query)

	if(!istype(q))
		return

	return q

/proc/vchat_create_tables()
	//Byond is so great half the time it doesn't delete the file
	var/cleanup = "DROP TABLE IF EXISTS messages"
	vchat_exec_update(cleanup)

	//Messages table
	var/tabledef = "CREATE TABLE messages(\
			id INTEGER PRIMARY KEY AUTOINCREMENT,\
			ckey VARCHAR(50) NOT NULL,\
			worldtime INTEGER NOT NULL,\
			message TEXT NOT NULL)"
	vchat_exec_update(tabledef)

	//Index on ckey
	var/indexdef = "CREATE INDEX ckey_index ON messages (ckey)"
	vchat_exec_update(indexdef)

//INSERT a new message
/proc/vchat_add_message(var/ckey, var/message)
	if(!ckey || !message)
		return
	var/list/messagedef = list(
		"INSERT INTO messages (ckey,worldtime,message) VALUES (?, ?, ?)",
		ckey,
		world.time || 0,
		message)

	return vchat_exec_update(messagedef)

//Get a player's message history.  If limit is supplied, messages will be in reverse order.
/proc/vchat_get_messages(var/ckey, var/limit)
	if(!ckey)
		return

	var/list/getdef
	if (limit)
		getdef = list("SELECT * FROM messages WHERE ckey = ? ORDER BY id DESC LIMIT [text2num(limit)]", ckey)
	else
		getdef = list("SELECT * FROM messages WHERE ckey = ?", ckey)

	return vchat_exec_query(getdef)

#undef VCHAT_FILENAME
