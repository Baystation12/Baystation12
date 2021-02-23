#include "rawl_shuttles.dm"
#include "rawl_jobs.dm"
#include "rawl_areas.dm"

/datum/map_template/ruin/away_site/rawl
	name = "IPV Rawl"
	id = "awaysite_rawl"
	description = "rawl thingy."
	suffixes = list("rawl/rawl.dmm")
	area_usage_test_exempted_root_areas = list(/area/rawl/)
	cost = 0.5
	spawn_weight = 0.67
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/rawl_ship)

/obj/effect/overmap/visitable/sector/rawl_spawn
	name = "mundane asteroid"
	desc = "Initial scans suggest something has impacted this asteroid. Further analysis reveals it was a second asteroid."
	icon_state = "meteor2"
	hide_from_reports = TRUE

	initial_generic_waypoints = list(
		"nav_rawl_1",
		"nav_rawl_2"
	)

/obj/effect/shuttle_landmark/rawl/one
	name = "East of asteroid"
	landmark_tag = "nav_rawl_1"

/obj/effect/shuttle_landmark/rawl/two
	name = "South of asteroid"
	landmark_tag = "nav_rawl_2"

/obj/effect/submap_landmark/joinable_submap/rawl
	name =  "IPV Rawl"
	archetype = /decl/submap_archetype/derelict/rawl

/decl/submap_archetype/derelict/rawl
	descriptor = "Unathi Poacher Ship"
	map = "IPV Rawl"
	crew_jobs = list(
		/datum/job/submap/rawl_pilot,
		/datum/job/submap/rawl_tech,
		/datum/job/submap/rawl_medic
	)

/obj/machinery/power/smes/buildable/preset/rawl/smes
	uncreated_component_parts = list(/obj/item/weapon/stock_parts/smes_coil = 1)
	_input_maxed = TRUE
	_output_maxed = TRUE
	_input_on = TRUE
	_output_on = TRUE

/obj/item/weapon/storage/secure/safe/rawl/New()
	..()
	new /obj/item/weapon/melee/energy/knife(src)
	new /obj/item/clothing/accessory/storage/holster/knife(src)
	spawn_money(rand(75,350)*10, src)

/var/const/access_rawl = "ACCESS_RAWL"
/datum/access/rawl
	id = access_rawl
	desc = "Rawl Access"
	region = ACCESS_REGION_NONE

/obj/item/weapon/card/id/rawl
	access = list(access_rawl)
	color = COLOR_BEIGE
	detail_color = COLOR_AMBER

/obj/machinery/power/apc/high/rawl
	req_access = list(access_rawl)

/obj/machinery/alarm/rawl
	req_access = list(access_rawl)
	target_temperature = T0C+40

/obj/machinery/alarm/rawl/Initialize()
	. = ..()
	TLV[GAS_OXYGEN] =			list(18, 19, 135, 140) // Partial pressure, kpa
	TLV["temperature"] =	list(T0C-26, T0C, T0C+80, T0C+90) // K

/obj/structure/closet/secure_closet/personal/rawl
	name = "Personal Wall Closet"
	desc = "It's a wall-mounted id-locked closet for personal storage."
	anchored = 1
	density = 0
	wall_mounted = 1
	storage_types = CLOSET_STORAGE_ITEMS
	closet_appearance = /decl/closet_appearance/wall

/obj/structure/closet/rawlkitchen
	name = "Kitchen Cabinet"
	desc = "A small cupboard made of metal for storing kitchen supplies."
	anchored = 1
	density = 0
	wall_mounted = 1
	storage_types = CLOSET_STORAGE_ITEMS
	closet_appearance = /decl/closet_appearance/wall

/obj/structure/closet/secure_closet/personal/rawl/WillContain()
	return list(
		/obj/item/clothing/under/savage_hunter,
		/obj/item/clothing/shoes/jackboots/unathi,
		/obj/item/weapon/storage/backpack/satchel/leather/reddish)

/obj/structure/closet/secure_closet/freezer/rawl
	name = "freezer"
	icon = 'icons/obj/closets/fridge.dmi'
	closet_appearance = null
	req_access = list(access_rawl)

/obj/item/device/radio/rawl
	name = "old radio"
	desc = "an old, cheap radio that looks heavy enough to kill someone."
	cell = /obj/item/weapon/cell/device/high
	throwforce = 12
	icon_state = "radio"
	w_class = ITEM_SIZE_NORMAL
	canhear_range = 6
	power_usage = 8
