//These lists are populated in /datum/shuttle_controller/New()
//Shuttle controller is instantiated in master_controller.dm.

#define SHUTTLE_IDLE		0
#define SHUTTLE_WARMUP		1
#define SHUTTLE_INTRANSIT	2

var/global/datum/shuttle_controller/shuttles

/datum/shuttle_controller //This isn't really a controller...
	var/list/location = list()
	var/list/warmup = list()
	var/list/moving = list()
	var/list/areas_offsite = list()
	var/list/areas_station = list()

	//Shuttles with multiple destinations don't quite behave in the same way as ferries.
	var/list/multi_shuttles = list()
	
	//docking stuff
	var/list/docking_controller = list()
	var/list/docking_targets = list()

/datum/shuttle_controller/New()

	..()

	//Supply and escape shuttles.
	location["Supply"] = 1
	warmup["Supply"] = 0
	moving["Supply"] = SHUTTLE_IDLE
	areas_offsite["Supply"] = locate(/area/supply/dock)
	areas_station["Supply"] = locate(/area/supply/station)
	docking_targets["Supply"] = list(null, null)

	// Admin shuttles.
	location["Centcom"] = 1
	warmup["Centcom"] = 0
	moving["Centcom"] = SHUTTLE_IDLE
	areas_offsite["Centcom"] = locate(/area/shuttle/transport1/centcom)
	areas_station["Centcom"] = locate(/area/shuttle/transport1/station)
	docking_targets["Centcom"] = list(null, null)

	location["Administration"] = 1
	warmup["Administration"] = 0
	moving["Administration"] = SHUTTLE_IDLE
	areas_offsite["Administration"] = locate(/area/shuttle/administration/centcom)
	areas_station["Administration"] = locate(/area/shuttle/administration/station)
	docking_targets["Administration"] = list(null, null)

	location["Alien"] = 0
	warmup["Alien"] = 0
	moving["Alien"] = SHUTTLE_IDLE
	areas_offsite["Alien"] = locate(/area/shuttle/alien/base)
	areas_station["Alien"] = locate(/area/shuttle/alien/mine)
	docking_targets["Alien"] = list(null, null)

	// Public shuttles.
	location["Engineering"] = 1
	warmup["Engineering"] = 10
	moving["Engineering"] = SHUTTLE_IDLE
	areas_offsite["Engineering"] = locate(/area/shuttle/constructionsite/site)
	areas_station["Engineering"] =  locate(/area/shuttle/constructionsite/station)
	docking_targets["Engineering"] = list(null, null)

	location["Mining"] = 0
	warmup["Mining"] = 10
	moving["Mining"] = SHUTTLE_IDLE
	areas_offsite["Mining"] = locate(/area/shuttle/mining/outpost)
	areas_station["Mining"] = locate(/area/shuttle/mining/station)
	docking_targets["Mining"] = list(null, null)

	location["Research"] = 0
	warmup["Research"] = 10
	moving["Research"] = SHUTTLE_IDLE
	areas_offsite["Research"] = locate(/area/shuttle/research/outpost)
	areas_station["Research"] = locate(/area/shuttle/research/station)
	docking_targets["Research"] = list("research_dock_airlock", "research_dock_airlock")

	//Vox Shuttle.
	var/datum/multi_shuttle/VS = new
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

	multi_shuttles["Vox Skipjack"] = VS
	location["Vox Skipjack"] = 1
	warmup["Vox Skipjack"] = 10
	moving["Vox Skipjack"] = SHUTTLE_IDLE

	//Nuke Ops shuttle.
	var/datum/multi_shuttle/MS = new
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

	multi_shuttles["Syndicate"] = MS
	location["Syndicate"] = 1
	warmup["Syndicate"] = 10
	moving["Syndicate"] = SHUTTLE_IDLE


/datum/shuttle_controller/proc/jump_shuttle(var/shuttle_tag,var/area/origin,var/area/destination)
	if(moving[shuttle_tag] != SHUTTLE_IDLE) return

	moving[shuttle_tag] = SHUTTLE_WARMUP
	spawn(warmup[shuttle_tag]*10)
		move_shuttle(shuttle_tag, origin, destination)
		moving[shuttle_tag] = SHUTTLE_IDLE

//This is for shuttles with a timer before arrival such as the vox skipjack and the escape shuttle.
/datum/shuttle_controller/proc/jump_shuttle_long(var/shuttle_tag,var/area/departing,var/area/destination,var/area/interim,var/travel_time)
	if(moving[shuttle_tag] != SHUTTLE_IDLE) return

	moving[shuttle_tag] = SHUTTLE_WARMUP

	spawn(warmup[shuttle_tag]*10)
		move_shuttle(shuttle_tag,locate(departing),locate(interim))

		sleep(travel_time)

		move_shuttle(shuttle_tag,locate(interim),locate(destination))

		moving[shuttle_tag] = SHUTTLE_IDLE

	return


//just moves the shuttle from A to B, if it can be moved
/datum/shuttle_controller/proc/move_shuttle(var/shuttle_tag,var/area/origin,var/area/destination)

	//world << "move_shuttle() called for [shuttle_tag] leaving [origin] en route to [destination]."
	if(!shuttle_tag || isnull(location[shuttle_tag]))
		return

	var/area/area_going_to
	if(destination)
		//world << "Using supplied destination [destination]."
		area_going_to = destination
	else
		//world << "Using controller value [(location[shuttle_tag] == 1 ? areas_station[shuttle_tag] : areas_offsite[shuttle_tag])]."
		area_going_to = (location[shuttle_tag] == 1 ? areas_station[shuttle_tag] : areas_offsite[shuttle_tag])

	var/area/area_coming_from
	if(origin)
		//world << "Using supplied origin [origin]."
		area_coming_from = origin
	else
		//world << "Using controller value [(location[shuttle_tag] == 1 ? areas_offsite[shuttle_tag] : areas_station[shuttle_tag])]."
		area_coming_from = (location[shuttle_tag] == 1 ? areas_offsite[shuttle_tag] : areas_station[shuttle_tag])

	//world << "area_coming_from: [area_coming_from]"
	//world << "area_going_to: [area_going_to]"

	if(area_coming_from == area_going_to)
		//world << "cancelling move, shuttle will overlap."
		return

	moving[shuttle_tag] = SHUTTLE_INTRANSIT
	
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

	location[shuttle_tag] = !location[shuttle_tag]

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