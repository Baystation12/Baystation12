#define DEFAULT_GAME_YEAR_OFFSET 288

GLOBAL_DATUM_INIT(using_map, /datum/map, new using_map_DATUM)
GLOBAL_LIST_EMPTY(all_maps)

var/const/MAP_HAS_BRANCH = 1	//Branch system for occupations, togglable
var/const/MAP_HAS_RANK = 2		//Rank system, also togglable

/hook/startup/proc/initialise_map_list()
	for(var/type in subtypesof(/datum/map))
		var/datum/map/M
		if(type == GLOB.using_map.type)
			M = GLOB.using_map
			M.setup_map()
		else
			M = new type
		if(!M.path)
			log_error("Map '[M]' ([type]) does not have a defined path, not adding to map list!")
		else
			GLOB.all_maps[M.path] = M
	return 1


/datum/map
	var/name = "Unnamed Map"
	var/full_name = "Unnamed Map"
	var/path
	var/config_path = null

	var/list/station_levels = list() // Z-levels the station exists on
	var/list/admin_levels = list()   // Z-levels for admin functionality (Centcom, shuttle transit, etc)
	var/list/contact_levels = list() // Z-levels that can be contacted from the station, for eg announcements
	var/list/player_levels = list()  // Z-levels a character can typically reach
	var/list/sealed_levels = list()  // Z-levels that don't allow random transit at edge
	var/list/empty_levels = null     // Empty Z-levels that may be used for various things (currently used by bluespace jump)
	var/list/escape_levels = list()  // Z-levels that when a player is in, are considered to have 'escaped' after evacuations.

	var/list/map_levels              // Z-levels available to various consoles, such as the crew monitor. Defaults to station_levels if unset.

	var/list/base_turf_by_z = list() // Custom base turf by Z-level. Defaults to world.turf for unlisted Z-levels
	var/list/usable_email_tlds = list("freemail.net")
	var/base_floor_type = /turf/simulated/floor/airless // The turf type used when generating floors between Z-levels at startup.
	var/base_floor_area                                 // Replacement area, if a base_floor_type is generated. Leave blank to skip.

	//This list contains the z-level numbers which can be accessed via space travel and the percentile chances to get there.
	var/list/accessible_z_levels = list()

	var/list/allowed_jobs	       //Job datums to use.
	                               //Works a lot better so if we get to a point where three-ish maps are used
	                               //We don't have to C&P ones that are only common between two of them
	                               //That doesn't mean we have to include them with the rest of the jobs though, especially for map specific ones.
	                               //Also including them lets us override already created jobs, letting us keep the datums to a minimum mostly.
	                               //This is probably a lot longer explanation than it needs to be.

	var/station_name  = "BAD Station"
	var/station_short = "Baddy"
	var/dock_name     = "THE PirateBay"
	var/boss_name     = "Captain Roger"
	var/boss_short    = "Cap'"
	var/company_name  = "BadMan"
	var/company_short = "BM"
	var/system_name = "Uncharted System"

	var/list/map_admin_faxes = list()

	var/shuttle_docked_message
	var/shuttle_leaving_dock
	var/shuttle_called_message
	var/shuttle_recall_message
	var/emergency_shuttle_docked_message
	var/emergency_shuttle_leaving_dock
	var/emergency_shuttle_recall_message

	var/list/station_networks = list() 		// Camera networks that will show up on the console.

	var/list/holodeck_programs = list() // map of string ids to /datum/holodeck_program instances
	var/list/holodeck_supported_programs = list() // map of maps - first level maps from list-of-programs string id (e.g. "BarPrograms") to another map
												  // this is in order to support multiple holodeck program listings for different holodecks
	                                              // second level maps from program friendly display names ("Picnic Area") to program string ids ("picnicarea")
	                                              // as defined in holodeck_programs
	var/list/holodeck_restricted_programs = list() // as above... but EVIL!

	var/allowed_spawns = list("Arrivals Shuttle","Gateway", "Cryogenic Storage", "Cyborg Storage")
	var/default_spawn = "Arrivals Shuttle"
	var/flags = 0
	var/evac_controller_type = /datum/evacuation_controller
	var/use_overmap = 0		//If overmap should be used (including overmap space travel override)
	var/overmap_size = 20		//Dimensions of overmap zlevel if overmap is used.
	var/overmap_z = 0		//If 0 will generate overmap zlevel on init. Otherwise will populate the zlevel provided.
	var/overmap_event_areas = 0 //How many event "clouds" will be generated

	var/list/lobby_screens = list('icons/default_lobby.png')    // The list of lobby screen images to pick() from.
	var/current_lobby_screen
	var/decl/audio/track/lobby_track                     // The track that will play in the lobby screen.
	var/list/lobby_tracks = list()                  // The list of lobby tracks to pick() from. If left unset will randomly select among all available decl/audio/track subtypes.
	var/welcome_sound = 'sound/AI/welcome.ogg'		// Sound played on roundstart

	var/default_law_type = /datum/ai_laws/nanotrasen  // The default lawset use by synth units, if not overriden by their laws var.
	var/security_state = /decl/security_state/default // The default security state system to use.

	var/id_hud_icons = 'icons/mob/hud.dmi' // Used by the ID HUD (primarily sechud) overlay.

	var/num_exoplanets = 0
	var/list/planet_size  //dimensions of planet zlevel, defaults to world size. Due to how maps are generated, must be (2^n+1) e.g. 17,33,65,129 etc. Map will just round up to those if set to anything other.
	var/away_site_budget = 0
	var/min_offmap_players = 0

	var/list/loadout_blacklist	//list of types of loadout items that will not be pickable

	//Economy stuff
	var/starting_money = 75000		//Money in station account
	var/department_money = 5000		//Money in department accounts
	var/salary_modifier	= 1			//Multiplier to starting character money
	var/station_departments = list()//Gets filled automatically depending on jobs allowed

	var/supply_currency_name = "Credits"
	var/supply_currency_name_short = "Cr."
	var/local_currency_name = "thalers"
	var/local_currency_name_singular = "thaler"
	var/local_currency_name_short = "T"

	var/game_year

	var/list/available_cultural_info = list(
		TAG_HOMEWORLD = list(
			HOME_SYSTEM_MARS,
			HOME_SYSTEM_LUNA,
			HOME_SYSTEM_EARTH,
			HOME_SYSTEM_VENUS,
			HOME_SYSTEM_CERES,
			HOME_SYSTEM_PLUTO,
			HOME_SYSTEM_TAU_CETI,
			HOME_SYSTEM_HELIOS,
			HOME_SYSTEM_TERRA,
			HOME_SYSTEM_TERSTEN,
			HOME_SYSTEM_LORRIMAN,
			HOME_SYSTEM_CINU,
			HOME_SYSTEM_YUKLID,
			HOME_SYSTEM_LORDANIA,
			HOME_SYSTEM_KINGSTON,
			HOME_SYSTEM_GAIA,
			HOME_SYSTEM_MAGNITKA,
			HOME_SYSTEM_OTHER
		),
		TAG_FACTION = list(
			FACTION_SOL_CENTRAL,
			FACTION_INDIE_CONFED,
			FACTION_CORPORATE,
			FACTION_NANOTRASEN,
			FACTION_FREETRADE,
			FACTION_XYNERGY,
			FACTION_HEPHAESTUS,
			FACTION_DAIS,
			FACTION_EXPEDITIONARY,
			FACTION_FLEET,
			FACTION_ARMY,
			FACTION_PCRC,
			FACTION_SAARE,
			FACTION_OTHER
		),
		TAG_CULTURE = list(
			CULTURE_HUMAN_MARTIAN,
			CULTURE_HUMAN_MARSTUN,
			CULTURE_HUMAN_LUNAPOOR,
			CULTURE_HUMAN_LUNARICH,
			CULTURE_HUMAN_VENUSIAN,
			CULTURE_HUMAN_VENUSLOW,
			CULTURE_HUMAN_BELTER,
			CULTURE_HUMAN_PLUTO,
			CULTURE_HUMAN_EARTH,
			CULTURE_HUMAN_CETI,
			CULTURE_HUMAN_SPACER,
			CULTURE_HUMAN_SPAFRO,
			CULTURE_HUMAN_CONFED,
			CULTURE_HUMAN_OTHER,
			CULTURE_OTHER
		),
		TAG_RELIGION = list(
			RELIGION_UNSTATED,
			RELIGION_OTHER,
			RELIGION_JUDAISM,
			RELIGION_HINDUISM,
			RELIGION_BUDDHISM,
			RELIGION_SIKHISM,
			RELIGION_JAINISM,
			RELIGION_ISLAM,
			RELIGION_CHRISTIANITY,
			RELIGION_BAHAI_FAITH,
			RELIGION_AGNOSTICISM,
			RELIGION_DEISM,
			RELIGION_ATHEISM,
			RELIGION_THELEMA,
			RELIGION_SPIRITUALISM,
			RELIGION_SHINTO,
			RELIGION_TAOISM
		)
	)

	var/list/default_cultural_info = list(
		TAG_HOMEWORLD = HOME_SYSTEM_MARS,
		TAG_FACTION =   FACTION_SOL_CENTRAL,
		TAG_CULTURE =   CULTURE_HUMAN_MARTIAN,
		TAG_RELIGION =  RELIGION_AGNOSTICISM
	)

	var/access_modify_region = list(
		ACCESS_REGION_SECURITY = list(access_hos, access_change_ids),
		ACCESS_REGION_MEDBAY = list(access_cmo, access_change_ids),
		ACCESS_REGION_RESEARCH = list(access_rd, access_change_ids),
		ACCESS_REGION_ENGINEERING = list(access_ce, access_change_ids),
		ACCESS_REGION_COMMAND = list(access_change_ids),
		ACCESS_REGION_GENERAL = list(access_change_ids),
		ACCESS_REGION_SUPPLY = list(access_change_ids)
	)

	// List of /datum/department types to instantiate at roundstart.
	var/list/departments

	// List of events specific to a map
	var/list/map_event_container = list()

