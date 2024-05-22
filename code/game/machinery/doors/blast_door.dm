// BLAST DOORS
//
// Refactored 27.12.2014 by Atlantis
//
// Blast doors are supposed to be reinforced versions of regular doors. Instead of being manually
// controlled they use buttons or other means of remote control. This is why they cannot be emagged
// as they lack any ID scanning system, they just handle remote control signals. Subtypes have
// different icons, which are defined by set of variables. Subtypes are on bottom of this file.

/obj/machinery/door/blast
	name = "blast door"
	desc = "That looks like it doesn't open easily."
	icon = 'icons/obj/doors/rapid_pdoor.dmi'
	icon_state = null

	// Icon states for different shutter types. Simply change this instead of rewriting the update_icon proc.
	var/icon_state_open = null
	var/icon_state_opening = null
	var/icon_state_closed = null
	var/icon_state_closing = null

	var/icon_state_open_broken = null
	var/icon_state_closed_broken = null

	var/open_sound = 'sound/machines/blastdoor_open.ogg'
	var/close_sound = 'sound/machines/blastdoor_close.ogg'

	closed_layer = ABOVE_WINDOW_LAYER
	dir = 1
	explosion_resistance = 25
	atom_flags = ATOM_FLAG_ADJACENT_EXCEPTION

	//Most blast doors are infrequently toggled and sometimes used with regular doors anyways,
	//turning this off prevents awkward zone geometry in places like medbay lobby, for example.
	block_air_zones = FALSE

	var/begins_closed = TRUE
	var/material/implicit_material
	autoset_access = FALSE // Uses different system with buttons.
	pry_mod = 1.35

	uncreated_component_parts = list(
		/obj/item/stock_parts/radio/receiver,
		/obj/item/stock_parts/power/apc
	)
	// To be fleshed out and moved to parent door, but staying minimal for now.
	public_methods = list(
		/singleton/public_access/public_method/open_door,
		/singleton/public_access/public_method/close_door_delayed,
		/singleton/public_access/public_method/toggle_door
	)
	stock_part_presets = list(/singleton/stock_part_preset/radio/receiver/blast_door = 1)

/obj/machinery/door/blast/Initialize()
	. = ..()

	if(!begins_closed)
		icon_state = icon_state_open
		set_density(0)
		set_opacity(0)
		layer = open_layer

	implicit_material = SSmaterials.get_material_by_name(MATERIAL_PLASTEEL)

/obj/machinery/door/blast/examine(mob/user)
	. = ..()
	if(MACHINE_IS_BROKEN(src))
		to_chat(user, "It's broken.")

// Proc: Bumped()
// Parameters: 1 (AM - Atom that tried to walk through this object)
// Description: If we are open returns zero, otherwise returns result of parent function.
/obj/machinery/door/blast/Bumped(atom/AM)
	if(!density)
		return ..()
	else
		return 0

// Proc: update_icon()
// Parameters: None
// Description: Updates icon of this object. Uses icon state variables.
/obj/machinery/door/blast/on_update_icon()
	if(density)
		if(MACHINE_IS_BROKEN(src))
			icon_state = icon_state_closed_broken
		else
			icon_state = icon_state_closed
	else
		if(MACHINE_IS_BROKEN(src))
			icon_state = icon_state_open_broken
		else
			icon_state = icon_state_open
	SSradiation.resistance_cache.Remove(get_turf(src))
	return

// Proc: force_open()
// Parameters: None
// Description: Opens the door. No checks are done inside this proc.
/obj/machinery/door/blast/proc/force_open()
	operating = DOOR_OPERATING_YES
	playsound(src.loc, open_sound, 100, 1)
	flick(icon_state_opening, src)
	set_density(0)
	update_nearby_tiles()
	update_icon()
	set_opacity(0)
	sleep(15)
	layer = open_layer
	operating = DOOR_OPERATING_NO

// Proc: force_close()
// Parameters: None
// Description: Closes the door. No checks are done inside this proc.
/obj/machinery/door/blast/proc/force_close()
	operating = DOOR_OPERATING_YES
	playsound(src.loc, close_sound, 100, 1)
	layer = closed_layer
	flick(icon_state_closing, src)
	set_density(1)
	update_nearby_tiles()
	update_icon()
	set_opacity(1)
	sleep(15)
	operating = DOOR_OPERATING_NO

// Proc: force_toggle()
// Parameters: None
// Description: Opens or closes the door, depending on current state. No checks are done inside this proc.
/obj/machinery/door/blast/proc/force_toggle()
	if(density)
		force_open()
	else
		force_close()

/obj/machinery/door/blast/get_material()
	return implicit_material

/obj/machinery/door/blast/get_material_melting_point()
	return 10000 // Blast doors are implicitly heavily fire resistant and are used for containing high-temperature areas like burn chambers.

/obj/machinery/door/blast/attack_hand(mob/user)
	if (MUTATION_FERAL in user.mutations)
		if ((!is_powered() || MACHINE_IS_BROKEN(src)) && density)
			visible_message(SPAN_DANGER("\The [user] manages to pry \the [src] open!"))
			return force_open()
	return ..()

