
/datum/armourspecials
	var/mob/living/carbon/human/user

/obj/effect/overlay/shields
	icon = 'code/modules/halo/icons/species/Sangheili_Combat_Harness.dmi'
	icon_state = "shield"
	plane = ABOVE_HUMAN_PLANE
	layer = ABOVE_HUMAN_LAYER

/obj/effect/overlay/shields/spartan
	icon = 'code/modules/halo/clothing/mob_spartansuit.dmi'
	icon_state = "Spartan Shields"

/obj/effect/overlay/shields/unggoy
	icon = 'code/modules/halo/icons/species/grunt_gear.dmi'
	icon_state = "shield"

/datum/armourspecials/shields
	var/shieldstrength
	var/totalshields
	var/nextcharge
	var/warned
	var/shield_recharge_delay = 2//The delay for the shields to start recharging from damage (Multiplied by 1.5 if shields downed entirely)
	var/shieldoverlay = new /obj/effect/overlay/shields
	var/obj/item/clothing/suit/armor/special/connectedarmour
	var/list/armourvalue

/datum/armourspecials/proc/tryemp(var/severity)

/datum/armourspecials/proc/tryexplosion(var/severity)

/datum/armourspecials/proc/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	return 0

/datum/armourspecials/proc/try_item_action()

/datum/armourspecials/proc/on_equip(var/obj/source_armour)

/datum/armourspecials/proc/on_drop(var/obj/source_armour)

/datum/armourspecials/proc/process()

/datum/armourspecials/shields/New(var/obj/item/clothing/suit/armor/special/c) //Needed the type path for typecasting to use the totalshields var.
	connectedarmour = c
	totalshields = connectedarmour.totalshields
	shieldstrength = totalshields
	armourvalue = connectedarmour.armor


/datum/armourspecials/shields/handle_shield(mob/m,damage,atom/damage_source)
	GLOB.processing_objects += src
	user.overlays -= shieldoverlay
	if(checkshields(damage))
		user.overlays += shieldoverlay
		connectedarmour.armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0) //This is needed because shields don't work if armour absorbs the blow instead.
		return 1
	else
		connectedarmour.armor =  armourvalue
		return 0

/datum/armourspecials/shields/proc/checkshields(var/damage,var/display_message = 1)
	if(shieldstrength> 0)
		shieldstrength -= damage
		if(display_message)
			user.visible_message("<span class='warning'>[user]'s shields absorbs the force of the impact</span>","<span class = 'notice'>Your shields absorbs the force of the impact</span>")
		return 1
	if(shieldstrength<= 0)
		if(!warned && display_message) //Stops spam and constant resetting
			user.visible_message("<span class ='warning'>[user]'s shield collapses!</span>","<span class ='userdanger'>Your shields fizzle and spark, losing their protective ability!</span>")
		warned = 1
		nextcharge = world.time + ((shield_recharge_delay SECONDS)*1.5)
		return 0

/datum/armourspecials/shields/proc/tryshields(var/mob/living/m)
	if(shieldstrength >= totalshields)
		shieldstrength = totalshields
		GLOB.processing_objects -= src
		return 0
	if(shieldstrength < 0)
		shieldstrength = 0
		GLOB.processing_objects += src
	if(world.time > nextcharge)
		shieldstrength += 10
		if(prob(30)&& !isnull(m)) //Stops runtime when no mob to display message to.
			m.visible_message("<span class = 'notice'>A faint ping emanates from [m.name]'s armour.</span>","<span class ='notice'>Current shield level: [(shieldstrength/totalshields)*100]%</span>")
		nextcharge = world.time + (shield_recharge_delay SECONDS)
		warned = 0
		return 1

/datum/armourspecials/shields/tryemp(severity)
	switch(severity)
		if(1)
			checkshields(totalshields/2,0)
			user.visible_message("<span class = 'warning'>[user.name]'s shields momentarily fail, the internal capacitors barely recovering.</span>")
		if(2)
			checkshields(totalshields,0)
			user.visible_message("<span class = 'warning'>[user.name]'s shields violently spark, the internal capacitors shorting out.</span>")
	nextcharge = world.time + (shield_recharge_delay SECONDS *2)

/datum/armourspecials/shields/process()
	tryshields(user)
	return

/datum/armourspecials/shields/spartan
	shieldoverlay = new /obj/effect/overlay/shields/spartan

/datum/armourspecials/shields/unggoy
	shieldoverlay = new /obj/effect/overlay/shields/unggoy

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

/datum/armourspecials/shieldmonitor //This is here to be checked to see if shieldlevels should be displayed in the "Status" panel.
	/*var/hud_elements[0] //Can be used later on to create a hud shieldbar. I'd rather get the basics created and implemented first.
	var/client
	var/datum/armourspecials/shields/shield_datum*/
	var/list/valid_helmets = list(/obj/item/clothing/head/helmet/spartan) //This should work for the slayer helms too. IIRC, Istype also counts subtypes.

