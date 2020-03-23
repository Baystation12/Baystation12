/obj/item/mech_component/chassis
	name = "body"
	icon_state = "loader_body"
	gender = NEUTER

	var/mech_health = 300
	var/obj/item/weapon/cell/cell
	var/obj/item/robot_parts/robot_component/diagnosis_unit/diagnostics
	var/obj/item/robot_parts/robot_component/armour/exosuit/armour
	var/obj/machinery/portable_atmospherics/canister/air_supply
	var/datum/gas_mixture/cockpit
	var/transparent_cabin = FALSE
	var/hide_pilot =        FALSE
	var/hatch_descriptor = "cockpit"
	var/list/pilot_positions
	var/pilot_coverage = 100
	var/min_pilot_size = MOB_SMALL
	var/max_pilot_size = MOB_LARGE
	has_hardpoints = list(HARDPOINT_BACK, HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)
	var/climb_time = 25

/obj/item/mech_component/chassis/New()
	..()
	if(isnull(pilot_positions))
		pilot_positions = list(
			list(
				"[NORTH]" = list("x" = 8, "y" = 0),
				"[SOUTH]" = list("x" = 8, "y" = 0),
				"[EAST]"  = list("x" = 8, "y" = 0),
				"[WEST]"  = list("x" = 8, "y" = 0)
			)
		)

/obj/item/mech_component/chassis/Destroy()
	QDEL_NULL(cell)
	QDEL_NULL(diagnostics)
	QDEL_NULL(armour)
	QDEL_NULL(air_supply)
	. = ..()

/obj/item/mech_component/chassis/update_components()
	diagnostics = locate() in src
	cell =        locate() in src
	armour =      locate() in src
	air_supply =  locate() in src

/obj/item/mech_component/chassis/show_missing_parts(var/mob/user)
	if(!cell)
		to_chat(user, SPAN_WARNING("It is missing a power cell."))
	if(!diagnostics)
		to_chat(user, SPAN_WARNING("It is missing a diagnostics unit."))
	if(!armour)
		to_chat(user, SPAN_WARNING("It is missing exosuit armour plating."))

/obj/item/mech_component/chassis/Initialize()
	. = ..()
	cockpit = new(20)
	if(loc)
		var/datum/gas_mixture/air = loc.return_air()
		if(air)
			cockpit.equalize(air)
	air_supply = new /obj/machinery/portable_atmospherics/canister/air(src)

/obj/item/mech_component/chassis/proc/update_air(var/take_from_supply)

	var/changed
	if(!take_from_supply || pilot_coverage < 100)
		var/turf/T = get_turf(src)
		if(!T)
			return
		cockpit.equalize(T.return_air())
		changed = TRUE
	else if(air_supply)
		var/env_pressure = cockpit.return_pressure()
		var/pressure_delta = air_supply.release_pressure - env_pressure
		if((air_supply.air_contents.temperature > 0) && (pressure_delta > 0))
			var/transfer_moles = calculate_transfer_moles(air_supply.air_contents, cockpit, pressure_delta)
			transfer_moles = min(transfer_moles, (air_supply.release_flow_rate/air_supply.air_contents.volume)*air_supply.air_contents.total_moles)
			pump_gas_passive(air_supply, air_supply.air_contents, cockpit, transfer_moles)
			changed = TRUE
	if(changed)
		cockpit.react()

/obj/item/mech_component/chassis/ready_to_install()
	return (cell && diagnostics && armour)

/obj/item/mech_component/chassis/prebuild()
	diagnostics = new(src)
	cell = new /obj/item/weapon/cell/exosuit(src)
	cell.charge = cell.maxcharge

/obj/item/mech_component/chassis/attackby(var/obj/item/thing, var/mob/user)
	if(istype(thing,/obj/item/robot_parts/robot_component/diagnosis_unit))
		if(diagnostics)
			to_chat(user, SPAN_WARNING("\The [src] already has a diagnostic system installed."))
			return
		if(install_component(thing, user)) diagnostics = thing
	else if(istype(thing, /obj/item/weapon/cell))
		if(cell)
			to_chat(user, SPAN_WARNING("\The [src] already has a cell installed."))
			return
		if(install_component(thing,user)) cell = thing
	else if(istype(thing, /obj/item/robot_parts/robot_component/armour/exosuit))
		if(armour)
			to_chat(user, SPAN_WARNING("\The [src] already has armour installed."))
			return
		if(install_component(thing, user))
			armour = thing
			set_extension(src, /datum/extension/armor, armour.armor)
	else
		return ..()

/obj/item/mech_component/chassis/MouseDrop_T(atom/dropping, mob/user)
	var/obj/machinery/portable_atmospherics/canister/C = dropping
	if(istype(C) && do_after(user, 5, src))
		to_chat(user, SPAN_NOTICE("You install the canister in the [src]."))
		if(air_supply)
			air_supply.forceMove(get_turf(src))
			air_supply = null
		C.forceMove(src)
		update_components()
	else . = ..()


