
#define SHIELD_MELEE_BYPASS_DAM_MOD 0.5
#define SHIELD_IDLE 0
#define SHIELD_PROCESS 1
#define SHIELD_RECHARGE 2
#define SHIELD_DAMAGE 3

/datum/armourspecials
	var/mob/living/carbon/human/user

/obj/effect/overlay/shields
	icon = 'code/modules/halo/icons/species/Sangheili_Combat_Harness.dmi'
	icon_state = "shield_overlay"
	plane = ABOVE_HUMAN_PLANE
	layer = ABOVE_HUMAN_LAYER

/obj/effect/overlay/shields/spartan
	icon = 'code/modules/halo/clothing/spartan_armour.dmi'

/obj/effect/overlay/shields/unggoy
	icon = 'code/modules/halo/icons/species/grunt_gear.dmi'

/datum/armourspecials/shields
	var/shieldstrength
	var/totalshields
	var/nextcharge
	var/shield_recharge_delay = 10 SECONDS//The delay for the shields to start recharging from damage (Multiplied by 1.5 if shields downed entirely)
	var/shield_recharge_ticktime = 1 SECOND //The delay between recharge ticks
	var/obj/effect/overlay/shields/shieldoverlay = new /obj/effect/overlay/shields
	var/image/mob_overlay
	var/obj/item/clothing/suit/armor/special/connectedarmour
	var/armour_state = SHIELD_IDLE
	var/tick_recharge = 40
	var/intercept_chance = 100
	var/eva_mode_active = 0

/datum/armourspecials/shields/New(var/obj/item/clothing/suit/armor/special/c) //Needed the type path for typecasting to use the totalshields var.
	. = ..()
	connectedarmour = c
	totalshields = connectedarmour.totalshields
	shieldstrength = totalshields
	add_evamode_verb()

/datum/armourspecials/shields/proc/add_evamode_verb() //Proc-ified to allow subtypes to disable EVA mode.
	connectedarmour.verbs += /obj/item/clothing/suit/armor/special/proc/toggle_eva_mode

/datum/armourspecials/shields/proc/toggle_eva_mode(var/mob/toggler)

	src.eva_mode_active = !src.eva_mode_active
	if(eva_mode_active)
		connectedarmour.visible_message("[toggler] reroutes their shields, prioritising atmospheric and pressure containment.")
		totalshields = connectedarmour.totalshields /4
		take_damage(shieldstrength) //drop our shields to 0
		connectedarmour.item_flags |= STOPPRESSUREDAMAGE
		connectedarmour.item_flags |= AIRTIGHT
		connectedarmour.min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
		connectedarmour.cold_protection = FULL_BODY //There's probably a better way to do this, but I'm not sure of the correct use of the operators.

	else
		connectedarmour.visible_message("[toggler] reroutes their shields, prioritising defense.")
		take_damage(shieldstrength) //drop our shields to 0
		totalshields = connectedarmour.totalshields
		connectedarmour.item_flags = initial(connectedarmour.item_flags)
		connectedarmour.min_cold_protection_temperature = initial(connectedarmour.min_cold_protection_temperature)
		connectedarmour.cold_protection = initial(connectedarmour.cold_protection)

/datum/armourspecials/shields/update_mob_overlay(var/image/generated_overlay)
	mob_overlay = generated_overlay
	if(generated_overlay)
		mob_overlay.overlays += shieldoverlay

/datum/armourspecials/shields/handle_shield(mob/m,damage,atom/damage_source)
	var/mob/living/attacker = damage_source
	if(istype(attacker) && damage < 5 && (attacker.a_intent == "help" || attacker.a_intent == "grab")) //We don't need to block helpful actions. (Or grabs)
		return 0
	if(take_damage(damage))
		//Melee damage through shields is reduced
		var/obj/item/dam_source = damage_source
		if(istype(dam_source) &&!istype(dam_source,/obj/item/projectile) && dam_source.loc.Adjacent(connectedarmour.loc))
			dam_source.force *= SHIELD_MELEE_BYPASS_DAM_MOD
			user.visible_message("<span class = 'warning'>[user]'s shields fail to fully absorb the melee attack!</span>")
			spawn(2)
				dam_source.force /= SHIELD_MELEE_BYPASS_DAM_MOD//Revert the damage reduction.
			return 0
		return 1
	else
		return 0

