#include "scavver_gantry_shuttles.dm"
#include "scavver_gantry_jobs.dm"
#include "scavver_gantry_radio.dm"

/datum/map_template/ruin/away_site/scavver_gantry
	name =  "\improper Salvage Gantry"
	id = "awaysite_gantry"
	description = "Salvage Gantry turned Ship"
	suffixes = list("scavver/scavver_gantry-1.dmm","scavver/scavver_gantry-2.dmm")
	spawn_cost = 1
	player_cost = 4
	accessibility_weight = 10
	shuttles_to_initialise = list(
		/datum/shuttle/autodock/overmap/scavver_gantry,
		/datum/shuttle/autodock/overmap/scavver_gantry/two,
		/datum/shuttle/autodock/overmap/scavver_gantry/three,
		/datum/shuttle/autodock/ferry/gantry
	)
	area_usage_test_exempted_root_areas = list(/area/scavver)
	apc_test_exempt_areas = list(
		/area/scavver/yachtdown = NO_SCRUBBER|NO_VENT,
		/area/scavver/yachtup = NO_SCRUBBER|NO_VENT,
		/area/scavver/gantry/down1 = NO_SCRUBBER|NO_VENT,
		/area/scavver/gantry/down2= NO_SCRUBBER|NO_VENT,
		/area/scavver/gantry/up1 = NO_SCRUBBER|NO_VENT,
		/area/scavver/gantry/up2 = NO_SCRUBBER|NO_VENT,
		/area/scavver/gantry/lift = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/scavver/harvestpod = NO_SCRUBBER|NO_VENT
	)
	spawn_weight = 0.67

/obj/effect/submap_landmark/joinable_submap/scavver_gantry
	name =  "Salvage Gantry"
	archetype = /decl/submap_archetype/derelict/scavver_gantry

/decl/submap_archetype/derelict/scavver_gantry
	descriptor = "Salvage Gantry turned Ship."
	map = "Salvage Gantry"
	crew_jobs = list(
		/datum/job/submap/scavver_pilot,
		/datum/job/submap/scavver_doctor,
		/datum/job/submap/scavver_engineer
	)

/obj/effect/overmap/visitable/ship/scavver_gantry
	name = "Unknown Vessel"
	desc = "Sensor array detects a medium-sized vessel of irregular shape. Vessel origin is unidentifiable."
	vessel_mass = 1200
	fore_dir = NORTH
	burn_delay = 2 SECONDS
	hide_from_reports = TRUE
	known = FALSE
	initial_generic_waypoints = list(
		"nav_gantry_one",
		"nav_gantry_two",
		"nav_gantry_three",
		"nav_gantry_four",
		"nav_gantry_five"
	)
	initial_restricted_waypoints = list(
		"ITV The Reclaimer" = list("nav_hangar_gantry_one"),
		"ITV Vulcan" = list("nav_hangar_gantry_two"),
		"ITV Spiritus" = list("nav_hangar_gantry_three", "nav_hangar_gantry_four", "nav_hangar_gantry_five", "nav_hangar_gantry_six"),
		"Charon" = list("nav_gantry_charon"),
		"Guppy" = list("nav_gantry_gup"),
		"Aquila" = list("nav_gantry_aquila"),
		"Desperado" = list("nav_gantry_desperado")
	)

/obj/item/mech_component/sensors/light/salvage/prebuild()
  ..()
  software.installed_software = list(MECH_SOFTWARE_UTILITY, MECH_SOFTWARE_ENGINEERING)

/mob/living/exosuit/premade/salvage_gantry
	name = "\improper Carrion Crawler"
	desc = "An outdated mech designed to strip and repair ships by crawling along their hull. This one won't be doing many repairs anymore."

/mob/living/exosuit/premade/salvage_gantry/Initialize()
	if(!body)
		body = new /obj/item/mech_component/chassis/pod(src)
		body.color = COLOR_ORANGE
	if(!legs)
		legs = new /obj/item/mech_component/propulsion/spider(src)
		legs.color = COLOR_GUNMETAL
	if(!arms)
		arms = new /obj/item/mech_component/manipulators/powerloader(src)
		arms.color = COLOR_GUNMETAL
	if(!head)
		head = new /obj/item/mech_component/sensors/light/salvage(src)
		head.color = COLOR_GUNMETAL

	. = ..()

