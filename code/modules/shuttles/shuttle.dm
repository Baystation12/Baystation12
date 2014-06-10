//These lists are populated in /datum/shuttle_controller/New()
//Shuttle controller is instantiated in master_controller.dm.

#define SHUTTLE_IDLE		0
#define SHUTTLE_WARMUP		1
#define SHUTTLE_INTRANSIT	2

var/global/list/shuttles

/datum/shuttle
	var/location = 0	//0 = at area_station, 1 = at area_offsite
	var/warmup_time = 0
	var/moving_status = SHUTTLE_IDLE	//prevents people from doing things they shouldn't when the shuttle is in transit
	var/in_use = 0						//this mutex ensures that only one console can be doing things with the shuttle at a time.
	var/area_station
	var/area_offsite
	
	var/docking_controller_tag	//tag of the controller used to coordinate docking
	var/datum/computer/file/embedded_program/docking/docking_controller	//the controller itself
	//TODO: change location to a string and use a mapping for area and dock targets.
	var/dock_target_station
	var/dock_target_offsite
	

/datum/shuttle/proc/short_jump(var/datum/shuttle/shuttle,var/area/origin,var/area/destination)
	if(moving_status != SHUTTLE_IDLE) return

	moving_status = SHUTTLE_WARMUP
	spawn(warmup_time*10)
		if (moving_status == SHUTTLE_IDLE) 
			return	//someone cancelled the launch
		
		move(origin, destination)
		moving_status = SHUTTLE_IDLE

/datum/shuttle/proc/long_jump(var/shuttle_tag,var/area/departing,var/area/destination,var/area/interim,var/travel_time)
	if(moving_status != SHUTTLE_IDLE) return

	moving_status = SHUTTLE_WARMUP

	spawn(warmup_time*10)
		if (moving_status == SHUTTLE_IDLE) 
			return	//someone cancelled the launch
		
		move(locate(departing),locate(interim))

		sleep(travel_time)

		move(locate(interim),locate(destination))

		moving_status = SHUTTLE_IDLE


/datum/shuttle/proc/dock()
	if (!docking_controller)
		return

	var/dock_target = current_dock_target()
	if (!dock_target)
		return

	docking_controller.initiate_docking(dock_target)

/datum/shuttle/proc/undock()
	if (!docking_controller)
		return

	docking_controller.initiate_undocking()

/datum/shuttle/proc/current_dock_target()
	var/dock_target
	if (!location)	//station
		dock_target = dock_target_station
	else
		dock_target = dock_target_offsite
	return dock_target

//just moves the shuttle from A to B, if it can be moved
/datum/shuttle/proc/move(var/area/origin,var/area/destination)

	//world << "move_shuttle() called for [shuttle_tag] leaving [origin] en route to [destination]."
	if(isnull(location))
		return

	var/area/area_going_to
	if(destination)
		//world << "Using supplied destination [destination]."
		area_going_to = destination
	else
		//world << "Using controller value [(cur_location[shuttle_tag] == 1 ? areas_station[shuttle_tag] : areas_offsite[shuttle_tag])]."
		area_going_to = (location == 1 ? area_station : area_offsite)

	var/area/area_coming_from
	if(origin)
		//world << "Using supplied origin [origin]."
		area_coming_from = origin
	else
		//world << "Using controller value [(cur_location[shuttle_tag] == 1 ? areas_offsite[shuttle_tag] : areas_station[shuttle_tag])]."
		area_coming_from = (location == 1 ? area_offsite : area_station)

	//world << "area_coming_from: [area_coming_from]"
	//world << "area_going_to: [area_going_to]"

	if(area_coming_from == area_going_to)
		//world << "cancelling move, shuttle will overlap."
		return

	moving_status = SHUTTLE_INTRANSIT
	
	var/list/dstturfs = list()
	var/throwy = world.maxy

	for(var/turf/T in area_going_to)
		dstturfs += T
		if(T.y < throwy)
			throwy = T.y

	for(var/turf/T in dstturfs)
		var/turf/D = locate(T.x, throwy - 1, 1)
		for(var/atom/movable/AM as mob|obj in T)
			AM.Move(D)
		if(istype(T, /turf/simulated))
			del(T)

	for(var/mob/living/carbon/bug in area_going_to)
		bug.gib()

	for(var/mob/living/simple_animal/pest in area_going_to)
		pest.gib()

	area_coming_from.move_contents_to(area_going_to)

	location = !location	//this needs to change.

	for(var/mob/M in area_going_to)
		if(M.client)
			spawn(0)
				if(M.buckled)
					M << "\red Sudden acceleration presses you into your chair!"
					shake_camera(M, 3, 1)
				else
					M << "\red The floor lurches beneath you!"
					shake_camera(M, 10, 1)
		if(istype(M, /mob/living/carbon))
			if(!M.buckled)
				M.Weaken(3)

	return



