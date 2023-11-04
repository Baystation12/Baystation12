// use inside attack_hand/attackby
#define TRANSFER_STATE(path)\
	. = try_change_state(machine, path, user);\
	if(. != MCS_CHANGE) return (. == MCS_BLOCK);\
	. = TRUE

/// The construction state singleton associated with this machine
/obj/machinery/var/singleton/machine_construction/construct_state

/obj/machinery/Initialize()
	if(construct_state)
		construct_state = GET_SINGLETON(construct_state)
	. = ..()

/// Called on state transition; can intercept, but must call parent.
/obj/machinery/proc/state_transition(singleton/machine_construction/new_state)
	construct_state = new_state

/// Return a change state define or a fail message to block transition.
/obj/machinery/proc/cannot_transition_to(state_path, mob/user)
	return MCS_CHANGE

/singleton/machine_construction
	var/needs_board  // Type of circuitboard expected, if any. Used in unit testing.
	var/cannot_print // If false, unit testing will attempt to guarantee that the machine is buildable in-round. This inverts that behavior.

// Run on unit testing. Should return a fail message or null.
/singleton/machine_construction/proc/fail_unit_test(obj/machinery/machine)
	if(!state_is_valid(machine))
		return "[log_info_line(machine)] had an invalid construction state of type [type]."
	if(needs_board)
		var/obj/item/stock_parts/circuitboard/C = machine.get_component_of_type(/obj/item/stock_parts/circuitboard)
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
/singleton/machine_construction/proc/get_requirements(obj/machinery/machine)
	if(needs_board)
		var/obj/item/stock_parts/circuitboard/board = machine.get_component_of_type(/obj/item/stock_parts/circuitboard)
		if(board)
			return board.req_components

// There are many machines, so this is designed to catch errors.  This proc must either return TRUE or set the machine's construct_state to a valid one (or null).
/singleton/machine_construction/proc/validate_state(obj/machinery/machine)
	if(!state_is_valid(machine))
		machine.construct_state = null
		return FALSE
	return TRUE

/singleton/machine_construction/proc/state_is_valid(obj/machinery/machine)
	return TRUE

/singleton/machine_construction/proc/try_change_state(obj/machinery/machine, path, user)
	if(machine.construct_state != src)
		return MCS_BLOCK
	var/singleton/machine_construction/state = GET_SINGLETON(path)
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

/singleton/machine_construction/proc/attack_hand(mob/user, obj/machinery/machine)
	if(!validate_state(machine))
		crash_with("Machine [log_info_line(machine)] violated the state assumptions of the construction state [type]!")
		machine.attack_hand(user)
		return TRUE

/singleton/machine_construction/proc/attackby(obj/item/I, mob/user, obj/machinery/machine)
	if(!validate_state(machine))
		crash_with("Machine [log_info_line(machine)] violated the state assumptions of the construction state [type]!")
		machine.use_tool(I, user)
		return TRUE

/singleton/machine_construction/proc/mechanics_info()

// Used to transfer state as needed post-construction.
/singleton/machine_construction/proc/post_construct(obj/machinery/machine)
