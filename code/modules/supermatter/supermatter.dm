/*
	How to tweak the SM

	POWER_FACTOR		directly controls how much power the SM puts out at a given level of excitation (power var). Making this lower means you have to work the SM harder to get the same amount of power.
	CRITICAL_TEMPERATURE	The temperature at which the SM starts taking damage.

	CHARGING_FACTOR		Controls how much emitter shots excite the SM.
	DAMAGE_RATE_LIMIT	Controls the maximum rate at which the SM will take damage due to high temperatures.
*/

// Base variants are applied to everyone on the same Z level
// Range variants are applied on per-range basis: numbers here are on point blank, it scales with the map size (assumes square shaped Z levels)
#define DETONATION_RADS 40
#define DETONATION_MOB_CONCUSSION 4			// Value that will be used for Weaken() for mobs.

// Base amount of ticks for which a specific type of machine will be offline for. +- 20% added by RNG.
// This does pretty much the same thing as an electrical storm, it just affects the whole Z level instantly.
#define DETONATION_APC_OVERLOAD_PROB 10		// prob() of overloading an APC's lights.
#define DETONATION_SHUTDOWN_APC 120			// Regular APC.
#define DETONATION_SHUTDOWN_CRITAPC 10		// Critical APC. AI core and such. Considerably shorter as we don't want to kill the AI with a single blast. Still a nuisance.
#define DETONATION_SHUTDOWN_SMES 60			// SMES
#define DETONATION_SHUTDOWN_RNG_FACTOR 20	// RNG factor. Above shutdown times can be +- X%, where this setting is the percent. Do not set to 100 or more.
#define DETONATION_SOLAR_BREAK_CHANCE 60	// prob() of breaking solar arrays (this is per-panel, and only affects the Z level SM is on)

#define WARNING_DELAY 20			//seconds between warnings.

///SM Shutdown off. This is the phase during normal operation.
#define SHUTDOWN_PHASE_OFF 0
///Active SM shutdown, the SM is depowering rapidly and shedding lots of heat.
#define SHUTDOWN_PHASE_ONE 1
/// Final SM shutdown phase, it is holding in a non-reactive state where the setup can be safely modified.
#define SHUTDOWN_PHASE_TWO 2

/obj/machinery/power/supermatter
	name = "supermatter core"
	desc = "A strangely translucent and iridescent crystal. <span class='danger'>You get headaches just from looking at it.</span>"
	icon = 'icons/obj/machines/power/supermatter.dmi'
	icon_state = "supermatter"
	density = TRUE
	anchored = FALSE
	light_range = 4

	layer = ABOVE_HUMAN_LAYER

	var/nitrogen_retardation_factor = 0.15	//Higher == N2 slows reaction more
	var/thermal_release_modifier = 15000		//Higher == more heat released during reaction
	var/phoron_release_modifier = 1500		//Higher == less phoron released by reaction
	var/oxygen_release_modifier = 15000		//Higher == less oxygen released at high temperature/power
	var/radiation_release_modifier = 2      //Higher == more radiation released with more power.
	var/reaction_power_modifier =  1.1			//Higher == more overall power

	//Controls how much power is produced by each collector in range - this is the main parameter for tweaking SM balance, as it basically controls how the power variable relates to the rest of the game.
	var/power_factor = 1.0
	var/decay_factor = 700			//Affects how fast the supermatter power decays
	var/critical_temperature = 5000	//K
	var/charging_factor = 0.05
	var/damage_rate_limit = 4.5		//damage rate cap at power = 300, scales linearly with power

	var/gasefficency = 0.25

	var/base_icon_state = "supermatter"

	var/damage = 0
	var/damage_archived = 0
	var/safe_alert = "Crystaline hyperstructure returning to safe operating levels."
	var/safe_warned = 0
	var/public_alert = 0 //Stick to Engineering frequency except for big warnings when integrity bad
	var/warning_point = 100
	var/warning_alert = "Danger! Crystal hyperstructure instability!"
	var/emergency_point = 700
	var/emergency_alert = "CRYSTAL DELAMINATION IMMINENT."
	var/explosion_point = 1000
	var/shutdown_alert = "Supermatter shutdown sequence engaged."
	var/shutdown_phase_two_alert = "Shutdown sequence complete. Further reactions are now halted. Press shutdown button again to prepare for startup."
	var/shutdown_complete_alert = "Supermatter shutdown sequence terminated."
	var/shutdown_aborted_alert = "Supermatter shutdown sequence aborted. Hypermatrix integrity may be compromised."

	light_color = "#927a10"
	var/base_color = "#927a10"
	var/warning_color = "#c78c20"
	var/emergency_color = "#ffd04f"
	var/rotation_angle = 0

	var/grav_pulling = 0
	// Time in ticks between delamination ('exploding') and exploding (as in the actual boom)
	var/pull_time = 30 SECONDS
	var/explosion_power = 9

	var/emergency_issued = 0

	// Time in 1/10th of seconds since the last sent warning
	var/lastwarning = 0

	// This stops spawning redundant explosions. Also incidentally makes supermatter unexplodable if set to 1.
	var/exploded = 0

	var/power = 0
	var/oxygen = 0

	//Temporary values so that we can optimize this
	//How much the bullets damage should be multiplied by when it is added to the internal variables
	var/config_bullet_energy = 2
	//How much of the power is left after processing is finished?