/datum/armourspecials/shieldmonitor/sangheili
	valid_helmets = list(/obj/item/clothing/head/helmet/sangheili)

/datum/armourspecials/internal_jumpsuit
	//Created for spartan armour to allow them to carry things in slots which require a jumpsuit.
	var/internal_jumpsuit_type

/datum/armourspecials/internal_jumpsuit/on_equip(var/obj/source_armour)
	if(!user)
		return
	if(user.wear_suit != source_armour)
		return
	if(!user.w_uniform)
		user.equip_to_slot(new internal_jumpsuit_type,slot_w_uniform)

/datum/armourspecials/internal_jumpsuit/on_drop(var/obj/source_armour)
	if(!user)
		return
	if(user.wear_suit == source_armour)
		return
	if(istype(user.w_uniform,internal_jumpsuit_type))
		qdel(user.w_uniform)

/datum/armourspecials/internal_jumpsuit/spartan
	internal_jumpsuit_type = /obj/item/clothing/under/spartan_internal

/datum/armourspecials/internal_jumpsuit/unggoy
	internal_jumpsuit_type = /obj/item/clothing/under/unggoy_internal

//An internal air tank: Refillable at specialised machinery. (TODO: CODE SPECIAL MACHINERY)
/datum/armourspecials/internal_air_tank
	var/obj/item/weapon/tank/internal_air_tank
	var/equip_slot = slot_back //The slot to equip the air tank to.

/datum/armourspecials/internal_air_tank/New()
	internal_air_tank = new internal_air_tank
	return ..()

/datum/armourspecials/internal_air_tank/on_equip(var/obj/source_armour)
	. = ..()
	if(user.wear_suit != source_armour)
		return
	if(!user.equip_to_slot_if_possible(internal_air_tank,equip_slot))
		to_chat(user,"<span class = 'warning'>Back obstructed. Internal air tank functionality may be diminished.</span>")
		return

/datum/armourspecials/internal_air_tank/on_drop()
	. = ..()
	user.drop_from_inventory(internal_air_tank)
	internal_air_tank.loc = null

/datum/armourspecials/internal_air_tank/unggoy
	internal_air_tank = /obj/item/weapon/tank/methane/unggoy_internal

/datum/armourspecials/cloaking
	var/cloak_active = 0
	var/min_alpha = 10 //The minimum level of alpha to reach.
	var/cloak_recover_time = 5 //The time in seconds it takes to recover to full cloak after being hit.
	var/cloak_toggle_time = 2 //The time in seconds it takes to enable/disable the cloaking device.
	var/cloak_disrupted = 0 //Is the cloak currently disrupted?

/datum/armourspecials/cloaking/proc/activate_cloak(var/voluntary = 1)
	src.cloak_active = 1
	animate(user,alpha = min_alpha,time = (cloak_toggle_time SECONDS),flags = ANIMATION_END_NOW)
	if(cloak_disrupted)//This stops span from cloak disruption, but still applies the affects.
		return
	if(voluntary)
		user.visible_message("<span class = 'warning'>[user] activates their active camoflage</span>")
	else
		to_chat(user,"<span class = 'danger'>Your active camoflage recovers!</span>")
		user.visible_message("<span calss = 'warning'>[user]'s active camoflage lets out a soft ping and [user] starts to fade.</span>")

/datum/armourspecials/cloaking/proc/deactivate_cloak(var/voluntary = 1)
	src.cloak_active = 0
	animate(user,alpha = 255,time = (cloak_toggle_time SECONDS),flags = ANIMATION_END_NOW)
	if(cloak_disrupted)//This stops span from cloak disruption, but still applies the affects.
		return
	if(voluntary)
		user.visible_message("<span class = 'warning'>[user] deactivates their active camoflage</span>")
	else
		to_chat(user,"<span class = 'danger'>Your active camoflage fails!</span>")
		user.visible_message("<span calss = 'warning'>[user]'s active camoflage sputters and fails!</span>")

/datum/armourspecials/cloaking/proc/disrupt_cloak(var/disrupt_time = cloak_recover_time)
	if(!src.cloak_active)
		return
	src.cloak_disrupted = 1
	deactivate_cloak(0)
	spawn(disrupt_time SECONDS)
		activate_cloak(0)
		src.cloak_disrupted = 0

/datum/armourspecials/cloaking/try_item_action()
	if(!cloak_active)
		if(cloak_disrupted)
			to_chat(user,"<span class = 'warning'>You can't re-enable your cloak whilst it's being disrupted.</span>")
			return
		activate_cloak()
	else
		deactivate_cloak()

/datum/armourspecials/cloaking/handle_shield(mob/m,damage,atom/damage_source)
	disrupt_cloak()
	return 0

/datum/armourspecials/cloaking/tryemp(severity)
	switch(severity)
		if(1)
			disrupt_cloak(cloak_recover_time*2)
		if(2)
			disrupt_cloak(cloak_recover_time*4)

/datum/armourspecials/thrusters
