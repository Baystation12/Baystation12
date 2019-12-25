/datum/death
	var/name
	var/key
	var/job
	var/special_role
	var/place_of_death
	var/time_of_death
	var/last_attacker_name
	var/last_attacker_key
	var/gender
	var/bruteloss
	var/fireloss
	var/brainloss
	var/oxyloss
	var/using_map_name
	var/overmap_location_name
	var/coords

SUBSYSTEM_DEF(statistics)
	name = "Statistics"
	wait = 10 MINUTES
	init_order = SS_INIT_MISC_LATE
	flags = SS_NO_INIT | SS_NEEDS_SHUTDOWN

	var/extracted_slime_cores_amount = 0
	var/crew_death_count = 0
	var/list/deaths
	var/list/values = list()
	var/list/value_details = list()
	var/list/population_log = list()

/datum/controller/subsystem/statistics/fire(resumed = FALSE)
	population_log[time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")] = list("players" = LAZYLEN(GLOB.clients), "admin" = LAZYLEN(GLOB.admins))

/datum/controller/subsystem/statistics/Shutdown()

	// Create tables.
	var/database/db = new("data/statistics.sqlite")
	var/database/query/query = new(
		"CREATE TABLE IF NOT EXISTS deaths ( \
		game_id TEXT NOT NULL, \
		name TEXT, \
		key TEXT, \
		job TEXT, \
		special_role TEXT, \
		place_of_death TEXT, \
		time_of_death TEXT, \
		last_attacker_name TEXT, \
		last_attacker_key TEXT, \
		gender TEXT, \
		bruteloss INTEGER, \
		fireloss INTEGER, \
		brainloss INTEGER, \
		oxyloss INTEGER, \
		using_map_name TEXT, \
		overmap_location_name TEXT, \
		coords TEXT \
		);")
	query.Execute(db)
	if(query.Error() || query.ErrorMsg())
		to_world_log( "SQL error - creating death table - [query.Error()] - [query.ErrorMsg()]")

	query = new("CREATE TABLE IF NOT EXISTS population (game_id TEXT NOT NULL, timestamp TEXT NOT NULL, players INTEGER, admin INTEGER);")
	query.Execute(db)
	if(query.Error() || query.ErrorMsg())
		to_world_log( "SQL error - creating population table - [query.Error()] - [query.ErrorMsg()]")

	query = new("CREATE TABLE IF NOT EXISTS feedback (game_id TEXT NOT NULL, field_name TEXT, value TEXT, details TEXT);")
	query.Execute(db)
	if(query.Error() || query.ErrorMsg())
		to_world_log( "SQL error - creating feedback table - [query.Error()] - [query.ErrorMsg()]")

	// Dump stats.
	if(LAZYLEN(deaths))
		for(var/thing in deaths)
			var/datum/death/death = thing
			query = new("INSERT INTO deaths VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);",
				game_id,
				death.name,
				death.key,
				death.job,
				death.special_role,
				death.place_of_death,
				death.time_of_death,
				death.last_attacker_name,
				death.last_attacker_key,
				death.gender,
				death.bruteloss,
				death.fireloss,
				death.brainloss,
				death.oxyloss,
				death.using_map_name,
				death.overmap_location_name,
				death.coords
			)
			query.Execute(db);
			if(query.Error() || query.ErrorMsg())
				to_world_log( "SQL error - logging death - [query.Error()] - [query.ErrorMsg()]")

	if(LAZYLEN(population_log))
		for(var/thing in population_log)
			var/list/data = population_log[thing]
			query = new("INSERT INTO population VALUES (?, ?, ?, ?);", game_id, thing, data["players"], data["admin"])
			query.Execute(db);
			if(query.Error() || query.ErrorMsg())
				to_world_log( "SQL error - logging population - [query.Error()] - [query.ErrorMsg()]")

	// These values are arbitrary and largely unused, so using JSON is far easier than expecting
	// people to maintain a hard list of fields and migrate the tables every time they change.
	if(LAZYLEN(values))
		for(var/field in values)
			var/deets = value_details[field] ? json_encode(value_details[field]) : null
			var/val = islist(values[field]) ? jointext(values[field], "\n") : "[values[field]]"
			query = new("INSERT INTO feedback VALUES (?, ?, ?, ?);", game_id, field, val, deets)
			query.Execute(db);
			if(query.Error() || query.ErrorMsg())
				to_world_log( "SQL error - logging values - [query.Error()] - [query.ErrorMsg()]")

/datum/controller/subsystem/statistics/proc/get_field(var/field)
	return values[field]

/datum/controller/subsystem/statistics/proc/set_field(var/field, var/value)
	values[field] = value

/datum/controller/subsystem/statistics/proc/add_field(var/field, var/value)
	if(isnull(values[field]))
		set_field(field, value)
	else
		values[field] += value

/datum/controller/subsystem/statistics/proc/get_field_details(var/field)
	return jointext(value_details[field], "<br>")

/datum/controller/subsystem/statistics/proc/set_field_details(var/field, var/details)
	value_details[field] = list(details)

/datum/controller/subsystem/statistics/proc/add_field_details(var/field, var/details)
	if(isnull(value_details[field]))
		set_field_details(field, details)
	else
		value_details[field] += details

/datum/controller/subsystem/statistics/proc/report_death(var/mob/living/dead)

	if(dead && dead.mind && dead.client)
		var/datum/death/death = new
		var/area/placeofdeath = get_area(dead)
		death.place_of_death = placeofdeath ? placeofdeath.name : "Unknown area"
		death.place_of_death = sanitizeSQL(death.place_of_death)
		death.name = sanitizeSQL(dead.real_name)
		death.key = sanitizeSQL(dead.key)
		death.special_role = sanitizeSQL(dead.mind.special_role)
		death.job = sanitizeSQL(dead.mind.assigned_role)
		if(dead.last_attacker_)
			death.last_attacker_name = sanitizeSQL(dead.last_attacker_.name)
			death.last_attacker_key =  sanitizeSQL(dead.last_attacker_.client.key)
		death.gender = dead.gender
		death.time_of_death = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")
		death.coords = "[dead.x], [dead.y], [dead.z]"
		death.bruteloss = dead.getBruteLoss()
		death.fireloss =  dead.getFireLoss()
		death.brainloss = dead.getBrainLoss()
		death.oxyloss =   dead.getOxyLoss()
		death.using_map_name = GLOB.using_map.full_name
		var/obj/effect/overmap/visitable/cell = map_sectors ? map_sectors["[dead.z]"] : null
		death.overmap_location_name = cell ? cell.name : "Unknown"
		LAZYADD(deaths, death)

		if(!player_is_antag(dead.mind) && dead.mind.assigned_job && dead.mind.assigned_job.department_flag)
			crew_death_count++
