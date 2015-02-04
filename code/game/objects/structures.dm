/obj/structure
	icon = 'icons/obj/structures.dmi'

	var/climbable
	var/breakable
	var/parts

/obj/structure/proc/destroy()
	if(parts)
		new parts(loc)
	density = 0
	del(src)

/obj/structure/attack_hand(mob/user)
	if(breakable)
		if(HULK in user.mutations)
			user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))
			attack_generic(user,1,"smashes")
		else if(istype(user,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			if(H.species.can_shred(user))
				attack_generic(user,1,"slices")
	return ..()

/obj/structure/blob_act()
	if(prob(50))
		del(src)

/obj/structure/meteorhit(obj/O as obj)
	destroy(src)

/obj/structure/attack_tk()
	return

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
		verbs += /obj/structure/proc/climb_on

/obj/structure/Del()
	..()

/obj/structure/proc/climb_on()

	set name = "Climb structure"
	set desc = "Climbs onto a structure."
	set category = "Object"
	set src in oview(1)

	do_climb(usr)

/obj/structure/MouseDrop_T(mob/target, mob/user)

	var/mob/living/H = user
	if(istype(H) && can_climb(H) && target == user)
		do_climb(target)
	else
		return ..()

/obj/structure/proc/can_climb(var/mob/living/user)
	if (!can_touch(user) || !climbable)
		return 0

	if (!user.Adjacent(src))
		user << "<span class='danger'>You can't climb there, the way is blocked.</span>"
		return 0

	var/obj/occupied = turf_is_crowded()
	if(occupied)
		user << "<span class='danger'>There's \a [occupied] in the way.</span>"
		return 0
	return 1

/obj/structure/proc/turf_is_crowded()
	var/turf/T = get_turf(src)
	if(!T || !istype(T))
		return 0
	for(var/obj/O in T.contents)
		if(istype(O,/obj/structure))
			var/obj/structure/S = O
			if(S.climbable) continue
		if(O && O.density && !(O.flags & ON_BORDER)) //ON_BORDER structures are handled by the Adjacent() check.
			return O
	return 0

/obj/structure/proc/do_climb(var/mob/living/user)
	if (!can_climb(user))
		return

	usr.visible_message("<span class='warning'>[user] starts climbing onto \the [src]!</span>")

	if(!do_after(user,50))
		return

	if (!can_climb(user))
		return

	usr.forceMove(get_turf(src))

	if (get_turf(user) == get_turf(src))
		usr.visible_message("<span class='warning'>[user] climbs onto \the [src]!</span>")

/obj/structure/proc/structure_shaken()

	for(var/mob/living/M in get_turf(src))

		if(M.lying) return //No spamming this on people.

		M.Weaken(5)
		M << "<span class='danger'>You topple as \the [src] moves under you!</span>"

		if(prob(25))

			var/damage = rand(15,30)
			var/mob/living/carbon/human/H = M
			if(!istype(H))
				H << "<span class='danger'>You land heavily!</span>"
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
				M << "<span class='danger'>You land heavily on your [affecting.display_name]!</span>"
				affecting.take_damage(damage, 0)
				if(affecting.parent)
					affecting.parent.add_autopsy_data("Misadventure", damage)
			else
				H << "<span class='danger'>You land heavily!</span>"
				H.adjustBruteLoss(damage)

			H.UpdateDamageIcon()
			H.updatehealth()
	return

/obj/structure/proc/can_touch(var/mob/user)
	if (!user)
		return 0
	if(!Adjacent(user))
		return 0
	if (user.restrained() || user.buckled)
		user << "<span class='notice'>You need your hands and legs free for this.</span>"
		return 0
	if (user.stat || user.paralysis || user.sleeping || user.lying || user.weakened)
		return 0
	if (issilicon(user))
		user << "<span class='notice'>You need hands for this.</span>"
		return 0
	return 1

/obj/structure/attack_generic(var/mob/user, var/damage, var/attack_verb, var/wallbreaker)
	if(!breakable || !damage || !wallbreaker)
		return 0
	visible_message("<span class='danger'>[user] [attack_verb] the [src] apart!</span>")
	spawn(1) destroy()
	return 1
