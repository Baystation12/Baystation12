#define LASER_COOLDOWN 0
/obj/machinery/space_battle/computer/targeting/laser
	name = "laser targeting computer"
	var/obj/machinery/space_battle/laser_emitter/emitter
	var/amount = 1

/obj/machinery/space_battle/computer/targeting/laser/Destroy()
	if(emitter)
		emitter.computer = null
		emitter = null
	return ..()

/obj/machinery/space_battle/computer/targeting/laser/rename()
	..()
	if(emitter)
		emitter.rename()

/obj/machinery/space_battle/computer/targeting/laser/reconnect()
	for(var/obj/machinery/space_battle/laser_emitter/E in world)
		if(E.id_tag == id_tag && E.z == src.z)
			emitter = E
			E.computer = src
			break
	..()

/obj/machinery/space_battle/computer/targeting/laser/check_fire(var/mob/user)
	if(!emitter)
		user << "<span class='warning'>No emitters are connected!</span>"
		return 0
	return 1

/obj/machinery/space_battle/computer/targeting/laser/give_verbs(var/mob/missile_eye/user)
	user.verbs += /obj/machinery/space_battle/computer/targeting/laser/proc/change_laser

/obj/machinery/space_battle/computer/targeting/laser/proc/change_laser()
	set name = "Change Laser"
	set desc = "Change the laser you are firing."
	set category = "Fire Control"

	var/mob/missile_eye/user = usr
	var/obj/machinery/space_battle/computer/targeting/laser/this = user.linked
	if(this && this.emitter)
		user << this.emitter.change_firemode()

/obj/machinery/space_battle/computer/targeting/laser/fire_at(var/atom/A, params, var/mob/missile_eye/user)
	if(emitter)
		var/wait_time = emitter.wait_time
		var/turf/newloc = get_turf(user.start_loc)
		var/emitter_efficiency = emitter.get_efficiency(-1,1)
		switch(firing_angle)
			if("Flanking")
				wait_time *= 1.5
			if("Carefully Aimed")
				wait_time *= 1.5
			if("Rapid Fire")
				wait_time *= 0.75
		if(firing_angle == "Flanking" || prob(10*emitter_efficiency*(firing_angle == "Rapid Fire" ? 1.5 : 1)) && firing_angle != "Carefully Aimed") // Random firing.
			newloc = pick_area_turf(get_area(newloc), list(/proc/is_space, /proc/not_turf_contains_dense_objects))
		if((firing_angle == "Frontal Assault" || firing_angle == "Carefully Aimed" || firing_angle == "Rapid Fire") && (x_offset || y_offset))
			var/xo = x_offset
			var/yo = y_offset
			while(xo != 0)
				if(xo < 0)
					newloc = get_turf(get_step(newloc, 	WEST))
					xo++
				else
					newloc = get_turf(get_step(newloc, EAST))
					xo--
			while(yo != 0)
				if(yo < 0)
					newloc = get_turf(get_step(newloc, SOUTH))
					yo++
				else
					newloc = get_turf(get_step(newloc, NORTH))
					yo--
		user << emitter.fire_at(A, params, newloc, amount, user)
		var/wait = cooldown(LASER_COOLDOWN + wait_time)
		user << "<span class='notice'>Sensors are now calibrating. Please wait [(wait / 10)] seconds.</span>"


