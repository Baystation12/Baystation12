/obj/item/mech_equipment/clamp
	name = "mounted clamp"
	desc = "A large, heavy industrial cargo loading clamp."
	icon_state = "mech_clamp"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	var/obj/carrying

/obj/item/mech_equipment/clamp/attack()
	return 0

/obj/item/mech_equipment/clamp/afterattack(var/atom/target, var/mob/living/user, var/inrange, var/params)
	. = ..()

	if(. && !carrying)
		if(istype(target, /obj))


			var/obj/O = target
			if(O.buckled_mob)
				return
			if(locate(/mob/living) in O)
				to_chat(user,"<span class='warning'>You can't load living things into the cargo compartment.</span>")
				return

			if(O.anchored)
				to_chat(user, "<span class='warning'>[target] is firmly secured.</span>")
				return


			owner.visible_message(SPAN_NOTICE("\The [owner] begins loading \the [O]."))
			if(do_after(owner, 20, O, 0, 1))
				O.forceMove(src)
				carrying = O
				owner.visible_message(SPAN_NOTICE("\The [owner] loads \the [O] into its cargo compartment."))


		//attacking - Cannot be carrying something, cause then your clamp would be full
		else if(istype(target,/mob/living))
			var/mob/living/M = target
			if(user.a_intent == I_HURT)
				//M.take_overall_damage(dam_force)
				//setClickCooldown(arms ? arms.action_delay : 15)
				if(prob(33))
					return
				M.attack_generic(src, (owner.arms ? owner.arms.melee_damage * 1.5 : 0), "slammed") //Honestly you should not be able to do this without hands, but still
				M.throw_at(get_edge_target_turf(owner ,owner.dir),5, 2)
				//to_chat(user, "<span class='warning'>You slam [target] with [src.name].</span>")
				//owner.visible_message("<span class='warning'>[owner] slams [target] with the hydraulic clamp.</span>")
			else
				step_away(M, owner)
				to_chat(user, "You push [target] out of the way.")
				owner.visible_message("[owner] pushes [target] out of the way.")

/obj/item/mech_equipment/clamp/attack_self(var/mob/user)
	. = ..()
	if(.)
		if(!carrying)
			to_chat(user, SPAN_WARNING("You are not carrying anything in \the [src]."))
		else
			owner.visible_message(SPAN_NOTICE("\The [owner] unloads \the [carrying]."))
			carrying.forceMove(get_turf(src))
			carrying = null

/obj/item/mech_equipment/clamp/get_hardpoint_maptext()
	if(carrying)
		return carrying.name
	. = ..()

// A lot of this is copied from floodlights.
/obj/item/mech_equipment/light
	name = "floodlight"
	desc = "An exosuit-mounted light."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "flashlight"
	item_state = "flashlight"
	restricted_hardpoints = list(HARDPOINT_HEAD)

	var/on = 0
	var/l_max_bright = 0.8
	var/l_inner_range = 1
	var/l_outer_range = 6

/obj/item/mech_equipment/light/attack_self(var/mob/user)
	. = ..()
	if(.)
		on = !on
		to_chat(user, "You switch \the [src] [on ? "on" : "off"].")
		update_icon()

/obj/item/mech_equipment/light/on_update_icon()
	if(on)
		icon_state = "[initial(icon_state)]-on"
		set_light(l_max_bright, l_inner_range, l_outer_range)
	else
		icon_state = "[initial(icon_state)]"
		set_light(0, 0)

/obj/item/mech_equipment/catapult
	name = "\improper gravitational catapult"
	desc = "An exosuit-mounted gravitational catapult."
	icon_state = "mech_clamp"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	var/mode = 1
	var/atom/movable/locked

/obj/item/mech_equipment/catapult/get_hardpoint_maptext()
	var/string
	if(locked)
		string = locked.name + " - "
	if(mode == 1)
		string += "Pull"
	else string += "Push"
	return string


/obj/item/mech_equipment/catapult/attack_self(var/mob/user)
	. = ..()
	if(.)
		mode = mode == 1 ? 2 : 1
		to_chat(user, SPAN_NOTICE("You set \the [src] to [mode == 1 ? "single" : "multi"]-target mode."))
		update_icon()


/obj/item/mech_equipment/catapult/afterattack(var/atom/target, var/mob/living/user, var/inrange, var/params)
	. = ..()
	if(.)
		switch(mode)
			if(1)
				//if(!action_checks(target) && !locked) return
				if(!locked)
					var/atom/movable/AM = target
					if(!istype(AM) || AM.anchored)
						to_chat(user, SPAN_NOTICE("Unable to lock on [target]"))
						return
					locked = AM
					to_chat(user, SPAN_NOTICE("Locked on [AM]"))
					return
				else if(target != locked)
					if(locked in view(owner))
						locked.throw_at(target, 14, 1.5, owner)
						locked = null
						//set_ready_state(0)
						//chassis.use_power(energy_drain)
						//do_after_cooldown()
					else
						locked = null
						to_chat(user, SPAN_NOTICE("Lock on [locked] disengaged."))
			if(2)
				//if(!action_checks(target)) return
				var/list/atoms = list()
				if(isturf(target))
					atoms = range(target,3)
				else
					atoms = orange(target,3)
				for(var/atom/movable/A in atoms)
					if(A.anchored) continue
					spawn(0)
						var/iter = 5-get_dist(A,target)
						for(var/i=0 to iter)
							step_away(A,target)
							sleep(2)
				//set_ready_state(0)
				//chassis.use_power(energy_drain)
				//do_after_cooldown()
		return
