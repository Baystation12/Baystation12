//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

//Circuit boards are in /code/game/objects/items/weapons/circuitboards/machinery

/obj/machinery/constructable_frame //Made into a seperate type to make future revisions easier.
	name = "machine frame"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "box_0"
	density = TRUE
	anchored = FALSE
	use_power = POWER_USE_OFF
	uncreated_component_parts = null
	construct_state = /singleton/machine_construction/frame/unwrenched
	var/obj/item/stock_parts/circuitboard/circuit = null
	var/obj/item/stock_parts/circuitboard/stored_circuit = null
	var/obj/item/warhead_core/core = null
	var/expected_machine_type
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE
	obj_flags = OBJ_FLAG_CAN_TABLE

/obj/machinery/constructable_frame/state_transition(singleton/machine_construction/new_state)
	. = ..()
	update_icon()

/obj/machinery/constructable_frame/dismantle()
	new /obj/item/stack/material/steel(loc, 5)
	qdel(src)
	return TRUE

/obj/machinery/constructable_frame/machine_frame
	expected_machine_type = "machine"

/obj/machinery/constructable_frame/machine_frame/on_update_icon()
	switch(construct_state && construct_state.type)
		if(/singleton/machine_construction/frame/awaiting_circuit)
			icon_state = "box_1"
		if(/singleton/machine_construction/frame/awaiting_parts)
			icon_state = "box_2"
		if(istype(circuit, /obj/item/stock_parts/circuitboard/wmd))
			if(/singleton/machine_construction/frame/awaiting_circuit)
				icon_state = "payload_5"
			if(/singleton/machine_construction/frame/awaiting_parts)
				icon_state = "payload_6"
		if(/singleton/machine_construction/frame/reinforced)
			icon_state = "payload_0"
		if(/singleton/machine_construction/frame/framed)
			icon_state = "payload_1"
		if(/singleton/machine_construction/frame/awaiting_board)
			icon_state = "payload_2"
		if(/singleton/machine_construction/frame/awaiting_cable)
			icon_state = "payload_3"
		if(/singleton/machine_construction/frame/awaiting_connection)
			icon_state = "payload_4"
		else
			icon_state = "box_0"

/obj/machinery/constructable_frame/machine_frame/AltClick(mob/user)
	if (!anchored)
		set_dir(turn(dir, -90))
		to_chat(user, SPAN_NOTICE("You turn \the [src] around."))
		return TRUE
	return ..()

/obj/machinery/constructable_frame/machine_frame/deconstruct
	anchored = TRUE
	construct_state = /singleton/machine_construction/frame/awaiting_circuit
