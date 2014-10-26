/obj/mecha/working/hoverpod
	desc = "Stubby and round, this space-capable craft is an ancient favorite."
	name = "Hover Pod"
	icon_state = "engineering_pod"
	initial_icon = "engineering_pod"
	internal_damage_threshold = 80
	step_in = 4
	step_energy_drain = 10
	max_temperature = 20000
	health = 150
	infra_luminosity = 6
	wreckage = /obj/effect/decal/mecha_wreckage/hoverpod
	var/list/cargo = new
	var/cargo_capacity = 5
	max_equip = 3
	var/datum/effect/effect/system/ion_trail_follow/ion_trail

/obj/mecha/working/hoverpod/New()
	..()
	ion_trail = new /datum/effect/effect/system/ion_trail_follow()
	ion_trail.set_up(src)
	ion_trail.start()

//No space drifting
/obj/mecha/working/hoverpod/check_for_support()
	//does the hoverpod have enough charge left to stabilize itself?
	if (has_charge(step_energy_drain))
		if (!ion_trail.on)
			ion_trail.start()
		return 1
	
	ion_trail.stop()
	return ..()

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

//Hoverpod variants
/obj/mecha/working/hoverpod/combatpod
	desc = "An ancient, run-down combat spacecraft." // Ideally would have a seperate icon.
	name = "Combat Hoverpod"
	health = 200
	internal_damage_threshold = 35
	cargo_capacity = 2
	max_equip = 2

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