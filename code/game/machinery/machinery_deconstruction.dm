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

// Fetches the components the machine is supposed to have to function fully. Not related to state validity.
/decl/machine_construction/proc/get_requirements(obj/machinery/machine)
	if(needs_board)
		var/obj/item/weapon/stock_parts/circuitboard/board = machine.get_component_of_type(/obj/item/weapon/stock_parts/circuitboard)
		if(board)
			return board.req_components

// There are many machines, so this is designed to catch errors.  This proc must either return TRUE or set the machine's construct_state to a valid one (or null).
/decl/machine_construction/proc/validate_state(obj/machinery/machine)
	if(!state_is_valid(machine))
		machine.construct_state = null
		return FALSE
	return TRUE

/decl/machine_construction/proc/state_is_valid(obj/machinery/machine)
	return TRUE

/decl/machine_construction/proc/try_change_state(obj/machinery/machine, path, user)
	if(machine.construct_state != src)
		return MCS_BLOCK
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

/decl/machine_construction/proc/mechanics_info()

// Used to transfer state as needed post-construction.
/decl/machine_construction/proc/post_construct(obj/machinery/machine)

// Used to be called default_deconstruction_screwdriver -> default_deconstruction_crowbar and default_part_replacement

/decl/machine_construction/default
	needs_board = "machine"
	var/up_state
	var/down_state

/decl/machine_construction/default/panel_closed
	down_state = /decl/machine_construction/default/panel_open

/decl/machine_construction/default/panel_closed/state_is_valid(obj/machinery/machine)
	return !machine.panel_open

/decl/machine_construction/default/panel_closed/validate_state(obj/machinery/machine)
	. = ..()
	if(!.)
		try_change_state(machine, down_state)

/decl/machine_construction/default/panel_closed/attackby(obj/item/I, mob/user, obj/machinery/machine)
	if((. = ..()))
		return
	if(isScrewdriver(I))
		TRANSFER_STATE(down_state)
		playsound(get_turf(machine), 'sound/items/Screwdriver.ogg', 50, 1)
		machine.panel_open = TRUE
		to_chat(user, SPAN_NOTICE("You open the maintenance hatch of \the [machine]."))
		machine.update_icon()
		return
	if(istype(I, /obj/item/weapon/storage/part_replacer))
		machine.display_parts(user)
		return TRUE

/decl/machine_construction/default/panel_closed/post_construct(obj/machinery/machine)
	try_change_state(machine, down_state)
	machine.panel_open = TRUE
	machine.queue_icon_update()

/decl/machine_construction/default/panel_closed/mechanics_info()
	. = list()
	. += "Use a screwdriver to open the panel."
	. += "Use a parts replacer to view installed parts."

/decl/machine_construction/default/panel_open
	up_state = /decl/machine_construction/default/panel_closed
	down_state = /decl/machine_construction/default/deconstructed

/decl/machine_construction/default/panel_open/state_is_valid(obj/machinery/machine)
	return machine.panel_open

/decl/machine_construction/default/panel_open/validate_state(obj/machinery/machine)
	. = ..()
	if(!.)
		try_change_state(machine, up_state)

/decl/machine_construction/default/panel_open/attackby(obj/item/I, mob/user, obj/machinery/machine)
	if((. = ..()))
		return
	if(isCrowbar(I))
		TRANSFER_STATE(down_state)
		machine.dismantle()
		return
	if(isScrewdriver(I))
		TRANSFER_STATE(up_state)
		playsound(get_turf(machine), 'sound/items/Screwdriver.ogg', 50, 1)
		machine.panel_open = FALSE
		to_chat(user, SPAN_NOTICE("You close the maintenance hatch of \the [machine]."))
		machine.update_icon()
		return

	if(istype(I, /obj/item/weapon/storage/part_replacer))
		return machine.part_replacement(user, I)

	if(isWrench(I))
		return machine.part_removal(user)

	if(istype(I))
		return machine.part_insertion(user, I)

/decl/machine_construction/default/panel_open/mechanics_info()
	. = list()
	. += "Use a screwdriver to close the panel."
	. += "Use a parts replacer to upgrade some parts."
	. += "Use a crowbar to remove the circuit and deconstruct the machine"
	. += "Insert a new part to install it."
	. += "Remove installed parts with a wrench."