/datum/map/New()
	if(!map_levels)
		map_levels = station_levels.Copy()
	if(!allowed_jobs)
		allowed_jobs = list()
		for(var/jtype in subtypesof(/datum/job))
			var/datum/job/job = jtype
			if(initial(job.available_by_default))
				allowed_jobs += jtype
	if(!LAZYLEN(planet_size))
		planet_size = list(world.maxx, world.maxy)
	current_lobby_screen = pick(lobby_screens)
	game_year = text2num(time2text(world.timeofday, "YYYY")) + DEFAULT_GAME_YEAR_OFFSET


/datum/map/proc/get_lobby_track(banned)
	var/path = /decl/audio/track/absconditus
	var/count = length(lobby_tracks)
	if (count != 1)
		var/allowed
		if (count > 1)
			allowed = lobby_tracks - banned
		if (!length(allowed))
			allowed = subtypesof(/decl/audio/track) - banned
		if (length(allowed))
			path = pickweight(allowed)
	else
		path = lobby_tracks[1]
	return decls_repository.get_decl(path)


/datum/map/proc/setup_config(name, value, filename)
	switch (name)
		if ("use_overmap") use_overmap = text2num_or_default(value, use_overmap)
		if ("overmap_z") overmap_z = text2num_or_default(value, overmap_z)
		if ("overmap_size") overmap_size = text2num_or_default(value, overmap_size)
		if ("overmap_event_areas") overmap_event_areas = text2num_or_default(value, overmap_event_areas)
		if ("num_exoplanets") num_exoplanets = text2num_or_default(value, num_exoplanets)
		if ("away_site_budget") away_site_budget = text2num_or_default(value, away_site_budget)
		if ("station_name") station_name = value
		if ("station_short") station_short = value
		if ("dock_name") dock_name = value
		if ("boss_name") boss_name = value
		if ("boss_short") boss_short = value
		if ("company_name") company_name = value
		if ("company_short") company_short = value
		if ("shuttle_docked_message") shuttle_docked_message = value
		if ("shuttle_leaving_dock") shuttle_leaving_dock = value
		if ("shuttle_called_message") shuttle_called_message = value
		if ("shuttle_recall_message") shuttle_recall_message = value
		if ("emergency_shuttle_docked_message") emergency_shuttle_docked_message = value
		if ("emergency_shuttle_leaving_dock") emergency_shuttle_leaving_dock = value
		if ("emergency_shuttle_recall_message") emergency_shuttle_recall_message = value
		if ("starting_money") starting_money = text2num_or_default(value, starting_money)
		if ("department_money") department_money = text2num_or_default(value, department_money)
		if ("salary_modifier") salary_modifier = text2num_or_default(value, salary_modifier)
		if ("supply_currency_name") supply_currency_name = value
		if ("supply_currency_name_short") supply_currency_name_short = value
		if ("local_currency_name") local_currency_name = value
		if ("local_currency_name_singular") local_currency_name_singular = value
		if ("local_currency_name_short") local_currency_name_short = value
		if ("game_year_offset") game_year = text2num(time2text(world.timeofday, "YYYY")) + text2num_or_default(value, DEFAULT_GAME_YEAR_OFFSET)
		if ("min_offmap_players") min_offmap_players = text2num_or_default(value, min_offmap_players)
		else log_misc("Unknown setting [name] in [filename].")