/datum/armourspecials/shields/proc/update_overlay(var/new_icon_state)
	if(mob_overlay)
		mob_overlay.overlays -= shieldoverlay
		shieldoverlay.icon_state = new_icon_state
		mob_overlay.overlays += shieldoverlay

/datum/armourspecials/shields/proc/take_damage(var/damage)
	. = 0

	//some shields dont have full coverage
	if(prob(intercept_chance))
		//reset or begin the recharge timer
		reset_recharge()

		if(shieldstrength > 0)

			//tell the damage procs that we blocked the attack
			. = 1

			//shield visual effect
			update_overlay("shield_overlay_damage")
			armour_state = SHIELD_DAMAGE

			//apply the damage
			shieldstrength -= damage

			//chat log output
			if(shieldstrength <= 0)
				shieldstrength = 0
				playsound(user, 'code/modules/halo/sounds/Shields_Gone.ogg',100,0)
				user.visible_message("<span class ='warning'>[user]'s [connectedarmour] shield collapses!</span>","<span class ='userdanger'>Your [connectedarmour] shields fizzle and spark, losing their protective ability!</span>")
			else
				user.visible_message("<span class='warning'>[user]'s [connectedarmour] shields absorbs the force of the impact</span>","<span class = 'notice'>Your [connectedarmour] shields absorbs the force of the impact</span>")

/datum/armourspecials/shields/proc/reset_recharge(var/extra_delay = 0)
	//begin counting down the recharge
	if(armour_state == SHIELD_IDLE)
		GLOB.processing_objects |= src

	//update the shield effect overlay
	if(shieldstrength > 0)
		update_overlay("shield_overlay")
	else
		update_overlay("shield_overlay_dead")

	armour_state = SHIELD_PROCESS
	nextcharge = world.time + shield_recharge_delay + extra_delay

/datum/armourspecials/shields/process()

	//reset the shield visual
	if(armour_state == SHIELD_DAMAGE)
		if(shieldstrength > 0)
			update_overlay("shield_overlay")
		else
			update_overlay("shield_overlay_dead")
		armour_state = SHIELD_PROCESS

	//check if its a recharge tick
	if(world.time > nextcharge)
		//recharge
		shieldstrength += tick_recharge
		if(shieldstrength >= totalshields)
			shieldstrength = totalshields

		//tell the user
		to_chat(user, "<span class ='notice'>Your [connectedarmour] shield level: [(shieldstrength/totalshields)*100]%</span>")

		//begin this recharge cycle
		if(armour_state == SHIELD_PROCESS)
			playsound(user, 'code/modules/halo/sounds/Shields_Recharge.ogg',100,0)
			if(user)
				user.visible_message("<span class = 'notice'>A faint hum emanates from [user]'s [connectedarmour].</span>")
			else
				connectedarmour.visible_message("<span class = 'notice'>A faint hum emanates from [connectedarmour].</span>")
			update_overlay("shield_overlay_recharge")
			armour_state = SHIELD_RECHARGE
		nextcharge = world.time + shield_recharge_ticktime

	//finished recharging
	if(shieldstrength >= totalshields)
		shieldstrength = totalshields
		armour_state = SHIELD_IDLE
		GLOB.processing_objects -= src
		update_overlay("shield_overlay")
		user.update_icons()

/datum/armourspecials/shields/tryemp(severity)
	switch(severity)
		if(1)
			take_damage(totalshields/2)
			user.visible_message("<span class = 'warning'>[user.name]'s shields momentarily fail, the internal capacitors barely recovering.</span>")
		if(2)
			take_damage(totalshields)
			user.visible_message("<span class = 'warning'>[user.name]'s shields violently spark, the internal capacitors shorting out.</span>")
	reset_recharge(shield_recharge_delay * 2)

/datum/armourspecials/shields/spartan
	shieldoverlay = new /obj/effect/overlay/shields/spartan
	shield_recharge_delay = 5 SECONDS //much faster.

/datum/armourspecials/shields/unggoy
	shield_recharge_delay = 5 SECONDS //Equal to spartans because unggoy shields should be low capacity.
	shieldoverlay = new /obj/effect/overlay/shields/unggoy

#undef SHIELD_IDLE
#undef SHIELD_PROCESS
#undef SHIELD_RECHARGE
#undef SHIELD_DAMAGE