//        var/config_power_reduction_per_tick = 0.5
	//How much hallucination should it produce per unit of power?
	var/config_hallucination_power = 0.1

	var/debug = 0

	var/disable_adminwarn = FALSE

	var/aw_normal = FALSE
	var/aw_warning = FALSE
	var/aw_danger = FALSE
	var/aw_emerg = FALSE
	var/aw_delam = FALSE
	var/aw_EPR = FALSE

	///Whether or not the shutdown process is currently active
	var/shutdown_phase = SHUTDOWN_PHASE_OFF
	/// The next time power/EER will tick down while the shutdown process is active
	var/next_shutdown_process_time = 0
	///Modifier to the amount of thermal energy added to the air around the SM during the shutdown phase. Higher = more energy, higher temperature
	var/shutdown_thermal_modifier = 3.5
	///Modifier to the rate of power decay during the shutdown phase. Higher = faster power loss
	var/shutdown_power_modifier = 0.15
	/// Set when the shutdown process starts. This is the power/EER at the moment the button is pressed, used to scale thermal energy release during shutdown.
	var/power_at_shutdown_start
	/// Time after which the shutdown can be aborted/terminated
	var/cooldown_time = 5 MINUTES
	///maximum temperature output during shutdown (kelvin)
	var/max_temperature_shutdown = 15000
	///How long the aborted phase will last when triggered
	var/aborted_phase_length = 2 MINUTES
	var/shutdown_aborted = FALSE
	var/last_shutdown_time = 0

	var/list/threshholds = list( // List of lists defining the amber/red labeling threshholds in readouts. Numbers are minminum red and amber and maximum amber and red, in that order
		list("name" = SUPERMATTER_DATA_EER,         "min_h" = -1, "min_l" = -1,  "max_l" = 1100,  "max_h" = 1300),
		list("name" = SUPERMATTER_DATA_TEMPERATURE, "min_h" = -1, "min_l" = -1,  "max_l" = 4000, "max_h" = 5000),
		list("name" = SUPERMATTER_DATA_PRESSURE,    "min_h" = -1, "min_l" = -1,  "max_l" = 5000, "max_h" = 10000),
		list("name" = SUPERMATTER_DATA_EPR,         "min_h" = -1, "min_l" = 1.0, "max_l" = 2.5,  "max_h" = 4.0)
	)

	uncreated_component_parts = list(
		/obj/item/stock_parts/radio/receiver,
		/obj/item/stock_parts/power/apc
	)
	public_methods = list(
		/singleton/public_access/public_method/supermatter_shutdown
	)
	stock_part_presets = list(/singleton/stock_part_preset/radio/receiver/supermatter_shutdown = 1)


/obj/machinery/power/supermatter/Destroy()
	GLOB.supermatter_status.raise_event(src, FALSE) //If any alarm was still reporting on this, tell them to stop
	return ..()

/obj/machinery/power/supermatter/proc/handle_admin_warnings()
	if(disable_adminwarn)
		return

	// Generic checks, similar to checks done by supermatter monitor program.
	aw_normal = status_adminwarn_check(SUPERMATTER_NORMAL, aw_normal, "INFO: Supermatter crystal has been energised", FALSE)
	aw_warning = status_adminwarn_check(SUPERMATTER_WARNING, aw_warning, "WARN: Supermatter crystal is taking integrity damage", FALSE)
	aw_danger = status_adminwarn_check(SUPERMATTER_DANGER, aw_danger, "WARN: Supermatter integrity is below 50%", TRUE)
	aw_emerg = status_adminwarn_check(SUPERMATTER_EMERGENCY, aw_emerg, "CRIT: Supermatter integrity is below 25%", FALSE)
	aw_delam = status_adminwarn_check(SUPERMATTER_DELAMINATING, aw_delam, "CRIT: Supermatter is delaminating", TRUE)

	// EPR check. Only runs when supermatter is energised. Triggers when there is very low amount of coolant in the core (less than one standard canister).
	// This usually means a core breach or deliberate venting.
	if(get_status() && (get_epr() < 0.5))
		if(!aw_EPR)
			var/area/A = get_area(src)
			log_and_message_admins("WARN: Supermatter EPR value low. Possible core breach detected in [A.name]", null, src)
		aw_EPR = TRUE
	else
		aw_EPR = FALSE

/obj/machinery/power/supermatter/proc/status_adminwarn_check(min_status, current_state, message, send_to_irc = FALSE)
	var/status = get_status()
	if(status >= min_status)
		if(!current_state)
			var/area/A = get_area(src)
			log_and_message_admins(message + " in [A.name]", null, src)
			if(send_to_irc)
				send_to_admin_discord(message + " in [A.name]")
		return TRUE
	else
		return FALSE

/obj/machinery/power/supermatter/proc/get_epr()
	var/turf/T = get_turf(src)
	if(!istype(T))
		return
	var/datum/gas_mixture/air = T.return_air()
	if(!air)
		return 0
	return round((air.total_moles / air.group_multiplier) / 23.1, 0.01)