/datum/map/proc/setup_map()
	lobby_track = get_lobby_track()
	world.update_status()
	setup_events()

/datum/map/proc/setup_events()
	return

/datum/map/proc/setup_job_lists()
	return

/datum/map/proc/send_welcome()
	return

/datum/map/proc/perform_map_generation()
	return


/* It is perfectly possible to create loops with TEMPLATE_FLAG_ALLOW_DUPLICATES and force/allow. Don't. */
/proc/resolve_site_selection(datum/map_template/ruin/away_site/site, list/selected, list/available, list/unavailable, list/by_type)
	var/spawn_cost = 0
	var/player_cost = 0
	if (site in selected)
		if (!(site.template_flags & TEMPLATE_FLAG_ALLOW_DUPLICATES))
			return list(spawn_cost, player_cost)
	if (!(site.template_flags & TEMPLATE_FLAG_ALLOW_DUPLICATES))
		available -= site
	spawn_cost += site.spawn_cost
	player_cost += site.player_cost
	selected += site

	for (var/forced_type in site.force_ruins)
		var/list/costs = resolve_site_selection(by_type[forced_type], selected, available, unavailable, by_type)
		spawn_cost += costs[1]
		player_cost += costs[2]

	for (var/banned_type in site.ban_ruins)
		var/datum/map_template/ruin/away_site/banned = by_type[banned_type]
		if (banned in unavailable)
			continue
		unavailable += banned
		available -= banned

	for (var/allowed_type in site.allow_ruins)
		var/datum/map_template/ruin/away_site/allowed = by_type[allowed_type]
		if (allowed in available)
			continue
		if (allowed in unavailable)
			continue
		if (allowed in selected)
			if (!(allowed.template_flags & TEMPLATE_FLAG_ALLOW_DUPLICATES))
				continue
		available[allowed] = allowed.spawn_weight

	return list(spawn_cost, player_cost)


