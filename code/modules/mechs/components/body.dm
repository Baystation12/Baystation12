/obj/item/storage/mech
	w_class = ITEM_SIZE_NO_CONTAINER
	max_w_class = ITEM_SIZE_LARGE
	storage_slots = 4
	use_sound = 'sound/effects/storage/toolbox.ogg'
	anchored = TRUE

/obj/item/mech_component/chassis/Adjacent(var/atom/neighbor, var/recurse = 1) //For interaction purposes we consider body to be adjacent to whatever holder mob is adjacent
	var/mob/living/exosuit/E = loc
	if(istype(E))
		. = E.Adjacent(neighbor, recurse)
	return . || ..()

/obj/item/storage/mech/Adjacent(var/atom/neighbor, var/recurse = 1) //in order to properly retrieve items
	var/obj/item/mech_component/chassis/C = loc
	if(istype(C))
		. = C.Adjacent(neighbor, recurse-1)
	return . || ..()

/obj/item/mech_component/chassis
	name = "body"
	icon_state = "loader_body"
	gender = NEUTER

	var/mech_health = 300
	var/obj/item/cell/cell
	var/obj/item/robot_parts/robot_component/diagnosis_unit/diagnostics
	var/obj/item/robot_parts/robot_component/armour/exosuit/m_armour
	var/obj/machinery/portable_atmospherics/canister/air_supply
	var/obj/item/storage/mech/storage_compartment
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
	QDEL_NULL(m_armour)
	QDEL_NULL(air_supply)
	QDEL_NULL(storage_compartment)
	. = ..()

/obj/item/mech_component/chassis/update_components()
	diagnostics = locate() in src
	cell =        locate() in src
	m_armour =    locate() in src
	air_supply =  locate() in src
	storage_compartment = locate() in src

/obj/item/mech_component/chassis/show_missing_parts(var/mob/user)
	if(!cell)
		to_chat(user, SPAN_WARNING("It is missing a power cell."))
	if(!diagnostics)
		to_chat(user, SPAN_WARNING("It is missing a diagnostics unit."))
	if(!m_armour)
		to_chat(user, SPAN_WARNING("It is missing exosuit armour plating."))

/obj/item/mech_component/chassis/Initialize()
	. = ..()
	if(pilot_coverage >= 100) //Open cockpits dont get to have air
		cockpit = new
		cockpit.volume = 200
		if(loc)
			var/datum/gas_mixture/air = loc.return_air()
			if(air)
				//Essentially at this point its like we created a vacuum, but realistically making a bottle doesnt actually increase volume of a room and neither should a mech
				for(var/g in air.gas)
					var/amount = air.gas[g]
					amount/= air.volume
					cockpit.gas[g] = amount * cockpit.volume

				cockpit.temperature = air.temperature
				cockpit.update_values()

		air_supply = new /obj/machinery/portable_atmospherics/canister/air(src)
	storage_compartment = new(src)

/obj/item/mech_component/chassis/proc/update_air(var/take_from_supply)

	var/changed
	if(!cockpit)
		return
	if(!take_from_supply || pilot_coverage < 100)
		var/turf/T = get_turf(src)
		if(!T)
			return
		cockpit.equalize(T.return_air())
		changed = TRUE
	else if(air_supply)
		var/env_pressure = cockpit.return_pressure()
		var/pressure_delta = air_supply.release_pressure - env_pressure
		if(pressure_delta > 0)
			if(air_supply.air_contents.temperature > 0)
				var/transfer_moles = calculate_transfer_moles(air_supply.air_contents, cockpit, pressure_delta)
				transfer_moles = min(transfer_moles, (air_supply.release_flow_rate/air_supply.air_contents.volume)*air_supply.air_contents.total_moles)
				pump_gas_passive(air_supply, air_supply.air_contents, cockpit, transfer_moles)
				changed = TRUE
		else if(pressure_delta < 0) //Release overpressure.
			var/turf/T = get_turf(src)
			if(!T)
				return
			var/datum/gas_mixture/t_air = T.return_air()
			if(t_air)
				pressure_delta = min(env_pressure - t_air.return_pressure(), pressure_delta)
			if(pressure_delta > 0) //Location is at a lower pressure (so we can vent into it)
				var/transfer_moles = calculate_transfer_moles(cockpit, t_air, pressure_delta)
				var/datum/gas_mixture/removed = cockpit.remove(transfer_moles)
				if(!removed)
					return
				if(t_air)
					t_air.merge(removed)
				else //just delete the cabin gas, we are somewhere with invalid air, so they wont mind the additional nothingness
					qdel(removed)
				changed = TRUE

	if(changed)
		cockpit.react()

