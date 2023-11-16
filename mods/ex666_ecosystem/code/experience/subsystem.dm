#define SSEXP_STEP_WAIT 0
#define SSEXP_STEP_GET_EXP 1
#define SSEXP_STEP_UPDATE_EXP 2

SUBSYSTEM_DEF(experience)
	name = "Player Experience"
	wait = 0.5 SECONDS
	init_order = SS_INIT_MISC_LATE
	flags = SS_NO_INIT | SS_NEEDS_SHUTDOWN
	var/step = SSEXP_STEP_WAIT
	var/last_check = 0
	var/interval = 5 MINUTES
	var/max_queries_per_tick = 20

	var/list/client/clients_to_process

	/// List of SELECT queries to mass grab EXP.
	var/list/DBQuery/select_queries_queue
	/// List of SELECT queries with grabbed EXP.
	var/list/DBQuery/select_queries

	/// List of queries to update player EXP
	var/list/DBQuery/player_update_queries
	/// List of queries to update the playtime history table
	var/list/DBQuery/playtime_history_update_queries

	var/list/old_exp_records = list() // Assoc List of ckey to exp
	var/list/old_species_exp_records = list() // Assoc List of ckey to species exp

/datum/controller/subsystem/experience/fire(resumed = FALSE)

	if (step == SSEXP_STEP_WAIT && (world.realtime - last_check) < interval)
		return

	establish_db_connection()
	if (!dbcon.IsConnected())
		log_debug("No connections to database while updating player experience in [src.type]")
		last_check = world.realtime
		step = SSEXP_STEP_WAIT
		return

	switch (step)
		if (SSEXP_STEP_WAIT)
			populate_select_queue()
		if (SSEXP_STEP_GET_EXP)
			execute_select_queue()
			get_player_exp()
		if (SSEXP_STEP_UPDATE_EXP)
			populate_update_queue()


/datum/controller/subsystem/experience/proc/populate_select_queue()
	last_check = world.realtime
	var/minutes_to_add = interval / (1 MINUTE)

	// Get a list of clients to process
	// This is copied so that clients joining in the middle of this dont break things
	clients_to_process = GLOB.clients.Copy()
	log_debug("Starting EXP update for [LAZYLEN(clients_to_process)] clients. (Adding [minutes_to_add] minutes)")

	select_queries_queue = list()
	for (var/client/client as anything in clients_to_process)
		// If a client logs out in the middle of this or has no mob or mind
		if(!client || !client.mob || !client.mob.mind)
			clients_to_process.Remove(client)
			continue

		var/sql_ckey = sql_sanitize_text(client.ckey)
		select_queries_queue[client.ckey] = dbcon.NewQuery("SELECT `exp`, `species_exp` FROM `erro_player` WHERE `ckey` = '[sql_ckey]'")

	step = SSEXP_STEP_GET_EXP


/datum/controller/subsystem/experience/proc/execute_select_queue()
	LAZYINITLIST(select_queries)

	var/i = 1
	for (var/ckey in select_queries_queue)
		if (i++ > max_queries_per_tick)
			return

		var/DBQuery/query = select_queries_queue[ckey]
		query.Execute()

		select_queries_queue.Remove(ckey)
		select_queries[ckey] = query

	// When all the queue was processed we can continue to updates
	// Next will be called proc get_player_exp() and next tick - next step
	step = SSEXP_STEP_UPDATE_EXP


/datum/controller/subsystem/experience/proc/get_player_exp()
	LAZYINITLIST(old_exp_records)
	LAZYINITLIST(old_species_exp_records)

	for (var/client/client as anything in clients_to_process)
		// If a client logs out in the middle of this or has no mob or mind
		if(!client || !client.mob || !client.mob.mind || !select_queries[client.ckey])
			clients_to_process.Remove(client)
			continue

		while(select_queries[client.ckey].NextRow())
			old_exp_records[client.ckey] = params2list(select_queries[client.ckey].item[1])
			old_species_exp_records[client.ckey] = params2list(select_queries[client.ckey].item[2])

	for(var/item in select_queries)
		qdel(select_queries[item])
	select_queries.Cut()


