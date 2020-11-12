/datum/map_template/ruin/antag_spawn/mercenary
	name = "Mercenary Base"
	suffixes = list("mercenary/mercenary_base.dmm")
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/merc_shuttle)

/obj/effect/overmap/visitable/sector/merc_base
	name = "Tiny Asteroid"
	desc = "Sensor array detects a miniscule asteroid. The core appears to be reflecting scans."
	in_space = 1
	known = 0
	icon_state = "meteor4"
	hide_from_reports = TRUE
	initial_generic_waypoints = list(
		"nav_merc_start",
		"nav_merc_1",
		"nav_merc_2",
		"nav_merc_3",
		"nav_merc_4"
	)

/obj/effect/overmap/visitable/ship/landable/merc
	name = "Cyclopes"
	desc = "An older model shuttle with a number of visible modifications. The hull plating is deflecting attempts at more thorough scans."
	shuttle = "Cyclopes"
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_SMALL
	vessel_mass = 10000

/datum/shuttle/autodock/overmap/merc_shuttle
	name = "Cyclopes"
	shuttle_area = list(/area/map_template/merc_shuttle)
	dock_target = "merc_shuttle"
	current_location = "nav_merc_start"
	defer_initialisation = TRUE
	ceiling_type = /turf/simulated/floor/shuttle_ceiling/merc
	warmup_time = 5
	range = 2
	fuel_consumption = 2
	skill_needed = SKILL_NONE

/turf/simulated/floor/shuttle_ceiling/merc
	color = COLOR_RED

/obj/machinery/computer/shuttle_control/explore/merc_shuttle
	name = "shuttle control console"
	shuttle_tag = "Cyclopes"

/obj/effect/shuttle_landmark/merc/start
	landmark_tag = "nav_merc_start"
	name = "Hidden Base"
	docking_controller = "merc_base"

/obj/effect/shuttle_landmark/merc/nav1
	landmark_tag = "nav_merc_1"

/obj/effect/shuttle_landmark/merc/nav2
	landmark_tag = "nav_merc_2"

/obj/effect/shuttle_landmark/merc/nav3
	landmark_tag = "nav_merc_3"

/obj/effect/shuttle_landmark/merc/nav4
	landmark_tag = "nav_merc_4"

/obj/effect/shuttle_landmark/merc/dock
	name = "Docking Port"
	landmark_tag = "nav_merc_dock"
	docking_controller = "eva_airlock"

/obj/effect/shuttle_landmark/transit/merc
	name = "In transit"
	landmark_tag = "nav_transit_merc"

//Areas

/area/map_template/merc_spawn
	name = "\improper Hidden Base"
	icon_state = "syndie-ship"
	req_access = list(access_syndicate)

/area/map_template/merc_shuttle
	name = "\improper Cyclopes"
	icon_state = "yellow"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	req_access = list(access_syndicate)


//Flavorful reminders

/obj/item/weapon/paper/merc/tutorial_1
	name = "highlighted note"
	info = {"<h2> Hey, idiots!</h2>
	<list> Alright, I've gotten complaints from previous customers that this here suit cycler "doesn't work". To make <i>sure</i> my email remains clear so I can pretend I don't have to deal with you lot, here's a handy-dandy cheat sheet for anyone too thick to use a suit cycler.

	1: Put the damn voidsuit and helmet in <b>seperately</b>.
	2: Set the customization you want - the suit will LOOK different, but it's still the same suit.
	3: For my xeno customers, apply special xeno customizations if you want to be able to fit in your pajamas.
	4: And the important part - <i><b> Cycle. The. Suit.</i></b> It does not work if you don't cycle the damn thing!

	</list>
	<list>Regards, Harry.</list>"}


/obj/item/weapon/paper/merc/tutorial_2
	name = "reminder"
	info = {"<center> Heyyyyyyy, so, whoever piloted the Cyclopes last (without telling me! >:|) didn't set the thrust right! </center>
			<center> Uh-oh! Now we're short <i>five</i> whole CO2 canisters, and I'm grummmmmpy! Next person to run the thrusters over 10% without good reason is getting shot, thaaaanks! </center>
			<list><i>J.J.</i></list>
			"}

/obj/item/weapon/paper/merc/tutorial_3
	name = "crumpled pamphlet"
	info = {"<center> <h1> Golden Prawn Hardsuits </h1></center>
		<center><h2> Instructions for Stupid Meat </h2></center>
		<center>Meat must first check that the tank is full. Crowbar open panel. Remove tank with wrench. Fill with the disgusting gas mixture of meat's choice, and replace. Seal panel.</center>
		<center>  Once suit is on, meat may toggle parts of suit. It's not our fault if meat suffocates because they removed their helmet in space and died like idiots. </center>
		<center> Thank you for shopping with Golden Prawn Enterprises! </center>
		<center><h2> NO REFUNDS!</h2></center>
		<center><small> <i>Modules not included</i></small></center>
		<i>Takriakakaw, Chief Technical Officer, Golden Prawn Enterprises</i>
		"}