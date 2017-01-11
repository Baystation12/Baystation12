/obj/machinery/power/shield_generator
	name = "advanced shield generator"
	desc = "A heavy-duty shield generator and capacitor, capable of generating energy shield at large distance."
	icon = 'icons/obj/machines/shielding.dmi'
	icon_state = "generator0"
	density = 1
	var/datum/wires/shield_generator/wires
	var/list/field_segments = list()	// List of all shield segments owned by this generator.
	var/list/damaged_segments = list()	// List of shield segments that have failed and are currently regenerating.
	var/shield_modes = 0				// Enabled shield mode flags
	var/mitigation_em = 0				// Current EM mitigation
	var/mitigation_physical = 0			// Current Physical mitigation
	var/mitigation_heat = 0				// Current Burn mitigation
	var/mitigation_max = 0				// Maximal mitigation reachable with this generator. Set by RefreshParts()
	var/max_energy = 0					// Maximal stored energy. In joules. Depends on the type of used SMES coil when constructing this generator.
	var/current_energy = 0				// Current stored energy.
	var/field_radius = 1				// Current field radius.
	var/running = SHIELD_OFF			// Whether the generator is enabled or not.
	var/input_cap = 1 MEGAWATTS			// Currently set input limit. Set to 0 to disable limits altogether. The shield will try to input this value per tick at most
	var/upkeep_power_usage = 0			// Upkeep power usage last tick.
	var/upkeep_multiplier = 1			// Multiplier of upkeep values.
	var/power_usage = 0					// Total power usage last tick.
	var/overloaded = 0					// Whether the field has overloaded and shut down to regenerate.
	var/hacked = 0						// Whether the generator has been hacked by cutting the safety wire.
	var/offline_for = 0					// The generator will be inoperable for this duration in ticks.
	var/input_cut = 0					// Whether the input wire is cut.
	var/mode_changes_locked = 0			// Whether the control wire is cut, locking out changes.
	var/ai_control_disabled = 0			// Whether the AI control is disabled.
	var/list/mode_list = null			// A list of shield_mode datums.

/obj/machinery/power/shield_generator/update_icon()
	if(running)
		icon_state = "generator1"
	else
		icon_state = "generator0"


/obj/machinery/power/shield_generator/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/shield_generator(src)
	component_parts += new /obj/item/weapon/stock_parts/capacitor(src)			// Capacitor. Improves shield mitigation when better part is used.
	component_parts += new /obj/item/weapon/stock_parts/micro_laser(src)
	component_parts += new /obj/item/weapon/smes_coil(src)						// SMES coil. Improves maximal shield energy capacity.
	component_parts += new /obj/item/weapon/stock_parts/console_screen(src)
	RefreshParts()
	connect_to_network()
	wires = new(src)

	mode_list = list()
	for(var/st in subtypesof(/datum/shield_mode/))
		var/datum/shield_mode/SM = new st()
		mode_list.Add(SM)


/obj/machinery/power/shield_generator/Destroy()
	shutdown_field()
	field_segments = null
	damaged_segments = null
	mode_list = null
	qdel_null(wires)
	. = ..()


/obj/machinery/power/shield_generator/RefreshParts()
	max_energy = 0
	for(var/obj/item/weapon/smes_coil/S in component_parts)
		max_energy += (S.ChargeCapacity / CELLRATE)
	current_energy = between(0, current_energy, max_energy)

	mitigation_max = MAX_MITIGATION_BASE
	for(var/obj/item/weapon/stock_parts/capacitor/C in component_parts)
		mitigation_max += MAX_MITIGATION_RESEARCH * C.rating
	mitigation_em = between(0, mitigation_em, mitigation_max)
	mitigation_physical = between(0, mitigation_physical, mitigation_max)
	mitigation_heat = between(0, mitigation_heat, mitigation_max)


// Shuts down the shield, removing all shield segments and unlocking generator settings.
/obj/machinery/power/shield_generator/proc/shutdown_field()
	for(var/obj/effect/shield/S in field_segments)
		qdel(S)

	running = SHIELD_OFF
	current_energy = 0
	mitigation_em = 0
	mitigation_physical = 0
	mitigation_heat = 0
	update_icon()