/obj/machinery/power/supermatter/proc/get_status()
	var/turf/T = get_turf(src)
	if(!T)
		return SUPERMATTER_ERROR
	var/datum/gas_mixture/air = T.return_air()
	if(!air)
		return SUPERMATTER_ERROR

	if(grav_pulling || exploded)
		return SUPERMATTER_DELAMINATING

	if(get_integrity() < 25)
		return SUPERMATTER_EMERGENCY

	if(get_integrity() < 50)
		return SUPERMATTER_DANGER

	if((get_integrity() < 100) || (air.temperature > critical_temperature))
		return SUPERMATTER_WARNING

	if(power > 5)
		return SUPERMATTER_NORMAL
	return SUPERMATTER_INACTIVE


/obj/machinery/power/supermatter/proc/explode()
	set waitfor = 0

	if(exploded)
		return

	log_and_message_admins("Supermatter delaminating at [x] [y] [z]", null, src)
	anchored = TRUE
	grav_pulling = 1
	exploded = 1
	sleep(pull_time)
	var/turf/TS = get_turf(src)		// The turf supermatter is on. SM being in a locker, exosuit, or other container shouldn't block it's effects that way.
	if(!istype(TS))
		return

	var/list/affected_z = GetConnectedZlevels(TS.z)

	// Effect 1: Radiation, weakening to all mobs on Z level
	for(var/z in affected_z)
		SSradiation.z_radiate(locate(1, 1, z), DETONATION_RADS, 1)

	for(var/mob/living/mob in GLOB.alive_mobs)
		var/turf/TM = get_turf(mob)
		if(!TM)
			continue
		if(!(TM.z in affected_z))
			continue

		mob.Weaken(DETONATION_MOB_CONCUSSION)
		to_chat(mob, SPAN_DANGER("An invisible force slams you against the ground!"))

	// Effect 2: Z-level wide electrical pulse
	for(var/obj/machinery/power/apc/A as anything in MACHINES_OF(/obj/machinery/power/apc))
		if(!(A.z in affected_z))
			continue

		// Overloads lights
		if(prob(DETONATION_APC_OVERLOAD_PROB))
			A.overload_lighting()
		// Causes the APCs to go into system failure mode.
		var/random_change = rand(100 - DETONATION_SHUTDOWN_RNG_FACTOR, 100 + DETONATION_SHUTDOWN_RNG_FACTOR) / 100
		if(A.is_critical)
			A.energy_fail(round(DETONATION_SHUTDOWN_CRITAPC * random_change))
		else
			A.energy_fail(round(DETONATION_SHUTDOWN_APC * random_change))

	for(var/obj/machinery/power/smes/buildable/S as anything in MACHINES_OF(/obj/machinery/power/smes/buildable))
		if(!(S.z in affected_z))
			continue
		// Causes SMESes to shut down for a bit
		var/random_change = rand(100 - DETONATION_SHUTDOWN_RNG_FACTOR, 100 + DETONATION_SHUTDOWN_RNG_FACTOR) / 100
		S.energy_fail(round(DETONATION_SHUTDOWN_SMES * random_change))

	// Effect 3: Break solar arrays

	for(var/obj/machinery/power/solar/S as anything in MACHINES_OF(/obj/machinery/power/solar))
		if(!(S.z in affected_z))
			continue
		if(prob(DETONATION_SOLAR_BREAK_CHANCE))
			S.set_broken(TRUE)



	// Effect 4: Medium scale explosion
	spawn(0)
		explosion(TS, explosion_power * 3.5)
		qdel(src)

/obj/machinery/power/supermatter/examine(mob/user)
	. = ..()
	if(user.skill_check(SKILL_ENGINES, SKILL_EXPERIENCED))
		var/integrity_message
		switch(get_integrity())
			if(0 to 30)
				integrity_message = SPAN_DANGER("It looks highly unstable!")
			if(31 to 70)
				integrity_message = "It appears to be losing cohesion!"
			else
				integrity_message = "At a glance, it seems to be in sound shape."
		to_chat(user, integrity_message)
		if(user.skill_check(SKILL_ENGINES, SKILL_MASTER))
			var/display_power = power
			display_power *= (0.85 + 0.3 * rand())
			display_power = round(display_power, 20)
			to_chat(user, "Eyeballing it, you place the relative EER at around [display_power] MeV/cm3.")

//Changes color and luminosity of the light to these values if they were not already set
/obj/machinery/power/supermatter/proc/shift_light(lum, clr)
	if(lum != light_range || clr != light_color)
		set_light(lum, 1, l_color = clr)

/obj/machinery/power/supermatter/proc/get_integrity()
	var/integrity = damage / explosion_point
	integrity = round(100 - integrity * 100)
	integrity = integrity < 0 ? 0 : integrity
	return integrity


