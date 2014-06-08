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
	var/in_use = 0						//prevents people from controlling the shuttle from different consoles at the same time
	var/area_station
	var/area_offsite
	
	var/docking_controller = null
	var/list/docking_targets = list()

/datum/shuttle/proc/short_jump(var/datum/shuttle/shuttle,var/area/origin,var/area/destination)
	if(moving_status != SHUTTLE_IDLE) return

	moving_status = SHUTTLE_WARMUP
	spawn(warmup_time*10)
		move(origin, destination)
		moving_status = SHUTTLE_IDLE

/datum/shuttle/proc/long_jump(var/shuttle_tag,var/area/departing,var/area/destination,var/area/interim,var/travel_time)
	if(moving_status != SHUTTLE_IDLE) return

	moving_status = SHUTTLE_WARMUP

	spawn(warmup_time*10)
		move(locate(departing),locate(interim))

		sleep(travel_time)

		move(locate(interim),locate(destination))

		moving_status = SHUTTLE_IDLE

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
	var/datum/shuttle/shuttle
	
	//Supply and escape shuttles.
	shuttle = new/datum/shuttle()
	shuttle.location = 1
	shuttle.area_offsite = locate(/area/supply/dock)
	shuttle.area_station = locate(/area/supply/station)
	shuttle.docking_targets = list(null, null)
	shuttles["Supply"] = shuttle

	// Admin shuttles.
	shuttle = new/datum/shuttle()
	shuttle.location = 1
	shuttle.area_offsite = locate(/area/shuttle/transport1/centcom)
	shuttle.area_station = locate(/area/shuttle/transport1/station)
	shuttle.docking_targets = list(null, null)
	shuttles["Centcom"] = shuttle

	shuttle = new/datum/shuttle()
	shuttle.location = 1
	shuttle.area_offsite = locate(/area/shuttle/administration/centcom)
	shuttle.area_station = locate(/area/shuttle/administration/station)
	shuttle.docking_targets = list(null, null)
	shuttles["Administration"] = shuttle

	shuttle = new/datum/shuttle()
	shuttle.area_offsite = locate(/area/shuttle/alien/base)
	shuttle.area_station = locate(/area/shuttle/alien/mine)
	shuttle.docking_targets = list(null, null)
	shuttles["Alien"] = shuttle

	// Public shuttles
	shuttle = new/datum/shuttle()
	shuttle.location = 1
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/shuttle/constructionsite/site)
	shuttle.area_station = locate(/area/shuttle/constructionsite/station)
	shuttle.docking_targets = list(null, null)
	shuttles["Engineering"] = shuttle

	shuttle = new/datum/shuttle()
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/shuttle/mining/outpost)
	shuttle.area_station = locate(/area/shuttle/mining/station)
	shuttle.docking_targets = list(null, null)
	shuttles["Mining"] = shuttle

	shuttle = new/datum/shuttle()
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/shuttle/research/outpost)
	shuttle.area_station = locate(/area/shuttle/research/station)
	shuttle.docking_targets = list(null, null)
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

