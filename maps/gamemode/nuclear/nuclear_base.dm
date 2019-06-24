#include "nuclear_base_areas.dm"

/datum/game_mode/nuclear
	overmap_template = /datum/map_template/ruin/gamemode_site/nuclear_base

/obj/effect/overmap/sector/nuclear_base
	name = "mercenary asteroid base"
	desc = "A large asteroid emitting faint traces of sub-space activity."
	icon_state = "meteor1"
	known = 0

/datum/map_template/ruin/gamemode_site/nuclear_base
	name = "mercenary asteroid base"
	id = "awaysite_nuclear_hideout"
	description = "Just another large asteroid."
	suffixes = list("nuclear/nuclear_base.dmm")
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/mercenary)

/obj/effect/shuttle_landmark/merc/nav1
	name = "Asteroid Base Navpoint #1"
	landmark_tag = "nav_merc_1"

/obj/effect/shuttle_landmark/merc/nav2
	name = "Asteroid Base Navpoint #2"
	landmark_tag = "nav_merc_2"

/obj/structure/closet/syndicate/nuclear
	desc = "It's a storage unit for nuclear-operative gear."

/obj/structure/closet/syndicate/nuclear/New()
	..()

	new /obj/item/ammo_magazine/smg(src)
	new /obj/item/ammo_magazine/smg(src)
	new /obj/item/ammo_magazine/smg(src)
	new /obj/item/ammo_magazine/smg(src)
	new /obj/item/ammo_magazine/smg(src)
	new /obj/item/weapon/storage/box/handcuffs(src)
	new /obj/item/weapon/storage/box/flashbangs(src)
	new /obj/item/weapon/gun/energy/gun(src)
	new /obj/item/weapon/gun/energy/gun(src)
	new /obj/item/weapon/gun/energy/gun(src)
	new /obj/item/weapon/gun/energy/gun(src)
	new /obj/item/weapon/gun/energy/gun(src)
	new /obj/item/weapon/pinpointer/nukeop(src)
	new /obj/item/weapon/pinpointer/nukeop(src)
	new /obj/item/weapon/pinpointer/nukeop(src)
	new /obj/item/weapon/pinpointer/nukeop(src)
	new /obj/item/weapon/pinpointer/nukeop(src)
	new /obj/item/modular_computer/pda/syndicate(src)
	var/obj/item/device/radio/uplink/U = new(src)
	U.hidden_uplink.uses = 40
	return

// Nuke ops locator

/obj/item/weapon/pinpointer/nukeop
	var/locate_shuttle = 0

/obj/item/weapon/pinpointer/nukeop/Process()
	var/new_mode
	if(!locate_shuttle && bomb_set)
		locate_shuttle = 1
		new_mode = "Shuttle Locator"
	else if (locate_shuttle && !bomb_set)
		locate_shuttle = 0
		new_mode = "Authentication Disk Locator"
	if(new_mode)
		playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)
		visible_message("<span class='notice'>[new_mode] active.</span>")
		target = acquire_target()
	..()

/obj/item/weapon/pinpointer/nukeop/acquire_target()
	if(locate_shuttle)
		var/obj/machinery/computer/shuttle_control/explore/syndicate/home = locate()
		return weakref(home)
	else
		return ..()

// Shuttle

/obj/machinery/computer/shuttle_control/explore/syndicate
	name = "mercenary shuttle control console"
	req_access = list(access_syndicate)
	shuttle_tag = "redship"

/datum/shuttle/autodock/overmap/mercenary
	name = "redship"
	move_time = 60
	shuttle_area = /area/map_template/syndicate_station/start
	dock_target = "merc_shuttle"
	current_location = "nav_merc_start"
	landmark_transition = "nav_merc_transition"
	range = 1
	fuel_consumption = 0
	logging_home_tag = "nav_merc_start"
	defer_initialisation = TRUE

/obj/effect/overmap/ship/landable/mercenary
	name = "redship"
	shuttle = "redship"
	vessel_mass = 1000
	fore_dir = NORTH

/obj/effect/shuttle_landmark/merc/start
	name = "Mercenary Base"
	landmark_tag = "nav_merc_start"
	docking_controller = "merc_base"

/obj/effect/shuttle_landmark/merc/internim
	name = "In transit"
	landmark_tag = "nav_merc_transition"
