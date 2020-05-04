GLOBAL_DATUM_INIT(using_map, /datum/map, new using_map_DATUM)
GLOBAL_LIST_EMPTY(all_maps)

var/const/MAP_HAS_BRANCH = 1	//Branch system for occupations, togglable
var/const/MAP_HAS_RANK = 2		//Rank system, also togglable

/hook/startup/proc/initialise_map_list()
	for(var/type in typesof(/datum/map) - /datum/map)
		var/datum/map/M
		if(type == GLOB.using_map.type)
			M = GLOB.using_map
			M.setup_map()
		else
			M = new type
		if(!M.path)
			log_error("Map '[M]' does not have a defined path, not adding to map list!")
		else
			GLOB.all_maps[M.path] = M
	return 1


/datum/map
	var/name = "Unnamed Map"
	var/full_name = "Unnamed Map"
	var/path = "example"

	var/list/station_levels = list() // Z-levels the station exists on
	var/list/admin_levels = list()   // Z-levels for admin functionality (Centcom, shuttle transit, etc)
	var/list/contact_levels = list() // Z-levels that can be contacted from the station, for eg announcements
	var/list/player_levels = list()  // Z-levels a character can typically reach
	var/list/sealed_levels = list()  // Z-levels that don't allow random transit at edge
	var/list/empty_levels = null     // Empty Z-levels that may be used for various things (currently used by bluespace jump)

	var/list/map_levels              // Z-levels available to various consoles, such as the crew monitor. Defaults to station_levels if unset.

	var/list/base_turf_by_z = list() // Custom base turf by Z-level. Defaults to world.turf for unlisted Z-levels
	var/list/usable_email_tlds = list("freemail.nt")
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

	var/map_admin_faxes = list()

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

	var/list/allowed_spawns = list(DEFAULT_SPAWNPOINT_ID)
	var/default_spawn = DEFAULT_SPAWNPOINT_ID
	var/flags = 0
	var/evac_controller_type = /datum/evacuation_controller
	var/use_overmap = 0		//If overmap should be used (including overmap space travel override)
	var/overmap_size = 20		//Dimensions of overmap zlevel if overmap is used.
	var/overmap_event_tokens = 0 //How many event type tokens do we generate and place on the overmap
	var/overmap_z = 0		//If 0 will generate overmap zlevel on init. Otherwise will populate the zlevel provided.
	var/overmap_event_areas = 0 //How many event "clouds" will be generated

	var/lobby_icon									// The icon which contains the lobby image(s)
	var/list/lobby_screens = list()                 // The list of lobby screen to pick() from. If left unset the first icon state is always selected.
	var/lobby_music/lobby_music                     // The track that will play in the lobby screen. Handed in the /setup_map() proc.

	var/default_law_type = /datum/ai_laws/free // The default lawset use by synth units, if not overriden by their laws var.

	var/id_hud_icons = 'icons/mob/hud.dmi' // Used by the ID HUD (primarily sechud) overlay.

	var/use_global_covenant_comms = 1

	var/num_exoplanets = 0

/datum/map/New()
	if(!map_levels)
		map_levels = station_levels.Copy()
	if(!allowed_jobs)
		allowed_jobs = subtypesof(/datum/job)

/datum/map/proc/setup_map()
	var/list/lobby_music_tracks = subtypesof(/lobby_music)
	var/lobby_music_type = /lobby_music
	if(lobby_music_tracks.len)
		lobby_music_type = pick(lobby_music_tracks)
	lobby_music = new lobby_music_type()
	world.update_status()

/datum/map/proc/send_welcome()
	return

/datum/map/proc/perform_map_generation()
	return

/datum/map/proc/build_exoplanets()
	if(!use_overmap)
		return

	for(var/i = 0, i < num_exoplanets, i++)
		var/exoplanet_type = pick(subtypesof(/obj/effect/overmap/sector/exoplanet))
		var/obj/effect/overmap/sector/exoplanet/new_planet = new exoplanet_type
		new_planet.build_level()

// Used to apply various post-compile procedural effects to the map.
/datum/map/proc/refresh_mining_turfs()

	set background = 1
	set waitfor = 0

	for(var/thing in mining_walls)
		var/turf/simulated/mineral/M = thing
		M.update_icon()
	for(var/thing in mining_floors)
		var/turf/simulated/floor/asteroid/M = thing
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
		world.maxz++
		empty_levels = list(world.maxz)
	return pick(empty_levels)

/datum/map/proc/get_working_spawn(var/client/C, var/datum/job/job_datum)

	//i've rewritten this proc to get the first working spawnpoint using all the checks from the job controller and new player spawning
	//this should be safety proof
	//no more rejected spawns and spawn runtimes (see you in 10 more years)
	//cael february 2019

	//start with the default spawn id
	var/datum/spawnpoint/candidate = spawntypes()[default_spawn]
	var/list/spawn_candidates = allowed_spawns.Copy()

	do
		var/display_name = spawn_candidates[1]
		//get the next possible candidate
		if(!candidate)
			candidate = spawntypes()[display_name]

		if(!candidate)
			to_chat(C,"<span class = 'warning'>SPAWN ERROR: spawntype \'[display_name]\' is enabled for the map \'[src]\' but does not exist!</span>")
			log_debug("SPAWN ERROR: spawntype \'[display_name]\' is enabled for the map \'[src]\' but does not exist!")
			message_admins("SPAWN ERROR: spawntype \'[display_name]\' is enabled for the map \'[src]\' but does not exist!")

		else if(!candidate.check_job_spawning(job_datum.title))
			//check if its viable to spawn in with this job
			break

		//reject this candidate
		spawn_candidates -= display_name
		candidate = null

		//only continue the loop if there are more candidates
	while(spawn_candidates.len > 0)

	if(candidate)
		return candidate
	else
		to_chat(C,"<span class = 'warning'>SPAWN WARNING: map \'[src]\' is not returning a working spawn for [C] as [job_datum.type].</span>")
		log_debug("SPAWN WARNING: map \'[src]\' is not returning a working spawn for [C] as [job_datum.type].")
		message_admins("SPAWN WARNING: map \'[src]\' is not returning a working spawn for [C] as [job_datum.type].")
