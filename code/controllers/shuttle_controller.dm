
var/global/datum/shuttle_controller/shuttle_controller


/datum/shuttle_controller
	var/list/shuttles	//maps shuttle tags to shuttle datums, so that they can be looked up.
	var/list/process_shuttles	//simple list of shuttles, for processing

/datum/shuttle_controller/proc/process()
	//process ferry shuttles
	for (var/datum/shuttle/ferry/shuttle in process_shuttles)
		if (shuttle.in_use)
			shuttle.process()


/datum/shuttle_controller/New()
	shuttles = list()
	process_shuttles = list()

	var/datum/shuttle/ferry/shuttle
	
	// Escape shuttle and pods
	shuttle = new/datum/shuttle/ferry/emergency()
	shuttle.location = 1
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/shuttle/escape/centcom)
	shuttle.area_station = locate(/area/shuttle/escape/station)
	shuttle.area_transition = locate(/area/shuttle/escape/transit)
	shuttle.transit_direction = NORTH
	shuttle.move_time = 300
	//shuttle.docking_controller_tag = "supply_shuttle"
	//shuttle.dock_target_station = "cargo_bay"
	shuttles["Escape"] = shuttle
	process_shuttles += shuttle
	
	//give the emergency shuttle controller it's shuttle
	emergency_shuttle.shuttle = shuttle
	emergency_shuttle.setup_pods()
	process_shuttles += emergency_shuttle.escape_pods
	
	// Supply shuttle
	shuttle = new/datum/shuttle/ferry/supply()
	shuttle.location = 1
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/supply/dock)
	shuttle.area_station = locate(/area/supply/station)
	shuttle.docking_controller_tag = "supply_shuttle"
	shuttle.dock_target_station = "cargo_bay"
	shuttles["Supply"] = shuttle
	process_shuttles += shuttle
	
	supply_controller.shuttle = shuttle

	// Admin shuttles.
	shuttle = new()
	shuttle.location = 1
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/shuttle/transport1/centcom)
	shuttle.area_station = locate(/area/shuttle/transport1/station)
	shuttle.docking_controller_tag = "centcom_shuttle"
	shuttle.dock_target_station = "centcom_shuttle_dock_airlock"
	shuttle.dock_target_offsite = "centcom_shuttle_bay"
	shuttles["Centcom"] = shuttle
	process_shuttles += shuttle

	shuttle = new()
	shuttle.location = 1
	shuttle.warmup_time = 10	//want some warmup time so people can cancel.
	shuttle.area_offsite = locate(/area/shuttle/administration/centcom)
	shuttle.area_station = locate(/area/shuttle/administration/station)
	shuttle.docking_controller_tag = "admin_shuttle"
	shuttle.dock_target_station = "admin_shuttle_dock_airlock"
	shuttle.dock_target_offsite = "admin_shuttle_bay"
	shuttles["Administration"] = shuttle
	process_shuttles += shuttle

	shuttle = new()
	shuttle.area_offsite = locate(/area/shuttle/alien/base)
	shuttle.area_station = locate(/area/shuttle/alien/mine)
	shuttles["Alien"] = shuttle
	//process_shuttles += shuttle	//don't need to process this. It can only be moved using admin magic anyways.

	// Public shuttles
	shuttle = new()
	shuttle.location = 1
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/shuttle/constructionsite/site)
	shuttle.area_station = locate(/area/shuttle/constructionsite/station)
	shuttle.docking_controller_tag = "engineering_shuttle"
	shuttle.dock_target_station = "engineering_dock_airlock"
	shuttle.dock_target_offsite = "engineering_station_airlock"
	shuttles["Engineering"] = shuttle
	process_shuttles += shuttle

	shuttle = new()
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/shuttle/mining/outpost)
	shuttle.area_station = locate(/area/shuttle/mining/station)
	shuttle.docking_controller_tag = "mining_shuttle"
	shuttle.dock_target_station = "mining_dock_airlock"
	shuttle.dock_target_offsite = "mining_outpost_airlock"
	shuttles["Mining"] = shuttle
	process_shuttles += shuttle

	shuttle = new()
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/shuttle/research/outpost)
	shuttle.area_station = locate(/area/shuttle/research/station)
	shuttle.docking_controller_tag = "research_shuttle"
	shuttle.dock_target_station = "research_dock_airlock"
	shuttle.dock_target_offsite = "research_outpost_dock"
	shuttles["Research"] = shuttle
	process_shuttles += shuttle

	// ERT Shuttle
	var/datum/shuttle/ferry/multidock/specops/ERT = new()
	ERT.location = 0
	ERT.warmup_time = 10
	ERT.area_offsite = locate(/area/shuttle/specops/station)	//centcom is the home station, the Exodus is offsite
	ERT.area_station = locate(/area/shuttle/specops/centcom)
	ERT.docking_controller_tag = "specops_shuttle_port"
	ERT.docking_controller_tag_station = "specops_shuttle_port"
	ERT.docking_controller_tag_offsite = "specops_shuttle_fore"
	ERT.dock_target_station = "specops_centcom_dock"
	ERT.dock_target_offsite = "specops_dock_airlock"
	shuttles["Special Operations"] = ERT
	process_shuttles += ERT

	//Vox Shuttle.
	var/datum/shuttle/multi_shuttle/VS = new/datum/shuttle/multi_shuttle()
	VS.origin = /area/shuttle/vox/station

	VS.destinations = list(
		"Fore Starboard Solars" = locate(/area/vox_station/northeast_solars),
		"Fore Port Solars" = locate(/area/vox_station/northwest_solars),
		"Aft Starboard Solars" = locate(/area/vox_station/southeast_solars),
		"Aft Port Solars" = locate(/area/vox_station/southwest_solars),
		"Mining asteroid" = locate(/area/vox_station/mining)
		)

	VS.announcer = "NSV Icarus"
	VS.arrival_message = "Attention, Exodus, we just tracked a small target bypassing our defensive perimeter. Can't fire on it without hitting the station - you've got incoming visitors, like it or not."
	VS.departure_message = "Your guests are pulling away, Exodus - moving too fast for us to draw a bead on them. Looks like they're heading out of the system at a rapid clip."
	VS.interim = locate(/area/vox_station/transit)

	VS.warmup_time = 0
	shuttles["Vox Skipjack"] = VS

	//Nuke Ops shuttle.
	var/datum/shuttle/multi_shuttle/MS = new/datum/shuttle/multi_shuttle()
	MS.origin = /area/syndicate_station/start

	MS.destinations = list(
		"Northwest of the station" = locate(/area/syndicate_station/northwest),
		"North of the station" = locate(/area/syndicate_station/north),
		"Northeast of the station" = locate(/area/syndicate_station/northeast),
		"Southwest of the station" = locate(/area/syndicate_station/southwest),
		"South of the station" = locate(/area/syndicate_station/south),
		"Southeast of the station" = locate(/area/syndicate_station/southeast),
		"Telecomms Satellite" = locate(/area/syndicate_station/commssat),
		"Mining Asteroid" = locate(/area/syndicate_station/mining)
		)

	MS.announcer = "NSV Icarus"
	MS.arrival_message = "Attention, Exodus, you have a large signature approaching the station - looks unarmed to surface scans. We're too far out to intercept - brace for visitors."
	MS.departure_message = "Your visitors are on their way out of the system, Exodus, burning delta-v like it's nothing. Good riddance."
	MS.interim = locate(/area/syndicate_station/transit)

	MS.warmup_time = 0
	shuttles["Syndicate"] = MS


