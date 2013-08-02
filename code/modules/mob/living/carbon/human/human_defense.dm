/*
Contains most of the procs that are called when a mob is attacked by something

bullet_act
ex_act
meteor_act
emp_act

*/

/mob/living/carbon/human/bullet_act(var/obj/item/projectile/P, var/def_zone)

// BEGIN TASER NERF
					/* Commenting out new-old taser nerf.
					if(C.siemens_coefficient == 0) //If so, is that clothing shock proof?
						if(prob(deflectchance))
							visible_message("\red <B>The [P.name] gets deflected by [src]'s [C.name]!</B>") //DEFLECT!
							visible_message("\red <B> Taser hit for [P.damage] damage!</B>")
							del P
*/
/* Commenting out old Taser nerf
	if(wear_suit && istype(wear_suit, /obj/item/clothing/suit/armor))
		if(istype(P, /obj/item/projectile/energy/electrode))
			visible_message("\red <B>The [P.name] gets deflected by [src]'s [wear_suit.name]!</B>")
			del P
		return -1
*/
// END TASER NERF

	if(wear_suit && istype(wear_suit, /obj/item/clothing/suit/armor/laserproof))
		if(istype(P, /obj/item/projectile/energy) || istype(P, /obj/item/projectile/beam))
			var/reflectchance = 40 - round(P.damage/3)
			if(!(def_zone in list("chest", "groin")))
				reflectchance /= 2
			if(prob(reflectchance))
				visible_message("\red <B>The [P.name] gets reflected by [src]'s [wear_suit.name]!</B>")

				// Find a turf near or on the original location to bounce to
				if(P.starting)
					var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
					var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
					var/turf/curloc = get_turf(src)

					// redirect the projectile
					P.original = locate(new_x, new_y, P.z)
					P.starting = curloc
					P.current = curloc
					P.firer = src
					P.yo = new_y - curloc.y
					P.xo = new_x - curloc.x

				return -1 // complete projectile permutation

	if(check_shields(P.damage, "the [P.name]"))
		P.on_hit(src, 2)
		return 2

//BEGIN BOOK'S TASER NERF.
	if(istype(P, /obj/item/projectile/energy/electrode))
		var/datum/organ/external/select_area = get_organ(def_zone) // We're checking the outside, buddy!
		var/list/body_parts = list(head, wear_mask, wear_suit, w_uniform, gloves, shoes) // What all are we checking?
		// var/deflectchance=90 //Is it a CRITICAL HIT with that taser?
		for(var/bp in body_parts) //Make an unregulated var to pass around.
			if(!bp)
				continue //Does this thing we're shooting even exist?
			if(bp && istype(bp ,/obj/item/clothing)) // If it exists, and it's clothed
				var/obj/item/clothing/C = bp // Then call an argument C to be that clothing!
				if(C.body_parts_covered & select_area.body_part) // Is that body part being targeted covered?
					P.agony=P.agony*C.siemens_coefficient
		apply_effect(P.agony,AGONY,0)
		flash_pain()
		src <<"\red You have been shot!"
		del P

		var/obj/item/weapon/cloaking_device/C = locate((/obj/item/weapon/cloaking_device) in src)
		if(C && C.active)
			C.attack_self(src)//Should shut it off
			update_icons()
			src << "\blue Your [C.name] was disrupted!"
			Stun(2)

		if(istype(equipped(),/obj/item/device/assembly/signaler))
			var/obj/item/device/assembly/signaler/signaler = equipped()
			if(signaler.deadman && prob(80))
				src.visible_message("\red [src] triggers their deadman's switch!")
				signaler.signal()

		return
//END TASER NERF


	return (..(P , def_zone))


/mob/living/carbon/human/getarmor(var/def_zone, var/type)
	var/armorval = 0
	var/organnum = 0

	if(def_zone)
		if(isorgan(def_zone))
			return checkarmor(def_zone, type)
		var/datum/organ/external/affecting = get_organ(ran_zone(def_zone))
		return checkarmor(affecting, type)
		//If a specific bodypart is targetted, check how that bodypart is protected and return the value.

	//If you don't specify a bodypart, it checks ALL your bodyparts for protection, and averages out the values
	for(var/datum/organ/external/organ in organs)
		armorval += checkarmor(organ, type)
		organnum++
	return (armorval/max(organnum, 1))


/mob/living/carbon/human/proc/checkarmor(var/datum/organ/external/def_zone, var/type)
	if(!type)	return 0
	var/protection = 0
	var/list/body_parts = list(head, wear_mask, wear_suit, w_uniform)
	for(var/bp in body_parts)
		if(!bp)	continue
		if(bp && istype(bp ,/obj/item/clothing))
			var/obj/item/clothing/C = bp
			if(C.body_parts_covered & def_zone.body_part)
				protection += C.armor[type]
	return protection