// If we are clicked with crowbar or wielded fire axe, try to manually open the door.
// This only works on broken doors or doors without power. Also allows repair with Plasteel.
/obj/machinery/door/blast/use_tool(obj/item/C, mob/living/user, list/click_params)
	if(isCrowbar(C) || (istype(C, /obj/item/material/twohanded/fireaxe) && C:wielded == 1))
		if(((!is_powered()) || MACHINE_IS_BROKEN(src)) && !( operating ))
			to_chat(user, SPAN_NOTICE("You begin prying at \the [src]..."))
			if(do_after(user, (C.toolspeed * 2) SECONDS, src, DO_REPAIR_CONSTRUCT))
				force_toggle()
		else
			to_chat(user, SPAN_NOTICE("[src]'s motors resist your effort."))
		return TRUE

	if(istype(C, /obj/item/stack/material) && C.get_material_name() == MATERIAL_PLASTEEL)
		var/amt = ceil(get_damage_value() / 150)
		if(!amt)
			to_chat(user, SPAN_NOTICE("\The [src] is already fully functional."))
			return TRUE
		var/obj/item/stack/P = C
		if(!P.can_use(amt))
			to_chat(user, SPAN_WARNING("You don't have enough sheets to repair this! You need at least [amt] sheets."))
			return TRUE
		to_chat(user, SPAN_NOTICE("You begin repairing \the [src]..."))
		if(do_after(user, 5 SECONDS, src, DO_REPAIR_CONSTRUCT))
			if(P.use(amt))
				to_chat(user, SPAN_NOTICE("You have repaired \the [src]."))
				revive_health()
			else
				to_chat(user, SPAN_WARNING("You don't have enough sheets to repair this! You need at least [amt] sheets."))
		else
			to_chat(user, SPAN_WARNING("You must remain still while working on \the [src]."))
		return TRUE

	return ..()


/obj/machinery/door/blast/allowed(mob/M)
	return FALSE // Blast doors can only be opened remotely, or with a crowbar when broken/unpowered.


// Proc: open()
// Parameters: None
// Description: Opens the door. Does necessary checks. Automatically closes if autoclose is true
/obj/machinery/door/blast/open()
	if (operating || (MACHINE_IS_BROKEN(src) || !is_powered()))
		return
	force_open()
	if(autoclose)
		spawn(150)
			close()
	return 1

// Proc: close()
// Parameters: None
// Description: Closes the door. Does necessary checks.
/obj/machinery/door/blast/close()
	if (operating || (MACHINE_IS_BROKEN(src) || !is_powered()))
		return
	force_close()

/obj/machinery/door/blast/toggle()
	if (operating || (MACHINE_IS_BROKEN(src) || !is_powered()))
		return
	force_toggle()

/obj/machinery/door/blast/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group) return 1
	return ..()

/obj/machinery/door/blast/do_simple_ranged_interaction(mob/user)
	return TRUE

// Used with mass drivers to time the close.
/obj/machinery/door/blast/proc/delayed_close()
	set waitfor = FALSE
	sleep(5 SECONDS)
	close()

/singleton/public_access/public_method/close_door_delayed
	name = "delayed close door"
	desc = "Closes the door if possible, after a short delay."
	call_proc = TYPE_PROC_REF(/obj/machinery/door/blast, delayed_close)

/singleton/stock_part_preset/radio/receiver/blast_door
	frequency = BLAST_DOORS_FREQ
	receive_and_call = list(
		"open_door" = /singleton/public_access/public_method/open_door,
		"close_door_delayed" = /singleton/public_access/public_method/close_door_delayed,
		"toggle_door" = /singleton/public_access/public_method/toggle_door
	)

/obj/machinery/button/blast_door
	icon = 'icons/obj/structures/buttons.dmi'
	name = "remote blast door-control"
	desc = "It controls blast doors, remotely."
	icon_state = "blastctrl"
	stock_part_presets = list(/singleton/stock_part_preset/radio/basic_transmitter/blast_door_button = 1)

/singleton/stock_part_preset/radio/basic_transmitter/blast_door_button
	transmit_on_change = list(
		"toggle_door" = /singleton/public_access/public_variable/button_active,
	)
	frequency = BLAST_DOORS_FREQ

/obj/machinery/button/blast_door/on_update_icon()
	if(operating)
		icon_state = "blastctrl1"
	else
		icon_state = "blastctrl"

// SUBTYPE: Regular
// Your classical blast door, found almost everywhere.
/obj/machinery/door/blast/regular

	icon_state = "pdoor1"
	icon_state_open = "pdoor0"
	icon_state_opening = "pdoorc0"
	icon_state_closed = "pdoor1"
	icon_state_closing = "pdoorc1"

	icon_state_open_broken = "blast_open_broken"
	icon_state_closed_broken = "blast_closed_broken"

	health_min_damage = 30
	health_max = 1000
	block_air_zones = TRUE

/obj/machinery/door/blast/regular/escape_pod
	name = "escape pod release door"

/obj/machinery/door/blast/regular/escape_pod/Process()
	if(evacuation_controller.emergency_evacuation && evacuation_controller.state >= EVAC_LAUNCHING && src.icon_state == icon_state_closed)
		src.force_open()
	. = ..()

/obj/machinery/door/blast/regular/open
	begins_closed = FALSE

// SUBTYPE: Shutters
// Nicer looking, and also weaker, shutters. Found in kitchen and similar areas.
/obj/machinery/door/blast/shutters
	name = "shutters"
	desc = "A set of mechanized shutters made of a pretty sturdy material."

	icon_state = "shutter1"
	icon_state_open = "shutter0"
	icon_state_opening = "shutterc0"
	icon_state_closed = "shutter1"
	icon_state_closing = "shutterc1"

	icon_state_open_broken = "shutter_open_broken"
	icon_state_closed_broken = "shutter_closed_broken"

	open_sound = 'sound/machines/shutters_open.ogg'
	close_sound = 'sound/machines/shutters_close.ogg'
	health_min_damage = 10
	health_max = 500
	explosion_resistance = 10
	pry_mod = 0.55

/obj/machinery/door/blast/shutters/open
	begins_closed = FALSE
	icon_state = "shutter0"
