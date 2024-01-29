/datum/map_template/ruin/away_site/minnoe
	name = "minnoe"
	id = "awaysite_minnoe"
	description = "A derelict Free Peoples of Earhart station, raided by the Frontier Alliance."
	spawn_cost = 0.1
	suffixes = list("minnoe/minnoe.dmm")
	area_usage_test_exempted_root_areas = list(/area/map_template/minnoe)
	apc_test_exempt_areas = list(/area/map_template/minnoe)
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/FPEshuttle)

/obj/overmap/visitable/sector/minnoe
	name = "Large Asteroid Station"
	desc = "A large Asteroid Station, with a destroyed Vessel dashed against the south face of the Asteroid. Unusual atmospheric readings indiciate the Asteroid interior is likely pressurized; excavation heavily discouraged. Powernets are reading as if they're inact, and shutdown procedures where followed. Repowering is recommended."
	color = "#665028"
	icon_state = "object"
	initial_generic_waypoints = list(
		"nav_minnoe_north",
		"nav_minnoe_east",
		"nav_minnoe_south",
		"nav_minnoe_west"
	)
	initial_restricted_waypoints = list(
		"ITV The Reclaimer" = list("nav_minnoe_lifepod"),
		"ITV Vulcan" = list("nav_minnoe_escapepod"),
		"Charon" = list("nav_minnoe_charon", "nav_minnoe_charon/alt"),
		"Guppy" = list("nav_gantry_gup", "nav_minnoe_gup/alt", "nav_minnoe_gup/alt/hatch"),
		"Aquila" = list("nav_gantry_aquila", "nav_minnoe_aquila/alt"),
		"Courage of Earhart" = list("nav_minnoe_FPEskiff"),
	)

/obj/overmap/visitable/ship/landable/FPEshuttle
	name = "Courage of Earhart"
	shuttle = "Courage of Earhart"
	desc = "Sensor array detects a tiny vessel, claiming to be 'Courage of Earhart', a utility pod of unknown make."
	fore_dir = WEST
	skill_needed = SKILL_BASIC
	vessel_size = SHIP_SIZE_TINY
	moving_state = "ship_moving"
	max_speed = 1/(4 SECONDS)
	burn_delay = 2.5 SECONDS
	vessel_mass = 3500 //more inefficient than GUP

/datum/shuttle/autodock/overmap/FPEshuttle
	name = "Courage of Earhart"
	warmup_time = 5
	move_time = 35
	shuttle_area = list(/area/map_template/minnoe/FPEskiff)
	current_location = "nav_minnoe_FPEskiff"
	landmark_transition = "nav_minnoe_FPEskiff_transit"
	range = 1
	fuel_consumption = 3
	ceiling_type = /turf/simulated/floor/shuttle_ceiling
	flags = SHUTTLE_FLAGS_PROCESS
	defer_initialisation = TRUE

/obj/machinery/computer/shuttle_control/explore/FPEskiff
	name = "shuttle control console"
	shuttle_tag = "Courage of Earhart"

//areas
/area/map_template/minnoe/FPEskiff
	name = "\improper FPE Skiff"
	icon_state = "fpeskiff"
	area_flags = AREA_FLAG_RAD_SHIELDED
	turfs_airless = TRUE

/area/map_template/minnoe
	name = "\improper Asteroid Station Exterior"
	icon_state = "exterior"
	icon = 'maps/away/minnoe/minnoe_areas.dmi'
	base_turf = /turf/simulated/floor/asteroid

/area/map_template/minnoe/spoke
	name = "\improper Asteroid Station South Spoke"
	icon_state = "spokeS"

/area/map_template/minnoe/spoke/north
	name = "\improper Asteroid Station North Spoke"
	icon_state = "spokeN"

/area/map_template/minnoe/spoke/west
	name = "\improper Asteroid Station West Spoke"
	icon_state = "spokeW"

/area/map_template/minnoe/spoke/northeast
	name = "\improper Asteroid Station North-East Spoke"
	icon_state = "spokeNE"

