/obj/item/weapon/gun/energy/gun
	name = "energy gun"
	desc = "An energy-based gun with two settings: Stun and kill."
	icon_state = "energystun100"
	item_state = null	//so the human update icon uses the icon_state instead.
	fire_sound = 'sound/weapons/Taser.ogg'

	charge_cost = 100 //How much energy is needed to fire.
	projectile_type = /obj/item/projectile/beam/stun
	origin_tech = "combat=3;magnets=2"
	modifystate = "energystun"

	var/mode = 0 //0 = stun, 1 = kill

/obj/item/weapon/gun/energy/gun/attack_self(mob/living/user as mob)
	switch(mode)
		if(0)
			mode = 1
			charge_cost = 100
			fire_sound = 'sound/weapons/Laser.ogg'
			user << "<span class='warning'>[src.name] is now set to kill.</span>"
			projectile_type = /obj/item/projectile/beam
			modifystate = "energykill"
		if(1)
			mode = 0
			charge_cost = 100
			fire_sound = 'sound/weapons/Taser.ogg'
			user << "<span class='warning'>[src.name] is now set to stun.</span>"
			projectile_type = /obj/item/projectile/beam/stun
			modifystate = "energystun"
	update_icon()
	update_held_icon()

/obj/item/weapon/gun/energy/gun/mounted
	name = "mounted energy gun"
	self_recharge = 1
	use_external_power = 1

/obj/item/weapon/gun/energy/gun/nuclear
	name = "advanced energy gun"
	desc = "An energy gun with an experimental miniaturized reactor."
	icon_state = "nucgun"
	origin_tech = "combat=3;materials=5;powerstorage=3"
	slot_flags = SLOT_BELT
	force = 8 //looks heavier than a pistol
	self_recharge = 1
	var/lightfail = 0

//override for failcheck behaviour
/obj/item/weapon/gun/energy/gun/nuclear/process()
	charge_tick++
	if(charge_tick < 4) return 0
	charge_tick = 0
	if(!power_supply) return 0
	if((power_supply.charge / power_supply.maxcharge) != 1)
		if(!failcheck())	return 0
		power_supply.give(charge_cost)
		update_icon()
	return 1

/obj/item/weapon/gun/energy/gun/nuclear/proc/failcheck()
	lightfail = 0
	if (prob(src.reliability)) return 1 //No failure
	if (prob(src.reliability))
		for (var/mob/living/M in range(0,src)) //Only a minor failure, enjoy your radiation if you're in the same tile or carrying it
			if (src in M.contents)
				M << "<span class='warning'>Your gun feels pleasantly warm for a moment.</span>"
			else
				M << "<span class='warning'>You feel a warm sensation.</span>"
			M.apply_effect(rand(3,120), IRRADIATE)
		lightfail = 1
	else
		for (var/mob/living/M in range(rand(1,4),src)) //Big failure, TIME FOR RADIATION BITCHES
			if (src in M.contents)
				M << "<span class='danger'>Your gun's reactor overloads!</span>"
			M << "<span class='warning'>You feel a wave of heat wash over you.</span>"
			M.apply_effect(300, IRRADIATE)
		crit_fail = 1 //break the gun so it stops recharging
		processing_objects.Remove(src)
		update_icon()
	return 0


/obj/item/weapon/gun/energy/gun/nuclear/proc/update_charge()
	if (crit_fail)
		overlays += "nucgun-whee"
		return
	var/ratio = power_supply.charge / power_supply.maxcharge
	ratio = round(ratio, 0.25) * 100
	overlays += "nucgun-[ratio]"

/obj/item/weapon/gun/energy/gun/nuclear/proc/update_reactor()
	if(crit_fail)
		overlays += "nucgun-crit"
		return
	if(lightfail)
		overlays += "nucgun-medium"
	else if ((power_supply.charge/power_supply.maxcharge) <= 0.5)
		overlays += "nucgun-light"
	else
		overlays += "nucgun-clean"

/obj/item/weapon/gun/energy/gun/nuclear/proc/update_mode()
	if (mode == 0)
		overlays += "nucgun-stun"
	else if (mode == 1)
		overlays += "nucgun-kill"

/obj/item/weapon/gun/energy/gun/nuclear/emp_act(severity)
	..()
	reliability -= round(15/severity)

/obj/item/weapon/gun/energy/gun/nuclear/update_icon()
	overlays.Cut()
	update_charge()
	update_reactor()
	update_mode()
