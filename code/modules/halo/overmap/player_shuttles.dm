#define SHUTTLE_REQ_DELAY 5 SECONDS

/obj/machinery/shuttle_spawner
	var/obj/effect/overmap/ship/npc_ship/ship_to_spawn
	var/shuttle_refresh_time = 60 SECONDS
	var/next_shuttle_at = 0

/obj/machinery/shuttle_spawner/examine(var/mob/examiner)
	. = ..()
	show_next_available_time(examiner)

/obj/machinery/shuttle_spawner/proc/show_next_available_time(var/mob/user)
	var/time_until_shuttle = (next_shuttle_at - world.time)/60
	if(time_until_shuttle <= 0)
		to_chat(user,"<span class = 'notice'>Shuttle currently available.</span>")
		return
	to_chat(user,"<span class = 'notice'>Next shuttle available in [time_until_shuttle] seconds.</span>")

/obj/machinery/shuttle_spawner/proc/spawn_shuttlecraft()
	if(!ship_to_spawn)
		log_error("[src] tried to spawn a shuttle at [map_sectors["[loc.z]"]]'s location, but it doesn't have a ship_to_spawn set!")
		return
	if(isnull(map_sectors["[loc.z]"]))
		log_error("[src] tried to spawn a shuttlecraft without having an overmap-object assigned to it's z-level. ([loc.z])")
		return
	var/obj/effect/overmap/ship/npc_ship/ship = new ship_to_spawn (map_sectors["[loc.z]"])
	ship.make_player_controlled()

/obj/machinery/shuttle_spawner/ex_act(var/severity)
	return

/obj/machinery/shuttle_spawner/attack_hand(var/mob/user)
	if(world.time < next_shuttle_at)
		to_chat(user,"<span class = 'notice'>Shuttlecraft are undergoing refit, currently unavailable.</span>")
		return
	user.visible_message("<span class = 'notice'>[user] starts requisitioning a shuttlecraft from [src]...</span>")
	if(!do_after(user,SHUTTLE_REQ_DELAY,user))
		return
	user.visible_message("<span class = 'notice'>[user] requisitions a shuttlecraft from [src].</span>")
	visible_message("<span class = 'notice'>[src] announces: \"Shuttlecraft Requisitioned. Connect umbilical for access.\"</span>")
	spawn_shuttlecraft()
	next_shuttle_at = world.time + shuttle_refresh_time

/obj/machinery/shuttle_spawner/debug
	ship_to_spawn = /obj/effect/overmap/ship/npc_ship/combat/unsc

#undef SHUTTLE_REQ_DELAY