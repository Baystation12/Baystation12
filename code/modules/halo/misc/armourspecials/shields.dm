
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
	var/shield_recharge_delay = 40//The delay for the shields to start recharging from damage (Multiplied by 1.5 if shields downed entirely)
	var/obj/effect/overlay/shields/shieldoverlay = new /obj/effect/overlay/shields
	var/image/mob_overlay
	var/obj/item/clothing/suit/armor/special/connectedarmour
	var/list/armourvalue
	var/armour_state = SHIELD_IDLE
	var/tick_recharge = 30
	var/intercept_chance = 100

/datum/armourspecials/shields/New(var/obj/item/clothing/suit/armor/special/c) //Needed the type path for typecasting to use the totalshields var.
	connectedarmour = c
	totalshields = connectedarmour.totalshields
	shieldstrength = totalshields
	armourvalue = connectedarmour.armor

/datum/armourspecials/shields/update_mob_overlay(var/image/generated_overlay)
	mob_overlay = generated_overlay
	if(generated_overlay)
		mob_overlay.overlays += shieldoverlay

/datum/armourspecials/shields/handle_shield(mob/m,damage,atom/damage_source)

	if(take_damage(damage))
		connectedarmour.armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0) //This is needed because shields don't work if armour absorbs the blow instead.

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
		connectedarmour.armor =  armourvalue
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
				user.visible_message("<span class ='warning'>[user]'s [connectedarmour] shield collapses!</span>","<span class ='userdanger'>Your [connectedarmour] shields fizzle and spark, losing their protective ability!</span>")
			else
				user.visible_message("<span class='warning'>[user]'s [connectedarmour] shields absorbs the force of the impact</span>","<span class = 'notice'>Your [connectedarmour] shields absorbs the force of the impact</span>")

/datum/armourspecials/shields/proc/reset_recharge(var/extra_delay = 0)
	//begin counting down the recharge
	if(armour_state == SHIELD_IDLE)
		GLOB.processing_objects += src

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
			user.visible_message("<span class = 'notice'>A faint hum emanates from [user]'s [connectedarmour].</span>")
			update_overlay("shield_overlay_recharge")
			armour_state = SHIELD_RECHARGE
		nextcharge = world.time + shield_recharge_delay

	//finished recharging
	if(shieldstrength >= totalshields)
		shieldstrength = totalshields
		armour_state = SHIELD_IDLE
		GLOB.processing_objects -= src
		update_overlay("shield_overlay")

/datum/armourspecials/shields/tryemp(severity)
	switch(severity)
		if(1)
			take_damage(totalshields)
			user.visible_message("<span class = 'warning'>[user.name]'s shields momentarily fail, the internal capacitors barely recovering.</span>")
		if(2)
			take_damage(totalshields)
			user.visible_message("<span class = 'warning'>[user.name]'s shields violently spark, the internal capacitors shorting out.</span>")
	reset_recharge(shield_recharge_delay * 2)

/datum/armourspecials/shields/spartan
	shieldoverlay = new /obj/effect/overlay/shields/spartan

/datum/armourspecials/shields/unggoy
	shieldoverlay = new /obj/effect/overlay/shields/unggoy

#undef SHIELD_IDLE
#undef SHIELD_PROCESS
#undef SHIELD_RECHARGE
#undef SHIELD_DAMAGE