/obj/machinery/power/supermatter/proc/announce_warning()
	var/integrity = get_integrity()
	var/alert_msg = " Integrity at [integrity]%"

	if(damage > emergency_point)
		alert_msg = emergency_alert + alert_msg
		lastwarning = world.timeofday - WARNING_DELAY * 4
	else if(damage >= damage_archived) // The damage is still going up
		safe_warned = 0
		alert_msg = warning_alert + alert_msg
		lastwarning = world.timeofday
	else if(!safe_warned)
		safe_warned = 1 // We are safe, warn only once
		alert_msg = safe_alert
		lastwarning = world.timeofday
	else
		alert_msg = null
	if(alert_msg)
		GLOB.global_announcer.autosay(alert_msg, "Supermatter Monitor", "Engineering")
		//Public alerts
		if((damage > emergency_point) && !public_alert)
			GLOB.global_announcer.autosay("WARNING: SUPERMATTER CRYSTAL DELAMINATION IMMINENT! SAFEROOMS UNBOLTED.", "Supermatter Monitor")
			public_alert = 1
			GLOB.using_map.unbolt_saferooms() // torch
			for(var/mob/M in GLOB.player_list)
				var/turf/T = get_turf(M)
				if(T && (T.z in GLOB.using_map.station_levels) && !istype(M,/mob/new_player) && !isdeaf(M))
					sound_to(M, 'sound/ambience/matteralarm.ogg')
		else if(safe_warned && public_alert)
			GLOB.global_announcer.autosay(alert_msg, "Supermatter Monitor")
			public_alert = 0

/obj/machinery/power/supermatter/Process()
	var/turf/L = loc

	if(isnull(L))		// We have a null turf...something is wrong, stop processing this entity.
		return PROCESS_KILL

	if(!istype(L)) 	//We are in a crate or somewhere that isn't turf, if we return to turf resume processing but for now.
		return  //Yeah just stop.

	if(damage > explosion_point)
		if(!exploded)
			if(!istype(L, /turf/space) && (L.z in GLOB.using_map.station_levels))
				announce_warning()
			explode()
	else if(damage > warning_point) // while the core is still damaged and it's still worth noting its status
		shift_light(5, warning_color)
		if(damage > emergency_point)
			shift_light(7, emergency_color)
		if(!istype(L, /turf/space) && ((world.timeofday - lastwarning) >= WARNING_DELAY * 10) && (L.z in GLOB.using_map.station_levels))
			announce_warning()
	else
		shift_light(4,base_color)
	if(grav_pulling)
		supermatter_pull(src)

	//Send state changed events
	if (damage > warning_point)
		if (damage > damage_archived && damage_archived < warning_point)
			GLOB.supermatter_status.raise_event(src, TRUE)
	if (damage < warning_point)
		if (damage < damage_archived && damage_archived > warning_point)
			GLOB.supermatter_status.raise_event(src, FALSE)

	//Ok, get the air from the turf
	var/datum/gas_mixture/removed = null
	var/datum/gas_mixture/env = null

	//ensure that damage doesn't increase too quickly due to super high temperatures resulting from no coolant, for example. We don't want the SM exploding before anyone can react.
	//We want the cap to scale linearly with power (and explosion_point). Let's aim for a cap of 5 at power = 300 (based on testing, equals roughly 5% per SM alert announcement).
	var/damage_inc_limit = (power/300)*(explosion_point/1000)*damage_rate_limit

	if(!istype(L, /turf/space))
		env = L.return_air()
		removed = env.remove(gasefficency * env.total_moles)	//Remove gas from surrounding area

	if(!env || !removed || !removed.total_moles)
		damage_archived = damage
		damage += max((power - 15*power_factor)/10, 0)
	else if (grav_pulling) //If supermatter is detonating, remove all air from the zone
		env.remove(env.total_moles)
	else
		damage_archived = damage
		damage = max(0, damage + clamp((removed.temperature - critical_temperature) / (shutdown_phase ? 50 : 150), -damage_rate_limit, damage_inc_limit))

		if (shutdown_phase == SHUTDOWN_PHASE_ONE && (next_shutdown_process_time < world.time))
			if (get_rads(loc) < ((power * 1.5) * radiation_release_modifier))
				SSradiation.radiate(src, (power * 1.5) * radiation_release_modifier)
			if (!(shutdown_phase == SHUTDOWN_PHASE_TWO))
				power = power - shutdown_power_modifier * (power - (power * 0.025) ** 2 + 10)
			if (power <= 0.05)
				shutdown_phase = SHUTDOWN_PHASE_TWO
				power = 0
				charging_factor = 0.01
				power_factor = 3
				damage_rate_limit = 20
				thermal_release_modifier = initial(thermal_release_modifier) * 5
				radiation_release_modifier = radiation_release_modifier * 45
				GLOB.global_announcer.autosay(shutdown_phase_two_alert, "Supermatter Monitor", "Engineering")
			next_shutdown_process_time = world.time + 1 SECOND

		//Ok, 100% oxygen atmosphere = best reaction
		//Maxes out at 100% oxygen pressure
		oxygen = clamp((removed.get_by_flag(XGM_GAS_OXIDIZER) - (removed.gas[GAS_NITROGEN] * nitrogen_retardation_factor)) / removed.total_moles, 0, 1)

		//calculate power gain for oxygen reaction
		var/temp_factor
		var/equilibrium_power
		if (oxygen > 0.8)
			//If chain reacting at oxygen == 1, we want the power at 800 K to stabilize at a power level of 400
			equilibrium_power = 400
			icon_state = "[base_icon_state]_glow"
		else
			//If chain reacting at oxygen == 1, we want the power at 800 K to stabilize at a power level of 250
			equilibrium_power = 250
			icon_state = base_icon_state

		temp_factor = ( (equilibrium_power/decay_factor)**3 )/800
		if (!(shutdown_phase == SHUTDOWN_PHASE_TWO))
			power = max( (removed.temperature * temp_factor) * oxygen + power, 0)

		var/device_energy = power * reaction_power_modifier

		//Release reaction gasses
		var/heat_capacity = removed.heat_capacity()
		removed.adjust_multi(GAS_PHORON, max(device_energy / phoron_release_modifier, 0), \
							GAS_OXYGEN, max((device_energy + removed.temperature - T0C) / oxygen_release_modifier, 0))

		var/thermal_power = thermal_release_modifier * device_energy
		if (debug)
			var/heat_capacity_new = removed.heat_capacity()
			visible_message("[src]: Releasing [round(thermal_power)] W.")
			visible_message("[src]: Releasing additional [round((heat_capacity_new - heat_capacity)*removed.temperature)] W with exhaust gasses.")

		var/current_thermal_modifier = shutdown_phase ? shutdown_thermal_modifier : 1
		if (power_at_shutdown_start) //if we're above roughly 1600 eer then the reaction will build rapidly during shutdown and be catastrophic if not stopped
			current_thermal_modifier = current_thermal_modifier * (power_at_shutdown_start / 500) + power
		removed.add_thermal_energy(thermal_power * current_thermal_modifier)
		removed.temperature = clamp(removed.temperature, 0, shutdown_phase ? max_temperature_shutdown : 10000)

		env.merge(removed)

	for(var/mob/living/carbon/human/subject in view(src, min(7, round(sqrt(power/6)))))
		var/obj/item/organ/internal/eyes/eyes = subject.internal_organs_by_name[BP_EYES]
		if (!eyes)
			continue
		if (BP_IS_ROBOTIC(eyes))
			continue
		if(subject.has_meson_effect())
			continue
		var/effect = max(0, min(200, power * config_hallucination_power * sqrt( 1 / max(1,get_dist(subject, src)))) )
		subject.adjust_hallucination(effect, 0.25 * effect)

	var/level = Interpolate(0, 50, clamp( (damage - emergency_point) / (explosion_point - emergency_point),0,1))
	var/list/new_color = color_contrast(level )
	//Apply visual effects based on damage
	if(rotation_angle != 0)
		if(level != 0)
			new_color = multiply_matrices(new_color, color_rotation(rotation_angle), 4, 3,3)
		else
			new_color = color_rotation(rotation_angle)

	color = new_color

	if (damage >= emergency_point && !length(filters))
		filters = filter(type="rays", size = 64, color = "#ffd04f", factor = 0.6, density = 12)
		animate(filters[1], time = 10 SECONDS, offset = 10, loop=-1)
		animate(time = 10 SECONDS, offset = 0, loop=-1)

		animate(filters[1], time = 2 SECONDS, size = 80, loop=-1, flags = ANIMATION_PARALLEL)
		animate(time = 2 SECONDS, size = 10, loop=-1, flags = ANIMATION_PARALLEL)
	else if (damage < emergency_point)
		filters = null

	if (get_rads(loc) < (power * radiation_release_modifier))
		SSradiation.radiate(src, power * radiation_release_modifier) //Better close those shutters!
	power -= (power/decay_factor)**3		//energy losses due to radiation
	handle_admin_warnings()

	return 1


