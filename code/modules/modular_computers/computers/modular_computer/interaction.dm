/obj/item/modular_computer/proc/update_verbs()
	if(portable_drive)
		verbs |= /obj/item/modular_computer/proc/eject_usb
	else
		verbs -= /obj/item/modular_computer/proc/eject_usb

	if(stores_pen && istype(stored_pen))
		verbs |= /obj/item/modular_computer/proc/remove_pen_verb
	else
		verbs -= /obj/item/modular_computer/proc/remove_pen_verb

	if(card_slot)
		verbs |= /obj/item/stock_parts/computer/card_slot/proc/verb_eject_id
	else
		verbs -= /obj/item/stock_parts/computer/card_slot/proc/verb_eject_id

// Forcibly shut down the device. To be used when something bugs out and the UI is nonfunctional.
/obj/item/modular_computer/verb/emergency_shutdown()
	set name = "Forced Shutdown"
	set category = "Object"
	set src in view(1)

	if(usr.incapacitated() || !istype(usr, /mob/living))
		to_chat(usr, "<span class='warning'>You can't do that.</span>")
		return

	if(!Adjacent(usr))
		to_chat(usr, "<span class='warning'>You can't reach it.</span>")
		return

	if(enabled)
		bsod = 1
		update_icon()
		to_chat(usr, "You press a hard-reset button on \the [src]. It displays a brief debug screen before shutting down.")
		shutdown_computer(FALSE)
		spawn(2 SECONDS)
			bsod = 0
			update_icon()


// Eject ID card from computer, if it has ID slot with card inside.
/obj/item/modular_computer/proc/eject_usb()
	set name = "Eject Portable Storage"
	set category = "Object"
	set src in view(1)

	if(!CanPhysicallyInteract(usr))
		return

	if(!Adjacent(usr))
		to_chat(usr, "<span class='warning'>You can't reach it.</span>")
		return

	proc_eject_usb(usr)
	update_verbs()

/obj/item/modular_computer/proc/remove_pen_verb()
	set name = "Remove Pen"
	set category = "Object"
	set src in view(1)

	remove_pen(usr)

/obj/item/modular_computer/proc/remove_pen(mob/user)

	if(user.incapacitated() || !istype(user, /mob/living))
		to_chat(user, "<span class='warning'>You can't do that.</span>")
		return

	if(!Adjacent(user))
		to_chat(user, "<span class='warning'>You can't reach it.</span>")
		return

	if(istype(stored_pen))
		to_chat(user, "<span class='notice'>You remove [stored_pen] from [src].</span>")
		user.put_in_hands(stored_pen) // Silicons will drop it anyway.
		stored_pen = null
		update_verbs()

/obj/item/modular_computer/proc/proc_eject_usb(mob/user)
	if(!user)
		user = usr

	if(!portable_drive)
		to_chat(user, "There is no portable device connected to \the [src].")
		return

	uninstall_component(user, portable_drive)

/obj/item/modular_computer/attack_ghost(var/mob/observer/ghost/user)
	if(enabled)
		ui_interact(user)
	else if(check_rights(R_ADMIN, 0, user))
		var/response = alert(user, "This computer is turned off. Would you like to turn it on?", "Admin Override", "Yes", "No")
		if(response == "Yes")
			turn_on(user)

/obj/item/modular_computer/attack_ai(var/mob/user)
	return attack_self(user)

/obj/item/modular_computer/attack_hand(var/mob/user)
	if(anchored)
		return attack_self(user)
	return ..()

// On-click handling. Turns on the computer if it's off and opens the GUI.
/obj/item/modular_computer/attack_self(var/mob/user)
	if(MUTATION_CLUMSY in user.mutations)
		to_chat(user, SPAN_WARNING("You can't quite work out how to use [src]."))
		return
	if(enabled && screen_on)
		ui_interact(user)
	else if(!enabled && screen_on)
		turn_on(user)

