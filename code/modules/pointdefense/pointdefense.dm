//Point defense 

/obj/machinery/pointdefense
	name = "\improper point defense battery"
	icon = 'icons/obj/artillery.dmi'
	icon_state = "pointdefense"
	desc = "A Kuiper pattern anti-meteor battery. Capable of destroying most threats in a single salvo."
	density = TRUE
	anchored = TRUE
	idle_power_usage = 0.1 KILOWATTS
	construct_state = /decl/machine_construction/default/panel_closed
	maximum_component_parts = list(/obj/item/weapon/stock_parts = 10)         //null - no max. list(type part = number max).
	base_type = /obj/machinery/pointdefense
	uncreated_component_parts = null
	appearance_flags = PIXEL_SCALE
	var/active = TRUE
	var/charge_cooldown = 1 SECOND  //time between it can fire at different targets
	var/last_shot = 0
	var/kill_range = 18
	var/rotation_speed = 0.25 SECONDS  //How quickly we turn to face threats
	var/engaging = FALSE

/obj/machinery/pointdefense/populate_parts(full_populate)
	. = ..()
	var/obj/machinery/power/terminal/term = locate() in loc
	if(!istype(term))
		return
	if(!term.master)
		var/obj/item/weapon/stock_parts/power/terminal/t = locate() in src
		if(istype(t))
			t.set_terminal(src, term)

//Guns cannot shoot through hull or generally dense turfs.
/obj/machinery/pointdefense/proc/Space_los(meteor)
	for(var/turf/T in getline(src,meteor))
		if(T.density)
			return FALSE
	return TRUE

/obj/machinery/pointdefense/proc/Shoot(var/obj/effect/meteor/target)
	engaging = TRUE
	target.targeted = TRUE
	var/Angle = round(Get_Angle(src,target))
	var/matrix/rot_matrix = matrix()
	rot_matrix.Turn(Angle)
	addtimer(CALLBACK(src, .proc/Finish_shot, target), rotation_speed)
	animate(src, transform = rot_matrix, rotation_speed, easing = SINE_EASING)
			
	set_dir(transform.get_angle() > 0 ? NORTH : SOUTH)

/obj/machinery/pointdefense/proc/Finish_shot(var/obj/effect/meteor/target)
	engaging = FALSE
	last_shot = world.time
	if(QDELETED(target))
		return
	//We throw a laser but it doesnt have to hit for meteor to explode
	var/obj/item/projectile/beam/pointdefense/beam = new (get_turf(src))
	playsound(src, 'sound/effects/heavy_cannon_blast.ogg', 75, 1)
	use_power_oneoff(idle_power_usage * 10)
	beam.launch(target.loc)
	target.make_debris()
	qdel(target)

/obj/machinery/pointdefense/Process()
	..()
	if(stat & (NOPOWER|BROKEN))
		return
	if(!active)
		return
	var/desiredir = transform.get_angle() > 0 ? NORTH : SOUTH
	if(dir != desiredir)
		set_dir(desiredir)
	if(engaging || ((world.time - last_shot) < charge_cooldown))
		return
	
	for(var/obj/effect/meteor/M in GLOB.meteor_list)
		if(M.targeted)
			continue
		if(!(M.z in GetConnectedZlevels(z)))
			continue
		if(get_dist(M, src) > kill_range)
			continue
		if(!emagged && Space_los(M)) //Reconsider this
			Shoot(M)
			return

/obj/machinery/pointdefense/RefreshParts()
	. = ..()
	// Calculates an average rating of components that affect shooting rate
	var/shootrate_divisor = total_component_rating_of_type(/obj/item/weapon/stock_parts/capacitor)

	charge_cooldown = 2 SECONDS / (shootrate_divisor ? shootrate_divisor : 1)

	//Calculate max shooting range
	var/killrange_multiplier = total_component_rating_of_type(/obj/item/weapon/stock_parts/capacitor)
	killrange_multiplier += 1.5 * total_component_rating_of_type(/obj/item/weapon/stock_parts/scanning_module)

	kill_range = 10 + 4 * killrange_multiplier

	var/rotation_divisor = total_component_rating_of_type(/obj/item/weapon/stock_parts/manipulator)
	rotation_speed = 0.5 SECONDS / (rotation_divisor ? rotation_divisor : 1)