/datum/controller/subsystem/experience/proc/populate_update_queue()

	player_update_queries = list() // List of queries to update player EXP
	playtime_history_update_queries = list() // List of queries to update the playtime history table

	var/minutes_to_add = interval / (1 MINUTE)

	// Loop to update player experience
	for(var/client/client as anything in clients_to_process)
		// If a client logs out in the middle of this or has no mob or mind
		if(!client || !client.mob || !client.mob.mind)
			clients_to_process.Remove(client)
			continue

		var/list/new_exp_records = create_exp_records(GLOB.job_exp_type_to_job_titles, old_exp_records[client.ckey])
		var/list/new_species_exp_records = create_exp_records(GLOB.species_to_names_map, old_species_exp_records[client.ckey])

		var/role = client.mob.mind.assigned_role
		var/species = client.mob.dna?.species
		var/added_living = 0
		var/added_ghost = 0
		if(client.mob.stat != DEAD)
			if(role)
				new_exp_records[EXP_TYPE_LIVING] += minutes_to_add
				added_living += minutes_to_add

				for(var/job_exp_type in GLOB.job_exp_type_to_job_titles)
					if(role in GLOB.job_exp_type_to_job_titles[job_exp_type])
						new_exp_records[job_exp_type] += minutes_to_add // Add played time to current player's job experience

				// To avoid double logging for submap positions and special roles,
				// that are mostly antags, there is check for presence in submap_positions list
				if(client.mob.mind.special_role && !(role in GLOB.submap_positions))
					new_exp_records[EXP_TYPE_SPECIAL] += minutes_to_add

			if(species)
				for(var/species_type in GLOB.species_to_names_map)
					if(species in GLOB.species_to_names_map[species_type])
						new_species_exp_records[species_type] += minutes_to_add // Add played time to current player's species experience
						break // Mob can't be multiple species at the same time, so we break as we found needed `species`

		else if(isobserver(client.mob))
			new_exp_records[EXP_TYPE_GHOST] += minutes_to_add
			added_ghost += minutes_to_add
		else
			continue

		var/updated_exp = list2params(new_exp_records)
		var/updated_species_exp = list2params(new_species_exp_records)

		var/sql_ckey = sql_sanitize_text(client.ckey)
		var/DBQuery/player_update_query = dbcon.NewQuery({"
			UPDATE `erro_player`
			SET
				`exp` = [updated_exp],
				`species_exp` = [updated_species_exp],
				`lastseen` = NOW()
			WHERE
				`ckey` = '[sql_ckey]'
		"})

		player_update_queries += player_update_query

		var/DBQuery/update_query_history = dbcon.NewQuery({"
			INSERT
				INTO `erro_playtime_history`
				(`ckey`, `date`, `time_living`, `time_ghost`)
			VALUES
				('[sql_ckey]', CURDATE(), [added_living], [added_ghost])
			ON DUPLICATE KEY
				UPDATE
					`time_living` = `time_living` + VALUES(`time_living`),
					`time_ghost` = `time_ghost` + VALUES(`time_ghost`)
		"})

		playtime_history_update_queries += update_query_history

		execute_update_queue()

/datum/controller/subsystem/experience/proc/execute_update_queue()

	for (var/DBQuery/query as anything in player_update_queries)
		invoke_async(query, /DBQuery/proc/Execute)
	player_update_queries.Cut()

	for (var/DBQuery/query as anything in playtime_history_update_queries)
		invoke_async(query, /DBQuery/proc/Execute)
	playtime_history_update_queries.Cut()

	log_debug("Successfully requested update of all EXP data in [(world.realtime - last_check)/10]s")
	step = SSEXP_STEP_WAIT

/datum/controller/subsystem/experience/proc/create_exp_records(list/exp_map, list/old_records)
	if (!old_records)
		old_records = list()

	var/list/new_records = list()
	for(var/exp_type in exp_map)
		var/old_exp_value = text2num(old_records[exp_type])
		if(old_exp_value)
			new_records[exp_type] = old_exp_value
		else
			new_records[exp_type] = 0

	return new_records

#undef SSEXP_STEP_WAIT
#undef SSEXP_STEP_GET_EXP
#undef SSEXP_STEP_UPDATE_EXP