// Not implemented fully as the machine will qdel on transition to this. Path needed for checks.
/decl/machine_construction/default/deconstructed

// Computers follow similar steps, but have different circuit types (which is enforced here)

/decl/machine_construction/default/panel_closed/computer
	down_state = /decl/machine_construction/default/panel_open/computer
	needs_board = "computer"

/decl/machine_construction/default/panel_open/computer
	up_state = /decl/machine_construction/default/panel_closed/computer
	needs_board = "computer"

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

/decl/machine_construction/tcomms/panel_closed/post_construct(obj/machinery/machine)
	try_change_state(machine, /decl/machine_construction/tcomms/panel_open/no_cable)
	machine.panel_open = TRUE
	machine.queue_icon_update()

/decl/machine_construction/tcomms/panel_closed/mechanics_info()
	. = list()
	. += "Use a screwdriver to open the panel."

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

/decl/machine_construction/tcomms/panel_open/mechanics_info()
	. = list()
	. += "Use a screwdriver to close the panel."
	. += "Use a wrench to remove the external plating."

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

/decl/machine_construction/tcomms/panel_open/unwrenched/mechanics_info()
	. = list()
	. += "Use a wrench to secure the external plating."
	. += "Use wirecutters to remove the cabling."

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

	if(isWrench(I))
		return machine.part_removal(user)

	if(istype(I))
		return machine.part_insertion(user, I)

/decl/machine_construction/tcomms/panel_open/no_cable/mechanics_info()
	. = list()
	. += "Attach cables to make the machine functional."
	. += "Use a parts replacer to upgrade some parts."
	. += "Use a crowbar to remove the circuit and deconstruct the machine"
	. += "Insert a new part to install it."
	. += "Remove installed parts with a wrench."

// Construction frames

/decl/machine_construction/frame/unwrenched/state_is_valid(obj/machinery/machine)
	return !machine.anchored
	
/decl/machine_construction/frame/unwrenched/validate_state(obj/machinery/constructable_frame/machine)
	. = ..()
	if(!.)
		if(machine.circuit)
			try_change_state(machine, /decl/machine_construction/frame/awaiting_parts)
		else
			try_change_state(machine, /decl/machine_construction/frame/wrenched)

/decl/machine_construction/frame/unwrenched/attackby(obj/item/I, mob/user, obj/machinery/machine)
	if(isWrench(I))
		playsound(machine.loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user, 20, machine))
			TRANSFER_STATE(/decl/machine_construction/frame/wrenched)
			to_chat(user, "<span class='notice'>You wrench \the [machine] into place.</span>")
			machine.anchored = TRUE
	if(isWelder(I))
		var/obj/item/weapon/weldingtool/WT = I
		if(!WT.remove_fuel(0, user))
			to_chat(user, "The welding tool must be on to complete this task.")
			return TRUE
		playsound(machine.loc, 'sound/items/Welder.ogg', 50, 1)
		if(do_after(user, 20, machine))
			if(!WT.isOn())
				return TRUE
			TRANSFER_STATE(/decl/machine_construction/default/deconstructed)
			to_chat(user, "<span class='notice'>You deconstruct \the [machine].</span>")
			machine.dismantle()


/decl/machine_construction/frame/unwrenched/mechanics_info()
	. = list()
	. += "Use a welder to break apart the frame."
	. += "Use a wrench to secure the frame in place."

/decl/machine_construction/frame/wrenched/state_is_valid(obj/machinery/constructable_frame/machine)
	return machine.anchored && !machine.circuit

/decl/machine_construction/frame/wrenched/validate_state(obj/machinery/constructable_frame/machine)
	. = ..()
	if(!.)
		if(machine.circuit)
			try_change_state(machine, /decl/machine_construction/frame/awaiting_parts)
		else
			try_change_state(machine, /decl/machine_construction/frame/unwrenched)

