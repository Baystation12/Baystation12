/datum/map_template/ruin/antag_spawn/vox_raider
	name = "Vox Raider"
	suffixes = list("vox/vox_raider.dmm")
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/vox_raider)

/obj/effect/overmap/visitable/sector/vox_start
	name = "Empty Space"
	desc = "Just some empty space, with an irregular sensor echo."
	in_space = TRUE
	known = FALSE
	icon_state = "event"
	hide_from_reports = TRUE
	initial_generic_waypoints = list(
		"nav_vox_raider_start"
	)

/obj/effect/overmap/visitable/ship/landable/vox_raider
	name = "Alien Interceptor"
	desc = "An irregular, bulbous craft of unknown origin."
	shuttle = "Alien Interceptor"
	fore_dir = WEST
	vessel_size = SHIP_SIZE_SMALL
	vessel_mass = 2500 //Vox alloys are lightweight or smthn. Idk.

/datum/shuttle/autodock/overmap/vox_raider
	name = "Alien Interceptor"
	shuttle_area = list(/area/map_template/vox_raider)
	dock_target = "vox_raider"
	current_location = "nav_vox_raider_start"
	defer_initialisation = TRUE
	ceiling_type = /turf/simulated/floor/shuttle_ceiling/vox
	warmup_time = 5
	range = 2
	fuel_consumption = 0
	skill_needed = SKILL_NONE
	knockdown = FALSE

/turf/simulated/floor/tiled/dark/vox
	initial_gas = list("nitrogen" = 102.684)

/turf/simulated/floor/tiled/dark/monotile/vox
	initial_gas = list("nitrogen" = 102.684)

/turf/simulated/floor/shuttle_ceiling/vox
	color = COLOR_DARK_GUNMETAL

/obj/effect/paint/vox
	color = COLOR_VOX

/obj/machinery/computer/shuttle_control/explore/vox_raider
	name = "shuttle control console"
	shuttle_tag = "Alien Interceptor"

/obj/effect/shuttle_landmark/vox_raider/start
	landmark_tag = "nav_vox_raider_start"
	name = "Echo Source"

/obj/machinery/alarm/vox_raider
	req_access = list()

/obj/machinery/alarm/vox_raider/Initialize()
	.=..()
	TLV[GAS_OXYGEN] =	list(-1, -1, 0.1, 0.5) // Partial pressure, kpa
	TLV[GAS_NITROGEN] = list(16, 19, 135, 140) // Partial pressure, kpa

/obj/machinery/light/vox
	name = "alien light"
	light_type = /obj/item/light/tube/vox
	desc = "An alien light that smells faintly of rotting meat."


/obj/item/light/tube/vox
	name = "alien light tube"
	color = "#a2f7b8"
	b_colour = "#a2f7b8"
	desc = "An alien light tube. Smells like rotting meat.."
	random_tone = FALSE


/area/map_template/vox_raider
	name = "\improper Alien Interceptor"
	icon_state = "syndie-ship"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	req_access = list(access_syndicate)

