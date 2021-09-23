/obj/item/modular_computer/Process()
	if(!enabled) // The computer is turned off
		last_power_usage = 0
		return

	handle_power() // Handles all power interaction

	if(damage > broken_damage)
		shutdown_computer()
		return

	var/datum/extension/interactive/ntos/os = get_extension(src, /datum/extension/interactive/ntos)
	if(os)
		os.Process()

	var/static/list/beepsounds = list('sound/effects/compbeep1.ogg','sound/effects/compbeep2.ogg','sound/effects/compbeep3.ogg','sound/effects/compbeep4.ogg','sound/effects/compbeep5.ogg')
	if(enabled && world.time > ambience_last_played + 60 SECONDS && prob(1))
		ambience_last_played = world.time
		playsound(src.loc, pick(beepsounds),15,1,10, is_ambiance = 1)

/obj/item/modular_computer/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1)
	var/datum/extension/interactive/ntos/os = get_extension(src, /datum/extension/interactive/ntos)
	if(os)
		os.ui_interact(user)

/// Used to perform preset-specific hardware changes.
/obj/item/modular_computer/proc/install_default_hardware()
	return

/// Used to install preset-specific programs
/obj/item/modular_computer/proc/install_default_programs()
	return

/obj/item/modular_computer/proc/install_default_programs_by_job(mob/living/carbon/human/H)
	var/datum/job/jb = SSjobs.get_by_title(H.job)
	if(!jb) return
	for(var/prog_type in jb.software_on_spawn)
		var/datum/computer_file/program/prog_file = prog_type
		if(initial(prog_file.usage_flags) & hardware_flag)
			prog_file = new prog_file
			hard_drive.create_file(prog_file)

/obj/item/modular_computer/Initialize()
	START_PROCESSING(SSobj, src)
	set_extension(src, /datum/extension/interactive/ntos/device)

	if(stores_pen && ispath(stored_pen))
		stored_pen = new stored_pen(src)

	install_default_hardware()
	if(hard_drive)
		install_default_programs()
	if(scanner)
		scanner.do_after_install(null, src)
	update_icon()
	update_verbs()
	update_name()
	. = ..()

/obj/item/modular_computer/Destroy()
	QDEL_NULL_LIST(terminals)
	STOP_PROCESSING(SSobj, src)
	if(istype(stored_pen))
		QDEL_NULL(stored_pen)
	for(var/obj/item/stock_parts/computer/CH in src.get_all_components())
		uninstall_component(null, CH)
		qdel(CH)
	return ..()

/obj/item/modular_computer/emag_act(remaining_charges, mob/user)
	if(computer_emagged)
		to_chat(user, "\The [src] was already emagged.")
		return NO_EMAG_ACT
	else
		computer_emagged = TRUE
		to_chat(user, "You emag \the [src]. It's screen briefly shows a \"OVERRIDE ACCEPTED: New software downloads available.\" message.")
		return 1

/obj/item/modular_computer/on_update_icon()
	icon_state = icon_state_unpowered

	overlays.Cut()
	var/datum/extension/interactive/ntos/os = get_extension(src, /datum/extension/interactive/ntos)
	if(os)
		overlays += os.get_screen_overlay()
		overlays += os.get_keyboard_overlay()

	if(enabled)
		set_light(0.2, 0.1, light_strength)
	else
		set_light(0)

/obj/item/modular_computer/proc/turn_on(mob/user)
	if(bsod)
		return
	if(tesla_link)
		tesla_link.enabled = TRUE
	var/issynth = issilicon(user) // Robots and AIs get different activation messages.
	if(damage > broken_damage)
		if(issynth)
			to_chat(user, "You send an activation signal to \the [src], but it responds with an error code. It must be damaged.")
		else
			to_chat(user, "You press the power button, but the computer fails to boot up, displaying variety of errors before shutting down again.")
		return
	if(processor_unit && (apc_power(0) || battery_power(0))) // Battery-run and charged or non-battery but powered by APC.
		if(issynth)
			to_chat(user, "You send an activation signal to \the [src], turning it on.")
		else
			to_chat(user, "You press the power button and start up \the [src].")
		enable_computer(user)

	else // Unpowered
		if(issynth)
			to_chat(user, "You send an activation signal to \the [src] but it does not respond.")
		else
			to_chat(user, "You press the power button but \the [src] does not respond.")

/obj/item/modular_computer/proc/shutdown_computer(loud = 1)
	QDEL_NULL_LIST(terminals)

	if(loud)
		visible_message("\The [src] shuts down.", range = 1)

	enabled = FALSE
	var/datum/extension/interactive/ntos/os = get_extension(src, /datum/extension/interactive/ntos)
	if(os)
		os.system_shutdown()

/obj/item/modular_computer/proc/enable_computer(mob/user = null)
	enabled = TRUE
	var/datum/extension/interactive/ntos/os = get_extension(src, /datum/extension/interactive/ntos)
	if(os)
		os.system_boot()

	update_icon()

	if(user)
		ui_interact(user)

/obj/item/modular_computer/GetIdCard()
	if(card_slot && card_slot.can_broadcast && istype(card_slot.stored_card) && card_slot.check_functionality())
		return card_slot.stored_card

/obj/item/modular_computer/proc/update_name()

/obj/item/modular_computer/get_cell()
	if(battery_module)
		return battery_module.get_cell()
