/obj/item/weapon/gun/energy
	icon_state = "energy"
	name = "energy gun"
	desc = "A basic energy-based gun."

	var/obj/item/weapon/cell/power_supply //What type of power cell this uses
	var/cell_type = /obj/item/weapon/cell
	var/modifystate = 0
	var/list/ammo_type = list(/obj/item/ammo_casing/energy)
	var/select = 1 //The state of the select fire switch. Determines from the ammo_type list what kind of shot is fired next.

/obj/item/weapon/gun/energy/emp_act(severity)
	power_supply.use(round(power_supply.maxcharge / severity))
	update_icon()
	..()

/obj/item/weapon/gun/energy/New()
	..()
	if(cell_type)
		power_supply = new cell_type(src)
	else
		power_supply = new(src)
	power_supply.give(power_supply.maxcharge)
	var/obj/item/ammo_casing/energy/shot
	for (var/i = 1, i <= ammo_type.len, i++)
		var/shottype = ammo_type[i]
		shot = new shottype(src)
		ammo_type[i] = shot
	shot = ammo_type[select]
	fire_sound = shot.fire_sound
	update_icon()
	return

/obj/item/weapon/gun/energy/Fire(atom/target as mob|obj|turf, mob/living/user as mob|obj, params, reflex = 0)
	newshot()
	..()

/obj/item/weapon/gun/energy/proc/newshot()
	if (!ammo_type || !power_supply)	return
	var/obj/item/ammo_casing/energy/shot = ammo_type[select]
	if (!power_supply.use(shot.e_cost))	return
	chambered = shot
	chambered.newshot()
	return

/obj/item/weapon/gun/energy/process_chamber()
	chambered = null
	return

/obj/item/weapon/gun/energy/can_fire()
	newshot()
	if(chambered && chambered.BB)
		return 1

/obj/item/weapon/gun/energy/proc/select_fire(mob/living/user as mob)
	select++
	if (select > ammo_type.len)
		select = 1
	var/obj/item/ammo_casing/energy/shot = ammo_type[select]
	fire_sound = shot.fire_sound
	if (shot.select_name)
		user << "\red [src] is now set to [shot.select_name]."
	update_icon()
	return

/obj/item/weapon/gun/energy/update_icon()
	var/ratio = power_supply.charge / power_supply.maxcharge
	ratio = Ceiling(ratio*4) * 25
	var/obj/item/ammo_casing/energy/shot = ammo_type[select]
	switch(modifystate)
		if (0)
			if(ratio > 100)
				icon_state = "[initial(icon_state)]100"
			else
				icon_state = "[initial(icon_state)][ratio]"
		if (1)
			if(ratio > 100)
				icon_state = "[initial(icon_state)][shot.mod_name]100"
			else
				icon_state = "[initial(icon_state)][shot.mod_name][ratio]"
		if (2)
			if(ratio > 100)
				icon_state = "[initial(icon_state)][shot.select_name]100"
			else
				icon_state = "[initial(icon_state)][shot.select_name][ratio]"
	return