/datum/map/proc/build_away_sites()
#ifdef UNIT_TEST
	report_progress("Unit testing, so not loading away sites")
	return // don't build away sites during unit testing
#else
	report_progress("Loading away sites...")

	var/list/guaranteed = list()
	var/list/selected = list()
	var/list/available = list()
	var/list/unavailable = list()
	var/list/by_type = list()

	for (var/site_name in SSmapping.away_sites_templates)
		var/datum/map_template/ruin/away_site/site = SSmapping.away_sites_templates[site_name]
		if (site.template_flags & TEMPLATE_FLAG_SPAWN_GUARANTEED)
			guaranteed += site
			if ((site.template_flags & TEMPLATE_FLAG_ALLOW_DUPLICATES) && !(site.template_flags & TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED))
				available[site] = site.spawn_weight
		else if (!(site.template_flags & TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED))
			available[site] = site.spawn_weight
		by_type[site.type] = site

	var/points = away_site_budget
	var/players = -min_offmap_players
	for (var/client/C)
		++players

	for (var/datum/map_template/ruin/away_site/site in guaranteed)
		var/list/costs = resolve_site_selection(site, selected, available, unavailable, by_type)
		points -= costs[1]
		players -= costs[2]

	while (points > 0 && length(available))
		var/datum/map_template/ruin/away_site/site = pickweight(available)
		if (site.spawn_cost && site.spawn_cost > points || site.player_cost && site.player_cost > players)
			unavailable += site
			available -= site
			continue
		var/list/costs = resolve_site_selection(site, selected, available, unavailable, by_type)
		points -= costs[1]
		players -= costs[2]

	report_progress("Finished selecting away sites ([english_list(selected)]) for [away_site_budget - points] cost of [away_site_budget] budget.")

	for (var/datum/map_template/template in selected)
		if (template.load_new_z())
			report_progress("Loaded away site [template]!")
		else
			report_progress("Failed loading away site [template]!")
