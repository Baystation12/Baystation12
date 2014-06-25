/obj/structure
	icon = 'icons/obj/structures.dmi'
	var/climbable

/obj/structure/blob_act()
	if(prob(50))
		del(src)

/obj/structure/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			if(prob(50))
				del(src)
				return
		if(3.0)
			return

/obj/structure/meteorhit(obj/O as obj)
	del(src)

/obj/structure/New()
	..()
	if(climbable)
		verbs += /obj/structure/proc/do_climb

/obj/structure/proc/do_climb()

	set name = "Climb structure"
	set desc = "Climbs onto a structure."
	set category = "Object"
	set src in oview(1)

	if (!can_touch(usr) || !climbable)
		return

	usr.visible_message("<span class='warning'>[usr] starts climbing onto \the [src]!</span>")

	if(!do_after(usr,50))
		return

	usr.loc = get_turf(src)
	if (get_turf(usr) == get_turf(src))
		usr.visible_message("<span class='warning'>[usr] climbs onto \the [src]!</span>")

/obj/structure/proc/structure_shaken()

	for(var/mob/living/M in get_turf(src))

		if(M.lying) return //No spamming this on people.

		M.Weaken(5)
		M << "\red You topple as \the [src] moves under you!"

		if(prob(25))

			var/damage = rand(15,30)
			var/mob/living/carbon/human/H = M
			if(!istype(M))
				H << "\red You land heavily!"
				M.adjustBruteLoss(damage)
				return

			var/datum/organ/external/affecting

			switch(pick(list("ankle","wrist","head","knee","elbow")))
				if("ankle")
					affecting = H.get_organ(pick("l_foot", "r_foot"))
				if("knee")
					affecting = H.get_organ(pick("l_leg", "r_leg"))
				if("wrist")
					affecting = H.get_organ(pick("l_hand", "r_hand"))
				if("elbow")
					affecting = H.get_organ(pick("l_arm", "r_arm"))
				if("head")
					affecting = H.get_organ("head")

			if(affecting)
				M << "\red You land heavily on your [affecting.display_name]!"
				affecting.take_damage(damage, 0)
				if(affecting.parent)
					affecting.parent.add_autopsy_data("Misadventure", damage)
			else
				H << "\red You land heavily!"
				H.adjustBruteLoss(damage)

			H.UpdateDamageIcon()
			H.updatehealth()
	return

/obj/structure/proc/can_touch(var/mob/user)
	if (!user)
		return 0
	if (user.stat || user.restrained() || user.paralysis || user.sleeping || user.lying || user.weakened)
		return 0
	if (issilicon(user))
		user << "<span class='notice'>You need hands for this.</span>"
		return 0
	return 1