/area/map_template/minnoe/spoke/East
	name = "\improper Asteroid Station East Spoke"
	icon_state = "spokeE"

/area/map_template/minnoe/hub
	name = "\improper Asteroid Station Hub"
	icon_state = "hub"

/area/map_template/minnoe/tunnel
	name = "\improper Asteroid Station South Tunnel"
	icon_state = "tunnelS"

/area/map_template/minnoe/tunnel/north
	name = "\improper Asteroid Station North Tunnel"
	icon_state = "tunnelN"

/area/map_template/minnoe/tunnel/exterior/
	name = "\improper Asteroid Station Exterior South Tunnel"
	icon_state = "tunnelES"

/area/map_template/minnoe/tunnel/exterior/north
	name = "\improper Asteroid Station Exterior North Tunnel"
	icon_state = "tunnelEN"

/area/map_template/minnoe/tunnel/exterior/east
	name = "\improper Asteroid Station Exterior East Tunnel"
	icon_state = "tunnelEE"

/area/map_template/minnoe/quarters
	name = "\improper Asteroid Station Visitor Bunks"
	icon_state = "quarters"

/area/map_template/minnoe/quarters/dormA
	name = "\improper Asteroid Station Staff Dorm A"
	icon_state = "dormA"

/area/map_template/minnoe/quarters/dormB
	name = "\improper Asteroid Station Staff Dorm B"
	icon_state = "dormB"

/area/map_template/minnoe/quarters/captain
	name = "\improper Asteroid Station Station Commanders Office"
	icon_state = "dormC"

/area/map_template/minnoe/quarters/diner
	name = "\improper Asteroid Station Diner"
	icon_state = "diner"

/area/map_template/minnoe/quartermaster
	name = "\improper Asteroid Station Quartermaster"
	icon_state = "trader"

/area/map_template/minnoe/quartermaster/stockroom
	name = "\improper Asteroid Station Stockroom"
	icon_state = "trader2"

/area/map_template/minnoe/engineering
	name = "\improper Asteroid Station Engineering"
	icon_state = "engine"

/area/map_template/minnoe/engineering/power
	name = "\improper Asteroid Station Reactor"
	icon_state = "engine2"

/area/map_template/minnoe/engineering/robotics
	name = "\improper Asteroid Station Robotics"
	icon_state = "engine3"

/area/map_template/minnoe/engineering/janitor
	name = "\improper Asteroid Station Janitorial"
	icon_state = "engine4"

/area/map_template/minnoe/medical
	name = "\improper Asteroid Station Medical"
	icon_state = "med"

/area/map_template/minnoe/medical/bay
	name = "\improper Asteroid Station Treatment Room"
	icon_state = "med2"

/area/map_template/minnoe/bridge
	name = "\improper Asteroid Station Bridge"
	icon_state = "bridge"

/area/map_template/minnoe/gashauler
	name = "\improper Gas Hauler"
	icon_state = "gas"

/area/map_template/minnoe/hiddendock
	name = "\improper Asteroid Station Hidden Dock"
	icon_state = "hiddendock"

/area/map_template/minnoe/FApod
	name = "\improper FA Breach Pod"
	icon_state = "breachpod"


//shuttles
/obj/shuttle_landmark/minnoe
	base_area = /area/space

/obj/shuttle_landmark/minnoe/FPEskiff
	name = "North-East Catwalk"
	landmark_tag = "nav_minnoe_FPEskiff"
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/shuttle_landmark/minnoe/FPEskiff/transit
	name = "In transit"
	landmark_tag = "nav_minnoe_FPEskiff_transit"

/obj/shuttle_landmark/minnoe/generic/north
	name = "North of Asteroid Station"
	landmark_tag = "nav_minnoe_north"

/obj/shuttle_landmark/minnoe/generic/east
	name = "East of Asteroid Station"
	landmark_tag = "nav_minnoe_east"

/obj/shuttle_landmark/minnoe/generic/south
	name = "South of Asteroid Station"
	landmark_tag = "nav_minnoe_south"