#endif

/datum/map/proc/build_exoplanets()
	if(!use_overmap)
		return

	for(var/i = 0, i < num_exoplanets, i++)
		var/exoplanet_type = pick(subtypesof(/obj/effect/overmap/visitable/sector/exoplanet))
		var/obj/effect/overmap/visitable/sector/exoplanet/new_planet = new exoplanet_type(null, planet_size[1], planet_size[2])
		new_planet.build_level()

// Used to apply various post-compile procedural effects to the map.
/datum/map/proc/refresh_mining_turfs(var/zlevel)

	set background = 1
	set waitfor = 0

	for(var/thing in mining_walls["[zlevel]"])
		var/turf/simulated/mineral/M = thing
		M.update_icon()
	for(var/thing in mining_floors["[zlevel]"])
		var/turf/simulated/floor/asteroid/M = thing
		if(istype(M))
			M.updateMineralOverlays()

/datum/map/proc/get_network_access(var/network)
	return 0

// By default transition randomly to another zlevel
/datum/map/proc/get_transit_zlevel(var/current_z_level)
	var/list/candidates = GLOB.using_map.accessible_z_levels.Copy()
	candidates.Remove(num2text(current_z_level))

	if(!candidates.len)
		return current_z_level
	return text2num(pickweight(candidates))

/datum/map/proc/get_empty_zlevel()
	if(empty_levels == null)
		INCREMENT_WORLD_Z_SIZE
		empty_levels = list(world.maxz)
	return pick(empty_levels)


/datum/map/proc/setup_economy()
	for (var/datum/feed_network/N in news_network)
		N.CreateFeedChannel("Nyx Daily", "SolGov Minister of Information", 1, 1)
		N.CreateFeedChannel("The Gibson Gazette", "Editor Mike Hammers", 1, 1)

	for(var/loc_type in typesof(/datum/trade_destination) - /datum/trade_destination)
		var/datum/trade_destination/D = new loc_type
		weighted_randomevent_locations[D] = D.viable_random_events.len
		weighted_mundaneevent_locations[D] = D.viable_mundane_events.len

	if(!station_account)
		station_account = create_account("[station_name()] Primary Account", "[station_name()]", starting_money, ACCOUNT_TYPE_DEPARTMENT)

	for(var/job in allowed_jobs)
		var/datum/job/J = job
		var/dept = initial(J.department)
		if(dept)
			station_departments |= dept

	for(var/department in station_departments)
		department_accounts[department] = create_account("[department] Account", "[department]", department_money, ACCOUNT_TYPE_DEPARTMENT)

	department_accounts["Vendor"] = create_account("Vendor Account", "Vendor", 0, ACCOUNT_TYPE_DEPARTMENT)
	vendor_account = department_accounts["Vendor"]