/obj/item/mech_component/chassis/ready_to_install()
	return (cell && diagnostics && m_armour)

/obj/item/mech_component/chassis/prebuild()
	diagnostics = new(src)
	cell = new /obj/item/cell/high(src)
	cell.charge = cell.maxcharge

/obj/item/mech_component/chassis/attackby(var/obj/item/thing, var/mob/user)
	if(istype(thing,/obj/item/robot_parts/robot_component/diagnosis_unit))
		if(diagnostics)
			to_chat(user, SPAN_WARNING("\The [src] already has a diagnostic system installed."))
			return
		if(install_component(thing, user)) diagnostics = thing
	else if(istype(thing, /obj/item/cell))
		if(cell)
			to_chat(user, SPAN_WARNING("\The [src] already has a cell installed."))
			return
		if(install_component(thing,user)) cell = thing
	else if(istype(thing, /obj/item/robot_parts/robot_component/armour/exosuit))
		if(m_armour)
			to_chat(user, SPAN_WARNING("\The [src] already has armour installed."))
			return
		if(install_component(thing, user))
			m_armour = thing
	else
		return ..()

/obj/item/mech_component/chassis/MouseDrop_T(atom/dropping, mob/user)
	var/obj/machinery/portable_atmospherics/canister/C = dropping
	if(!istype(C))
		return ..()
	if(pilot_coverage < 100)
		to_chat(user, SPAN_NOTICE("This type of chassis doesn't support internals."))
	if(!C.anchored && do_after(user, 0.5 SECONDS, src, DO_PUBLIC_UNIQUE))
		if(C.anchored)
			return
		to_chat(user, SPAN_NOTICE("You install the canister in the [src]."))
		if(air_supply)
			air_supply.forceMove(get_turf(src))
			air_supply = null
		C.forceMove(src)
		update_components()
	else . = ..()

/obj/item/mech_component/chassis/MouseDrop(atom/over)
	if(!usr || !over) return
	if(!Adjacent(usr) || !over.Adjacent(usr)) return

	if(storage_compartment)
		return storage_compartment.MouseDrop(over)

/obj/item/mech_component/chassis/return_diagnostics(mob/user)
	..()
	if(diagnostics)
		to_chat(user, SPAN_NOTICE(" Diagnostics Unit Integrity: <b>[round((((diagnostics.max_dam - diagnostics.total_dam) / diagnostics.max_dam)) * 100)]%</b>"))
	else
		to_chat(user, SPAN_WARNING(" Diagnostics Unit Missing or Non-functional."))
	if(m_armour)
		to_chat(user, SPAN_NOTICE(" Armor Integrity: <b>[round((((m_armour.max_dam - m_armour.total_dam) / m_armour.max_dam)) * 100)]%</b>"))
	else
		to_chat(user, SPAN_WARNING(" Armor Missing or Non-functional."))


/obj/item/mech_component/chassis/powerloader
	name = "open exosuit chassis"
	hatch_descriptor = "roll cage"
	pilot_coverage = 40
	exosuit_desc_string = "an industrial rollcage"
	desc = "A Xion industrial brand roll cage. Technically OSHA compliant. Technically."
	max_damage = 100
	power_use = 0
	climb_time = 6

/obj/item/mech_component/chassis/powerloader/prebuild()
	. = ..()
	m_armour = new /obj/item/robot_parts/robot_component/armour/exosuit(src)

/obj/item/mech_component/chassis/powerloader/Initialize()
	pilot_positions = list(
		list(
			"[NORTH]" = list("x" = 8,  "y" = 8),
			"[SOUTH]" = list("x" = 8,  "y" = 8),
			"[EAST]"  = list("x" = 8,  "y" = 8),
			"[WEST]"  = list("x" = 8,  "y" = 8)
		),
		list(
			"[NORTH]" = list("x" = 8,  "y" = 16),
			"[SOUTH]" = list("x" = 8,  "y" = 16),
			"[EAST]"  = list("x" = 0,  "y" = 16),
			"[WEST]"  = list("x" = 16, "y" = 16)
		)
	)
	. = ..()

/obj/item/mech_component/chassis/light
	name = "light exosuit chassis"
	hatch_descriptor = "canopy"
	pilot_coverage = 100
	transparent_cabin =  TRUE
	exosuit_desc_string = "an open and light chassis"
	icon_state = "light_body"
	max_damage = 50
	power_use = 5
	has_hardpoints = list(HARDPOINT_BACK, HARDPOINT_LEFT_SHOULDER)
	desc = "The Veymed Odysseus series cockpits combine ultralight materials and clear aluminum laminates to provide an optimized cockpit experience."
	climb_time = 15

