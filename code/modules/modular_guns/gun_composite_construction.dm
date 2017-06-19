var/list/can_dismantle_guns = list(
	/obj/item/weapon/screwdriver,
	/obj/item/weapon/pen,
	/obj/item/weapon/material/kitchen/utensil
	)

/obj/item/weapon/gun/composite/proc/dismantle(var/mob/user)

	var/obj/item/gun_assembly/assembly = new(get_turf(src))

	for(var/obj/item/I in contents)
		I.forceMove(get_turf(src))

	assembly.barrel = barrel
	assembly.body = body
	assembly.grip = grip
	assembly.stock = stock
	assembly.chamber = chamber
	assembly.accessories = accessories.Copy()

	for(var/obj/item/gun_component/I in list(barrel,body,grip,stock,chamber)+accessories)
		I.empty()
		I.forceMove(assembly)

	assembly.update_components()

	if(user && src.loc == user)
		user.drop_from_inventory(src)
		user.put_in_hands(assembly)

	qdel(src)

/obj/item/weapon/gun/composite/attackby(var/obj/item/thing, var/mob/user)

	if(istype(thing, /obj/item/ammo_casing) || istype(thing, /obj/item/ammo_magazine) || istype(thing, /obj/item/weapon/cell))
		chamber.load_ammo(thing, user)
		return

	else if(istype(thing, /obj/item/gun_component/accessory))

		// Check if we already have an accessory on that component.
		var/obj/item/gun_component/accessory/installing = thing
		for(var/obj/item/gun_component/accessory/temp_acc in accessories)
			if(temp_acc.installs_into == installing.installs_into)
				user << "<span class='warning'>\The [src] already has an accessory installed in that area.</span>"
				return

		// Check if we have a component fit for that accessory.
		var/acceptable
		for(var/obj/item/gun_component/temp_comp in list(barrel, body, grip, stock, chamber))
			if(istype(temp_comp) && temp_comp.accepts_accessories && installing.installs_into == temp_comp.component_type)
				acceptable = 1
				break

		// Did we fail?
		if(!acceptable)
			user << "<span class='warning'>\The [src] cannot have \the [thing] installed.</span>"
			return

		// Success!
		user.unEquip(installing)
		installing.installed(src, user)
		accessories |= installing
		update_from_components()
		return
	else

		var/can_strip
		if(!(thing.sharp || thing.edge))
			for(var/checkpath in can_dismantle_guns)
				if(istype(thing, checkpath))
					can_strip = 1
					break
		else
			can_strip = 1

		if(can_strip)

			if(accessories.len)
				var/obj/item/gun_component/accessory/removing = pick(accessories)
				removing.removed_from(src, user)
				accessories -= removing
				update_from_components()
				return

			user.visible_message("<span class='notice'>\The [user] begins field-stripping \the [src] with \the [thing].</span>")

			if(!do_after(user, 50)) // No doing it in the middle of combat.
				return
			if(!(user.l_hand == thing || user.r_hand == thing))
				return
			if(user.incapacitated() || user.restrained() || !user.Adjacent(src))
				return

			usr << "<span class='noticed'>\The [user] has field-stripped \the [src].</span>"
			dismantle(user)
			return

	return ..()