/datum/map/proc/map_info(var/client/victim)
	to_chat(victim, "<h2>Current map information</h2>")
	to_chat(victim, get_map_info())

/datum/map/proc/get_map_info()
	return "No map information available"

/datum/map/proc/bolt_saferooms()
	return // overriden by torch

/datum/map/proc/unbolt_saferooms()
	return // overriden by torch

/datum/map/proc/make_maint_all_access(var/radstorm = 0) // parameter used by torch
	maint_all_access = 1
	priority_announcement.Announce("The maintenance access requirement has been revoked on all maintenance airlocks.", "Attention!")

/datum/map/proc/revoke_maint_all_access(var/radstorm = 0) // parameter used by torch
	maint_all_access = 0
	priority_announcement.Announce("The maintenance access requirement has been readded on all maintenance airlocks.", "Attention!")

// Access check is of the type requires one. These have been carefully selected to avoid allowing the janitor to see channels he shouldn't
// This list needs to be purged but people insist on adding more cruft to the radio.
/datum/map/proc/default_internal_channels()
	return list(
		num2text(PUB_FREQ)   = list(),
		num2text(AI_FREQ)    = list(access_synth),
		num2text(ENT_FREQ)   = list(),
		num2text(ERT_FREQ)   = list(access_cent_specops),
		num2text(COMM_FREQ)  = list(access_bridge),
		num2text(ENG_FREQ)   = list(access_engine_equip, access_atmospherics),
		num2text(MED_FREQ)   = list(access_medical_equip),
		num2text(MED_I_FREQ) = list(access_medical_equip),
		num2text(SEC_FREQ)   = list(access_security),
		num2text(SEC_I_FREQ) = list(access_security),
		num2text(SCI_FREQ)   = list(access_tox,access_robotics,access_xenobiology),
		num2text(SUP_FREQ)   = list(access_cargo),
		num2text(SRV_FREQ)   = list(access_janitor, access_hydroponics),
		num2text(HAIL_FREQ)  = list(),
	)

/datum/map/proc/show_titlescreen(client/C)
	winset(C, "lobbybrowser", "is-disabled=false;is-visible=true")

	show_browser(C, current_lobby_screen, "file=titlescreen.png;display=0")
	show_browser(C, file('html/lobby_titlescreen.html'), "window=lobbybrowser")

/datum/map/proc/hide_titlescreen(client/C)
	if(C.mob) // Check if the client is still connected to something
		// Hide title screen, allowing player to see the map
		winset(C, "lobbybrowser", "is-disabled=true;is-visible=false")