/obj/machinery/power/supermatter/bullet_act(obj/item/projectile/Proj)
	var/turf/L = loc
	if(!istype(L))		// We don't run process() when we are in space
		return 0	// This stops people from being able to really power up the supermatter
				// Then bring it inside to explode instantly upon landing on a valid turf.


	var/proj_damage = Proj.get_structure_damage()
	if(istype(Proj, /obj/item/projectile/beam))
		if (shutdown_phase >= SHUTDOWN_PHASE_ONE)
			damage += 100
		power += proj_damage * config_bullet_energy	* charging_factor / power_factor
	else
		damage += proj_damage * config_bullet_energy
	return 0

/obj/machinery/power/supermatter/attack_robot(mob/user as mob)
	if(Adjacent(user))
		return attack_hand(user)
	else
		ui_interact(user)
	return

/obj/machinery/power/supermatter/attack_ai(mob/user)
	ui_interact(user)

/obj/machinery/power/supermatter/attack_ghost(mob/user)
	ui_interact(user)

/obj/machinery/power/supermatter/attack_hand(mob/user as mob)
	var/datum/pronouns/pronouns = user.choose_from_pronouns()
	user.visible_message(
		SPAN_WARNING("\The [user] reaches out and touches \the [src], inducing a resonance. For a brief instant, [pronouns.his] body glows brilliantly, then flashes into ash."),
		SPAN_DANGER(FONT_LARGE("You reach out and touch \the [src]. Instantly, you feel a curious sensation as your body turns into new and exciting forms of plasma. That was not a wise decision.")),
		SPAN_WARNING("You hear an unearthly ringing, then what sounds like a shrilling kettle as you are washed with a wave of heat.")
	)
	Consume(user)