//This is called by gameticker after all the machines and radio frequencies have been properly initialized
/datum/shuttle_controller/proc/setup_shuttle_docks()
	var/datum/shuttle/shuttle
	var/datum/shuttle/ferry/multidock/multidock
	var/list/dock_controller_map = list()	//so we only have to iterate once through each list
	
	//multidock shuttles
	var/list/dock_controller_map_station = list()
	var/list/dock_controller_map_offsite = list()

	for (var/shuttle_tag in shuttles)
		shuttle = shuttles[shuttle_tag]
		if (shuttle.docking_controller_tag)
			dock_controller_map[shuttle.docking_controller_tag] = shuttle
		if (istype(shuttle, /datum/shuttle/ferry/multidock))
			multidock = shuttle
			dock_controller_map_station[multidock.docking_controller_tag_station] = multidock
			dock_controller_map_offsite[multidock.docking_controller_tag_offsite] = multidock

	//search for the controllers, if we have one.
	if (dock_controller_map.len)
		for (var/obj/machinery/embedded_controller/radio/C in machines)	//only radio controllers are supported at the moment
			if (istype(C.program, /datum/computer/file/embedded_program/docking))
				if (C.id_tag in dock_controller_map)
					shuttle = dock_controller_map[C.id_tag]
					shuttle.docking_controller = C.program
					dock_controller_map -= C.id_tag
				if (C.id_tag in dock_controller_map_station)
					multidock = dock_controller_map_station[C.id_tag]
					if (istype(multidock))
						multidock.docking_controller_station = C.program
						dock_controller_map_station -= C.id_tag
				if (C.id_tag in dock_controller_map_offsite)
					multidock = dock_controller_map_offsite[C.id_tag]
					if (istype(multidock))
						multidock.docking_controller_offsite = C.program
						dock_controller_map_offsite -= C.id_tag
	
	//sanity check
	if (dock_controller_map.len || dock_controller_map_station.len || dock_controller_map_offsite.len)
		var/dat = ""
		for (var/dock_tag in dock_controller_map + dock_controller_map_station + dock_controller_map_offsite)
			dat += "\"[dock_tag]\", "
		world << "/red /b warning: shuttles with docking tags [dat] could not find their controllers!"
	
	//makes all shuttles docked to something at round start go into the docked state
	for (var/shuttle_tag in shuttles)
		shuttle = shuttles[shuttle_tag]
		shuttle.dock()