/mob/living/exosuit/premade/salvage_gantry/spawn_mech_equipment()
	install_system(new /obj/item/mech_equipment/light(src), HARDPOINT_HEAD)
	install_system(new /obj/item/mech_equipment/clamp(src), HARDPOINT_RIGHT_HAND)
	install_system(new /obj/item/mech_equipment/mounted_system/taser/plasma(src), HARDPOINT_LEFT_HAND)
	install_system(new /obj/item/mech_equipment/ionjets(src), HARDPOINT_BACK)

/area/scavver
	icon = 'maps/away/scavver/scavver_gantry_sprites.dmi'

/area/scavver/gantry/up1
	name = "\improper Upper Salvage Gantry Arm"
	icon_state = "gantry_up_1"

/area/scavver/gantry/up2
	name = "\improper Upper Salvage Gantry Spine"
	icon_state = "gantry_up_2"

/area/scavver/gantry/down1
	name = "\improper Lower Salvage Gantry Arm"
	icon_state = "gantry_down_1"

/area/scavver/gantry/down2
	name = "\improper Lower Salvage Gantry Spine"
	icon_state = "gantry_down_2"

/area/scavver/gantry/lift
	name = "\improper Salvage Gantry Lift"
	icon_state = "gantry_lift"
	requires_power = 0

/area/scavver/yachtup
	name = "\improper Private Yacht Upper Deck"
	icon_state = "gantry_yacht_up"

/area/scavver/yachtdown
	name = "\improper Private Yacht Lower Deck"
	icon_state = "gantry_yacht_down"

/area/scavver/yachtdown/thrusters
	name = "\improper Private Yacht Lower Deck Thrusters"
	icon_state = "gantry_yacht_up"

/area/scavver/hab
	name = "\improper Habitation Module"
	icon_state = "gantry_hab"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/scavver/calypso
	name = "\improper ITV Calypso"
	icon_state = "gantry_calypso"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/scavver/lifepod
	name = "\improper ITV The Reclaimer"
	icon_state = "gantry_lifepod"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/scavver/escapepod
	name = "\improper ITV Vulcan"
	icon_state = "gantry_pod"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/scavver/harvestpod
	name = "\improper ITV Spiritus"
	icon_state = "gantry_yacht_down"
	area_flags = AREA_FLAG_RAD_SHIELDED


//smes
/obj/machinery/power/smes/buildable/preset/scavver/smes
	uncreated_component_parts = list(/obj/item/stock_parts/smes_coil = 1)
	_input_maxed = TRUE
	_output_maxed = TRUE
	_input_on = TRUE
	_output_on = TRUE

/obj/machinery/suit_storage_unit/engineering/salvage/gantry
	name = "Salvage Engineering Voidsuit Storage Unit"
	suit= /obj/item/clothing/suit/space/void/engineering/salvage
	helmet = /obj/item/clothing/head/helmet/space/void/engineering/salvage/engi
	mask = /obj/item/clothing/mask/breath
	req_access = list()

/obj/machinery/suit_storage_unit/engineering/salvage/gantry/med
	name = "Salvage Medical Voidsuit Storage Unit"
	suit= /obj/item/clothing/suit/space/void/engineering/salvage
	helmet = /obj/item/clothing/head/helmet/space/void/engineering/salvage/med
	mask = /obj/item/clothing/mask/breath

/obj/machinery/suit_storage_unit/engineering/salvage/gantry/pilot
	name = "Salvage Pilot Voidsuit Storage Unit"
	suit= /obj/item/clothing/suit/space/void/engineering/salvage
	helmet = /obj/item/clothing/head/helmet/space/void/engineering/salvage/pilot
	mask = /obj/item/clothing/mask/breath

/obj/structure/closet/secure_closet/freezer/fridge/scavver
	req_access = list()

/obj/structure/closet/secure_closet/freezer/fridge/scavver/WillContain()
	return list(
		/obj/item/reagent_containers/food/drinks/milk = 6,
		/obj/item/reagent_containers/food/drinks/soymilk = 4,
		/obj/item/storage/fancy/egg_box = 4
	)
