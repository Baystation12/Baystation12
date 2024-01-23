/obj/structure
	icon = 'icons/obj/structures/structures.dmi'
	w_class = ITEM_SIZE_NO_CONTAINER
	layer = STRUCTURE_LAYER

	var/breakable
	var/parts
	var/list/connections = list("0", "0", "0", "0")
	var/list/other_connections = list("0", "0", "0", "0")
	var/list/blend_objects = newlist() // Objects which to blend with
	var/list/noblend_objects = newlist() //Objects to avoid blending with (such as children of listed blend objects.)
	var/material/material = null
	var/footstep_type
	var/mob_offset = 0 //used for on_structure_offset mob animation
	var/breakout //if someone is currently breaking out

/obj/structure/damage_health(damage, damage_type, damage_flags, severity, skip_can_damage_check)
	if (damage && HAS_FLAGS(damage_flags, DAMAGE_FLAG_TURF_BREAKER))
		if (breakable)
			return kill_health()
		damage = max(damage, 10)
	..()

/obj/structure/proc/mob_breakout(mob/living/escapee)
	set waitfor = FALSE
	return FALSE

/obj/structure/Destroy()
	reset_mobs_offset()
	var/turf/T = get_turf(src)
	if(T && parts)
		new parts(T)
	. = ..()
	if(istype(T))
		T.fluid_update()

/obj/structure/Crossed(mob/living/M)
	if(istype(M))
		M.on_structure_offset(mob_offset)
	..()

/obj/structure/proc/reset_mobs_offset()
	for(var/mob/living/M in loc)
		M.on_structure_offset(0)

/obj/structure/Initialize()
	. = ..()
	if(!CanFluidPass())
		fluid_update()

/obj/structure/Move()
	. = ..()
	if(. && !CanFluidPass())
		fluid_update()


/obj/structure/use_weapon(obj/item/weapon, mob/user, list/click_params)
	// Natural Weapon - Passthrough to generic attack
	if (istype(weapon, /obj/item/natural_weapon))
		attack_generic(user, weapon.force, pick(weapon.attack_verb), damtype = weapon.damtype, dam_flags = weapon.damage_flags())
		return TRUE

	return ..()

/obj/structure/get_interactions_info()
	. = ..()
	.[CODEX_INTERACTION_GRAB_AGGRESSIVE] = "<p>On harm intent, slams the victim against \the [initial(name)], causing damage to both the victim and object.</p>"
	if (HAS_FLAGS(initial(atom_flags), ATOM_FLAG_CLIMBABLE))
		.[CODEX_INTERACTION_GRAB_AGGRESSIVE] += "<p>On non-harm intent, places the victim on \the [initial(name)] after a 3 second timer.</p>"


/obj/structure/use_grab(obj/item/grab/grab, list/click_params)
	// Harm intent - Slam face against the structure
	if (grab.assailant.a_intent == I_HURT)
		if (!grab.force_danger())
			USE_FEEDBACK_GRAB_MUST_UPGRADE("to slam their face on \the [src]")
			return TRUE
		var/blocked = grab.affecting.get_blocked_ratio(BP_HEAD, DAMAGE_BRUTE, damage = 8)
		if (prob(30 * (1 - blocked)))
			grab.affecting.Weaken(5)
		grab.affecting.apply_damage(8, DAMAGE_BRUTE, BP_HEAD)
		visible_message(
			SPAN_DANGER("\The [grab.assailant] slams \the [grab.affecting]'s face against \the [src]!"),
			SPAN_DANGER("You slam \the [grab.affecting]'s face against \the [src]!")
		)
		if (material)
			playsound(src, material.tableslam_noise, 50, 1)
		else
			playsound(src, 'sound/weapons/tablehit1.ogg', 50, 1)
		damage_health(rand(1, 5), DAMAGE_BRUTE)
		qdel(grab)
		return TRUE

	// Climbable structure - Put victim on it
	if (HAS_FLAGS(atom_flags, ATOM_FLAG_CLIMBABLE))
		if (!grab.force_danger())
			USE_FEEDBACK_GRAB_MUST_UPGRADE("to put them on \the [src]")
			return TRUE
		var/obj/occupied = turf_is_crowded()
		if (occupied)
			USE_FEEDBACK_GRAB_FAILURE("There's \a [occupied] blocking \the [src].")
			return TRUE
		if (!do_after(grab.assailant, 3 SECONDS, grab.affecting, DO_PUBLIC_UNIQUE) || !grab.use_sanity_check(src))
			return TRUE
		occupied = turf_is_crowded()
		if (occupied)
			USE_FEEDBACK_GRAB_FAILURE("There's \a [occupied] blocking \the [src].")
			return TRUE
		grab.affecting.forceMove(loc)
		grab.affecting.Weaken(rand(2,5))
		visible_message(
			SPAN_WARNING("\The [grab.assailant] puts \the [grab.affecting] on \the [src]."),
			SPAN_WARNING("You put \the [grab.affecting] on \the [src].")
		)
		qdel(grab)
		return TRUE

	return ..()


/obj/structure/proc/can_visually_connect()
	return anchored

/obj/structure/proc/can_visually_connect_to(obj/structure/S)
	return istype(S, src)

/obj/structure/proc/refresh_neighbors()
	for(var/thing in RANGE_TURFS(src, 1))
		var/turf/T = thing
		T.update_icon()

/obj/structure/proc/update_connections(propagate = 0)
	var/list/dirs = list()
	var/list/other_dirs = list()

	for(var/obj/structure/S in orange(src, 1))
		if(can_visually_connect_to(S))
			if(S.can_visually_connect())
				if(propagate)
					S.update_connections()
					S.update_icon()
				dirs += get_dir(src, S)

	if(!can_visually_connect())
		connections = list("0", "0", "0", "0")
		other_connections = list("0", "0", "0", "0")
		return FALSE

	for(var/direction in GLOB.cardinal)
		var/turf/T = get_step(src, direction)
		var/success = 0
		for(var/b_type in blend_objects)
			if(istype(T, b_type))
				success = 1
				if(propagate)
					var/turf/simulated/wall/W = T
					if(istype(W))
						W.update_connections(1)
				if(success)
					break
			if(success)
				break
		if(!success)
			for(var/obj/O in T)
				for(var/b_type in blend_objects)
					if(istype(O, b_type))
						success = 1
						for(var/obj/structure/S in T)
							if(can_visually_connect_to(S))
								success = 0
						for(var/nb_type in noblend_objects)
							if(istype(O, nb_type))
								success = 0

					if(success)
						break
				if(success)
					break

		if(success)
			dirs += get_dir(src, T)
			other_dirs += get_dir(src, T)

	refresh_neighbors()

	connections = dirs_to_corner_states(dirs)
	other_connections = dirs_to_corner_states(other_dirs)
	return TRUE
