/datum/map_template/ruin/exoplanet/transshipment
	name = "Raided Transshipment point"
	id = "transshipment"
	description = "An abandoned warehouse and damaged CCG-produced shuttle."
	suffixes = list("transshipment/transshipment.dmm")
	spawn_cost = 0.5
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/old_snz)
	apc_test_exempt_areas = list(
		/area/map_template/transshipment/airstrip = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/map_template/transshipment/smes_crate = NO_SCRUBBER|NO_VENT,
		/area/map_template/transshipment/cabin_crate = NO_SCRUBBER|NO_VENT,
		/area/map_template/transshipment/control_crate = NO_SCRUBBER|NO_VENT
	)
	ruin_tags = RUIN_HUMAN|RUIN_WRECK
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS

	skip_main_unit_tests = "Ruin has shuttle landmark."

/area/map_template/transshipment/old_snz
	name = "\improper SNZ-210 Personnel Carrier"
	icon_state = "shuttlegrn"

/area/map_template/transshipment/smes_crate
	name = "\improper Transshipment point Backup Generator"
	icon_state = "security_sub"

/area/map_template/transshipment/cabin_crate
	name = "\improper Transshipment Point Cabin"
	icon_state = "crew_quarters"

/area/map_template/transshipment/control_crate
	name = "\improper Transshipment point Electrical Control"
	icon_state = "engineering_supply"

/area/map_template/transshipment/warehouse
	name = "\improper Transshipment Point Warehouse"
	icon_state = "storage"

/area/map_template/transshipment/airstrip
	name = "\improper Transshipment point Airstrip"
	icon_state = "shuttle2"
	area_flags = AREA_FLAG_EXTERNAL

/datum/shuttle/autodock/overmap/old_snz
	name = "SNZ-210 Personnel Carrier"
	dock_target = "oldsnz_shuttle"
	current_location = "nav_oldsnz_start"
	range = 1
	shuttle_area = /area/map_template/transshipment/old_snz
	fuel_consumption = 4
	defer_initialisation = TRUE
	flags = SHUTTLE_FLAGS_PROCESS
	skill_needed = SKILL_MIN
	ceiling_type = /turf/simulated/floor/shuttle_ceiling

/obj/machinery/computer/shuttle_control/explore/old_snz
	name = "SNZ-210 Shuttle control console"
	shuttle_tag = "SNZ-210 Personnel Carrier"

/obj/overmap/visitable/ship/landable/old_snz
	name = "SNZ-210 Personnel Carrier"
	desc = "SNZ-210 Personnel Carrier. Multipurpose shuttle, used for personnel delivery. Was obsolete even before the Gaia Conflict."
	shuttle = "SNZ-210 Personnel Carrier"
	fore_dir = WEST
	color = "#8dc0d8"
	vessel_mass = 2500
	vessel_size = SHIP_SIZE_TINY

/obj/shuttle_landmark/old_snz/start
	name = "Transshipment point Airstripe"
	landmark_tag = "nav_oldsnz_start"
	base_area = /area/map_template/transshipment/airstrip
	base_turf = /turf/simulated/floor/exoplanet/concrete
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/item/paper/transshipment
	language = LANGUAGE_SPACER

/obj/item/paper/transshipment/first
	name = "To Ted"
	info = {"
		<p>Ted, please don't make a scene about the fact that you're being forced to fly out to the edge of nowhere again.</p>
		<p>The place is just a warehouse - a mountain of containers piled in one place, ready for the taking. It's even got a spot to land!</p>
		<p>I didn't buy this decommissioned piece of titanium crap through the black market to just leave it in the hanger, so quit whining and get us our haul.</p>
		"}

/obj/item/paper/transshipment/second
		name = "Letter to an asshole"
		info = {"
		<p>Nicky, this is fucked up! I hope you don't have to read this, cause if you do then that means I'm DEAD!!</p>
		<p>While we were flying this hunk of scrap to the target, something hit us as we were entering orbit.</p>
		<p>Engines are dying, the hull is torn open, and we're not gonna be able to leave until we patch damn thing up.</p>
		<p>If something happens to me, my father is gonna tear you a new one!!!</p>
		"}

/obj/item/paper/transshipment/third
		name = "Another letter to Nicky"
		info = {"
		<p>Nicky, I'm gonna keep this short. Some sort of overgrown space parrots are on our tail. Me and the guys are taking apart the grilles around the landing pad and fashioning barricades to hold them off.</p>
		<p>You better hope we make it out of here, or you're not seeing a single god-damn thaler!!</p>
		<p>Ugh, now what - they just dropped eggs on us, it looks like? I don't know, I'm going to head out and see what the hell they are.</p>
		"}