/proc/setup_shuttles()
	shuttles = list()

	var/datum/shuttle/shuttle

	//Supply and escape shuttles.
	shuttle = new/datum/shuttle()
	shuttle.location = 1
	shuttle.area_offsite = locate(/area/supply/dock)
	shuttle.area_station = locate(/area/supply/station)
	shuttles["Supply"] = shuttle

	// Admin shuttles.
	shuttle = new/datum/shuttle()
	shuttle.location = 1
	shuttle.area_offsite = locate(/area/shuttle/transport1/centcom)
	shuttle.area_station = locate(/area/shuttle/transport1/station)
	shuttles["Centcom"] = shuttle

	shuttle = new/datum/shuttle()
	shuttle.location = 1
	shuttle.area_offsite = locate(/area/shuttle/administration/centcom)
	shuttle.area_station = locate(/area/shuttle/administration/station)
	shuttles["Administration"] = shuttle

	shuttle = new/datum/shuttle()
	shuttle.area_offsite = locate(/area/shuttle/alien/base)
	shuttle.area_station = locate(/area/shuttle/alien/mine)
	shuttles["Alien"] = shuttle

	// Public shuttles
	shuttle = new/datum/shuttle()
	shuttle.location = 1
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/shuttle/constructionsite/site)
	shuttle.area_station = locate(/area/shuttle/constructionsite/station)
	shuttles["Engineering"] = shuttle

	shuttle = new/datum/shuttle()
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/shuttle/mining/outpost)
	shuttle.area_station = locate(/area/shuttle/mining/station)
	shuttles["Mining"] = shuttle

	shuttle = new/datum/shuttle()
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/shuttle/research/outpost)
	shuttle.area_station = locate(/area/shuttle/research/station)
	shuttle.docking_controller_tag = "research_shuttle"
	shuttle.dock_target_station = "research_dock_airlock"
	shuttle.dock_target_offsite = "research_outpost_dock"
	shuttles["Research"] = shuttle

	//Vox Shuttle.
	var/datum/shuttle/multi_shuttle/VS = new/datum/shuttle/multi_shuttle()
	VS.origin = /area/shuttle/vox/station

	VS.destinations = list(
		"Fore Starboard Solars" = /area/vox_station/northeast_solars,
		"Fore Port Solars" = /area/vox_station/northwest_solars,
		"Aft Starboard Solars" = /area/vox_station/southeast_solars,
		"Aft Port Solars" = /area/vox_station/southwest_solars,
		"Mining asteroid" = /area/vox_station/mining
		)

	VS.announcer = "NSV Icarus"
	VS.arrival_message = "Attention, Exodus, we just tracked a small target bypassing our defensive perimeter. Can't fire on it without hitting the station - you've got incoming visitors, like it or not."
	VS.departure_message = "Your guests are pulling away, Exodus - moving too fast for us to draw a bead on them. Looks like they're heading out of the system at a rapid clip."
	VS.interim = /area/vox_station/transit

	VS.location = 1
	VS.warmup_time = 10
	shuttles["Vox Skipjack"] = VS

	//Nuke Ops shuttle.
	var/datum/shuttle/multi_shuttle/MS = new/datum/shuttle/multi_shuttle()
	MS.origin = /area/syndicate_station/start

	MS.destinations = list(
		"Northwest of the station" = /area/syndicate_station/northwest,
		"North of the station" = /area/syndicate_station/north,
		"Northeast of the station" = /area/syndicate_station/northeast,
		"Southwest of the station" = /area/syndicate_station/southwest,
		"South of the station" = /area/syndicate_station/south,
		"Southeast of the station" = /area/syndicate_station/southeast,
		"Telecomms Satellite" = /area/syndicate_station/commssat,
		"Mining Asteroid" = /area/syndicate_station/mining
		)

	MS.announcer = "NSV Icarus"
	MS.arrival_message = "Attention, Exodus, you have a large signature approaching the station - looks unarmed to surface scans. We're too far out to intercept - brace for visitors."
	MS.departure_message = "Your visitors are on their way out of the system, Exodus, burning delta-v like it's nothing. Good riddance."
	MS.interim = /area/syndicate_station/transit

	MS.location = 1
	MS.warmup_time = 10
	shuttles["Syndicate"] = MS


/proc/setup_shuttle_docks()
	var/datum/shuttle/shuttle
	var/list/dock_controller_map = list()	//so we only have to iterate once through each list

	for (var/shuttle_tag in shuttles)
		shuttle = shuttles[shuttle_tag]
		if (shuttle.docking_controller_tag)
			dock_controller_map[shuttle.docking_controller_tag] = shuttle

	//search for the controllers, if we have one.
	if (dock_controller_map.len)
		for (var/obj/machinery/embedded_controller/radio/C in machines)	//only radio controllers are supported at the moment
			if (istype(C.program, /datum/computer/file/embedded_program/docking) && C.id_tag in dock_controller_map)
				shuttle = dock_controller_map[C.id_tag]
				shuttle.docking_controller = C.program
				dock_controller_map -= C.id_tag
	
	//sanity check
	if (dock_controller_map.len)
		var/dat = ""
		for (var/dock_tag in dock_controller_map)
			dat += "\"[dock_tag]\", "
		world << "/red /b warning: shuttles with docking tags [dat] could not find their controllers!"
	
	//makes all shuttles docked to something at round start go into the docked state
	for (var/shuttle_tag in shuttles)
		shuttle = shuttles[shuttle_tag]
		shuttle.dock()
				