// Generates the field objects. Deletes existing field, if applicable.
/obj/machinery/power/shield_generator/proc/regenerate_field()
	if(field_segments.len)
		for(var/obj/effect/shield/S in field_segments)
			qdel(S)

	// The generator is not turned on, so don't generate any new tiles.
	if(!running)
		return

	var/list/shielded_turfs

	if(check_flag(MODEFLAG_HULL))
		shielded_turfs = fieldtype_hull()
	else
		shielded_turfs = fieldtype_square()

	for(var/turf/T in shielded_turfs)
		var/obj/effect/shield/S = new(T)
		S.gen = src
		S.flags_updated()
		field_segments |= S
	update_icon()


// Recalculates and updates the upkeep multiplier
/obj/machinery/power/shield_generator/proc/update_upkeep_multiplier()
	var/new_upkeep = 1.0
	for(var/datum/shield_mode/SM in mode_list)
		if(check_flag(SM.mode_flag))
			new_upkeep *= SM.multiplier

	upkeep_multiplier = new_upkeep


/obj/machinery/power/shield_generator/process()
	upkeep_power_usage = 0
	power_usage = 0

	if(offline_for)
		offline_for = max(0, offline_for - 1)
	// We're turned off.
	if(!running)
		return
	// We are shutting down, therefore our stored energy disperses faster than usual.
	else if(running == SHIELD_DISCHARGING)
		current_energy -= SHIELD_SHUTDOWN_DISPERSION_RATE

	mitigation_em = between(0, mitigation_em - MITIGATION_LOSS_PASSIVE, mitigation_max)
	mitigation_heat = between(0, mitigation_heat - MITIGATION_LOSS_PASSIVE, mitigation_max)
	mitigation_physical = between(0, mitigation_physical - MITIGATION_LOSS_PASSIVE, mitigation_max)

	upkeep_power_usage = round((field_segments.len - damaged_segments.len) * ENERGY_UPKEEP_PER_TILE * upkeep_multiplier)

	if(powernet && (running == SHIELD_RUNNING) && !input_cut)
		var/energy_buffer = 0
		energy_buffer = draw_power(min(upkeep_power_usage, input_cap))
		power_usage += round(energy_buffer)

		if(energy_buffer < upkeep_power_usage)
			current_energy -= round(upkeep_power_usage - energy_buffer)	// If we don't have enough energy from the grid, take it from the internal battery instead.

		// Now try to recharge our internal energy.
		var/energy_to_demand
		if(input_cap)
			energy_to_demand = between(0, max_energy - current_energy, input_cap - upkeep_power_usage)
		else
			energy_to_demand = max(0, max_energy - current_energy)
		energy_buffer = draw_power(energy_to_demand)
		power_usage += energy_buffer
		current_energy += round(energy_buffer)
	else
		current_energy -= round(upkeep_power_usage)	// We are shutting down, or we lack external power connection. Use energy from internal source instead.

	if(current_energy <= 0)
		energy_failure()

	if(!overloaded)
		for(var/obj/effect/shield/S in damaged_segments)
			S.regenerate()
	else if (field_integrity() > 25)
		overloaded = 0


/obj/machinery/power/shield_generator/attackby(obj/item/O as obj, mob/user as mob)
	if(panel_open && (istype(O, /obj/item/device/multitool) || istype(O, /obj/item/weapon/wirecutters)))
		attack_hand(user)
		return

	if(default_deconstruction_screwdriver(user, O))
		return

	// Prevents dismantle-rebuild tactics to reset the emergency shutdown timer.
	if(running)
		to_chat(user, "Turn off \the [src] first!")
		return
	if(offline_for)
		to_chat(user, "Wait until \the [src] cools down from emergency shutdown first!")
		return

	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return


/obj/machinery/power/shield_generator/proc/energy_failure()
	if(running == SHIELD_DISCHARGING)
		shutdown_field()
	else
		current_energy = 0
		overloaded = 1
		for(var/obj/effect/shield/S in field_segments)
			S.fail(1)


/obj/machinery/power/shield_generator/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]

	data["running"] = running
	data["modes"] = get_flag_descriptions()
	data["overloaded"] = overloaded
	data["mitigation_max"] = mitigation_max
	data["mitigation_physical"] = round(mitigation_physical, 0.1)
	data["mitigation_em"] = round(mitigation_em, 0.1)
	data["mitigation_heat"] = round(mitigation_heat, 0.1)
	data["field_integrity"] = field_integrity()
	data["max_energy"] = round(max_energy / 1000000, 0.1)
	data["current_energy"] = round(current_energy / 1000000, 0.1)
	data["total_segments"] = field_segments ? field_segments.len : 0
	data["functional_segments"] = damaged_segments ? data["total_segments"] - damaged_segments.len : data["total_segments"]
	data["field_radius"] = field_radius
	data["input_cap_kw"] = round(input_cap / 1000)
	data["upkeep_power_usage"] = round(upkeep_power_usage / 1000, 0.1)
	data["power_usage"] = round(power_usage / 1000)
	data["hacked"] = hacked
	data["offline_for"] = offline_for * 2

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "shieldgen.tmpl", src.name, 500, 800)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)


