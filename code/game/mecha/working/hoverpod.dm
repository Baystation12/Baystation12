/obj/mecha/working/hoverpod
	desc = "Stubby and round, this space-capable craft is an ancient favorite."
	name = "Hover Pod"
	icon_state = "engineering_pod"
	initial_icon = "engineering_pod"
	step_in = 4
	step_energy_drain = 5
	max_temperature = 20000
	health = 150
	infra_luminosity = 6
	wreckage = /obj/effect/decal/mecha_wreckage/hoverpod
	var/list/cargo = new
	var/cargo_capacity = 3
	max_equip = 3

//duplicate of parent proc, but without space drifting
/obj/mecha/working/hoverpod/dyndomove(direction)
	if(!can_move)
		return 0
	if(src.pr_inertial_movement.active())
		return 0
	if(!has_charge(step_energy_drain))
		return 0
	var/move_result = 0
	if(hasInternalDamage(MECHA_INT_CONTROL_LOST))
		move_result = mechsteprand()
	else if(src.dir!=direction)
		move_result = mechturn(direction)
	else
		move_result	= mechstep(direction)
	if(move_result)
		can_move = 0
		use_power(step_energy_drain)
		/*if(istype(src.loc, /turf/space))
			if(!src.check_for_support())
				src.pr_inertial_movement.start(list(src,direction))
				src.log_message("Movement control lost. Inertial movement started.")*/
		if(do_after(step_in))
			can_move = 1
		return 1
	return 0

//these three procs overriden to play different sounds
/obj/mecha/working/hoverpod/mechturn(direction)
	dir = direction
	//playsound(src,'sound/machines/hiss.ogg',40,1)
	return 1

/obj/mecha/working/hoverpod/mechstep(direction)
	var/result = step(src,direction)
	if(result)
		playsound(src,'sound/machines/hiss.ogg',40,1)
	return result


/obj/mecha/working/hoverpod/mechsteprand()
	var/result = step_rand(src)
	if(result)
		playsound(src,'sound/machines/hiss.ogg',40,1)
	return result

/*
/obj/mecha/working/hoverpod/New()
	..()
	return
*/

/obj/mecha/working/hoverpod/combatpod
	desc = "An ancient, ghetto fighter." // Ideally would have a seperate icon.
	name = "Combat Hoverpod"

/obj/mecha/working/hoverpod/combatpod/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive
	ME.attach(src)

/obj/mecha/working/hoverpod/shuttlepod
   desc = "Who knew a tiny ball could fit three people?"
/obj/mecha/working/hoverpod/shuttlepod/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/tool/passenger
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tool/passenger
	ME.attach(src)

/obj/mecha/working/hoverpod/Exit(atom/movable/O)
	if(O in cargo)
		return 0
	return ..()

/obj/mecha/working/hoverpod/Topic(href, href_list)
	..()
	if(href_list["drop_from_cargo"])
		var/obj/O = locate(href_list["drop_from_cargo"])
		if(O && O in src.cargo)
			src.occupant_message("\blue You unload [O].")
			O.loc = get_turf(src)
			src.cargo -= O
			var/turf/T = get_turf(O)
			if(T)
				T.Entered(O)
			src.log_message("Unloaded [O]. Cargo compartment capacity: [cargo_capacity - src.cargo.len]")
	return


/obj/mecha/working/hoverpod/get_stats_part()
	var/output = ..()
	output += "<b>Cargo Compartment Contents:</b><div style=\"margin-left: 15px;\">"
	if(src.cargo.len)
		for(var/obj/O in src.cargo)
			output += "<a href='?src=\ref[src];drop_from_cargo=\ref[O]'>Unload</a> : [O]<br>"
	else
		output += "Nothing"
	output += "</div>"
	return output

/obj/mecha/working/hoverpod/Del()
	for(var/mob/M in src)
		if(M==src.occupant)
			continue
		M.loc = get_turf(src)
		M.loc.Entered(M)
		step_rand(M)
	for(var/atom/movable/A in src.cargo)
		A.loc = get_turf(src)
		var/turf/T = get_turf(A)
		if(T)
			T.Entered(A)
		step_rand(A)
	..()
	return