// This is purely informational UI that may be accessed by AIs or robots
/obj/machinery/power/supermatter/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1)
	var/data = list()

	data["integrity_percentage"] = round(get_integrity())
	var/datum/gas_mixture/env = null
	var/turf/T = get_turf(src)

	if(istype(T))
		env = T.return_air()

	if(!env)
		data["ambient_temp"] = 0
		data["ambient_pressure"] = 0
	else
		data["ambient_temp"] = round(env.temperature)
		data["ambient_pressure"] = round(env.return_pressure())
	data["detonating"] = grav_pulling
	data["energy"] = power

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "supermatter_crystal.tmpl", "Supermatter Crystal", 500, 300)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)


/obj/machinery/power/supermatter/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(istype(W, /obj/item/tape_roll))
		to_chat(user, SPAN_NOTICE("You repair some of the damage to \the [src] with \the [W]."))
		damage = max(damage - 10, 0)
		playsound(src, 'sound/effects/tape.ogg', 25)


	if (istype(W, /obj/item/device/multitool))
		if (!user.skill_check(SKILL_ENGINES, SKILL_EXPERIENCED) && !prob(5))
			if (issilicon(user))
				user.visible_message(
					SPAN_DANGER("\The [user] fumbles \the [W], and it sparks against \the [src], causing it to flash into dust!"),
					SPAN_DANGER("You fumble \the [W], and it sparks against \the [src]. Your vision floods with static as you flash into dust!")
				)
				Consume(user)
				return TRUE
			var/mob/living/carbon/human/victim = user
			if (prob(25))
				if (victim.gloves)
					victim.visible_message(
						SPAN_DANGER("\The [victim] fumbles \the [W], and their [victim.gloves.name] graze \the [src] and turn to dust!"),
						SPAN_DANGER("You fumble \the [W], and your [victim.gloves.name] graze \the [src] - turning them to dust and burning your hands!")
					)
					qdel(victim.gloves)
					victim.apply_damage(25, DAMAGE_BURN, BP_L_HAND)
					victim.apply_damage(25, DAMAGE_BURN, BP_R_HAND)
					return TRUE
			if (prob(50) && !victim.gloves)
				victim.visible_message(
					SPAN_DANGER("\The [victim] makes one wrong move with \the [W], and their bare hands graze \the [src], turning them to ash!"),
					SPAN_DANGER("You make one wrong move with \the [W], causing your bare hands to graze \the [src], and suddenly wish you had remembered your gloves as you turn to ash.")
				)
				Consume(victim)
				return TRUE
			user.visible_message(
				SPAN_DANGER("\The [victim] slips with \the [W], but manages to avoid any contact with \the [src]."),
				SPAN_DANGER("You slip with \the [W], just barely avoiding contact with \the [src]!")
			)
			return TRUE

		var/tag = input(user, "Enter the tag to apply to the supermatter. This should match the tag on the shutdown button.", "Enter Tag", "supermatter_crystal") as null | text
		if (!tag)
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] uses \the [W] to set the tag on \the [src]."),
			SPAN_NOTICE("You set the tag on \the [src] with \the [W] to '[tag]'.")
		)
		playsound(src, 'sound/machines/click.ogg', 25)
		id_tag = tag
		return TRUE

	user.visible_message(
		SPAN_WARNING("\The [user] touches \a [W] to \the [src], then flinches away as it flashes instantly into dust. Silence blankets the air."),
		SPAN_DANGER("You touch \the [W] to \the [src]. Everything suddenly goes silent as it flashes into dust, and you flinch away."),
		SPAN_WARNING("For a brief moment, you hear an oppressive, unnatural silence.")
	)

	user.apply_damage(150, DAMAGE_RADIATION, damage_flags = DAMAGE_FLAG_DISPERSED)
	if (user.drop_from_inventory(W))
		Consume(W)
		return TRUE

	return ..()


/obj/machinery/power/supermatter/Bumped(atom/AM as mob|obj)
	if(istype(AM, /obj/effect))
		return
	if(istype(AM, /mob/living))
		var/mob/victim = AM
		var/datum/pronouns/pronouns = victim.choose_from_pronouns()
		AM.visible_message(
			SPAN_WARNING("\The [AM] slams into \the [src], inducing a resonance. For a brief instant, [pronouns.his] body glows brilliantly, then flashes into ash."),
			SPAN_DANGER(FONT_LARGE("You slam into \the [src], and your mind fills with unearthly shrieking. Your vision floods with light as your body instantly dissolves into dust.")),
			SPAN_WARNING("You hear an unearthly ringing, then what sounds like a shrilling kettle as you are washed with a wave of heat.")
		)
	else if(!grav_pulling) //To prevent spam, detonating supermatter does not indicate non-mobs being destroyed
		AM.visible_message(
			SPAN_WARNING("\The [AM] smacks into \the [src] and rapidly flashes to ash."),
			SPAN_WARNING("You hear a loud crack as you are washed with a wave of heat.")
		)

	Consume(AM)


