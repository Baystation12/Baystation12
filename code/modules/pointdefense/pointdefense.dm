//Point defense 

/obj/machinery/pointdefense
	name = "Point defense battery"
	icon = 'icons/obj/artillery.dmi'
	icon_state = "pointdefense"
	desc = "A Kuiper pattern anti-meteor battery. Capable of destroying most threats in a single salvo."
	density = TRUE
	anchored = TRUE
	idle_power_usage = 2 KILOWATTS
	construct_state = /decl/machine_construction/default/panel_closed
	
	appearance_flags = PIXEL_SCALE
	var/active = TRUE
	var/charge_cooldown = 1 SECOND  //time between it can fire at different targets
	var/last_shot = 0
	var/kill_range = 14
	var/rotation_speed = 0.25 SECONDS  //How quickly we turn to face threats
	var/engaging = FALSE

//Guns cannot shoot through hull or generally dense turfs.
/obj/machinery/pointdefense/proc/space_los(meteor)
	for(var/turf/T in getline(src,meteor))
		if(T.density)
			return FALSE
	return TRUE

/obj/machinery/pointdefense/proc/shot_complete(var/obj/effect/meteor/target)
	engaging = FALSE
	last_shot = world.time
	qdel(target)

/obj/machinery/pointdefense/Process()
	..()
	if(!active)
		return
	set_dir(transform.get_angle() > 0 ? NORTH : SOUTH)
	if(engaging || ((world.time - last_shot) < charge_cooldown))
		return
	
	for(var/obj/effect/meteor/M in GLOB.meteor_list)
		if(!(M.z in GetConnectedZlevels(z)))
			continue
		if(get_dist(M, src) > kill_range)
			continue
		if(!emagged && space_los(M)) //Reconsider this
			engaging = TRUE
			var/Angle = round(Get_Angle(src,M))
			var/matrix/rot_matrix = matrix()
			rot_matrix.Turn(Angle)
			set_light(0.8, 2, 1, l_color = COLOR_SABER_RED)
			addtimer(CALLBACK(src, /atom/proc/Beam, get_turf(M), "thin_double", 'icons/effects/beam.dmi', 6 , kill_range , /obj/effect/overlay/beam/red, 3), rotation_speed)
			addtimer(CALLBACK(src, .proc/shot_complete, M), rotation_speed)
			animate(src, transform = rot_matrix, rotation_speed, easing = SINE_EASING)
			
			set_dir(transform.get_angle() > 0 ? NORTH : SOUTH)
			return

/obj/machinery/pointdefense/RefreshParts()
	. = ..()
	// ()
	// ..()
	// // Calculates an average rating of components that affect charging rate.
	// var/chargerate_multiplier = total_component_rating_of_type(/obj/item/weapon/stock_parts/capacitor)
	// chargerate_multiplier += total_component_rating_of_type(/obj/item/weapon/stock_parts/scanning_module)

	// var/chargerate_divisor = number_of_components(/obj/item/weapon/stock_parts/capacitor)
	// chargerate_divisor += number_of_components(/obj/item/weapon/stock_parts/scanning_module)

	// repair = -5
	// repair += 2 * total_component_rating_of_type(/obj/item/weapon/stock_parts/manipulator)
	// repair += total_component_rating_of_type(/obj/item/weapon/stock_parts/scanning_module)

	// if(chargerate_multiplier)
	// 	change_power_consumption(base_charge_rate * (chargerate_multiplier / chargerate_divisor), POWER_USE_ACTIVE)
	// else
	// 	change_power_consumption(base_charge_rate, POWER_USE_ACTIVE)



// /obj/machinery/pointdefense/proc/change_meteor_chance(mod)
// 	for(var/datum/event_container/container in SSevents.event_containers)
// 		for(var/datum/event_meta/M in container.available_events)
// 			if(M.event_type == /datum/event/meteor_wave)
// 				M.weight *= mod