/obj/mecha/working/aero
	parent_type = /obj/mecha/working/ripley
	desc = "An exosuit based off the APLU's design equipped for engineering work. Mounts powerful ion thrusters on the back."
	name = "42-YN \"Aero\""
	icon_state = "aero"
	cargo_capacity = 3
	internal_damage_threshold = 40
	wreckage = /obj/effect/decal/mecha_wreckage/aero
	var/thrusters = 0

/obj/mecha/working/aero/verb/toggle_thrusters()
	set category = "Exosuit Interface"
	set name = "Toggle Thrusters"
	set src = usr.loc
	set popup_menu = 0
	if(usr!=src.occupant)
		return
	if(src.occupant)
		if(get_charge() > 0)
			thrusters = !thrusters
			src.log_message("Toggled thrusters.")
			src.occupant_message("<font color='[src.thrusters?"blue":"red"]'>Thrusters [thrusters?"en":"dis"]abled.")
	return

/obj/mecha/working/aero/Topic(href, href_list)
	..()
	if (href_list["toggle_thrusters"])
		src.toggle_thrusters()

/obj/mecha/working/aero/get_stats_part()
	var/output = ..()
	output += {"<b>Thrusters:</b> [thrusters?"on":"off"]"}
	return output


/obj/mecha/working/aero/get_commands()
	var/output = {"<div class='wr'>
						<div class='header'>Special</div>
						<div class='links'>
						<a href='?src=\ref[src];toggle_thrusters=1'>Toggle Thrusters</a><br>
						</div>
						</div>
						"}
	output += ..()
	return output

/obj/mecha/working/aero/relaymove(mob/user,direction)
	if(user != src.occupant) //While not "realistic", this piece is player friendly.
		user.loc = get_turf(src)
		user.loc.Entered(user)
		user << "You climb out from [src]"
		return 0
	if(!can_move)
		return 0
	if(connected_port)
		if(world.time - last_message > 20)
			src.occupant_message("Unable to move while connected to the air system port")
			last_message = world.time
		return 0
	if(src.pr_inertial_movement.active())
		if(!thrusters)
			return 0
	if(state)
		occupant_message("<font color='red'>Maintenance protocols in effect</font>")
		return
	if(!get_charge())
		return 0
	var/move_result = 0
	if(internal_damage&MECHA_INT_CONTROL_LOST)
		if(thrusters && istype(src.loc, /turf/space))
			move_result = mechboostrand()
		else
			move_result = mechsteprand()
	else if(src.dir!=direction)
		if(thrusters && istype(src.loc, /turf/space))
			move_result = mechspaceturn(direction)
		else
			move_result = mechturn(direction)
	else
		if(thrusters & istype(src.loc, /turf/space))
			move_result	= mechboost(direction)
		else
			move_result	= mechstep(direction)
		if(occupant)
			for(var/obj/effect/speech_bubble/B in range(1, src))
				if(B.parent == occupant)
					B.loc = loc
	if(move_result)
		can_move = 0
		var/tmp_energy_drain = step_energy_drain
		if(istype(src.loc, /turf/space))
			if(!src.check_for_support())
				src.pr_inertial_movement.start(list(src,direction))
				if(thrusters)
					src.pr_inertial_movement.set_process_args(list(src,direction))
					tmp_energy_drain = step_energy_drain*2
		use_power(tmp_energy_drain)
		if(do_after(step_in))
			can_move = 1

		return 1
	return 0