/obj/machinery/power/supermatter/proc/Consume(mob/living/user)
	if(istype(user))
		user.dust()
		power += 200
	else
		qdel(user)

	power += 200

	//Some poor sod got eaten, go ahead and irradiate people nearby.
	for(var/mob/living/l in range(10))
		if(l in view())
			to_chat(l, SPAN_WARNING("As \the [src] slowly stops resonating, you feel an intense wave of heat wash over you."))
		else
			to_chat(l, SPAN_WARNING("You hear a muffled, shrill ringing as an intense wave of heat washes over you."))
	var/rads = 500
	if (get_rads(loc) < rads) //prevent rads from being reduced if they're already above 500
		SSradiation.radiate(src, rads)


/proc/supermatter_pull(atom/target, pull_range = 255, pull_power = STAGE_FIVE)
	for(var/atom/A in range(pull_range, target))
		A.singularity_pull(target, pull_power)

/obj/machinery/power/supermatter/GotoAirflowDest(n) //Supermatter not pushed around by airflow
	return

/obj/machinery/power/supermatter/RepelAirflowDest(n)
	return

/obj/machinery/power/supermatter/ex_act(severity)
	// not calling parent ex_act as it has a chance to qdel the supermatter
	switch(severity)
		if(EX_ACT_DEVASTATING)
			power *= 4
		if(EX_ACT_HEAVY)
			power *= 3
		if(EX_ACT_LIGHT)
			power *= 2
	log_and_message_admins("WARN: Explosion near the Supermatter! New EER: [power].", null, src)

/obj/machinery/power/supermatter/shard //Small subtype, less efficient and more sensitive, but less boom.
	name = "supermatter shard"
	desc = "A strangely translucent and iridescent crystal that looks like it used to be part of a larger structure. <span class='danger'>You get headaches just from looking at it.</span>"
	icon_state = "darkmatter_shard"
	base_icon_state = "darkmatter_shard"

	warning_point = 50
	emergency_point = 400
	explosion_point = 600

	gasefficency = 0.125

	pull_time = 150
	explosion_power = 3

/obj/machinery/power/supermatter/shard/announce_warning() //Shards don't get announcements
	return


/obj/machinery/power/supermatter/randomsample
	name = "experimental supermatter sample"
	icon_state = "darkmatter_shard"
	base_icon_state = "darkmatter_shard"

/obj/machinery/power/supermatter/randomsample/Initialize()
	. = ..()
	nitrogen_retardation_factor = frand(0.01, 1)	//Higher == N2 slows reaction more
	thermal_release_modifier = rand(100, 1000000)		//Higher == more heat released during reaction
	phoron_release_modifier = rand(0, 100000)		//Higher == less phoron released by reaction
	oxygen_release_modifier = rand(0, 100000)		//Higher == less oxygen released at high temperature/power
	radiation_release_modifier = rand(0, 100)    //Higher == more radiation released with more power.
	reaction_power_modifier =  rand(0, 100)			//Higher == more overall power

	power_factor = rand(0, 20)
	decay_factor = rand(50, 70000)			//Affects how fast the supermatter power decays
	critical_temperature = rand(3000, 5000)	//K
	charging_factor = rand(0, 1)
	damage_rate_limit = rand( 1, 10)		//damage rate cap at power = 300, scales linearly with power

	//Change fune colours
	var/angle = rand(-180, 180)
	var/list/color_matrix = color_rotation(angle)
	rotation_angle = angle

	color = color_matrix

	var/HSV = RGBtoHSV(base_color)
	var/RGB = HSVtoRGB(RotateHue(HSV, angle))
	base_color = RGB

	HSV = RGBtoHSV(warning_color)
	RGB = HSVtoRGB(RotateHue(HSV, angle))
	warning_color = RGB

	HSV = RGBtoHSV(emergency_color)
	RGB = HSVtoRGB(RotateHue(HSV, angle))
	emergency_color = RGB

/obj/machinery/power/supermatter/inert
	name = "experimental supermatter sample"
	icon_state = "darkmatter_shard"
	base_icon_state = "darkmatter_shard"
	thermal_release_modifier = 0 //Basically inert
	phoron_release_modifier = 100000000000
	oxygen_release_modifier = 100000000000
	radiation_release_modifier = 1

/obj/structure/closet/crate/secure/large/phoron/experimentalsm
	name = "experimental supermatter crate"
	desc = "Are you sure you want to open this?"

/obj/structure/closet/crate/secure/large/phoron/experimentalsm/WillContain()
	return list(/obj/machinery/power/supermatter/randomsample)

#undef DETONATION_MOB_CONCUSSION
#undef DETONATION_APC_OVERLOAD_PROB
#undef DETONATION_SHUTDOWN_APC
#undef DETONATION_SHUTDOWN_CRITAPC
#undef DETONATION_SHUTDOWN_SMES
#undef DETONATION_SHUTDOWN_RNG_FACTOR
#undef DETONATION_SOLAR_BREAK_CHANCE
#undef WARNING_DELAY


//Warning lights
/obj/machinery/rotating_alarm/supermatter
	name = "supermatter alarm"
	desc = "An industrial rotating alarm light. This one is used to monitor supermatter engines."

	frame_type = /obj/item/frame/supermatter_alarm
	construct_state = /singleton/machine_construction/default/item_chassis
	base_type = /obj/machinery/rotating_alarm/supermatter

	angle = 15
	sound_file = 'sound/obj/machinery/rotating_alarm/supermatter.ogg'

