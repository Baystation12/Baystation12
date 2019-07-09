/obj/machinery/cryopod/oni
	name = "ONI Black Site Cryopod"
	icon_state = "syndipod_0"
	base_icon_state = "syndipod_0"
	occupied_icon_state = "syndipod_1"
	time_till_despawn = 30		//3 seconds

/obj/machinery/cryopod/oni/despawn_occupant()

	var/datum/game_mode/game_mode = ticker.mode
	game_mode.handle_mob_death(occupant, unsc_capture = 1)
	. = ..()
