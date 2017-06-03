/obj/item/gun_component/chamber/laser
	projectile_type = GUN_TYPE_LASER
	var/can_remove_cell
	var/charge_cost = 200
	var/self_recharge_time // Default is 4; null or 0 means the gun does not recharge itself without a charger.
	var/self_recharge_tick = 0
	var/cell_type
	var/obj/item/weapon/cell/power_supply

/obj/item/gun_component/chamber/laser/update_ammo_overlay()
	if(ammo_indicator_state)
		if(!power_supply)
			if(!ammo_overlay)
				if(model)
					ammo_overlay = image(icon = model.ammo_indicator_icon)
				else
					ammo_overlay = image(icon = 'icons/obj/gun_components/unbranded_load_overlays.dmi')
			ammo_overlay.icon_state = null
			return
		..()

/obj/item/gun_component/chamber/laser/Destroy()
	if(power_supply)
		qdel(power_supply)
		power_supply = null
	return ..()

/obj/item/gun_component/chamber/laser/empty()
	if(power_supply && can_remove_cell)
		power_supply.forceMove(get_turf(src))
		power_supply = null

/obj/item/gun_component/chamber/laser/reset_max_shots()
	..()
	charge_cost = initial(charge_cost)

/obj/item/gun_component/chamber/laser/apply_shot_mod(var/val)
	..()
	charge_cost = round(charge_cost*val)

/obj/item/gun_component/chamber/laser/unload_ammo(var/mob/user)
	if(!can_remove_cell)
		user << "<span class='warning'>\The cell cannot be removed from \the [holder].</span>"
		return 0

	if(!power_supply)
		user << "<span class='warning'>\The [holder] does not have a cell.</span>"
		return 0
	user << "<span class='notice'>You remove \the [power_supply] from \the [holder].</span>"
	power_supply.forceMove(get_turf(src))
	user.put_in_hands(power_supply)
	power_supply = null
	update_ammo_overlay()
	return 1

/obj/item/gun_component/chamber/laser/load_ammo(var/obj/item/thing, var/mob/user)
	if(!istype(thing, /obj/item/weapon/cell))
		return
	if(power_supply)
		user << "<span class='warning'>\The [holder] already has a cell.</span>"
		return
	user.visible_message("<span class='danger'>\The [user] jacks \the [thing] into \the [holder].</span>")
	power_supply = thing
	user.unEquip(thing)
	thing.forceMove(src)
	update_ammo_overlay()
	return 1

/obj/item/gun_component/chamber/laser/New(var/newloc, var/weapontype, var/componenttype, var/use_model)
	..(newloc, weapontype, componenttype, use_model)
	if(cell_type)
		power_supply = new cell_type(src)
	else
		power_supply = new /obj/item/weapon/cell/device/variable(src, max_shots*charge_cost)
	if(self_recharge_time)
		processing_objects.Add(src)
	update_icon()

/obj/item/gun_component/chamber/laser/Destroy()
	if(!self_recharge_time)
		processing_objects.Remove(src)
	return ..()

/obj/item/gun_component/chamber/laser/process()

	// Are we ready to charge.
	self_recharge_tick++
	if(self_recharge_tick < self_recharge_time)
		return 0
	self_recharge_tick = 0

	if(!power_supply || power_supply.charge >= power_supply.maxcharge)
		return 0 // check if we actually need to recharge

	power_supply.give(charge_cost) //... to recharge the shot
	update_ammo_overlay()
	return 1

/obj/item/gun_component/chamber/laser/get_shots_remaining()
	return round(power_supply ? (power_supply.charge / charge_cost) : 0)

/obj/item/gun_component/chamber/laser/consume_next_projectile()

	if(holder.installed_in_turret)
		var/obj/machinery/porta_turret/turret = loc.loc
		if(turret.stat & (BROKEN|NOPOWER))
			return null
		turret.use_power(charge_cost)
	else
		if(!power_supply || !power_supply.checked_use(charge_cost))
			return null

	var/projtype
	if(holder && holder.barrel)
		projtype = holder.barrel.get_projectile_type()
	if(projtype)
		return new projtype(src)
	return null

/obj/item/gun_component/chamber/laser/get_external_power_supply()
	if(istype(src.loc, /obj/item/rig_module))
		var/obj/item/rig_module/module = src.loc
		if(module.holder && module.holder.wearer)
			var/mob/living/carbon/human/H = module.holder.wearer
			if(istype(H) && H.back)
				var/obj/item/weapon/rig/suit = H.back
				if(istype(suit))
					return suit.cell
	return null

// Predefined firing mechanisms.
/obj/item/gun_component/chamber/laser/pistol
	icon_state="las_pistol"
	weapon_type = GUN_PISTOL
	charge_cost = 100
	max_shots = 10
	fire_delay = 5
	ammo_indicator_state = "laser_pistol_loaded"

/obj/item/gun_component/chamber/laser/rifle
	icon_state="las_rifle"
	name = "precision lens"
	weapon_type = GUN_RIFLE
	charge_cost = 400
	max_shots = 4
	fire_delay = 35
	ammo_indicator_state = "laser_rifle_loaded"
	accuracy_mod = 1

/obj/item/gun_component/chamber/laser/cannon
	icon_state="las_cannon"
	name = "three-phase industrial lens"
	weapon_type = GUN_CANNON
	charge_cost = 400
	max_shots = 5
	fire_delay = 20
	ammo_indicator_state = "laser_cannon_loaded"

/obj/item/gun_component/chamber/laser/assault
	icon_state="las_assault"
	name = "multiphase lens"
	weapon_type = GUN_ASSAULT
	charge_cost = 200
	max_shots = 30
	fire_delay = 2
	ammo_indicator_state = "laser_assault_loaded"
	self_recharge_time = 4
