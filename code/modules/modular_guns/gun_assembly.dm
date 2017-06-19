/obj/item/gun_assembly //temp for testing.
	name = "gun assembly"
	desc = "It's a firearm in progress. When finished, it will make small pieces of stuff go very fast."
	icon_state = "blank"
	item_state = "gun"
	appearance_flags = KEEP_TOGETHER

	// Tracking helpers for objects to update from and to pass to finished gun.
	// See gun_composite.dm for what the objects are actually used for.
	var/obj/item/gun_component/barrel/barrel
	var/obj/item/gun_component/body/body
	var/obj/item/gun_component/grip/grip
	var/obj/item/gun_component/stock/stock
	var/obj/item/gun_component/chamber/chamber
	var/list/accessories = list()

/obj/item/gun_assembly/Destroy()
	barrel = null
	body = null
	grip = null
	stock = null
	chamber = null
	accessories.Cut()
	for(var/obj/item/thing in contents)
		qdel(thing)
	return ..()

/obj/item/gun_assembly/proc/update_components()
	barrel =  locate(/obj/item/gun_component/barrel)  in contents
	body =    locate(/obj/item/gun_component/body)    in contents
	grip =    locate(/obj/item/gun_component/grip)    in contents
	stock =   locate(/obj/item/gun_component/stock)   in contents
	chamber = locate(/obj/item/gun_component/chamber) in contents
	accessories.Cut()
	for(var/obj/item/gun_component/accessory/acc in contents)
		accessories += acc
	for(var/obj/item/gun_component/GC in list(body,barrel,stock,grip,chamber)+accessories)
		GC.holder = src
	update_icon()

/obj/item/gun_assembly/attack_self(var/mob/user)
	remove_component(user)

/obj/item/gun_assembly/AltClick(var/mob/user)
	remove_component(user)

/obj/item/gun_assembly/MouseDrop(var/atom/movable/over_atom,)
	if(over_atom == usr)
		remove_component(usr)
		return
	..()

/obj/item/gun_assembly/proc/remove_component(var/mob/user)

	if(!do_after(user, 20))
		return

	var/obj/item/gun_component/removed
	if(barrel)
		removed = barrel
		barrel = null
	else if(chamber)
		removed = chamber
		chamber = null
	else if(stock)
		removed = stock
		stock = null
	else if(grip)
		removed = grip
		grip = null
	else if(body)
		removed = body
		body = null

	var/list/all_removed = list()
	if(removed)
		all_removed += removed
		w_class = min(1,w_class - removed.weight_mod)
		removed.forceMove(get_turf(src))
		user.put_in_hands(removed)
		for(var/obj/item/gun_component/accessory/acc in accessories)
			if(acc.installs_into == removed.component_type)
				accessories -= acc
				acc.forceMove(get_turf(src))
				user.put_in_hands(acc)
				all_removed += acc
		user << "<span class='notice'>You remove [english_list(all_removed)] from \the [src].</span>"

	// Dismantle the entire thing.
	if((contents.len - accessories.len)<=1)
		user << "<span class='notice'>You have dismantled the gun assembly.</span>"
		for(var/obj/item/I in contents)
			I.forceMove(get_turf(src))
		var/mob/M = loc
		if(istype(M))
			M.unEquip(src)
		qdel(src)
		return
	update_icon()

/obj/item/gun_assembly/attackby(var/obj/item/thing, var/mob/user)

	if(istype(thing, /obj/item/gun_component))
		var/obj/item/gun_component/GC = thing
		var/installed
		if(GC.component_type == COMPONENT_BARREL && !barrel)
			barrel = GC
			installed = 1
		else if(GC.component_type == COMPONENT_BODY && !body)
			body = GC
			installed = 1
		else if(GC.component_type == COMPONENT_STOCK && !stock)
			stock = GC
			installed = 1
		else if(GC.component_type == COMPONENT_GRIP && !grip)
			grip = GC
			installed = 1
		else if(GC.component_type == COMPONENT_MECHANISM && !chamber)
			chamber = GC
			installed = 1
		else if(GC.component_type == COMPONENT_ACCESSORY)

			var/obj/item/gun_component/accessory/accessory = GC

			// Check if we already have an accessory on that component.
			for(var/obj/item/gun_component/accessory/temp_acc in accessories)
				if(accessory.installs_into == temp_acc.installs_into)
					user << "<span class='warning'>\The [src] already has an accessory installed in that area.</span>"
					return

			// Check if we have a component fit for that accessory.
			var/acceptable
			for(var/obj/item/gun_component/temp_comp in list(barrel, body, grip, stock, chamber))
				if(istype(temp_comp) && temp_comp.accepts_accessories && accessory.installs_into == temp_comp.component_type)
					acceptable = 1
					break

			// Did we fail?
			if(!acceptable)
				user << "<span class='warning'>\The [src] cannot have \the [thing] installed.</span>"
				return

			// Success!
			accessories += accessory
			installed = 1

		else
			user << "<span class='warning'>\The [src] already has \a [GC.component_type].</span>"
			return

		if(installed)
			user << "<span class='notice'>You install \the [thing] into \the [src].</span>"
			w_class = w_class + GC.weight_mod
			user.unEquip(thing)
			thing.forceMove(src)
			update_icon()

		if(barrel && body && grip && chamber)
			var/mob/M = src.loc
			user.unEquip(src)
			var/obj/item/weapon/gun/composite/new_gun = new(get_turf(src), src)
			if(istype(M))
				user.put_in_hands(new_gun)
			user << "<span class='notice'>You have assembled \the [new_gun].</span>"
		return

	return ..()

/obj/item/gun_assembly/update_icon()

	icon_state = "blank"

	if(body)
		item_state = body.item_state

	var/gun_type
	var/dam_type

	var/list/overlays_to_add = list()
	var/decl/weapon_model/model // If all the parts are from the same producer, we get a bonus.
	for(var/obj/item/gun_component/GC in list(body, barrel, grip, stock, chamber))
		if (!GC) continue
		if(!gun_type) gun_type = GC.weapon_type
		if(!dam_type) dam_type = GC.projectile_type
		overlays_to_add += GC
		if(GC.model)
			if(isnull(model))
				model = GC.model
			else if(model != GC.model)
				model = 0
		else if(model)
			model = 0

	if(!gun_type)
		gun_type = GUN_PISTOL //derp

	for(var/obj/item/gun_component/accessory/GC in accessories)

		GC.installed_dam_type = dam_type
		GC.installed_gun_type = gun_type
		GC.update_icon()
		overlays_to_add += GC

	if(model)
		if(model.force_gun_name)
			name = "\improper [model.force_gun_name] assembly"
		else
			name = "\improper [model.produced_by.manufacturer_short] [get_gun_name(src)] assembly"
		desc = "The casing is stamped with '[model.model_name]'. [initial(desc)] It's marked with the [model.produced_by.manufacturer_name] logo."
	else
		name = "[get_gun_name(src, dam_type, gun_type)] assembly"
		desc = "[initial(desc)] You can't work out who manufactured this one; it might be an aftermarket job."

	overlays = overlays_to_add

/obj/item/gun_assembly/examine()
	..()
	if(usr && usr.Adjacent(get_turf(src)))
		for(var/obj/item/gun_component/GC in list(barrel, body, grip, stock, chamber))
			if(!istype(GC))
				usr << "\The [initial(GC.component_type)] is missing."
			else
				usr << "\The [GC.component_type] [GC.model ? "was manufactured by [GC.model.produced_by.manufacturer_name]" : "is unremarkable"]."
		if(accessories.len)
			usr << "It has [english_list(accessories)] installed."