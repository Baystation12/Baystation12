#define SHUTTLE_REQ_DELAY 5 SECONDS

/obj/machinery/shuttle_spawner
	name = "Shuttle Requisition Console"
	desc = "Used to obtain a small transport shuttle for long or short range transportation."
	icon = 'code/modules/halo/overmap/icons/consoles.dmi'
	icon_state = "shuttle_req_console"
	density = 1
	anchored = 1
	var/obj/effect/overmap/ship/npc_ship/ship_to_spawn
	var/ship_type_name = "shuttlecraft"
	var/shuttle_refresh_time = 5 MINUTES
	var/next_shuttle_at = 0

/obj/machinery/shuttle_spawner/examine(var/mob/examiner)
	. = ..()
	show_next_available_time(examiner)

/obj/machinery/shuttle_spawner/proc/show_next_available_time(var/mob/user)
	var/time_until_shuttle = (next_shuttle_at - world.time)/60
	if(time_until_shuttle <= 0)
		to_chat(user,"<span class = 'notice'>[ship_type_name] currently available.</span>")
		return
	to_chat(user,"<span class = 'notice'>Next [ship_type_name] available in [time_until_shuttle] seconds.</span>")

/obj/machinery/shuttle_spawner/proc/spawn_shuttlecraft()
	if(!ship_to_spawn)
		log_error("[src] tried to spawn a [ship_type_name] at [map_sectors["[loc.z]"]]'s location, but it doesn't have a ship_to_spawn set!")
		return
	var/obj/effect/overmap/om_loc = map_sectors["[loc.z]"]
	if(isnull(om_loc))
		log_error("[src] tried to spawn a [ship_type_name] without having an overmap-object assigned to it's z-level. ([loc.z])")
		return
	var/obj/effect/overmap/ship/npc_ship/ship = new ship_to_spawn (om_loc.loc)
	ship.forceMove(om_loc.loc)
	ship.make_player_controlled()

/obj/machinery/shuttle_spawner/ex_act(var/severity)
	return

/obj/machinery/shuttle_spawner/attack_hand(var/mob/user)
	if(world.time < next_shuttle_at)
		to_chat(user,"<span class = 'notice'>[ship_type_name] are undergoing refit, currently unavailable.</span>")
		return
	user.visible_message("<span class = 'notice'>[user] starts requisitioning a [ship_type_name] from [src]...</span>")
	if(!do_after(user,SHUTTLE_REQ_DELAY,user))
		return
	if(world.time < next_shuttle_at)
		to_chat(user,"<span class = 'notice'>[ship_type_name] are undergoing refit, currently unavailable.</span>")
		return
	user.visible_message("<span class = 'notice'>[user] requisitions a [ship_type_name] from [src].</span>")
	visible_message("<span class = 'notice'>[src] announces: \"[ship_type_name] Requisitioned. Connect umbilical for access.\"</span>")
	spawn_shuttlecraft()
	next_shuttle_at = world.time + shuttle_refresh_time

/obj/machinery/shuttle_spawner/debug
	ship_to_spawn = /obj/effect/overmap/ship/npc_ship/combat/unsc

/obj/effect/overmap/ship/npc_ship/shuttlecraft
	name = "Shuttle Craft"
	vessel_mass = 1
	default_delay = 3 SECONDS //double the speed of a normal ship.

/obj/effect/overmap/ship/npc_ship/shuttlecraft/generate_ship_name()
	return initial(name)

#undef SHUTTLE_REQ_DELAY

//FACTION DEFINES//
/datum/npc_ship/cov_shuttle
	mapfile_links = list('maps/faction_bases/Covenant_Shuttle.dmm')
	fore_dir = WEST
	map_bounds = list(3,26,48,3)

/obj/effect/overmap/ship/npc_ship/shuttlecraft/cov
	icon = 'code/modules/halo/icons/overmap/cov_shuttle.dmi'
	faction = "covenant"
	ship_datums = list(/datum/npc_ship/cov_shuttle)

/datum/npc_ship/unsc_shuttle
	mapfile_links = list('maps/faction_bases/Human_Shuttle.dmm')
	fore_dir = WEST
	map_bounds = list(1,29,48,5)

/obj/effect/overmap/ship/npc_ship/shuttlecraft/unsc
	icon = 'code/modules/halo/icons/overmap/darter.dmi'
	faction = "unsc"
	ship_datums = list(/datum/npc_ship/unsc_shuttle)

/datum/npc_ship/innie_shuttle
	mapfile_links = list('maps/faction_bases/Innie_Shuttle.dmm')
	fore_dir = WEST
	map_bounds = list(1,29,48,5)

/obj/effect/overmap/ship/npc_ship/shuttlecraft/innie
	icon = 'code/modules/halo/icons/overmap/darter.dmi'
	faction = "Insurrection"
	ship_datums = list(/datum/npc_ship/innie_shuttle)

/obj/machinery/shuttle_spawner/cov
	icon = 'code/modules/halo/icons/machinery/covenant/consoles.dmi'
	icon_state = "covie_console"
	ship_to_spawn = /obj/effect/overmap/ship/npc_ship/shuttlecraft/cov

/obj/machinery/shuttle_spawner/unsc
	ship_to_spawn = /obj/effect/overmap/ship/npc_ship/shuttlecraft/unsc

/obj/machinery/shuttle_spawner/innie
	ship_to_spawn = /obj/effect/overmap/ship/npc_ship/shuttlecraft/innie