/obj/item/mech_component/chassis/light/prebuild()
	. = ..()
	m_armour = new /obj/item/robot_parts/robot_component/armour/exosuit/radproof(src)

/obj/item/mech_component/chassis/light/Initialize()
	pilot_positions = list(
		list(
			"[NORTH]" = list("x" = 8,  "y" = 0),
			"[SOUTH]" = list("x" = 8,  "y" = 0),
			"[EAST]"  = list("x" = 3,  "y" = 0),
			"[WEST]"  = list("x" = 13, "y" = 0)
		)
	)
	. = ..()

/obj/item/mech_component/chassis/pod
	name = "spherical exosuit chassis"
	hatch_descriptor = "hatch"
	pilot_coverage = 100
	transparent_cabin = TRUE
	exosuit_desc_string = "a spherical chassis"
	icon_state = "pod_body"
	max_damage = 70
	power_use = 5
	has_hardpoints = list(HARDPOINT_BACK)
	desc = "The NanoTrasen Katamari series cockpits have won a massive tender by SCG few years back. No one is sure why, but these terrible things keep popping up on every government facility."

/obj/item/mech_component/chassis/pod/Initialize()
	pilot_positions = list(
		list(
			"[NORTH]" = list("x" = 8,  "y" = 4),
			"[SOUTH]" = list("x" = 8,  "y" = 4),
			"[EAST]"  = list("x" = 12,  "y" = 4),
			"[WEST]"  = list("x" = 4,  "y" = 4)
		),
		list(
			"[NORTH]" = list("x" = 8,  "y" = 8),
			"[SOUTH]" = list("x" = 8,  "y" = 8),
			"[EAST]"  = list("x" = 10,  "y" = 8),
			"[WEST]"  = list("x" = 6, "y" = 8)
		)
	)
	. = ..()

/obj/item/mech_component/chassis/pod/prebuild()
	. = ..()
	m_armour = new /obj/item/robot_parts/robot_component/armour/exosuit/radproof(src)

/obj/item/mech_component/chassis/pod/Initialize()
	pilot_positions = list(
		list(
			"[NORTH]" = list("x" = 8,  "y" = 3),
			"[SOUTH]" = list("x" = 8,  "y" = 2),
			"[EAST]"  = list("x" = 4,  "y" = 3),
			"[WEST]"  = list("x" = 12, "y" = 3)
		)
	)
	. = ..()

/obj/item/mech_component/chassis/heavy
	name = "reinforced exosuit chassis"
	hatch_descriptor = "hatch"
	desc = "The HI-Koloss chassis is a veritable juggernaut, capable of protecting a pilot even in the most hostile of environments. It handles like a battlecruiser, however."
	pilot_coverage = 100
	exosuit_desc_string = "a heavily armoured chassis"
	icon_state = "heavy_body"
	max_damage = 150
	mech_health = 500
	power_use = 50
	has_hardpoints = list(HARDPOINT_BACK)

/obj/item/mech_component/chassis/heavy/prebuild()
	pilot_positions = list(
		list(
			"[NORTH]" = list("x" = 8,  "y" = 8),
			"[SOUTH]" = list("x" = 9,  "y" = 2),
			"[EAST]"  = list("x" = 4,  "y" = 8),
			"[WEST]"  = list("x" = 12, "y" = 8)
		)
	)

	. = ..()

/obj/item/mech_component/chassis/heavy/prebuild()
	. = ..()
	m_armour = new /obj/item/robot_parts/robot_component/armour/exosuit/combat(src)

/obj/item/mech_component/chassis/combat
	name = "sealed exosuit chassis"
	hatch_descriptor = "canopy"
	pilot_coverage = 100
	exosuit_desc_string = "an armoured chassis"
	icon_state = "combat_body"
	power_use = 40

/obj/item/mech_component/chassis/combat/prebuild()
	. = ..()
	m_armour = new /obj/item/robot_parts/robot_component/armour/exosuit/combat(src)

/obj/item/mech_component/chassis/combat/Initialize()
	pilot_positions = list(
		list(
			"[NORTH]" = list("x" = 8,  "y" = 8),
			"[SOUTH]" = list("x" = 8,  "y" = 8),
			"[EAST]"  = list("x" = 4,  "y" = 8),
			"[WEST]"  = list("x" = 12, "y" = 8)
		)
	)

	. = ..()