/decl/machine_construction/frame/wrenched/attackby(obj/item/I, mob/user, obj/machinery/machine)
	if(isWrench(I))
		playsound(machine.loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user, 20, machine))
			TRANSFER_STATE(/decl/machine_construction/frame/unwrenched)
			to_chat(user, "<span class='notice'>You unfasten \the [machine].</span>")
			machine.anchored = FALSE
			return
	if(isCoil(I))
		var/obj/item/stack/cable_coil/C = I
		if(C.get_amount() < 5)
			to_chat(user, "<span class='warning'>You need five lengths of cable to add them to \the [machine].</span>")
			return TRUE
		playsound(machine.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		to_chat(user, "<span class='notice'>You start to add cables to the frame.</span>")
		if(do_after(user, 20, machine) && C.use(5))
			TRANSFER_STATE(/decl/machine_construction/frame/awaiting_circuit)
			to_chat(user, "<span class='notice'>You add cables to the frame.</span>")
		return TRUE


/decl/machine_construction/frame/unwrenched/mechanics_info()
	. = list()
	. += "Use a wrench to unfasten the frame from the floor and prepare it for deconstruction."
	. += "Add cables to make it ready for a circuit."

/decl/machine_construction/frame/awaiting_circuit/state_is_valid(obj/machinery/constructable_frame/machine)
	return machine.anchored && !machine.circuit

/decl/machine_construction/frame/awaiting_circuit/validate_state(obj/machinery/constructable_frame/machine)
	. = ..()
	if(!.)
		if(machine.circuit)
			try_change_state(machine, /decl/machine_construction/frame/awaiting_parts)
		else
			try_change_state(machine, /decl/machine_construction/frame/unwrenched)

/decl/machine_construction/frame/awaiting_circuit/attackby(obj/item/I, mob/user, obj/machinery/constructable_frame/machine)
	if(istype(I, /obj/item/weapon/stock_parts/circuitboard))
		var/obj/item/weapon/stock_parts/circuitboard/circuit = I
		if(circuit.board_type == machine.expected_machine_type)
			if(!user.canUnEquip(I))
				return FALSE
			TRANSFER_STATE(/decl/machine_construction/frame/awaiting_parts)
			user.unEquip(I, machine)
			playsound(machine.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			to_chat(user, "<span class='notice'>You add the circuit board to \the [machine].</span>")
			machine.circuit = I
			return
		else
			to_chat(user, "<span class='warning'>This frame does not accept circuit boards of this type!</span>")
			return TRUE
	if(isWirecutter(I))
		TRANSFER_STATE(/decl/machine_construction/frame/wrenched)
		playsound(machine.loc, 'sound/items/Wirecutter.ogg', 50, 1)
		to_chat(user, "<span class='notice'>You remove the cables.</span>")
		new /obj/item/stack/cable_coil(machine.loc, 5)

/decl/machine_construction/frame/awaiting_circuit/mechanics_info()
	. = list()
	. += "Insert a circuit board to progress with constructing the machine."
	. += "Use a wirecutter to remove the cables."

/decl/machine_construction/frame/awaiting_parts/state_is_valid(obj/machinery/constructable_frame/machine)
	return machine.anchored && machine.circuit

/decl/machine_construction/frame/awaiting_parts/validate_state(obj/machinery/constructable_frame/machine)
	. = ..()
	if(!.)
		if(machine.anchored)
			try_change_state(machine, /decl/machine_construction/frame/wrenched)
		else
			try_change_state(machine, /decl/machine_construction/frame/unwrenched)

/decl/machine_construction/frame/awaiting_parts/attackby(obj/item/I, mob/user, obj/machinery/constructable_frame/machine)
	if(isCrowbar(I))
		TRANSFER_STATE(/decl/machine_construction/frame/awaiting_circuit)
		playsound(machine.loc, 'sound/items/Crowbar.ogg', 50, 1)
		machine.circuit.dropInto(machine.loc)
		machine.circuit = null
		to_chat(user, "<span class='notice'>You remove the circuit board.</span>")
		return
	if(isScrewdriver(I))
		playsound(machine.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		var/obj/machinery/new_machine = new machine.circuit.build_path(machine.loc, machine.dir, FALSE)
		machine.circuit.construct(new_machine)
		new_machine.install_component(machine.circuit, refresh_parts = FALSE)
		new_machine.apply_component_presets()
		new_machine.RefreshParts()
		new_machine.construct_state.post_construct(new_machine)
		qdel(machine)
		return TRUE

/decl/machine_construction/frame/awaiting_parts/mechanics_info()
	. = list()
	. += "Use a crowbar to remove the circuitboard and any parts installed."
	. += "Use a screwdriver to build the machine."