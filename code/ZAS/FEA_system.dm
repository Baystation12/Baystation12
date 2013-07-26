/*
Overview:
	The air_master global variable is the workhorse for the system.

Why are you archiving data before modifying it?
	The general concept with archiving data and having each tile keep track of when they were last updated is to keep everything symmetric
		and totally independent of the order they are read in an update cycle.
	This prevents abnormalities like air/fire spreading rapidly in one direction and super slowly in the other.

Why not just archive everything and then calculate?
	Efficiency. While a for-loop that goes through all tils and groups to archive their information before doing any calculations seems simple, it is
		slightly less efficient than the archive-before-modify/read method.

Why is there a cycle check for calculating data as well?
	This ensures that every connection between group-tile, tile-tile, and group-group is only evaluated once per loop.




Important variables:
	air_master.groups_to_rebuild (list)
		A list of air groups that have had their geometry occluded and thus may need to be split in half.
		A set of adjacent groups put in here will join together if validly connected.
		This is done before air system calculations for a cycle.
	air_master.tiles_to_update (list)
		Turfs that are in this list have their border data updated before the next air calculations for a cycle.
		Place turfs in this list rather than call the proc directly to prevent race conditions

	turf/simulated.archive() and datum/air_group.archive()
		This stores all data for.
		If you modify, make sure to update the archived_cycle to prevent race conditions and maintain symmetry

	atom/CanPass(atom/movable/mover, turf/target, height, air_group)
		returns 1 for allow pass and 0 for deny pass
		Turfs automatically call this for all objects/mobs in its turf.
		This is called both as source.CanPass(target, height, air_group)
			and  target.CanPass(source, height, air_group)

		Cases for the parameters
		1. This is called with args (mover, location, height>0, air_group=0) for normal objects.
		2. This is called with args (null, location, height=0, air_group=0) for flowing air.
		3. This is called with args (null, location, height=?, air_group=1) for determining group boundaries.

		Cases 2 and 3 would be different for doors or other objects open and close fairly often.
			(Case 3 would return 0 always while Case 2 would return 0 only when the door is open)
			This prevents the necessity of re-evaluating group geometry every time a door opens/closes.


Important Procedures
	air_master.process()
		This first processes the air_master update/rebuild lists then processes all groups and tiles for air calculations


*/

var/kill_air = 0
var/tick_multiplier = 2

atom/proc/CanPass(atom/movable/mover, turf/target, height=1.5, air_group = 0)
	//Purpose: Determines if the object (or airflow) can pass this atom.
	//Called by: Movement, airflow.
	//Inputs: The moving atom (optional), target turf, "height" and air group
	//Outputs: Boolean if can pass.

	return (!density || !height || air_group)

/turf/CanPass(atom/movable/mover, turf/target, height=1.5,air_group=0)
	if(!target) return 0

	if(istype(mover)) // turf/Enter(...) will perform more advanced checks
		return !density

	else // Now, doing more detailed checks for air movement and air group formation
		if(target.blocks_air||blocks_air)
			return 0

		for(var/obj/obstacle in src)
			if(!obstacle.CanPass(mover, target, height, air_group))
				return 0
		if(target != src)
			for(var/obj/obstacle in target)
				if(!obstacle.CanPass(mover, src, height, air_group))
					return 0

		return 1


var/datum/controller/air_system/air_master

/datum/controller/air_system/
	//Geoemetry lists
	var/list/turfs_with_connections = list()
	var/list/active_hotspots = list()

	//Special functions lists
	var/list/tiles_to_reconsider_zones = list()

	//Geometry updates lists
	var/list/tiles_to_update = list()
	var/list/connections_to_check = list()

	var/current_cycle = 0
	var/update_delay = 5 //How long between check should it try to process atmos again.
	var/failed_ticks = 0 //How many ticks have runtimed?

	var/tick_progress = 0


/*				process()
					//Call this to process air movements for a cycle

				process_rebuild_select_groups()
					//Used by process()
					//Warning: Do not call this

				rebuild_group(datum/air_group)
					//Used by process_rebuild_select_groups()
					//Warning: Do not call this, add the group to air_master.groups_to_rebuild instead
					*/


/datum/controller/air_system/proc/setup()
	//Purpose: Call this at the start to setup air groups geometry
	//    (Warning: Very processor intensive but only must be done once per round)
	//Called by: Gameticker/Master controller
	//Inputs: None.
	//Outputs: None.

	set background = 1
	world << "\red \b Processing Geometry..."
	sleep(-1)

	var/start_time = world.timeofday

	var/simulated_turf_count = 0

	for(var/turf/simulated/S in world)
		simulated_turf_count++
		if(!S.zone && !S.blocks_air)
			if(S.CanPass(null, S, 0, 0))
				new/zone(S)

	for(var/turf/simulated/S in world)
		S.update_air_properties()

	world << {"<font color='red'><b>Geometry initialized in [round(0.1*(world.timeofday-start_time),0.1)] seconds.</b>
Total Simulated Turfs: [simulated_turf_count]
Total Zones: [zones.len]
Total Unsimulated Turfs: [world.maxx*world.maxy*world.maxz - simulated_turf_count]</font>"}
	/*
	spawn start()

/datum/controller/air_system/proc/start()
	//Purpose: This is kicked off by the master controller, and controls the processing of all atmosphere.
	//Called by: Master controller
	//Inputs: None.
	//Outputs: None.


	set background = 1

	while(1)
		if(!kill_air)
			current_cycle++
			var/success = tick() //Changed so that a runtime does not crash the ticker.
			if(!success) //Runtimed.
				failed_ticks++
				if(failed_ticks > 20)
					world << "<font color='red'><b>ERROR IN ATMOS TICKER.  Killing air simulation!</font></b>"
					kill_air = 1
		sleep(max(5,update_delay*tick_multiplier))
	*/

/datum/controller/air_system/proc/tick()
	. = 1 //Set the default return value, for runtime detection.

	tick_progress = "update_air_properties"
	if(tiles_to_update.len) //If there are tiles to update, do so.
		for(var/turf/simulated/T in tiles_to_update)
			if(. && T && !T.update_air_properties())
				. = 0 //If a runtime occured, make sure we can sense it.
				//message_admins("ZASALERT: Unable run turf/simualted/update_air_properties()")
		if(.)
			tiles_to_update = list()

	//Check sanity on connection objects.
	if(.)
		tick_progress = "connections_to_check"
	if(connections_to_check.len)
		for(var/connection/C in connections_to_check)
			C.CheckPassSanity()
		connections_to_check = list()

	//Ensure tiles still have zones.
	if(.)
		tick_progress = "tiles_to_reconsider_zones"
	if(tiles_to_reconsider_zones.len)
		for(var/turf/simulated/T in tiles_to_reconsider_zones)
			if(!T.zone)
				new /zone(T)
		tiles_to_reconsider_zones = list()

	//Process zones.
	if(.)
		tick_progress = "zone/process()"
	for(var/zone/Z in zones)
		if(Z.last_update < current_cycle)
			var/output = Z.process()
			if(Z)
				Z.last_update = current_cycle
			if(. && Z && !output)
				. = 0
	//Process fires.
	if(.)
		tick_progress = "active_hotspots (fire)"
	for(var/obj/fire/F in active_hotspots)
		if(. && F && !F.process())
			. = 0

	if(.)
		tick_progress = "success"