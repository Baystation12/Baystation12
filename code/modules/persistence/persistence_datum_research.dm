/datum/persistent/research
	name = "research"

/datum/persistent/research/IsValidEntry(atom/entry)
	var/obj/machinery/r_n_d/server/server = entry
	return istype(server) && !MACHINE_IS_BROKEN(server)

/datum/persistent/research/ProcessAndApplyTokens(list/tokens)
	for (var/list/entry in tokens)
		if (prob(10)) //small chance to keep all progress from previous round
			break

		if (prob(60))
			entry["level"] = max(1, entry["level"] - 1)
		else if (prob(20))
			entry["level"] = entry["level"] - pick(2, 3)

		entry["level"] = max(1, entry["level"])

	for (var/list/entry in tokens)
		var/_z = entry["z"]
		if (_z in GLOB.using_map.station_levels)
			. = GetValidTurf(locate(entry["x"], entry["y"], _z), entry)
			if (.)
				CreateEntryInstance(., entry)

/datum/persistent/research/CheckTokenSanity(list/tokens)
	for (var/list/entry in tokens)
		if (!entry["id"] || entry["level"] < 0)
			return FALSE
	return TRUE

/datum/persistent/research/CheckTurfContents(turf/T, list/tokens)
	return (locate(/obj/machinery/r_n_d/server) in T)

/datum/persistent/research/CreateEntryInstance(turf/creating, list/tokens)
	var/obj/machinery/r_n_d/server/server = locate() in creating
	if (!server)
		return

	var/id = tokens["id"]
	var/level = tokens["level"] ? tokens["level"] : 1
	for (var/datum/tech/T in server.files.known_tech)
		if (T.id == id)
			T.level = max(1, level)
			break

	SSpersistence.track_value(server, /datum/persistent/research)

/datum/persistent/research/CompileEntry(atom/entry)
	var/obj/machinery/r_n_d/server/server = entry
	var/list/techs = list()
	for (var/datum/tech/tech in server.files.known_tech)
		if (tech.id == TECH_ESOTERIC)
			continue
		var/list/_entry = list()
		_entry["id"] = tech.id
		_entry["level"] = tech.level
		_entry["x"] = server.x
		_entry["y"] = server.y
		_entry["z"] = server.z
		techs += list(_entry)

	return techs

/hook/game_ready/proc/TrackResearchPersistence()
	for (var/obj/machinery/r_n_d/server/server in world)
		if (server.z in GLOB.using_map.station_levels)
			SSpersistence.track_value(server, /datum/persistent/research)

	return TRUE
