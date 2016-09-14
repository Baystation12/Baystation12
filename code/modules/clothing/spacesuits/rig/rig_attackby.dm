/obj/item/weapon/rig/attackby(obj/item/W as obj, mob/user as mob)

	if(!istype(user,/mob/living)) return 0

	if(electrified != 0)
		if(shock(user)) //Handles removing charge from the cell, as well. No need to do that here.
			return

	// Pass repair items on to the chestpiece.
	if(chest && (istype(W,/obj/item/stack/material) || istype(W, /obj/item/weapon/weldingtool)))
		return chest.attackby(W,user)

	// Lock or unlock the access panel.
	if(W.GetIdCard())
		if(subverted)
			locked = 0
			user << "<span class='danger'>It looks like the locking system has been shorted out.</span>"
			return

		if((!req_access || !req_access.len) && (!req_one_access || !req_one_access.len))
			locked = 0
			user << "<span class='danger'>\The [src] doesn't seem to have a locking mechanism.</span>"
			return

		if(security_check_enabled && !src.allowed(user))
			user << "<span class='danger'>Access denied.</span>"
			return

		locked = !locked
		user << "You [locked ? "lock" : "unlock"] \the [src] access panel."
		return

	else if(istype(W,/obj/item/weapon/crowbar))

		if(!open && locked)
			user << "The access panel is locked shut."
			return

		open = !open
		user << "You [open ? "open" : "close"] the access panel."
		return

	if(open)

		// Hacking.
		if(istype(W,/obj/item/weapon/wirecutters) || istype(W,/obj/item/device/multitool))
			if(open)
				wires.Interact(user)
			else
				user << "You can't reach the wiring."
			return
		// Air tank.
		if(istype(W,/obj/item/weapon/tank)) //Todo, some kind of check for suits without integrated air supplies.

			if(air_supply)
				user << "\The [src] already has a tank installed."
				return

			if(!user.unEquip(W)) return
			air_supply = W
			W.forceMove(src)
			user << "You slot [W] into [src] and tighten the connecting valve."
			return

		// Check if this is a hardsuit upgrade or a modification.
		else if(istype(W,/obj/item/rig_module))

			if(istype(src.loc,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = src.loc
				if(H.back == src)
					user << "<span class='danger'>You can't install a hardsuit module while the suit is being worn.</span>"
					return 1

			if(!installed_modules) installed_modules = list()
			if(installed_modules.len)
				for(var/obj/item/rig_module/installed_mod in installed_modules)
					if(!installed_mod.redundant && istype(installed_mod,W))
						user << "The hardsuit already has a module of that class installed."
						return 1

			var/obj/item/rig_module/mod = W
			user << "You begin installing \the [mod] into \the [src]."
			if(!do_after(user,40,src))
				return
			if(!user || !W)
				return
			if(!user.unEquip(mod)) return
			user << "You install \the [mod] into \the [src]."
			installed_modules |= mod
			mod.forceMove(src)
			mod.installed(src)
			update_icon()
			return 1

		else if(!cell && istype(W,/obj/item/weapon/cell))

			if(!user.unEquip(W)) return
			user << "You jack \the [W] into \the [src]'s battery mount."
			W.forceMove(src)
			src.cell = W
			return

		else if(istype(W,/obj/item/weapon/wrench))

			if(!air_supply)
				user << "There is not tank to remove."
				return

			if(user.r_hand && user.l_hand)
				air_supply.forceMove(get_turf(user))
			else
				user.put_in_hands(air_supply)
			user << "You detach and remove \the [air_supply]."
			air_supply = null
			return

		else if(istype(W,/obj/item/weapon/screwdriver))

			var/list/current_mounts = list()
			if(cell) current_mounts   += "cell"
			if(installed_modules && installed_modules.len) current_mounts += "system module"

			var/to_remove = input("Which would you like to modify?") as null|anything in current_mounts
			if(!to_remove)
				return

			if(istype(src.loc,/mob/living/carbon/human) && to_remove != "cell")
				var/mob/living/carbon/human/H = src.loc
				if(H.back == src)
					user << "You can't remove an installed device while the hardsuit is being worn."
					return

			switch(to_remove)

				if("cell")

					if(cell)
						user << "You detatch \the [cell] from \the [src]'s battery mount."
						for(var/obj/item/rig_module/module in installed_modules)
							module.deactivate()
						if(user.r_hand && user.l_hand)
							cell.forceMove(get_turf(user))
						else
							cell.forceMove(user.put_in_hands(cell))
						cell = null
					else
						user << "There is nothing loaded in that mount."

				if("system module")

					var/list/possible_removals = list()
					for(var/obj/item/rig_module/module in installed_modules)
						if(module.permanent)
							continue
						possible_removals[module.name] = module

					if(!possible_removals.len)
						user << "There are no installed modules to remove."
						return

					var/removal_choice = input("Which module would you like to remove?") as null|anything in possible_removals
					if(!removal_choice)
						return

					var/obj/item/rig_module/removed = possible_removals[removal_choice]
					user << "You detatch \the [removed] from \the [src]."
					removed.forceMove(get_turf(src))
					removed.removed()
					installed_modules -= removed
					update_icon()

		return

	// If we've gotten this far, all we have left to do before we pass off to root procs
	// is check if any of the loaded modules want to use the item we've been given.
	for(var/obj/item/rig_module/module in installed_modules)
		if(module.accepts_item(W,user)) //Item is handled in this proc
			return
	..()


/obj/item/weapon/rig/attack_hand(var/mob/user)

	if(electrified != 0)
		if(shock(user)) //Handles removing charge from the cell, as well. No need to do that here.
			return
	..()

/obj/item/weapon/rig/emag_act(var/remaining_charges, var/mob/user)
	if(!subverted)
		req_access.Cut()
		req_one_access.Cut()
		locked = 0
		subverted = 1
		user << "<span class='danger'>You short out the access protocol for the suit.</span>"
		return 1