/obj/machinery/power/shield_generator/attack_hand(var/mob/user)
	ui_interact(user)
	if(panel_open)
		wires.Interact(user)


/obj/machinery/power/shield_generator/CanUseTopic(var/mob/user)
	if(issilicon(user) && !Adjacent(user) && ai_control_disabled)
		return STATUS_UPDATE
	return ..()

/obj/machinery/power/shield_generator/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["begin_shutdown"])
		if(running != SHIELD_RUNNING)
			return
		running = SHIELD_DISCHARGING
		. = 1

	if(href_list["start_generator"])
		if(offline_for)
			return
		running = SHIELD_RUNNING
		regenerate_field()
		. = 1

	// Instantly drops the shield, but causes a cooldown before it may be started again. Also carries a risk of EMP at high charge.
	if(href_list["emergency_shutdown"])
		if(!running)
			return

		var/choice = input(usr, "Are you sure that you want to initiate an emergency shield shutdown? This will instantly drop the shield, and may result in unstable release of stored electromagnetic energy. Proceed at your own risk.") in list("Yes", "No")
		if((choice != "Yes") || !running)
			return

		var/temp_integrity = field_integrity()
		// If the shield would take 5 minutes to disperse and shut down using regular methods, it will take x2 (10 minutes) of this time to cool down after emergency shutdown
		offline_for = round(current_energy / (SHIELD_SHUTDOWN_DISPERSION_RATE / 2))
		shutdown_field()
		if(prob(temp_integrity - 50) * 1.75)
			spawn()
				empulse(src, 7, 14)
		. = 1

	if(mode_changes_locked)
		return 1

	if(href_list["set_range"])
		var/new_range = input(usr, "Enter new field range (1-[world.maxx]). Leave blank to cancel.", "Field Radius Control", field_radius) as num
		if(!new_range)
			return
		field_radius = between(1, new_range, world.maxx)
		regenerate_field()
		. = 1

	if(href_list["set_input_cap"])
		var/new_cap = round(input(usr, "Enter new input cap (in kW). Enter 0 or nothing to disable input cap.", "Generator Power Control", round(input_cap / 1000)) as num)
		if(!new_cap)
			input_cap = 0
			return
		input_cap = max(0, new_cap) * 1000
		. = 1

	if(href_list["toggle_mode"])
		// Toggling hacked-only modes requires the hacked var to be set to 1
		if((text2num(href_list["toggle_mode"]) & (MODEFLAG_BYPASS | MODEFLAG_OVERCHARGE)) && !hacked)
			return

		toggle_flag(text2num(href_list["toggle_mode"]))
		. = 1


/obj/machinery/power/shield_generator/proc/field_integrity()
	if(max_energy)
		return (current_energy / max_energy) * 100
	return 0


// Takes specific amount of damage
/obj/machinery/power/shield_generator/proc/take_damage(var/damage, var/shield_damtype)
	var/energy_to_use = damage * ENERGY_PER_HP
	if(check_flag(MODEFLAG_MODULATE))
		mitigation_em -= MITIGATION_HIT_LOSS
		mitigation_heat -= MITIGATION_HIT_LOSS
		mitigation_physical -= MITIGATION_HIT_LOSS

		switch(shield_damtype)
			if(SHIELD_DAMTYPE_PHYSICAL)
				mitigation_physical += MITIGATION_HIT_LOSS + MITIGATION_HIT_GAIN
				energy_to_use *= 1 - (mitigation_physical / 100)
			if(SHIELD_DAMTYPE_EM)
				mitigation_em += MITIGATION_HIT_LOSS + MITIGATION_HIT_GAIN
				energy_to_use *= 1 - (mitigation_em / 100)
			if(SHIELD_DAMTYPE_HEAT)
				mitigation_heat += MITIGATION_HIT_LOSS + MITIGATION_HIT_GAIN
				energy_to_use *= 1 - (mitigation_heat / 100)

		mitigation_em = between(0, mitigation_em, mitigation_max)
		mitigation_heat = between(0, mitigation_heat, mitigation_max)
		mitigation_physical = between(0, mitigation_physical, mitigation_max)

	current_energy -= energy_to_use

	// Overload the shield, which will shut it down until we recharge above 25% again
	if(current_energy < 0)
		energy_failure()
		return SHIELD_BREACHED_FAILURE

	if(prob(10 - field_integrity()))
		return SHIELD_BREACHED_CRITICAL
	if(prob(20 - field_integrity()))
		return SHIELD_BREACHED_MAJOR
	if(prob(35 - field_integrity()))
		return SHIELD_BREACHED_MINOR
	return SHIELD_ABSORBED


