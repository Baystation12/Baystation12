// use inside attack_hand/attackby
#define TRANSFER_STATE(path)\
	. = try_change_state(machine, path, user);\
	if(. != MCS_CHANGE) return (. == MCS_BLOCK);\
	. = TRUE

/obj/machinery
	var/decl/machine_construction/construct_state

/obj/machinery/Initialize()
	if(construct_state)
		construct_state = decls_repository.get_decl(construct_state)
	. = ..()

// Called on state transition; can intercept, but must call parent.
/obj/machinery/proc/state_transition(var/decl/machine_construction/new_state)
	construct_state = new_state

// Return a change state define or a fail message to block transition.
/obj/machinery/proc/cannot_transition_to(var/state_path, var/mob/user)
	return MCS_CHANGE

/decl/machine_construction
	var/needs_board  // Type of circuitboard expected, if any. Used in unit testing.
	var/cannot_print // If false, unit testing will attempt to guarantee that the machine is buildable in-round. This inverts that behavior.

// Run on unit testing. Should return a fail message or null.
/decl/machine_construction/proc/fail_unit_test(obj/machinery/machine)
	if(!state_is_valid(machine))
		return "[log_info_line(machine)] had an invalid construction state of type [type]."
	if(needs_board)
		var/obj/item/weapon/stock_parts/circuitboard/C = machine.get_component_of_type(/obj/item/weapon/stock_parts/circuitboard)
		if(!C)
			return "Machine [log_info_line(machine)] lacked a circuitboard."
		if(C.board_type != needs_board)
			return "Machine [log_info_line(machine)] had a circuitboard of an unexpected type: was [C.board_type], should be [needs_board]."
		var/design = GLOB.build_path_to_design_datum_path[C.type]
		if(!design && !cannot_print)
			return "Machine [log_info_line(machine)] had a circuitboard which could not be printed."
		else if(design && cannot_print)
			return "Machine [log_info_line(machine)] had a circuitboard which could be printed, but it wasn't supposed to."

// There are many machines, so this is designed to catch errors.  This proc must either return TRUE or set the machine's construct_state to a valid one (or null).
/decl/machine_construction/proc/validate_state(obj/machinery/machine)
	if(!state_is_valid(machine))
		machine.construct_state = null
		return FALSE
	return TRUE

/decl/machine_construction/proc/state_is_valid(obj/machinery/machine)
	return TRUE

/decl/machine_construction/proc/try_change_state(obj/machinery/machine, path, user)
	var/decl/machine_construction/state = decls_repository.get_decl(path)
	if(state)
		var/fail = machine.cannot_transition_to(path, user)
		if(fail == MCS_CHANGE)
			machine.state_transition(state)
			return MCS_CHANGE
		if(istext(fail))
			to_chat(user, fail)
			return MCS_BLOCK
		return fail
	return MCS_CONTINUE

/decl/machine_construction/proc/attack_hand(mob/user, obj/machinery/machine)
	if(!validate_state(machine))
		crash_with("Machine [log_info_line(machine)] violated the state assumptions of the construction state [type]!")
		machine.attack_hand(user)
		return TRUE

/decl/machine_construction/proc/attackby(obj/item/I, mob/user, obj/machinery/machine)
	if(!validate_state(machine))
		crash_with("Machine [log_info_line(machine)] violated the state assumptions of the construction state [type]!")
		machine.attackby(I, user)
		return TRUE


// Used to be called default_deconstruction_screwdriver -> default_deconstruction_crowbar and default_part_replacement

/decl/machine_construction/default
	needs_board = "machine"

/decl/machine_construction/default/panel_closed/state_is_valid(obj/machinery/machine)
	return !machine.panel_open

/decl/machine_construction/default/panel_closed/validate_state(obj/machinery/machine)
	. = ..()
	if(!.)
		try_change_state(machine, /decl/machine_construction/default/panel_open)

/decl/machine_construction/default/panel_closed/attackby(obj/item/I, mob/user, obj/machinery/machine)
	if((. = ..()))
		return
	if(isScrewdriver(I))
		TRANSFER_STATE(/decl/machine_construction/default/panel_open)
		playsound(get_turf(machine), 'sound/items/Screwdriver.ogg', 50, 1)
		machine.panel_open = TRUE
		to_chat(user, SPAN_NOTICE("You open the maintenance hatch of \the [machine]."))
		machine.update_icon()
		return
	if(istype(I, /obj/item/weapon/storage/part_replacer))
		machine.display_parts(user)
		return TRUE

/decl/machine_construction/default/panel_open/state_is_valid(obj/machinery/machine)
	return machine.panel_open

/decl/machine_construction/default/panel_open/validate_state(obj/machinery/machine)
	. = ..()
	if(!.)
		try_change_state(machine, /decl/machine_construction/default/panel_closed)