/mob/living/carbon/human/proc/check_shields(var/damage = 0, var/attack_text = "the attack")
	if(l_hand && istype(l_hand, /obj/item/weapon))//Current base is the prob(50-d/3)
		var/obj/item/weapon/I = l_hand
		if(I.IsShield() && (prob(50 - round(damage / 3))))
			visible_message("\red <B>[src] blocks [attack_text] with the [l_hand.name]!</B>")
			return 1
	if(r_hand && istype(r_hand, /obj/item/weapon))
		var/obj/item/weapon/I = r_hand
		if(I.IsShield() && (prob(50 - round(damage / 3))))
			visible_message("\red <B>[src] blocks [attack_text] with the [r_hand.name]!</B>")
			return 1
	if(wear_suit && istype(wear_suit, /obj/item/))
		var/obj/item/I = wear_suit
		if(I.IsShield() && (prob(35)))
			visible_message("\red <B>The reactive teleport system flings [src] clear of [attack_text]!</B>")
			var/list/turfs = new/list()
			for(var/turf/T in orange(6))
				if(istype(T,/turf/space)) continue
				if(T.density) continue
				if(T.x>world.maxx-6 || T.x<6)	continue
				if(T.y>world.maxy-6 || T.y<6)	continue
				turfs += T
			if(!turfs.len) turfs += pick(/turf in orange(6))
			var/turf/picked = pick(turfs)
			if(!isturf(picked)) return
			src.loc = picked
			return 1
	return 0

/mob/living/carbon/human/emp_act(severity)
	for(var/obj/O in src)
		if(!O)	continue
		O.emp_act(severity)
	for(var/datum/organ/external/O  in organs)
		if(O.status & ORGAN_DESTROYED)	continue
		O.emp_act(severity)
	..()


/mob/living/carbon/human/proc/attacked_by(var/obj/item/I, var/mob/living/user, var/def_zone)
	if(!I || !user)	return 0

	var/target_zone = get_zone_with_miss_chance(user.zone_sel.selecting, src)
	if(user == src) // Attacking yourself can't miss
		target_zone = user.zone_sel.selecting
	if(!target_zone)
		visible_message("\red <B>[user] misses [src] with \the [I]!")
		return

	var/datum/organ/external/affecting = get_organ(target_zone)
	if (!affecting)
		return
	if(affecting.status & ORGAN_DESTROYED)
		user << "What [affecting.display_name]?"
		return
	var/hit_area = affecting.display_name

	if((user != src) && check_shields(I.force, "the [I.name]"))
		return 0

	if(istype(I,/obj/item/weapon/card/emag))
		if(!(affecting.status & ORGAN_ROBOT))
			user << "\red That limb isn't robotic."
			return
		if(affecting.sabotaged)
			user << "\red [src]'s [affecting.display_name] is already sabotaged!"
		else
			user << "\red You sneakily slide [I] into the dataport on [src]'s [affecting.display_name] and short out the safeties."
			affecting.sabotaged = 1
		return

	if(I.attack_verb.len)
		visible_message("\red <B>[src] has been [pick(I.attack_verb)] in the [hit_area] with [I.name] by [user]!</B>")
	else
		visible_message("\red <B>[src] has been attacked in the [hit_area] with [I.name] by [user]!</B>")

	var/armor = run_armor_check(affecting, "melee", "Your armor has protected your [hit_area].", "Your armor has softened hit to your [hit_area].")
	if(armor >= 2)	return 0
	if(!I.force)	return 0

	apply_damage(I.force, I.damtype, affecting, armor , is_sharp(I), I)

	var/bloody = 0
	if(((I.damtype == BRUTE) || (I.damtype == HALLOSS)) && prob(25 + (I.force * 2)))
		I.add_blood(src)	//Make the weapon bloody, not the person.
//		if(user.hand)	user.update_inv_l_hand()	//updates the attacker's overlay for the (now bloodied) weapon
//		else			user.update_inv_r_hand()	//removed because weapons don't have on-mob blood overlays
		if(prob(33))
			bloody = 1
			var/turf/location = loc
			if(istype(location, /turf/simulated))
				location.add_blood(src)
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				if(get_dist(H, src) <= 1) //people with TK won't get smeared with blood
					H.bloody_body(src)
					H.bloody_hands(src)

		switch(hit_area)
			if("head")//Harder to score a stun but if you do it lasts a bit longer
				if(prob(I.force))
					apply_effect(20, PARALYZE, armor)
					visible_message("\red <B>[src] has been knocked unconscious!</B>")
					if(src != user && I.damtype == BRUTE)
						ticker.mode.remove_revolutionary(mind)

				if(bloody)//Apply blood
					if(wear_mask)
						wear_mask.add_blood(src)
						update_inv_wear_mask(0)
					if(head)
						head.add_blood(src)
						update_inv_head(0)
					if(glasses && prob(33))
						glasses.add_blood(src)
						update_inv_glasses(0)

			if("chest")//Easier to score a stun but lasts less time
				if(prob((I.force + 10)))
					apply_effect(5, WEAKEN, armor)
					visible_message("\red <B>[src] has been knocked down!</B>")

				if(bloody)
					bloody_body(src)

/mob/living/carbon/human/proc/bloody_hands(var/mob/living/source, var/amount = 2)
	if (gloves)
		gloves.add_blood(source)
		gloves:transfer_blood = amount
		gloves:bloody_hands_mob = source
	else
		add_blood(source)
		bloody_hands = amount
		bloody_hands_mob = source
	update_inv_gloves()		//updates on-mob overlays for bloody hands and/or bloody gloves

/mob/living/carbon/human/proc/bloody_body(var/mob/living/source)
	if(wear_suit)
		wear_suit.add_blood(source)
		update_inv_wear_suit(0)
	if(w_uniform)
		w_uniform.add_blood(source)
		update_inv_w_uniform(0)
