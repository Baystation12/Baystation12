/datum/persistence/load_cache/thing
	var/id
	var/thing_type
	var/x
	var/y
	var/z
	var/list/thing_vars = list()

/datum/persistence/load_cache/thing/New(var/sql_row)
	id = text2num(sql_row["id"])
	thing_type = text2path(sql_row["type"])
	x = text2num(sql_row["x"])
	y = text2num(sql_row["y"])
	z = text2num(sql_row["z"])
	thing_vars = list()

/datum/persistence/load_cache/thing_var
	var/id
	var/var_type
	var/key
	var/value

/datum/persistence/load_cache/thing_var/New(var/sql_row)
	var_type = sql_row["type"]
	key = sql_row["key"]
	value = sql_row["value"]

/datum/persistence/load_cache/list_element
	var/index
	var/key
	var/key_type
	var/value
	var/value_type

/datum/persistence/load_cache/list_element/New(var/sql_row)
	index = text2num(sql_row["index"])
	key = sql_row["key"]
	key_type = sql_row["key_type"]
	value = sql_row["value"]
	value_type = sql_row["value_type"]

/datum/persistence/load_cache/resolver
	var/list/things = list()
	var/list/lists = list()

	var/vars_cached = 0
	var/lists_cached = 0
	var/things_cached = 0

	var/failed_vars = 0

/datum/persistence/load_cache/resolver/proc/load_cache(var/version) 
	clear_cache()

	// Deserialize the objects
	var/start = world.timeofday
	var/DBQuery/query = dbcon.NewQuery("SELECT `id`,`type`,`x`,`y`,`z` FROM `thing` WHERE `version`=[version];")
	query.Execute()
	while(query.NextRow())
		var/items = query.GetRowData()
		var/datum/persistence/load_cache/thing/T = new(items)
		things[items["id"]] = T
		things_cached++
		CHECK_TICK
	to_world_log("Took [world.timeofday - start] to cache all things.")

	// Deserialize vars
	start = world.timeofday
	query = dbcon.NewQuery("SELECT `thing_id`,`key`,`type`,`value` FROM `thing_var` WHERE `version`=[version];")
	query.Execute()
	while(query.NextRow())
		var/items = query.GetRowData()
		var/datum/persistence/load_cache/thing_var/V = new(items)
		var/datum/persistence/load_cache/thing/T = things["[items["thing_id"]]"]
		if(T)
			T.thing_vars.Add(V)
			vars_cached++
		else
			failed_vars++
		CHECK_TICK
	to_world_log("Took [world.timeofday - start] to cache all thing vars.")

	// Deserialized lists
	start = world.timeofday
	query = dbcon.NewQuery("SELECT `list_id`,`index`,`key`,`key_type`,`value`,`value_type` FROM `list_element` WHERE `version`=[version];")
	query.Execute()
	while(query.NextRow())
		var/items = query.GetRowData()
		var/datum/persistence/load_cache/list_element/element = new(items)
		LAZYADD(lists["items["list_id"]"], element)
		lists_cached++
		CHECK_TICK
	to_world_log("Took [world.timeofday - start] to cache all lists")

	// Done!
	to_world_log("Cached [things_cached] things, [vars_cached + failed_vars] vars, [lists_cached] lists. [failed_vars] failed to cache due to missing thing references.")

/datum/persistence/load_cache/resolver/proc/clear_cache()
	things.Cut(1)
	lists.Cut(1)

	vars_cached = 0
	lists_cached = 0
	things_cached = 0
	failed_vars = 0