/decl/machine_construction/default/panel_open/attackby(obj/item/I, mob/user, obj/machinery/machine)
	if((. = ..()))
		return
	if(isCrowbar(I))
		TRANSFER_STATE(/decl/machine_construction/default/deconstructed)
		machine.dismantle()
		return
	if(isScrewdriver(I))
		TRANSFER_STATE(/decl/machine_construction/default/panel_closed)
		playsound(get_turf(machine), 'sound/items/Screwdriver.ogg', 50, 1)
		machine.panel_open = FALSE
		to_chat(user, SPAN_NOTICE("You close the maintenance hatch of \the [machine]."))
		machine.update_icon()
		return

	// Part modifications. First: part replacer
	if(istype(I, /obj/item/weapon/storage/part_replacer))
		return machine.part_replacement(I, user)

	// Second: Part insertion
	if(istype(I, /obj/item/weapon/stock_parts))
		return machine.part_insertion(user, I)

	// Finally: Part removal with wrench
	if(isWrench(I))
		return machine.part_removal(user)

// Not implemented fully as the machine will qdel on transition to this. Path needed for checks.
/decl/machine_construction/default/deconstructed

// Computers have only one built state.

/decl/machine_construction/computer
	needs_board = "computer"

/decl/machine_construction/computer/built/attackby(obj/item/I, mob/user, obj/machinery/machine)
	if((. = ..()))
		return
	if(isScrewdriver(I))
		TRANSFER_STATE(/decl/machine_construction/default/deconstructed)
		machine.dismantle()
		return

	if(istype(I, /obj/item/weapon/storage/part_replacer))
		return machine.part_replacement(I, user)

	if(istype(I, /obj/item/weapon/stock_parts))
		return machine.part_insertion(user, I)

	if(isWrench(I))
		return machine.part_removal(user)

// Telecomms have lots of states.

/decl/machine_construction/tcomms
	needs_board = "machine"

/decl/machine_construction/tcomms/panel_closed/state_is_valid(obj/machinery/machine)
	return !machine.panel_open

/decl/machine_construction/tcomms/panel_closed/validate_state(obj/machinery/machine)
	. = ..()
	if(!.)
		try_change_state(machine, /decl/machine_construction/tcomms/panel_open)

/decl/machine_construction/tcomms/panel_closed/attackby(obj/item/I, mob/user, obj/machinery/machine)
	if((. = ..()))
		return
	if(isScrewdriver(I))
		TRANSFER_STATE(/decl/machine_construction/tcomms/panel_open)
		machine.panel_open = TRUE
		to_chat(user, "You unfasten the bolts.")
		playsound(machine.loc, 'sound/items/Screwdriver.ogg', 50, 1)

/decl/machine_construction/tcomms/panel_closed/cannot_print
	cannot_print = TRUE

/decl/machine_construction/tcomms/panel_open/state_is_valid(obj/machinery/machine)
	return machine.panel_open

/decl/machine_construction/tcomms/panel_open/validate_state(obj/machinery/machine)
	. = ..()
	if(!.)
		try_change_state(machine, /decl/machine_construction/tcomms/panel_closed)

/decl/machine_construction/tcomms/panel_open/attackby(obj/item/I, mob/user, obj/machinery/machine)
	if((. = ..()))
		return
	return state_interactions(I, user, machine)

/decl/machine_construction/tcomms/panel_open/proc/state_interactions(obj/item/I, mob/user, obj/machinery/machine)
	if(isScrewdriver(I))
		TRANSFER_STATE(/decl/machine_construction/tcomms/panel_closed)
		machine.panel_open = FALSE
		to_chat(user, "You fasten the bolts.")
		playsound(machine.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		return
	if(isWrench(I))
		TRANSFER_STATE(/decl/machine_construction/tcomms/panel_open/unwrenched)
		to_chat(user, "You dislodge the external plating.")
		playsound(machine.loc, 'sound/items/Ratchet.ogg', 75, 1)

/decl/machine_construction/tcomms/panel_open/unwrenched/state_interactions(obj/item/I, mob/user, obj/machinery/machine)
	if(isWrench(I))
		TRANSFER_STATE(/decl/machine_construction/tcomms/panel_open)
		to_chat(user, "You secure the external plating.")
		playsound(machine.loc, 'sound/items/Ratchet.ogg', 75, 1)
		return
	if(isWirecutter(I))
		TRANSFER_STATE(/decl/machine_construction/tcomms/panel_open/no_cable)
		playsound(machine.loc, 'sound/items/Wirecutter.ogg', 50, 1)
		to_chat(user, "You remove the cables.")
		var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil( user.loc )
		A.amount = 5
		machine.set_broken(TRUE, TRUE) // the machine's been borked!

/decl/machine_construction/tcomms/panel_open/no_cable/state_interactions(obj/item/I, mob/user, obj/machinery/machine)
	if(isCoil(I))
		var/obj/item/stack/cable_coil/A = I
		if (A.can_use(5))
			TRANSFER_STATE(/decl/machine_construction/tcomms/panel_open/unwrenched)
			A.use(5)
			to_chat(user, "<span class='notice'>You insert the cables.</span>")
			machine.set_broken(FALSE, TRUE) // the machine's not borked anymore!
			return
		else
			to_chat(user, "<span class='warning'>You need five coils of wire for this.</span>")
			return TRUE
	if(isCrowbar(I))
		TRANSFER_STATE(/decl/machine_construction/default/deconstructed)
		machine.dismantle()
		return

	if(istype(I, /obj/item/weapon/storage/part_replacer))
		return machine.part_replacement(I, user)

	if(istype(I, /obj/item/weapon/stock_parts))
		return machine.part_insertion(user, I)

	if(isWrench(I))
		return machine.part_removal(user)