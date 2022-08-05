/obj/item/rig/attackby(obj/item/W as obj, mob/user as mob)

	if(!istype(user,/mob/living)) return 0

	if(electrified != 0)
		if(shock(user)) //Handles removing charge from the cell, as well. No need to do that here.
			return

	// Pass repair items on to the chestpiece.
	if(chest && (istype(W,/obj/item/stack/material) || isWelder(W)))
		return chest.attackby(W,user)

	// Lock or unlock the access panel.
	if(W.GetIdCard())
		if(subverted)
			locked = 0
			to_chat(user, "<span class='danger'>It looks like the locking system has been shorted out.</span>")
			return

		if(!length(req_access))
			locked = 0
			to_chat(user, "<span class='danger'>\The [src] doesn't seem to have a locking mechanism.</span>")
			return

		if(security_check_enabled && !src.allowed(user))
			to_chat(user, "<span class='danger'>Access denied.</span>")
			return

		locked = !locked
		to_chat(user, "You [locked ? "lock" : "unlock"] \the [src] access panel.")
		return

	else if(isCrowbar(W))

		if(!open && locked)
			to_chat(user, "The access panel is locked shut.")
			return

		open = !open
		to_chat(user, "You [open ? "open" : "close"] the access panel.")
		return

	else if(isScrewdriver(W))
		p_open = !p_open
		to_chat(user, "You [p_open ? "open" : "close"] the wire cover.")

	// Hacking.
	else if(isWirecutter(W) || isMultitool(W))
		if(p_open)
			wires.Interact(user)
		else
			to_chat(user, "You can't reach the wiring.")
		return

	if(open)


		// Air tank.
		if(istype(W,/obj/item/tank)) //Todo, some kind of check for suits without integrated air supplies.

			if(air_supply)
				to_chat(user, "\The [src] already has a tank installed.")
				return
			if (istype(W, /obj/item/tank/scrubber))
				to_chat(user, SPAN_WARNING("\The [W] is far too large to attach to \the [src]."))
				return

			if(!user.unEquip(W)) return
			air_supply = W
			W.forceMove(src)
			to_chat(user, "You slot [W] into [src] and tighten the connecting valve.")
			return

		// Check if this is a hardsuit upgrade or a modification.
		else if(istype(W,/obj/item/rig_module))

			if(istype(src.loc,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = src.loc
				if(H.back == src)
					to_chat(user, "<span class='danger'>You can't install a hardsuit module while the suit is being worn.</span>")
					return 1

			if(is_type_in_list(W,banned_modules))
				to_chat(user, SPAN_DANGER("\The [src] cannot mount this type of module."))
				return 1

			var/obj/item/rig_module/mod = W

			if(!installed_modules) installed_modules = list()
			if(installed_modules.len)
				for(var/obj/item/rig_module/installed_mod in installed_modules)
					if(is_type_in_list(installed_mod,mod.banned_modules))
						to_chat(user, SPAN_DANGER("\The [installed_mod] is incompatible with this module."))
						return 1
					if(installed_mod.banned_modules.len)
						if(is_type_in_list(W,installed_mod.banned_modules))
							to_chat(user, SPAN_DANGER("\The [installed_mod] is incompatible with this module."))
							return 1
					if(!installed_mod.redundant && installed_mod.type == W.type)
						to_chat(user, "The hardsuit already has a module of that class installed.")
						return 1

			to_chat(user, "You begin installing \the [mod] into \the [src].")
			if(!do_after(user, 4 SECONDS, src, DO_PUBLIC_UNIQUE))
				return
			if(!user || !W)
				return
			if(!user.unEquip(mod)) return
			to_chat(user, "You install \the [mod] into \the [src].")
			installed_modules |= mod
			mod.forceMove(src)
			mod.installed(src)
			update_icon()
			return 1

		else if(!cell && istype(W,/obj/item/cell))

			if(!user.unEquip(W)) return
			to_chat(user, "You jack \the [W] into \the [src]'s battery mount.")
			W.forceMove(src)
			src.cell = W
			return

		else if(isWrench(W))

			var/list/current_mounts = list()
			if(cell) current_mounts   += "cell"
			if(air_supply) current_mounts += "tank"
			if(installed_modules && installed_modules.len) current_mounts += "system module"

			var/to_remove = input("Which would you like to modify?") as null|anything in current_mounts
			if(!to_remove)
				return

			if(istype(src.loc,/mob/living/carbon/human) && to_remove != "cell" && to_remove != "tank")
				var/mob/living/carbon/human/H = src.loc
				if(H.back == src)
					to_chat(user, "You can't remove an installed device while the hardsuit is being worn.")
					return

			switch(to_remove)

				if("cell")

					if(cell)
						to_chat(user, "You detach \the [cell] from \the [src]'s battery mount.")
						for(var/obj/item/rig_module/module in installed_modules)
							module.deactivate()
						user.put_in_hands(cell)
						cell = null
					else
						to_chat(user, "There is nothing loaded in that mount.")

				if("tank")
					if(!air_supply)
						to_chat(user, "There is no tank to remove.")
						return

					user.put_in_hands(air_supply)
					to_chat(user, "You detach and remove \the [air_supply].")
					air_supply = null

				if("system module")

					var/list/possible_removals = list()
					for(var/obj/item/rig_module/module in installed_modules)
						if(module.permanent)
							continue
						possible_removals[module.name] = module

					if(!possible_removals.len)
						to_chat(user, "There are no installed modules to remove.")
						return

					var/removal_choice = input("Which module would you like to remove?") as null|anything in possible_removals
					if(!removal_choice)
						return

					var/obj/item/rig_module/removed = possible_removals[removal_choice]
					to_chat(user, "You detach \the [removed] from \the [src].")
					removed.dropInto(loc)
					removed.removed()
					installed_modules -= removed
					update_icon()

		else if(istype(W,/obj/item/stack/nanopaste)) //EMP repair
			var/obj/item/stack/S = W
			if(malfunctioning || malfunction_delay)
				if(S.use(1))
					to_chat(user, "You pour some of \the [S] over \the [src]'s control circuitry and watch as the nanites do their work with impressive speed and precision.")
					malfunctioning = 0
					malfunction_delay = 0
				else
					to_chat(user, "\The [S] is empty!")
			else
				to_chat(user, "You don't see any use for \the [S].")

		return

	// If we've gotten this far, all we have left to do before we pass off to root procs
	// is check if any of the loaded modules want to use the item we've been given.
	for(var/obj/item/rig_module/module in installed_modules)
		if(module.accepts_item(W,user)) //Item is handled in this proc
			return
	..()


/obj/item/rig/attack_hand(var/mob/user)

	if(electrified != 0)
		if(shock(user)) //Handles removing charge from the cell, as well. No need to do that here.
			return
	..()

/obj/item/rig/emag_act(var/remaining_charges, var/mob/user)
	if(!subverted)
		req_access.Cut()
		locked = 0
		subverted = 1
		to_chat(user, "<span class='danger'>You short out the access protocol for the suit.</span>")
		return 1
