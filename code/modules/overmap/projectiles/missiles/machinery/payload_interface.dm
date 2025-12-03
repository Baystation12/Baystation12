
/obj/machinery/payload_interface
	icon = 'icons/obj/structures/payload_interface.dmi'
	name = "payload interface"
	desc = "It controls blast doors, conveyor belts, and interfaces with payloads remotely."
	icon_state = "payload_interface"

	anchored = TRUE
	use_power = 1
	idle_power_usage = 10
	layer = BELOW_OBJ_LAYER

	var/allow_arming = FALSE
	var/arming = FALSE
	var/firing = FALSE
	var/loading = FALSE
	var/arming_cooldown = 5 SECONDS

	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc,
		/obj/item/stock_parts/radio/transmitter/basic,
		/obj/item/stock_parts/radio/transmitter/basic
	)
	public_variables = list(
		/singleton/public_access/public_variable/payload_interface_loading,
		/singleton/public_access/public_variable/payload_interface_arming
	)
	stock_part_presets = list(
		/singleton/stock_part_preset/radio/basic_transmitter/payload_interface_conveyor = 1,
		/singleton/stock_part_preset/radio/basic_transmitter/payload_interface_airlock = 1,
	)

	var/obj/overmap/visitable/linked = null

/obj/machinery/payload_interface/Initialize()
	. = ..()
	sync_linked()
	var/turf/owning_turf = get_turf(src)
	GLOB.entered_event.register(owning_turf, src, PROC_REF(on_turf_entered))
	GLOB.exited_event.register(owning_turf, src, PROC_REF(on_turf_exited))

/obj/machinery/payload_interface/Destroy()
	var/turf/owning_turf = get_turf(src)
	GLOB.entered_event.unregister(owning_turf, src, PROC_REF(on_turf_entered))
	GLOB.exited_event.unregister(owning_turf, src, PROC_REF(on_turf_exited))
	. = ..()

/obj/machinery/payload_interface/proc/sync_linked()
	linked = get_owning_sector_recursive(src)

/obj/machinery/payload_interface/proc/on_turf_entered(atom/entered, atom/movable/enterer, atom/old_loc)
	if (istype(enterer, /obj/structure/missile) && linked)
		GLOB.payload_interface_updated.raise_event(linked)

/obj/machinery/payload_interface/proc/on_turf_exited(atom/entered, atom/movable/exitee, atom/new_loc)
	if (istype(exitee, /obj/structure/missile) && linked)
		GLOB.payload_interface_updated.raise_event(linked)

/obj/machinery/payload_interface/use_tool(obj/item/tool, mob/living/user, list/click_params)
	if (isMultitool(tool))
		allow_arming = !allow_arming
		to_chat(user, "You toggle the arming mechanism of \the [src] to [allow_arming ? "on" : "off"].")
		return TRUE
	return ..()

/obj/machinery/payload_interface/on_update_icon(mob/user)
	ClearOverlays()
	if (is_powered())
		if (loading)
			AddOverlays("payload_interface_loading")
		if (firing)
			AddOverlays("payload_interface_arming")

/obj/machinery/payload_interface/proc/arm(mob/user)
	if (!is_powered())
		return
	var/obj/structure/missile/payload = get_payload()
	if (payload && !payload.armed)
		payload.arm(user)
	use_power_oneoff(500)
	update_icon()

/obj/machinery/payload_interface/proc/fire()
	if (!is_powered())
		return
	var/obj/structure/missile/payload = get_payload()
	if (payload && payload.armed)
		addtimer(new Callback(payload, TYPE_PROC_REF(/obj/structure/missile, fire)), 1 SECOND)
	var/singleton/public_access/public_variable/variable = GET_SINGLETON(/singleton/public_access/public_variable/payload_interface_arming)
	variable.write_var(src, TRUE)
	use_power_oneoff(500)
	addtimer(new Callback(src, PROC_REF(arm_cooldown)), arming_cooldown)

/obj/machinery/payload_interface/proc/arm_cooldown()
	firing = FALSE
	if (linked)
		GLOB.payload_interface_updated.raise_event(linked)
	update_icon()

/obj/machinery/payload_interface/proc/can_arm()
	if (!allow_arming || firing || !is_powered() || !get_payload())
		return FALSE
	return TRUE

/obj/machinery/payload_interface/proc/load()
	var/singleton/public_access/public_variable/variable = GET_SINGLETON(/singleton/public_access/public_variable/payload_interface_loading)
	variable.write_var(src, !loading)
	use_power_oneoff(500)
	update_icon()

/obj/machinery/payload_interface/proc/get_payload()
	var/obj/structure/missile/payload = locate() in loc
	return payload

/singleton/stock_part_preset/radio/basic_transmitter/payload_interface_conveyor
	transmit_on_change = list(
		"toggle_conveyor_forwards" = /singleton/public_access/public_variable/payload_interface_loading,
	)
	frequency = CONVEYOR_FREQ

/singleton/stock_part_preset/radio/basic_transmitter/payload_interface_airlock
	transmit_on_change = list(
		"open_door" = /singleton/public_access/public_variable/payload_interface_arming,
		"close_door_delayed" = /singleton/public_access/public_variable/payload_interface_arming,
	)
	frequency = BLAST_DOORS_FREQ

/singleton/public_access/public_variable/payload_interface_loading
	expected_type = /obj/machinery/payload_interface
	name = "loading active"
	desc = "Whether the payload interface is currently loading."
	can_write = TRUE
	has_updates = TRUE

/singleton/public_access/public_variable/payload_interface_loading/access_var(obj/machinery/payload_interface/interface)
	return interface.loading

/singleton/public_access/public_variable/payload_interface_loading/write_var(obj/machinery/payload_interface/interface, new_val)
	. = ..()
	if (.)
		interface.loading = new_val

/singleton/public_access/public_variable/payload_interface_arming
	expected_type = /obj/machinery/payload_interface
	name = "arming active"
	desc = "Whether the payload interface is currently firing."
	can_write = TRUE
	has_updates = TRUE

/singleton/public_access/public_variable/payload_interface_arming/access_var(obj/machinery/payload_interface/interface)
	return interface.firing

/singleton/public_access/public_variable/payload_interface_arming/write_var(obj/machinery/payload_interface/interface, new_val)
	. = ..()
	if (.)
		interface.firing = new_val
