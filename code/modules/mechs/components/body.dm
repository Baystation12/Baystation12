/obj/item/mech_component/chassis
	name = "body"
	icon_state = "loader_body"
	gender = NEUTER

	var/mech_health = 300
	var/obj/item/weapon/cell/cell
	var/obj/item/robot_parts/robot_component/diagnosis_unit/diagnostics
	var/obj/item/robot_parts/robot_component/armour/armour
	var/obj/machinery/portable_atmospherics/canister/air_supply
	var/datum/gas_mixture/cockpit
	var/pilot_offset_x = 0
	var/pilot_offset_y = 0
	var/open_cabin = 0
	var/hatch_descriptor = "cockpit"
	var/pilot_coverage = 100
	var/min_pilot_size = MOB_SMALL
	var/max_pilot_size = MOB_MEDIUM

/obj/item/mech_component/chassis/Destroy()
	if(cell)
		qdel(cell)
		cell = null
	if(diagnostics)
		qdel(diagnostics)
		diagnostics = null
	if(armour)
		qdel(armour)
		armour = null
	if(air_supply)
		qdel(air_supply)
		air_supply = null
	. = ..()

/obj/item/mech_component/chassis/update_components()
	diagnostics = locate() in src
	cell = locate() in src
	armour = locate() in src
	air_supply = locate() in src

/obj/item/mech_component/chassis/show_missing_parts(var/mob/user)
	if(!cell)
		to_chat(user, "<span class='warning'>It is missing a power cell.</span>")
	if(!diagnostics)
		to_chat(user, "<span class='warning'>It is missing a diagnostics unit.</span>")
	if(!armour)
		to_chat(user, "<span class='warning'>It is missing armour plating.</span>")

/obj/item/mech_component/chassis/New()
	cockpit = new(20)
	..()

/obj/item/mech_component/chassis/Initialize()
	. = ..()
	update_air()

/obj/item/mech_component/chassis/proc/update_air(var/take_from_supply)

	var/changed
	if(!take_from_supply || open_cabin)
		var/turf/T = get_turf(src)
		if(!T)
			return
		cockpit.equalize(T.return_air())
		changed = 1
	else if(air_supply)
		var/env_pressure = cockpit.return_pressure()
		var/pressure_delta = air_supply.release_pressure - env_pressure
		if((air_supply.air_contents.temperature > 0) && (pressure_delta > 0))
			var/transfer_moles = calculate_transfer_moles(air_supply.air_contents, cockpit, pressure_delta)
			transfer_moles = min(transfer_moles, (air_supply.release_flow_rate/air_supply.air_contents.volume)*air_supply.air_contents.total_moles)
			pump_gas_passive(air_supply, air_supply.air_contents, cockpit, transfer_moles)
			changed = 1
	if(changed) cockpit.react()

/obj/item/mech_component/chassis/ready_to_install()
	return (cell && diagnostics && armour)

/obj/item/mech_component/chassis/prebuild()
	diagnostics = new(src)
	cell = new /obj/item/weapon/cell/mecha(src)
	cell.charge = cell.maxcharge
	air_supply = new /obj/machinery/portable_atmospherics/canister/air(src)

/obj/item/mech_component/chassis/attackby(var/obj/item/thing, var/mob/user)
	if(istype(thing,/obj/item/robot_parts/robot_component/diagnosis_unit))
		if(diagnostics)
			to_chat(user, "<span class='warning'>\The [src] already has a diagnostic system installed.</span>")
			return
		if(install_component(thing, user)) diagnostics = thing
	else if(istype(thing, /obj/item/weapon/cell))
		if(cell)
			to_chat(user, "<span class='warning'>\The [src] already has a cell installed.</span>")
			return
		if(install_component(thing,user)) cell = thing
	else if(istype(thing, /obj/item/robot_parts/robot_component/armour))
		if(armour)
			to_chat(user, "<span class='warning'>\The [src] already has armour installed.</span>")
			return
		if(install_component(thing, user)) armour = thing
	else
		return ..()
