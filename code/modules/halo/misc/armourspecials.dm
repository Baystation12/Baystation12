
/datum/armourspecials
	var/mob/living/carbon/human/user

/obj/effect/overlay/shields
	icon = 'code/modules/halo/icons/elitearmour.dmi'
	icon_state = "shield"

/datum/armourspecials/shields
	var/shieldstrength
	var/totalshields
	var/nextcharge
	var/warned
	var/s = new /obj/effect/overlay/shields
	var/obj/item/clothing/suit/armor/special/connectedarmour

/datum/armourspecials/proc/tryemp(var/severity)

/datum/armourspecials/proc/tryexplosion(var/severity)

/datum/armourspecials/proc/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	return 0

/datum/armourspecials/proc/try_item_action()

/datum/armourspecials/shields/New(var/obj/item/clothing/suit/armor/special/c) //Needed the type path for typecasting to use the totalshields var.
	connectedarmour = c
	totalshields = connectedarmour.totalshields
	shieldstrength = totalshields


/datum/armourspecials/shields/handle_shield(mob/m,damage,atom/damage_source)
	if(checkshields(damage))
		user.overlays += s
		connectedarmour.armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0) //This is needed because shields don't work if armour absorbs the blow instead.
		return 1
	else
		user.overlays -= s
		connectedarmour.armor = list(melee = 95, bullet = 80, laser = 30, energy = 30, bomb = 60, bio = 25, rad = 25)
		GLOB.processing_objects += src
		return 0

/datum/armourspecials/shields/proc/checkshields(var/damage,var/damage_source)
	if(shieldstrength> 0)
		shieldstrength -= damage
		user.visible_message("<span class='warning'>[user]'s shields absorbs the force of the impact</span>","<span class = 'notice'>Your shields absorbs the force of the impact</span>")
		return 1
	if(shieldstrength<= 0)
		if(!warned) //Stops spam and constant resetting
			user.visible_message("<span class ='warning'>[user]'s shield collapses!</span>","<span class ='userdanger'>Your shields fizzle and spark, losing their protective ability!</span>")
		warned = 1
		nextcharge = world.time + 30 // 3 seconds
		return 0

/datum/armourspecials/shields/proc/tryshields(var/mob/living/m)
	if(shieldstrength >= totalshields)
		shieldstrength = totalshields
		GLOB.processing_objects -= src
		return 0
	if(world.time > nextcharge)
		shieldstrength += 10
		if(prob(25)&& !isnull(m)) //Stops runtime when no mob to display message to.
			m.visible_message("<span class = 'notice'>A faint ping emanates from [m.name]'s armour.</span>","<span class ='notice'>Current shield level: [(shieldstrength/totalshields)*100]</span>")
		nextcharge = world.time + 20 // 2 seconds.
		warned = 0
		return 1

/datum/armourspecials/shields/tryemp(severity)
	switch(severity)
		if(1)
			shieldstrength -= totalshields /4
		if(2)
			shieldstrength -= totalshields/2

/datum/armourspecials/shields/proc/process()
	tryshields(user)
	return

/datum/armourspecials/dispenseitems
	var/stored_items[0]
	var/expendedmessage //String for the message displayed when no items are left in the suit.
	var/dispensemessage //String to display when dispensing items.
	var/failmessage //String to display when dispensing fails.

/datum/armourspecials/dispenseitems/try_item_action()
	if(stored_items.len > 0)
		var/nextitem = pick(stored_items)
		if(user.put_in_active_hand(new nextitem))
			stored_items.Remove(nextitem)
			to_chat(user,"<span class ='notice'>[dispensemessage] [stored_items.len] left.</span>")
			return 1
		else if(user.put_in_inactive_hand(new nextitem))
			stored_items.Remove(nextitem)
			to_chat(user,"<span class ='notice'>[dispensemessage] [stored_items.len] left.</span>")
			return 1
		else
			to_chat(user,"<span class ='notice'>[failmessage]</span>")
			return 0
	else
		to_chat(user,"<span class = 'notice'>[expendedmessage]</span>")
		return 0

/datum/armourspecials/dispenseitems/spartanmeds
	expendedmessage = "Emergency medical supplies exhausted."
	dispensemessage = "Dispensing medical supplies..."
	failmessage = "No space in user's hands available for medical support."
	stored_items = list(/obj/item/weapon/reagent_containers/syringe/ld50_syringe/spartan,
	/obj/item/weapon/reagent_containers/syringe/ld50_syringe/spartan,
	/obj/item/weapon/reagent_containers/syringe/ld50_syringe/spartan,
	/obj/item/weapon/reagent_containers/syringe/ld50_syringe/spartan,
	/obj/item/weapon/reagent_containers/syringe/ld50_syringe/spartan,
	/obj/item/weapon/reagent_containers/syringe/ld50_syringe/spartan)

/datum/armourspecials/cloaking // Placeholders for later stuff.

/datum/armourspecials/thrusters
