/obj/item/modular_computer/proc/update_verbs()
	verbs.Cut()
	if(ai_slot)
		verbs |= new/obj/item/modular_computer/verb/eject_ai()
	if(portable_drive)
		verbs |= new/obj/item/modular_computer/verb/eject_usb()
	if(card_slot)
		verbs |= new/obj/item/modular_computer/verb/eject_id()

// Eject ID card from computer, if it has ID slot with card inside.
/obj/item/modular_computer/verb/eject_id()
	set name = "Eject ID"
	set category = "Object"
	set src in view(1)

	if(usr.incapacitated() || !istype(usr, /mob/living))
		to_chat(usr, "<span class='warning'>You can't do that.</span>")
		return

	if(!Adjacent(usr))
		to_chat(usr, "<span class='warning'>You can't reach it.</span>")
		return

	proc_eject_id(usr)

// Eject ID card from computer, if it has ID slot with card inside.
/obj/item/modular_computer/verb/eject_usb()
	set name = "Eject Portable Storage"
	set category = "Object"
	set src in view(1)

	if(usr.incapacitated() || !istype(usr, /mob/living))
		to_chat(usr, "<span class='warning'>You can't do that.</span>")
		return

	if(!Adjacent(usr))
		to_chat(usr, "<span class='warning'>You can't reach it.</span>")
		return

	proc_eject_usb(usr)

/obj/item/modular_computer/verb/eject_ai()
	set name = "Eject AI"
	set category = "Object"
	set src in view(1)

	if(usr.incapacitated() || !istype(usr, /mob/living))
		to_chat(usr, "<span class='warning'>You can't do that.</span>")
		return

	if(!Adjacent(usr))
		to_chat(usr, "<span class='warning'>You can't reach it.</span>")
		return

	proc_eject_ai(usr)

/obj/item/modular_computer/proc/proc_eject_id(mob/user)
	if(!user)
		user = usr

	if(!card_slot)
		to_chat(user, "\The [src] does not have an ID card slot")
		return

	if(!card_slot.stored_card)
		to_chat(user, "There is no card in \the [src]")
		return

	if(active_program)
		active_program.event_idremoved(0)

	for(var/datum/computer_file/program/P in idle_threads)
		P.event_idremoved(1)

	card_slot.stored_card.forceMove(get_turf(src))
	card_slot.stored_card = null
	update_uis()
	to_chat(user, "You remove the card from \the [src]")


/obj/item/modular_computer/proc/proc_eject_usb(mob/user)
	if(!user)
		user = usr

	if(!portable_drive)
		to_chat(user, "There is no portable device connected to \the [src].")
		return

	uninstall_component(user, portable_drive)
	update_uis()

/obj/item/modular_computer/proc/proc_eject_ai(mob/user)
	if(!user)
		user = usr

	if(!ai_slot || !ai_slot.stored_card)
		to_chat(user, "There is no intellicard connected to \the [src].")
		return

	ai_slot.stored_card.forceMove(get_turf(src))
	ai_slot.stored_card = null
	ai_slot.update_power_usage()
	update_uis()

/obj/item/modular_computer/attack_ghost(var/mob/observer/ghost/user)
	if(enabled)
		ui_interact(user)
	else if(check_rights(R_ADMIN, 0, user))
		var/response = alert(user, "This computer is turned off. Would you like to turn it on?", "Admin Override", "Yes", "No")
		if(response == "Yes")
			turn_on(user)

/obj/item/modular_computer/attack_hand(var/mob/user)
	if(anchored)
		return attack_self(user)
	return ..()

// On-click handling. Turns on the computer if it's off and opens the GUI.
/obj/item/modular_computer/attack_self(mob/user)
	if(enabled && screen_on)
		ui_interact(user)
	else if(!enabled && screen_on)
		turn_on(user)

/obj/item/modular_computer/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if(istype(W, /obj/item/weapon/card/id)) // ID Card, try to insert it.
		var/obj/item/weapon/card/id/I = W
		if(!card_slot)
			to_chat(user, "You try to insert \the [I] into \the [src], but it does not have an ID card slot installed.")
			return

		if(card_slot.stored_card)
			to_chat(user, "You try to insert \the [I] into \the [src], but it's ID card slot is occupied.")
			return
		user.drop_from_inventory(I)
		card_slot.stored_card = I
		I.forceMove(src)
		update_uis()
		to_chat(user, "You insert \the [I] into \the [src].")
		return
	if(istype(W, /obj/item/weapon/paper))
		if(!nano_printer)
			return
		nano_printer.attackby(W, user)
	if(istype(W, /obj/item/weapon/aicard))
		if(!ai_slot)
			return
		ai_slot.attackby(W, user)
	if(istype(W, /obj/item/weapon/computer_hardware))
		var/obj/item/weapon/computer_hardware/C = W
		if(C.hardware_size <= max_hardware_size)
			try_install_component(user, C)
		else
			to_chat(user, "This component is too large for \the [src].")
	if(istype(W, /obj/item/weapon/wrench))
		var/list/components = get_all_components()
		if(components.len)
			to_chat(user, "Remove all components from \the [src] before disassembling it.")
			return
		new /obj/item/stack/material/steel( get_turf(src.loc), steel_sheet_cost )
		src.visible_message("\The [src] has been disassembled by [user].")
		qdel(src)
		return
	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(!WT.isOn())
			to_chat(user, "\The [W] is off.")
			return

		if(!damage)
			to_chat(user, "\The [src] does not require repairs.")
			return

		to_chat(user, "You begin repairing damage to \the [src]...")
		if(WT.remove_fuel(round(damage/75)) && do_after(usr, damage/10))
			damage = 0
			to_chat(user, "You repair \the [src].")
		return

	if(istype(W, /obj/item/weapon/screwdriver))
		var/list/all_components = get_all_components()
		if(!all_components.len)
			to_chat(user, "This device doesn't have any components installed.")
			return
		var/list/component_names = list()
		for(var/obj/item/weapon/computer_hardware/H in all_components)
			component_names.Add(H.name)

		var/choice = input(usr, "Which component do you want to uninstall?", "Computer maintenance", null) as null|anything in component_names

		if(!choice)
			return

		if(!Adjacent(usr))
			return

		var/obj/item/weapon/computer_hardware/H = find_hardware_by_name(choice)

		if(!H)
			return

		uninstall_component(user, H)

		return

	..()