// Checks whether specific flags are enabled
/obj/machinery/power/shield_generator/proc/check_flag(var/flag)
	return (shield_modes & flag)


/obj/machinery/power/shield_generator/proc/toggle_flag(var/flag)
	shield_modes ^= flag
	update_upkeep_multiplier()
	for(var/obj/effect/shield/S in field_segments)
		S.flags_updated()

	if((flag & (MODEFLAG_HULL|MODEFLAG_MULTIZ)) && running)
		regenerate_field()

	if(flag & MODEFLAG_MODULATE)
		mitigation_em = 0
		mitigation_physical = 0
		mitigation_heat = 0


/obj/machinery/power/shield_generator/proc/get_flag_descriptions()
	var/list/all_flags = list()
	for(var/datum/shield_mode/SM in mode_list)
		if(SM.hacked_only && !hacked)
			continue
		all_flags.Add(list(list(
			"name" = SM.mode_name,
			"desc" = SM.mode_desc,
			"flag" = SM.mode_flag,
			"status" = check_flag(SM.mode_flag),
			"hacked" = SM.hacked_only,
			"multiplier" = SM.multiplier
		)))
	return all_flags


// These two procs determine tiles that should be shielded given the field range. They are quite CPU intensive and may trigger BYOND infinite loop checks, therefore they are set
// as background procs to prevent locking up the server. They are only called when the field is generated, or when hull mode is toggled on/off.
/obj/machinery/power/shield_generator/proc/fieldtype_square()
	set background = 1
	var/list/out = list()
	var/list/base_turfs = get_base_turfs()

	for(var/turf/gen_turf in base_turfs)
		var/turf/T
		for (var/x_offset = -field_radius; x_offset <= field_radius; x_offset++)
			T = locate(gen_turf.x + x_offset, gen_turf.y - field_radius, gen_turf.z)
			if(T)
				out += T
			T = locate(gen_turf.x + x_offset, gen_turf.y + field_radius, gen_turf.z)
			if(T)
				out += T

		for (var/y_offset = -field_radius+1; y_offset < field_radius; y_offset++)
			T = locate(gen_turf.x - field_radius, gen_turf.y + y_offset, gen_turf.z)
			if(T)
				out += T
			T = locate(gen_turf.x + field_radius, gen_turf.y + y_offset, gen_turf.z)
			if(T)
				out += T
	return out


/obj/machinery/power/shield_generator/proc/fieldtype_hull()
	set background = 1
	. = list()
	var/list/base_turfs = get_base_turfs()




	for(var/turf/gen_turf in base_turfs)
		for(var/turf/T in trange(field_radius, gen_turf))
			// Don't expand to space or on shuttle areas.
			if(istype(T, /turf/space) || istype(get_area(T), /area/space) || istype(get_area(T), /area/shuttle/))
				continue

			// Find adjacent space/shuttle tiles and cover them. Shuttles won't be blocked if shield diffuser is mapped in and turned on.
			for(var/turf/TN in orange(1, T))
				if(istype(TN, /turf/space) || (istype(get_area(TN), /area/shuttle/) && !istype(get_area(TN), /area/turbolift/)))
					. |= TN
					continue

// Returns a list of turfs from which a field will propagate. If multi-Z mode is enabled, this will return a "column" of turfs above and below the generator.
/obj/machinery/power/shield_generator/proc/get_base_turfs()
	var/list/turfs = list()
	var/turf/T = get_turf(src)

	if(!istype(T))
		return

	turfs.Add(T)

	// Multi-Z mode is disabled
	if(!check_flag(MODEFLAG_MULTIZ))
		return turfs

	while(HasAbove(T.z))
		T = GetAbove(T)
		if(istype(T))
			turfs.Add(T)

	T = get_turf(src)

	while(HasBelow(T.z))
		T = GetBelow(T)
		if(istype(T))
			turfs.Add(T)

	return turfs