
#define SHIELD_MELEE_BYPASS_DAM_MOD 0.5

/datum/armourspecials
	var/mob/living/carbon/human/user

/obj/effect/overlay/shields
	icon = 'code/modules/halo/icons/species/Sangheili_Combat_Harness.dmi'
	icon_state = "shield"
	plane = ABOVE_HUMAN_PLANE
	layer = ABOVE_HUMAN_LAYER

/obj/effect/overlay/shields/spartan
	icon = 'code/modules/halo/clothing/spartan_armour.dmi'
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
		var/obj/item/dam_source = damage_source
		if(istype(dam_source) &&!istype(dam_source,/obj/item/projectile) && dam_source.loc.Adjacent(connectedarmour.loc))
			dam_source.force *= SHIELD_MELEE_BYPASS_DAM_MOD //Melee damage through shields is reduced.
			user.visible_message("<span class = 'warning'>[user]'s shields fail to fully absorb the melee attack!</span>")
			spawn(2)
				dam_source.force /= SHIELD_MELEE_BYPASS_DAM_MOD//Revert the damage reduction.
			return 0
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
