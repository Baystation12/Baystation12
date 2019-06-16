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
	if(istype(I, /obj/item/weapon/storage/part_replacer))
		var/obj/item/weapon/storage/part_replacer/R = I
		for(var/obj/item/weapon/stock_parts/A in machine.component_parts)
			if(!A.base_type)
				continue
			for(var/obj/item/weapon/stock_parts/B in R.contents)
				if(istype(B, A.base_type) && B.rating > A.rating)
					machine.replace_part(user, R, A, B)
					return TRUE
		for(var/path in machine.uncreated_component_parts)
			var/obj/item/weapon/stock_parts/A = path
			var/base_type = initial(A.base_type)
			if(base_type)
				for(var/obj/item/weapon/stock_parts/B in R.contents)
					if(istype(B, base_type) && B.rating > initial(A.rating))
						machine.replace_part(user, R, A, B)
						return TRUE

// Not implemented fully as the machine will qdel on transition to this. Path needed for checks.
/decl/machine_construction/default/deconstructed