/datum/map/proc/roundend_player_status()
	for(var/mob/Player in GLOB.player_list)
		if(Player.mind && !isnewplayer(Player))
			if(Player.stat != DEAD)
				var/turf/playerTurf = get_turf(Player)
				if(evacuation_controller.round_over() && evacuation_controller.emergency_evacuation)
					if(isStationLevel(playerTurf.z))
						to_chat(Player, "<span class='info'><b>You managed to survive, but were left behind on [station_name()] as [Player.real_name]...</b></span>")
					else if (isEscapeLevel(playerTurf.z))
						to_chat(Player, "<font color='green'><b>You managed to survive the events on [station_name()] as [Player.real_name].</b></font>")
					else
						to_chat(Player, "<span class='info'><b>You managed to survive, but were lost far from [station_name()] as [Player.real_name]...</b></span>")
				else if(isAdminLevel(playerTurf.z))
					to_chat(Player, "<font color='green'><b>You successfully underwent crew transfer after events on [station_name()] as [Player.real_name].</b></font>")
				else if(issilicon(Player))
					to_chat(Player, "<font color='green'><b>You remain operational after the events on [station_name()] as [Player.real_name].</b></font>")
				else if (isNotStationLevel(playerTurf.z))
					to_chat(Player, "<span class='info'><b>You managed to survive, but were lost far from [station_name()] as [Player.real_name]...</b></span>")
				else
					to_chat(Player, "<span class='info'><b>You got through just another workday on [station_name()] as [Player.real_name].</b></span>")
			else
				if(isghost(Player))
					var/mob/observer/ghost/O = Player
					if(!O.started_as_observer)
						to_chat(Player, "<font color='red'><b>You did not survive the events on [station_name()]...</b></font>")
				else
					to_chat(Player, "<font color='red'><b>You did not survive the events on [station_name()]...</b></font>")

/datum/map/proc/roundend_statistics()
	var/data = list()
	data["clients"] = 0
	data["surviving_humans"] = 0
	data["surviving_total"] = 0 //required field for roundend webhook!
	data["ghosts"] = 0 //required field for roundend webhook!
	data["escaped_humans"] = 0
	data["escaped_total"] = 0
	data["left_behind_total"] = 0 //players who didnt escape and aren't on the station.
	data["offship_players"] = 0

	for(var/mob/M in GLOB.player_list)
		if(M.client)
			data["clients"]++
			if(M.stat != DEAD)
				if (get_crewmember_record(M.real_name || M.name))
					data["surviving_total"]++
					if(ishuman(M))
						data["surviving_humans"]++
					var/area/A = get_area(M)
					if(A && (istype(A, /area/shuttle) && isEscapeLevel(A.z)))
						data["escaped_total"]++
						if(ishuman(M))
							data["escaped_humans"]++
					if (evacuation_controller.emergency_evacuation && !isEscapeLevel(A.z)) //left behind after evac
						data["left_behind_total"]++
					if (!evacuation_controller.emergency_evacuation && isNotStationLevel(A.z))
						data["left_behind_total"]++
				else
					data["offship_players"]++
			else if(isghost(M))
				data["ghosts"]++

	if(data["clients"] > 0)
		SSstatistics.set_field("round_end_clients",data["clients"])
	if(data["ghosts"] > 0)
		SSstatistics.set_field("round_end_ghosts",data["ghosts"])
	if(data["surviving_humans"] > 0)
		SSstatistics.set_field("survived_human",data["surviving_humans"])
	if(data["surviving_total"] > 0)
		SSstatistics.set_field("survived_total",data["surviving_total"])
	if(data["escaped_humans"] > 0)
		SSstatistics.set_field("escaped_human",data["escaped_humans"])
	if(data["escaped_total"] > 0)
		SSstatistics.set_field("escaped_total",data["escaped_total"])

	return data

/datum/map/proc/roundend_summary(list/data)
	var/desc
	if(data["surviving_total"] > 0)
		var/survivors = data["surviving_total"]
		var/escaped_total = data["escaped_total"]
		var/ghosts = data["ghosts"]
		var/offship_players = data["offship_players"]

		desc += "There [survivors>1 ? "were <b>[survivors] survivors</b>" : "was <b>one survivor</b>"]"
		desc += " (<b>[escaped_total>0 ? escaped_total : "none"] escaped</b>), <b>[offship_players] off-ship player(s)."
		data += " and <b>[ghosts] ghosts</b>.</b><br>"
	else
		desc += "There were <b>no survivors</b>, <b>[data["offship_players"]] off-ship player(s)</b>, (<b>[data["ghosts"]] ghosts</b>)."

	return desc

#undef DEFAULT_GAME_YEAR_OFFSET