/obj/shuttle_landmark/minnoe/generic/west
	name = "West of Asteroid Station"
	landmark_tag = "nav_minnoe_west"

/obj/shuttle_landmark/minnoe/dock
	name = "South-East Catwalk"
	landmark_tag = "nav_minnoe_hiddendock"

/obj/shuttle_landmark/minnoe/dock/charon
	name = "Charon Dock, East Spoke"
	landmark_tag = "nav_minnoe_charon"
	docking_controller = "minnoe_east"

/obj/shuttle_landmark/minnoe/dock/charon/alt
	name = "Charon Dock, North-East Spoke"
	landmark_tag = "nav_minnoe_charon/alt"
	docking_controller = "minnoe_northeast"

/obj/shuttle_landmark/minnoe/dock/aquila
	name = "Aquila Dock, East Spoke"
	landmark_tag = "nav_minnoe_aquila"
	docking_controller = "minnoe_east"

/obj/shuttle_landmark/minnoe/dock/aquila/alt
	name = "Aquila Dock, North-East Spoke"
	landmark_tag = "nav_minnoe_aquila/alt"
	docking_controller = "minnoe_northeast"

/obj/shuttle_landmark/minnoe/dock/gup
	name = "GUP Dock, East Spoke"
	landmark_tag = "nav_minnoe_gup"

/obj/shuttle_landmark/minnoe/dock/gup/alt
	name = "GUP Dock, North-East Spoke"
	landmark_tag = "nav_minnoe_gup/alt"
	docking_controller = "minnoe_northeast"

/obj/shuttle_landmark/minnoe/dock/gup/hatch //hatch against a dock
	name = "GUP Hatch, West Spoke"
	landmark_tag = "nav_minnoe_gup/alt/hatch"

/obj/shuttle_landmark/minnoe/dock/scavver/escapepod
	name = "Vulcan Dock, West Spoke"
	landmark_tag = "nav_minnoe_escapepod"

/obj/shuttle_landmark/minnoe/dock/scavver/lifepod
	name = "Reclaimer Dock, West Spoke"
	landmark_tag = "nav_minnoe_lifepod"

//glowshrooms
/obj/structure/flora/seaweed/glow/mushroomfake
	icon = 'maps/away/minnoe/glowingmushroom.dmi'
	name = "glowing mushroom"

/obj/structure/flora/seaweed/glow/mushroomfake/Initialize()
	. = ..()
	set_light(2, 0.6, "#00ffb4")
	icon_state = "glowingmushroom"


//robots, FA fleet subtypes
/mob/living/simple_animal/hostile/hivebot/ranged_damage/fleet_robot/alliance
	desc = "A relatively recent model of a 'tracker' security subaltern, armed with an laser rifle."
	desc = "A 'tracker' security subaltern, repainted with Frontier Alliance colours, armed with an laser rifle."
	icon = 'maps/away/minnoe/smallrobot.dmi'
	icon_state = "deimoslaser"
	icon_dead = "deimoslaser"
	faction = "alliance"
	name = "Alliance combat robot"

/mob/living/simple_animal/hostile/hivebot/ranged_damage/fleet_robot/ion/alliance
	desc = "A 'tracker' security subaltern, repainted with Frontier Alliance colours, armed with an ion rifle."
	icon = 'maps/away/minnoe/smallrobot.dmi'
	icon_state = "deimosmagnetic"
	icon_dead = "deimosmagnetic"
	faction = "alliance"
	name = "Alliance combat robot"

/mob/living/simple_animal/hostile/hivebot/ranged_damage/fleet_robot/ballistic/alliance
	desc = "A 'tracker' security subaltern, repainted with Frontier Alliance colours, armed with a sub-machine gun."
	icon = 'maps/away/minnoe/smallrobot.dmi'
	icon_state = "deimosrifle"
	icon_dead = "deimosrifle"
	faction = "alliance"
	name = "Alliance combat robot"