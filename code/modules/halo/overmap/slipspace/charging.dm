
/obj/machinery/slipspace_engine
	var/sound_range = 21
	var/sound_falloff = 1.5

/obj/machinery/slipspace_engine/proc/start_charging()
	icon_state = "slipspace_active"
	update_use_power(2)
	//decl/sound_player/proc/PlayLoopingSound(var/atom/source, var/sound_id, var/sound, var/volume, var/range, var/falloff, var/prefer_mute)
	ambient_sound = sound_player.PlayLoopingSound(src, charging_sound_id, charging_sound, 100, sound_range, sound_falloff, TRUE, FALSE)
	current_charge_ticks = 1

/obj/machinery/slipspace_engine/proc/stop_charging(var/jump_successful = FALSE)
	icon_state = "slipspace"
	qdel(ambient_sound)
	current_charge_ticks = 0
	update_use_power(1)
	if(!jump_successful)
		playsound(src, stop_charging_sound, 100, FALSE, sound_range - world.view, sound_falloff)

/obj/machinery/slipspace_engine/proc/charge_ready()
	visible_message("<span class = 'info'>[src] is ready to jump.</span>")
	qdel(ambient_sound)
	ambient_sound = sound_player.PlayLoopingSound(src, running_sound_id, running_sound, 100, sound_range, sound_falloff, TRUE, FALSE)
	if(jump_type == SLIPSPACE_EMERGENCY)
		do_jump()
