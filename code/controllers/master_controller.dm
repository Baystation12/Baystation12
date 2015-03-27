//simplified MC that is designed to fail when procs 'break'. When it fails it's just replaced with a new one.
//It ensures master_controller.process() is never doubled up by killing the MC (hence terminating any of its sleeping procs)
//WIP, needs lots of work still

var/global/datum/controller/game_controller/master_controller //Set in world.New()

var/global/controller_iteration = 0
var/global/last_tick_duration = 0

var/global/air_processing_killed = 0
var/global/pipe_processing_killed = 0

datum/controller/game_controller
	var/list/shuttle_list	                    // For debugging and VV
	var/datum/random_map/ore/asteroid_ore_map   // For debugging and VV.

datum/controller/game_controller/New()
	//There can be only one master_controller. Out with the old and in with the new.
	if(master_controller != src)
		log_debug("Rebuilding Master Controller")
		if(istype(master_controller))
			del(master_controller)
		master_controller = src

	if(!job_master)
		job_master = new /datum/controller/occupations()
		job_master.SetupOccupations()
		job_master.LoadJobs("config/jobs.txt")
		world << "<span class='danger'>Job setup complete</span>"

	if(!syndicate_code_phrase)		syndicate_code_phrase	= generate_code_phrase()
	if(!syndicate_code_response)	syndicate_code_response	= generate_code_phrase()

datum/controller/game_controller/proc/setup()
	world.tick_lag = config.Ticklag

	spawn(20)
		createRandomZlevel()

	setup_objects()
	setupgenetics()
	setup_economy()
	SetupXenoarch()

	transfer_controller = new


datum/controller/game_controller/proc/setup_objects()
	world << "<span class='danger'>Initializing objects</span>"
	sleep(-1)
	for(var/atom/movable/object in world)
		object.initialize()

	world << "<span class='danger'>Initializing pipe networks</span>"
	sleep(-1)
	for(var/obj/machinery/atmospherics/machine in machines)
		machine.build_network()

	world << "<span class='danger'>Initializing atmos machinery.</span>"
	sleep(-1)
	for(var/obj/machinery/atmospherics/unary/U in machines)
		if(istype(U, /obj/machinery/atmospherics/unary/vent_pump))
			var/obj/machinery/atmospherics/unary/vent_pump/T = U
			T.broadcast_status()
		else if(istype(U, /obj/machinery/atmospherics/unary/vent_scrubber))
			var/obj/machinery/atmospherics/unary/vent_scrubber/T = U
			T.broadcast_status()

	// Create the mining ore distribution map.
	// These values determine the specific area that the map is applied to.
	// If you do not use the official Baycode asteroid map, you will need to change them.
	asteroid_ore_map = new /datum/random_map/ore(null,13,32,5,217,223)

	// Set up antagonists.
	populate_antag_type_list()

	//Set up spawn points.
	populate_spawn_points()

	world << "<span class='danger'>Initializations complete.</span>"
	sleep(-1)