/obj/machinery/rotating_alarm/supermatter/Initialize()
	. = ..()
	GLOB.supermatter_status.register_global(src, PROC_REF(check_supermatter))

/obj/machinery/rotating_alarm/supermatter/Destroy()
	GLOB.supermatter_status.unregister_global(src, PROC_REF(check_supermatter))
	. = ..()

/obj/machinery/rotating_alarm/supermatter/proc/check_supermatter(obj/machinery/power/supermatter/SM, danger)
	if (SM)
		if (SM.z in GetConnectedZlevels(src.z))
			if (danger && !on)
				set_on()
			else if (!danger && on)
				set_off()

/obj/machinery/button/alternate/sm_shutdown
	name = "Supermatter Shutdown"
	desc = "A large red button labeled 'EMERGENCY SUPERMATTER SHUTDOWN'. You should probably read the accompanying instructions before pressing it."

/singleton/public_access/public_method/supermatter_shutdown
	call_proc = TYPE_PROC_REF(/obj/machinery/power/supermatter, shutdown_sm)

/singleton/stock_part_preset/radio/receiver/supermatter_shutdown
	frequency = BUTTON_FREQ
	receive_and_call = list("button_active" = /singleton/public_access/public_method/supermatter_shutdown)

/turf/simulated/floor/greengrid/sm
	desc = "Extremely advanced circuitry embedded into the floor designed to interface with a supermatter crystal."

/obj/machinery/power/supermatter/proc/shutdown_sm()
	if ((cooldown_time + last_shutdown_time) > world.time)
		return

	//first stage shutdown
	if (shutdown_phase == SHUTDOWN_PHASE_OFF && istype(get_turf(src), /turf/simulated/floor/greengrid/sm))
		shutdown_phase = SHUTDOWN_PHASE_ONE
		GLOB.global_announcer.autosay(shutdown_alert, "Supermatter Monitor", "Engineering")
		if (get_rads(loc) < (power * 2 * radiation_release_modifier))
			SSradiation.radiate(loc, power * 2 * radiation_release_modifier)
		for(var/turf/simulated/floor/greengrid/sm/sm_turf in oview(2, src))
			sm_turf.icon_state = "rcircuitanim"

		radiation_release_modifier = (power / 10)
		thermal_release_modifier = thermal_release_modifier * (power / 250)
		power_at_shutdown_start = power
		return

	//shutdown aborted before second stage could start
	if (shutdown_phase == SHUTDOWN_PHASE_ONE)
		radiation_release_modifier = 50 * radiation_release_modifier
		shutdown_phase = SHUTDOWN_PHASE_OFF
		shutdown_aborted = TRUE
		var/obj/effect/warp/small/warpeffect = new(get_turf(src))
				//effect and sound
		warpeffect.SetTransform(scale = 0)
		warpeffect.alpha = 255
		animate(
			warpeffect,
			transform = matrix(),
			alpha = 0,
			time = 1.25 SECONDS
		)
		addtimer(new Callback(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), warpeffect), 1.25 SECONDS)
		playsound(warpeffect, 'sound/effects/heavy_cannon_blast.ogg', 50, 1)

		var/list/atoms = list()
		if(isturf(src))
			atoms = range(src, 6)
		else
			atoms = orange(src, 6)
		for(var/atom/movable/A in atoms)
			if(A.anchored || !A.simulated) continue
			A.throw_at(get_edge_target_turf(A,get_dir(src, A)),10,5)
		addtimer(new Callback(src, PROC_REF(end_abort_phase)), aborted_phase_length)
		GLOB.global_announcer.autosay(shutdown_aborted_alert, "Supermatter Monitor", "Engineering")
		for (var/turf/simulated/floor/greengrid/sm/T in oview(2, src))
			T.icon_state = "gcircuit"

	//end shutdown sequence after second stage, returns SM to normal
	if (shutdown_phase == SHUTDOWN_PHASE_TWO)
		if (power <= 0.01)
			power = 0
		shutdown_phase = SHUTDOWN_PHASE_OFF
		GLOB.global_announcer.autosay(shutdown_complete_alert, "Supermatter Monitor", "Engineering")
		for (var/turf/simulated/floor/greengrid/sm/T in oview(2, src))
			T.icon_state = "gcircuit"
		last_shutdown_time = world.time

	radiation_release_modifier = initial(radiation_release_modifier)
	thermal_release_modifier = initial(thermal_release_modifier)
	power_at_shutdown_start = 0
	charging_factor = initial(charging_factor)
	power_factor = initial(power_factor)
	damage_rate_limit = initial(damage_rate_limit)

/obj/machinery/power/supermatter/proc/end_abort_phase()
	radiation_release_modifier = initial(radiation_release_modifier)
	shutdown_aborted = FALSE

/obj/machinery/power/supermatter/proc/get_phase()
	if (shutdown_phase == SHUTDOWN_PHASE_OFF)
		return SPAN_GOOD("READY")
	else if (shutdown_phase == SHUTDOWN_PHASE_ONE)
		return SPAN_AVERAGE("SHUTTING DOWN")
	else if (shutdown_phase == SHUTDOWN_PHASE_TWO)
		return SPAN_AVERAGE("STANDBY")