/obj/item/modular_computer/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if(istype(W, /obj/item/card/id)) // ID Card, try to insert it.
		var/obj/item/card/id/I = W
		if(!card_slot)
			to_chat(user, "You try to insert [I] into [src], but it does not have an ID card slot installed.")
			return

		if(card_slot.insert_id(I, user))
			update_verbs()
		return

	if(istype(W, /obj/item/pen) && stores_pen)
		if(istype(stored_pen))
			to_chat(user, "<span class='notice'>There is already a pen in [src].</span>")
			return
		if(!user.unEquip(W, src))
			return
		stored_pen = W
		update_verbs()
		to_chat(user, "<span class='notice'>You insert [W] into [src].</span>")
		return
	if(istype(W, /obj/item/paper))
		var/obj/item/paper/paper = W
		if(scanner && paper.info)
			scanner.do_on_attackby(user, W)
			return
	if(istype(W, /obj/item/paper) || istype(W, /obj/item/paper_bundle))
		if(nano_printer)
			nano_printer.attackby(W, user)
	if(istype(W, /obj/item/aicard))
		if(!ai_slot)
			return
		ai_slot.attackby(W, user)

	if(!modifiable)
		return ..()

	if(istype(W, /obj/item/stock_parts/computer))
		var/obj/item/stock_parts/computer/C = W
		if(C.hardware_size <= max_hardware_size)
			try_install_component(user, C)
		else
			to_chat(user, "This component is too large for \the [src].")
	if(isWrench(W))
		var/list/components = get_all_components()
		if(components.len)
			to_chat(user, "Remove all components from \the [src] before disassembling it.")
			return
		new /obj/item/stack/material/steel( get_turf(src.loc), steel_sheet_cost )
		src.visible_message("\The [src] has been disassembled by [user].")
		qdel(src)
		return
	if(isWelder(W))
		var/obj/item/weldingtool/WT = W
		if(!WT.isOn())
			to_chat(user, "\The [W] is off.")
			return

		if(!damage)
			to_chat(user, "\The [src] does not require repairs.")
			return

		to_chat(user, "You begin repairing damage to \the [src]...")
		if(WT.remove_fuel(round(damage/75)) && do_after(usr, damage/10, src, DO_PUBLIC_UNIQUE))
			damage = 0
			to_chat(user, "You repair \the [src].")
		return

	if(isScrewdriver(W))
		var/list/all_components = get_all_components()
		if(!all_components.len)
			to_chat(user, "This device doesn't have any components installed.")
			return
		var/list/component_names = list()
		for(var/obj/item/stock_parts/computer/H in all_components)
			component_names.Add(H.name)

		var/choice = input(usr, "Which component do you want to uninstall?", "Computer maintenance", null) as null|anything in component_names

		if(!choice)
			return

		if(!Adjacent(usr))
			return

		var/obj/item/stock_parts/computer/H = find_hardware_by_name(choice)

		if(!H)
			return

		uninstall_component(user, H)

		return

	..()

/obj/item/modular_computer/examine(mob/user)
	. = ..()

	if(enabled)
		to_chat(user, "The time [stationtime2text()] is displayed in the corner of the screen.")

	if(card_slot && card_slot.stored_card)
		to_chat(user, "[card_slot.stored_card] is inserted into it.")

/obj/item/modular_computer/MouseDrop(var/atom/over_object)
	var/mob/M = usr
	if(!istype(over_object, /obj/screen) && CanMouseDrop(M))
		return attack_self(M)

/obj/item/modular_computer/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(scanner)
		scanner.do_on_afterattack(user, target, proximity)

/obj/item/modular_computer/CtrlAltClick(mob/user)
	if(!CanPhysicallyInteract(user))
		return 0
	var/datum/extension/interactive/ntos/os = get_extension(src, /datum/extension/interactive/ntos)
	if(os)
		os.open_terminal(user)
		return 1

/obj/item/modular_computer/CouldUseTopic(var/mob/user)
	..()
	if(LAZYLEN(interact_sounds) && CanPhysicallyInteract(user))
		playsound(src, pick(interact_sounds), interact_sound_volume)
