/obj/structure
	icon = 'icons/obj/structures.dmi'
	w_class = ITEM_SIZE_NO_CONTAINER
	layer = STRUCTURE_LAYER
	var/breakable
	var/parts

	var/list/connections = list("0", "0", "0", "0")
	var/list/other_connections = list("0", "0", "0", "0")
	var/list/blend_objects = newlist() // Objects which to blend with
	var/list/noblend_objects = newlist() //Objects to avoid blending with (such as children of listed blend objects.

	var/list/footstep_sounds	//footstep sounds when stepped on
	var/material/material = null

/obj/structure/proc/get_footstep_sound()
	if(LAZYLEN(footstep_sounds)) return pick(footstep_sounds)

/obj/structure/attack_generic(var/mob/user, var/damage, var/attack_verb, var/wallbreaker)
	if(wallbreaker && damage && breakable)
		visible_message("<span class='danger'>\The [user] smashes the \[src] to pieces!</span>")
		attack_animation(user)
		qdel(src)
		return 1
	visible_message("<span class='danger'>\The [user] [attack_verb] \the [src]!</span>")
	attack_animation(user)
	take_damage(damage)
	return 1

/obj/structure/proc/take_damage(var/damage)
	return

/obj/structure/Destroy()
	var/turf/T = get_turf(src)
	if(T && parts)
		new parts(T)
	. = ..()
	if(istype(T))
		T.fluid_update()

/obj/structure/Initialize()
	. = ..()
	if(!CanFluidPass())
		fluid_update()

/obj/structure/Move()
	. = ..()
	if(. && !CanFluidPass())
		fluid_update()


/obj/structure/attack_hand(mob/user)
	..()
	if(breakable)
		if(MUTATION_HULK in user.mutations)
			user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))
			attack_generic(user,1,"smashes")
		else if(istype(user,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			if(H.species.can_shred(user))
				attack_generic(user,1,"slices")
	return ..()

/obj/structure/attack_tk()
	return

/obj/structure/grab_attack(var/obj/item/grab/G)
	if (!G.force_danger())
		to_chat(G.assailant, "<span class='danger'>You need a better grip to do that!</span>")
		return TRUE
	if (G.assailant.a_intent == I_HURT)
		// Slam their face against the table.
		var/blocked = G.affecting.run_armor_check(BP_HEAD, "melee")
		if (prob(30 * blocked_mult(blocked)))
			G.affecting.Weaken(5)
		G.affecting.apply_damage(8, BRUTE, BP_HEAD, blocked)
		visible_message("<span class='danger'>[G.assailant] slams [G.affecting]'s face against \the [src]!</span>")
		if (material)
			playsound(loc, material.tableslam_noise, 50, 1)
		else
			playsound(loc, 'sound/weapons/tablehit1.ogg', 50, 1)
		var/list/L = take_damage(rand(1,5))
		for(var/obj/item/weapon/material/shard/S in L)
			if(S.sharp && prob(50))
				G.affecting.visible_message("<span class='danger'>\The [S] slices into [G.affecting]'s face!</span>", "<span class='danger'>\The [S] slices into your face!</span>")
				G.affecting.standard_weapon_hit_effects(S, G.assailant, S.force*2, blocked, BP_HEAD)
		qdel(G)
	else if(atom_flags & ATOM_FLAG_CLIMBABLE)
		var/obj/occupied = turf_is_crowded()
		if (occupied)
			to_chat(G.assailant, "<span class='danger'>There's \a [occupied] in the way.</span>")
			return TRUE
		G.affecting.forceMove(src.loc)
		G.affecting.Weaken(rand(2,5))
		visible_message("<span class='danger'>[G.assailant] puts [G.affecting] on \the [src].</span>")
		qdel(G)
		return TRUE

/obj/structure/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				qdel(src)
				return
		if(3.0)
			return

/obj/structure/proc/can_visually_connect()
	return anchored

/obj/structure/proc/can_visually_connect_to(var/obj/structure/S)
	return istype(S, src)

/obj/structure/proc/update_connections(propagate = 0)
	var/list/dirs = list()
	var/list/other_dirs = list()

	if(!anchored)
		return

	for(var/obj/structure/S in orange(src, 1))
		if(can_visually_connect_to(S))
			if(S.can_visually_connect())
				if(propagate)
					S.update_connections()
					S.update_icon()
				dirs += get_dir(src, S)

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
						W.update_icon()
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
							if(istype(S, src))
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

	connections = dirs_to_corner_states(dirs)
	other_connections = dirs_to_corner_states(other_dirs)