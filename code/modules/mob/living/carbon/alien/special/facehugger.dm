//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

//TODO: Make these simple_animals

var/const/MIN_IMPREGNATION_TIME = 100 //time it takes to impregnate someone
var/const/MAX_IMPREGNATION_TIME = 150

var/const/MIN_ACTIVE_TIME = 300 //time between being dropped and going idle
var/const/MAX_ACTIVE_TIME = 600

/obj/item/clothing/mask/facehugger
	name = "alien"
	desc = "It has some sort of a tube at the end of its tail."
	icon_state = "facehugger"
	item_state = "facehugger"
	w_class = 1 //note: can be picked up by aliens unlike most other items of w_class below 4
	flags = FPRINT|TABLEPASS|MASKCOVERSMOUTH|MASKCOVERSEYES

	var/stat = UNCONSCIOUS //UNCONSCIOUS is the idle state in this case

	var/sterile = 0

	var/strength = 5

	var/attached = 0

	attack_paw(user as mob) //can be picked up by aliens
		if(isalien(user))
			attack_hand(user)
			return
		else
			..()
			return

	attack_hand(user as mob)
		if(stat == CONSCIOUS && !isalien(user))
			Attach(user)
			return
		else
			..()
			return

	attack(mob/living/M as mob, mob/user as mob)
		..()
		user.drop_from_inventory(src)
		Attach(M)

	New()
		if(aliens_allowed)
			..()
		else
			del(src)

	examine()
		..()
		switch(stat)
			if(DEAD,UNCONSCIOUS)
				usr << "\red \b [src] is not moving."
			if(CONSCIOUS)
				usr << "\red \b [src] seems to be active."
		if (sterile)
			usr << "\red \b It looks like the proboscis has been removed."
		return

	attackby()
		Die()
		return

	bullet_act()
		Die()
		return

	temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
		if(exposed_temperature > 300)
			Die()
		return

	equipped(mob/M)
		Attach(M)

	HasEntered(atom/target)
		Attach(target)
		return

	dropped()
		..()
		GoActive()
		return

	throw_impact(atom/hit_atom)
		Attach(hit_atom)
		return

	proc/Attach(M as mob)
		if(!isliving(M) || isalien(M))
			return
		if(attached)
			return
		else
			attached++
			spawn(MAX_IMPREGNATION_TIME)
				attached = 0

		var/mob/living/L = M //just so I don't need to use :

		if(stat != CONSCIOUS)	return
		if(!sterile) L.take_organ_damage(strength,0) //done here so that even borgs and humans in helmets take damage

		if(issilicon(L))
			for(var/mob/O in viewers(src, null))
				O.show_message("\red \b [src] smashes against [L]'s frame!", 1)
			Die()
			return

		var/mob/living/carbon/target = L

		for(var/mob/O in viewers(target, null))
			O.show_message("\red \b [src] leaps at [target]'s face!", 1)

		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			if(H.head && H.head.flags & HEADCOVERSMOUTH)
				for(var/mob/O in viewers(H, null))
					O.show_message("\red \b [src] smashes against [H]'s [H.head]!", 1)
				Die()
				return

		if(target.wear_mask)
			if(prob(20))	return
			var/obj/item/clothing/W = target.wear_mask
			if(!W.canremove)	return
			target.drop_from_inventory(W)

			for(var/mob/O in viewers(target, null))
				O.show_message("\red \b [src] tears [W] off of [target]'s face!", 1)

		loc = target
		layer = 20
		target.wear_mask = src
		target.update_inv_wear_mask()

		GoIdle() //so it doesn't jump the people that tear it off

		if(!sterile) target.Paralyse(MAX_IMPREGNATION_TIME/6) //something like 25 ticks = 20 seconds with the default settings

		spawn(rand(MIN_IMPREGNATION_TIME,MAX_IMPREGNATION_TIME))
			Impregnate(target)

		return

	proc/Impregnate(mob/living/carbon/target as mob)
		if(!target || target.wear_mask != src || target.stat == DEAD) //was taken off or something
			return

		if(!sterile)
			target.contract_disease(new /datum/disease/alien_embryo(0)) //so infection chance is same as virus infection chance
			for(var/datum/disease/alien_embryo/A in target.viruses)
				target.status_flags |= XENO_HOST
				break

			for(var/mob/O in viewers(target,null))
				O.show_message("\red \b [src] falls limp after violating [target]'s face!", 1)

			Die()
		else
			for(var/mob/O in viewers(target,null))
				O.show_message("\red \b [src] violates [target]'s face!", 1)
		target.update_inv_wear_mask()
		return

	proc/GoActive()
		if(stat == DEAD || stat == CONSCIOUS)
			return

		stat = CONSCIOUS

/*		for(var/mob/living/carbon/alien/alien in world)
			var/image/activeIndicator = image('icons/mob/alien.dmi', loc = src, icon_state = "facehugger_active")
			activeIndicator.override = 1
			if(alien && alien.client)
				alien.client.images += activeIndicator	*/

		spawn(rand(MIN_ACTIVE_TIME,MAX_ACTIVE_TIME))
			GoIdle()

		return

	proc/GoIdle()
		if(stat == DEAD || stat == UNCONSCIOUS)
			return

/*		RemoveActiveIndicators()	*/

		stat = UNCONSCIOUS

		return

	proc/Die()
		if(stat == DEAD)
			return

/*		RemoveActiveIndicators()	*/

		icon_state = "facehugger_dead"
		stat = DEAD

		for(var/mob/O in viewers(src, null))
			O.show_message("\red \b[src] curls up into a ball!", 1)

		return

/*	proc/RemoveActiveIndicators() //removes the "active" facehugger indicator from all aliens in the world for this hugger
		for(var/mob/living/carbon/alien/alien in world)
			if(alien.client)
				for(var/image/image in alien.client.images)
					if(image.icon_state == "facehugger_active" && image.loc == src)
						del(image)

		return	*/

/obj/item/clothing/mask/facehugger/angry
	stat = CONSCIOUS

/obj/item/clothing/mask/facehugger/angry/HasProximity(atom/movable/AM as mob|obj)
	if(istype(AM , /mob/living/))
		Attach(AM)


/*
/obj/item/clothing/mask/facehugger/angry/New()
	processing_objects.Add(src)

/obj/item/clothing/mask/facehugger/angry/process()
	if(!src || src.stat == (DEAD))
		return

	for(var/mob/living/carbon/C in range(1,src))
		Attach(C)
		return

	for(var/mob/living/carbon/C in range(5,src))
		if(isInSight(C,src))
			step_to(src,C,0)
			spawn(5)
				if(C in range(1,src))
					Attach(C)
			return

	step_rand(src)

	return

/obj/item/clothing/mask/facehugger/angry/Attach(var/mob/M as mob)

	..(M)
	processing_objects.Remove(src)

*/
