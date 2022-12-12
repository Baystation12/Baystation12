SUBSYSTEM_DEF(statistics)
	name = "Statistics"
	wait = 5 MINUTES
	init_order = SS_INIT_MISC_LATE
	flags = SS_NO_INIT | SS_NEEDS_SHUTDOWN

/datum/controller/subsystem/statistics/fire(resumed = FALSE)

	if(!dbcon.IsConnected())
		log_debug("No connections to database while gathering player experience in /datum/controller/subsystem/statistics")
		return

	// Set 'announce' to TRUE, if want to notify players about their earnings :D
	update_player_exp(announce = TRUE)

/**
  * This proc will update all players EXP end SPECIES_EXP at once. It will calculate amount of time to add dynamically based on the SS fire time.
  *
  * Arguments:
  * * announce - whether or not to announce aboutconvert  exp update to players
  */
/datum/controller/subsystem/statistics/proc/update_player_exp(announce = FALSE)

	var/start_time = start_watch()

	// Calculate minutes based on the SS wait time (How often this proc fires)
	var/minutes_to_add = wait / (1 MINUTE)

	// Get a list of clients to process
	// This is copied so that clients joining in the middle of this dont break things
	var/list/client/clients_to_process = GLOB.clients.Copy()
	log_debug("Starting EXP update for [LAZYLEN(clients_to_process)] clients. (Adding [minutes_to_add] minutes)")

	// List of SELECT queries to mass grab EXP.
	var/list/datum/db_query/select_queries = list()

	for (var/client/client as anything in clients_to_process)

		// If a client logs out in the middle of this or has no mob or mind
		if(!client || !client.mob || !client.mob.mind)
			continue

		var/datum/db_query/exp_read = SSdbcore.NewQuery(
			"SELECT exp, species_exp FROM [format_table_name("player")] WHERE ckey=:ckey",
			list("ckey" = client.ckey)
		)

		select_queries[client.ckey] = exp_read

	// Explanation for parameters:
	// TRUE: We want warnings if these fail
	// FALSE: Do NOT qdel() queries here, otherwise they wont be read. At all.
	// TRUE: This is an assoc list, so it needs to prepare for that
	// FALSE: We dont want to logspam
	SSdbcore.MassExecute(select_queries, TRUE, FALSE, TRUE, FALSE) // Batch execute so we can take advantage of async magic

	// Assoc List of ckey to exp
	var/list/old_exp_records = list()

	// Assoc List of ckey to species exp
	var/list/old_species_exp_records = list()

	for (var/client/client as anything in clients_to_process)

		// If a client logs out in the middle of this or has no mob or mind
		if(!client || !client.mob || !client.mob.mind)
			continue

		while(select_queries[client.ckey].NextRow())
			old_exp_records[client.ckey] = params2list(select_queries[client.ckey].item[1])
			old_species_exp_records[client.ckey] = params2list(select_queries[client.ckey].item[2])

	QDEL_LIST_ASSOC_VAL(select_queries) // Clean stuff up

	var/list/datum/db_query/player_update_queries = list() // List of queries to update player EXP
	var/list/datum/db_query/playtime_history_update_queries = list() // List of queries to update the playtime history table

	// Loop to update player experience
	for(var/client/client as anything in clients_to_process)

		// If a client logs out in the middle of this or has no mob or mind
		if(!client || !client.mob || !client.mob.mind)
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

				if(announce)
					to_chat(client.mob, SPAN_NOTICE("You got: [minutes_to_add] Living EXP!"))

				for(var/job_exp_type in GLOB.job_exp_type_to_job_titles)
					if(role in GLOB.job_exp_type_to_job_titles[job_exp_type])

						// Add played time to current player's job experience
						new_exp_records[job_exp_type] += minutes_to_add
						if(announce)
							to_chat(client.mob, SPAN_NOTICE("You got: [minutes_to_add] [job_exp_type] EXP!"))

				// To avoid double logging for submap positions and special roles, that are mostly antags, there is check for presence in submap_positions list
				if(client.mob.mind.special_role && !(role in GLOB.submap_positions))
					new_exp_records[EXP_TYPE_SPECIAL] += minutes_to_add
					if(announce)
						to_chat(client.mob, SPAN_NOTICE("You got: [minutes_to_add] Special EXP!"))

			if(species)
				for(var/species_type in GLOB.species_to_names_map)
					if(species in GLOB.species_to_names_map[species_type])

						// Add played time to current player's species experience
						new_species_exp_records[species_type] += minutes_to_add
						if(announce)
							to_chat(client.mob, SPAN_NOTICE("You got: [minutes_to_add] [species_type] EXP!"))

						// Mob can't be multiple species at the same time, so we break as we found needed `species`
						break

		else if(isobserver(client.mob))
			new_exp_records[EXP_TYPE_GHOST] += minutes_to_add
			added_ghost += minutes_to_add
			if(announce)
				to_chat(client.mob, SPAN_NOTICE("You got: [minutes_to_add] Ghost EXP!"))
		else
			continue

		var/updated_exp = list2params(new_exp_records)
		var/updated_species_exp = list2params(new_species_exp_records)

		var/datum/db_query/player_update_query = SSdbcore.NewQuery(
			"UPDATE [format_table_name("player")] SET exp =:updated_exp, species_exp =:updated_species_exp, lastseen=NOW() WHERE ckey=:ckey",
			list(
				"updated_exp" = updated_exp,
				"updated_species_exp" = updated_species_exp,
				"ckey" = client.ckey
			)
		)

		player_update_queries += player_update_query

		var/datum/db_query/update_query_history = SSdbcore.NewQuery({"
			INSERT INTO [format_table_name("playtime_history")] (ckey, date, time_living, time_ghost)
			VALUES (:ckey, CURDATE(), :addedliving, :addedghost)
			ON DUPLICATE KEY UPDATE time_living=time_living + VALUES(time_living), time_ghost=time_ghost + VALUES(time_ghost)"},
			list(
				"ckey" = client.ckey,
				"addedliving" = added_living,
				"addedghost" = added_ghost
			)
		)

		playtime_history_update_queries += update_query_history


	// warn=TRUE, qdel=TRUE, assoc=FALSE, log=FALSE
	SSdbcore.MassExecute(player_update_queries, TRUE, TRUE, FALSE, FALSE) // Batch execute so we can take advantage of async magic
	SSdbcore.MassExecute(playtime_history_update_queries, TRUE, TRUE, FALSE, FALSE)

	log_debug("Successfully updated all EXP data in [stop_watch(start_time)]s")



/datum/controller/subsystem/statistics/proc/create_exp_records(list/exp_map, list/old_records)
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
