/singleton/security_state
	// When defining any of these values type paths should be used, not instances. Instances will be acquired in /New()

	var/singleton/security_level/severe_security_level // At which security level (and higher) the use of nuclear fission devices and other extreme measures are allowed. Defaults to the last entry in all_security_levels if unset.
	var/singleton/security_level/high_security_level   // At which security level (and higher) transfer votes are disabled, ERT may be requested, and other similar high alert implications. Defaults to the second to last entry in all_security_levels if unset.
	// All security levels within the above convention: Low, Guarded, Elevated, High, Severe


	// Under normal conditions the crew may not raise the current security level higher than the highest_standard_security_level
	// The crew may also not adjust the security level once it is above the highest_standard_security_level.
	// Defaults to the second to last entry in all_security_levels if unset/null.
	// Set to FALSE/0 if there should be no restrictions.
	var/singleton/security_level/highest_standard_security_level

	var/singleton/security_level/current_security_level  // The current security level. Defaults to the first entry in all_security_levels if unset.
	var/singleton/security_level/stored_security_level   // The security level that we are escalating to high security from - we will return to this level once we choose to revert.
	var/list/all_security_levels                    // List of all available security levels
	var/list/standard_security_levels               // List of all normally selectable security levels
	var/list/comm_console_security_levels           // List of all selectable security levels for the command and communication console - basically standard_security_levels - 1

/singleton/security_state/New()
	// Setup the severe security level
	if(!(severe_security_level in all_security_levels))
		severe_security_level = all_security_levels[length(all_security_levels)]
	severe_security_level = GET_SINGLETON(severe_security_level)

	// Setup the high security level
	if(!(high_security_level in all_security_levels))
		high_security_level = all_security_levels[length(all_security_levels) - 1]
	high_security_level = GET_SINGLETON(high_security_level)

	// Setup the highest standard security level
	if(highest_standard_security_level || isnull(highest_standard_security_level))
		if(!(highest_standard_security_level in all_security_levels))
			highest_standard_security_level = all_security_levels[length(all_security_levels) - 1]
		highest_standard_security_level = GET_SINGLETON(highest_standard_security_level)
	else
		highest_standard_security_level = null

	// Setup the current security level
	if(current_security_level in all_security_levels)
		current_security_level = GET_SINGLETON(current_security_level)
	else
		current_security_level = GET_SINGLETON(all_security_levels[1])

	// Setup the full list of available security levels now that we no longer need to use "x in all_security_levels"
	var/list/security_level_instances = list()
	for(var/security_level_type in all_security_levels)
		security_level_instances += GET_SINGLETON(security_level_type)
	all_security_levels = security_level_instances

	standard_security_levels = list()
	// Setup the list of normally selectable security levels
	for(var/security_level in all_security_levels)
		standard_security_levels += security_level
		if(security_level == highest_standard_security_level)
			break

	comm_console_security_levels = list()
	// Setup the list of selectable security levels available in the comm. console
	for(var/security_level in all_security_levels)
		if(security_level == highest_standard_security_level)
			break
		comm_console_security_levels += security_level

	// Now we ensure the high security level is not above the severe one (but we allow them to be equal)
	var/severe_index = all_security_levels.Find(severe_security_level)
	var/high_index = all_security_levels.Find(high_security_level)
	if(high_index > severe_index)
		high_security_level = severe_security_level

/singleton/security_state/Initialize()
	// Finally switch up to the default starting security level.
	current_security_level.switching_up_to()
	. = ..()

/singleton/security_state/proc/can_change_security_level()
	return current_security_level in standard_security_levels

/singleton/security_state/proc/can_switch_to(given_security_level)
	if(!can_change_security_level())
		return FALSE
	return given_security_level in standard_security_levels

/singleton/security_state/proc/current_security_level_is_lower_than(given_security_level)
	var/current_index = all_security_levels.Find(current_security_level)
	var/given_index   = all_security_levels.Find(given_security_level)

	return given_index && current_index < given_index

/singleton/security_state/proc/current_security_level_is_same_or_higher_than(given_security_level)
	var/current_index = all_security_levels.Find(current_security_level)
	var/given_index   = all_security_levels.Find(given_security_level)

	return given_index && current_index >= given_index

/singleton/security_state/proc/current_security_level_is_higher_than(given_security_level)
	var/current_index = all_security_levels.Find(current_security_level)
	var/given_index   = all_security_levels.Find(given_security_level)

	return given_index && current_index > given_index

/singleton/security_state/proc/set_security_level(singleton/security_level/new_security_level, force_change = FALSE)
	if(new_security_level == current_security_level)
		return FALSE
	if(!(new_security_level in all_security_levels))
		return FALSE
	if(!force_change && !can_switch_to(new_security_level))
		return FALSE

	var/singleton/security_level/previous_security_level = current_security_level
	current_security_level = new_security_level

	var/previous_index = all_security_levels.Find(previous_security_level)
	var/new_index      = all_security_levels.Find(new_security_level)

	if(new_index > previous_index)
		previous_security_level.switching_up_from()
		new_security_level.switching_up_to()
	else
		previous_security_level.switching_down_from()
		new_security_level.switching_down_to()

	for(var/thing in SSpsi.psi_dampeners)
		var/obj/item/implant/psi_control/implant = thing
		implant.update_functionality()

	log_and_message_admins("has changed the security level from [previous_security_level.name] to [new_security_level.name].")
	return TRUE

// This proc decreases the current security level, if possible
/singleton/security_state/proc/decrease_security_level(force_change = FALSE)
	var/current_index = all_security_levels.Find(current_security_level)
	if(current_index == 1)
		return FALSE
	return set_security_level(all_security_levels[current_index - 1], force_change)

/singleton/security_level
	var/icon
	var/name
	var/alarm_level = "off"

	// These values are primarily for station alarms and status displays, and which light colors and overlays to use
	var/light_max_bright = 0.5
	var/light_inner_range = 0.1
	var/light_outer_range = 1
	var/light_color_alarm
	var/light_color_status_display

	var/overlay_alarm
	var/overlay_status_display
	var/alert_border

	var/up_description
	var/down_description
	var/psionic_control_level = PSI_IMPLANT_WARN

// Called when we're switching from a lower security level to this one.
/singleton/security_level/proc/switching_up_to()
	return

// Called when we're switching from a higher security level to this one.
/singleton/security_level/proc/switching_down_to()
	return

// Called when we're switching from this security level to a higher one.
/singleton/security_level/proc/switching_up_from()
	return

// Called when we're switching from this security level to a lower one.
/singleton/security_level/proc/switching_down_from()
	return

/*
* The default security state and levels setup
*/
/singleton/security_state/default
	all_security_levels = list(/singleton/security_level/default/code_green, /singleton/security_level/default/code_blue, /singleton/security_level/default/code_red, /singleton/security_level/default/code_delta)

/singleton/security_level/default
	icon = 'icons/misc/security_state.dmi'

	var/static/datum/announcement/priority/security/security_announcement_up = new(do_log = 0, do_newscast = 1, new_sound = sound('sound/misc/notice1.ogg'))
	var/static/datum/announcement/priority/security/security_announcement_down = new(do_log = 0, do_newscast = 1, new_sound = sound('sound/misc/notice1.ogg'))

/singleton/security_level/default/switching_up_to()
	if(up_description)
		security_announcement_up.Announce(up_description, "Attention! Alert level elevated to [name]!")
	notify_station()

/singleton/security_level/default/switching_down_to()
	if(down_description)
		security_announcement_down.Announce(down_description, "Attention! Alert level changed to [name]!")
	notify_station()

/singleton/security_level/default/proc/notify_station()
	for(var/obj/machinery/firealarm/FA in SSmachines.machinery)
		if(FA.z in GLOB.using_map.contact_levels)
			FA.update_icon()
	for (var/obj/machinery/rotating_alarm/security_alarm/SA in SSmachines.machinery)
		if (SA.z in GLOB.using_map.contact_levels)
			SA.set_alert(name, alarm_level, light_color_alarm)
	post_status("alert")

/singleton/security_level/default/code_green
	name = "code green"

	light_max_bright = 0.25
	light_inner_range = 0.1
	light_outer_range = 1

	light_color_alarm = COLOR_GREEN
	light_color_status_display = COLOR_GREEN

	overlay_alarm = "alarm_green"
	overlay_status_display = "status_display_green"
	alert_border = "alert_border_green"

	down_description = "All threats to the station have passed. Security may not have weapons visible, privacy laws are once again fully enforced."

/singleton/security_level/default/code_blue
	name = "code blue"
	alarm_level = "on"

	light_max_bright = 0.5
	light_inner_range = 0.1
	light_outer_range = 2
	light_color_alarm = COLOR_BLUE
	light_color_status_display = COLOR_BLUE

	psionic_control_level = PSI_IMPLANT_LOG

	overlay_alarm = "alarm_blue"
	overlay_status_display = "status_display_blue"
	alert_border = "alert_border_blue"

	up_description = "The station has received reliable information about possible hostile activity on the station. Security staff may have weapons visible, random searches are permitted."
	down_description = "The immediate threat has passed. Security may no longer have weapons drawn at all times, but may continue to have them visible. Random searches are still allowed."

/singleton/security_level/default/code_red
	name = "code red"
	alarm_level = "on"

	light_max_bright = 0.5
	light_inner_range = 0.1
	light_outer_range = 2
	light_color_alarm = COLOR_RED
	light_color_status_display = COLOR_RED

	overlay_alarm = "alarm_red"
	overlay_status_display = "status_display_red"
	alert_border = "alert_border_red"

	psionic_control_level = PSI_IMPLANT_DISABLED

	up_description = "There is an immediate serious threat to the station. Security may have weapons unholstered at all times. Random searches are allowed and advised."
	down_description = "The self-destruct mechanism has been deactivated, there is still however an immediate serious threat to the station. Security may have weapons unholstered at all times, random searches are allowed and advised."

/singleton/security_level/default/code_delta
	name = "code delta"
	alarm_level = "on"

	light_max_bright = 0.75
	light_inner_range = 0.1
	light_outer_range = 3
	light_color_alarm = COLOR_RED
	light_color_status_display = COLOR_NAVY_BLUE

	overlay_alarm = "alarm_delta"
	overlay_status_display = "status_display_delta"
	alert_border = "alert_border_delta"

	psionic_control_level = PSI_IMPLANT_DISABLED

	var/static/datum/announcement/priority/security/security_announcement_delta = new(do_log = 0, do_newscast = 1, new_sound = sound('sound/effects/siren.ogg'))

/singleton/security_level/default/code_delta/switching_up_to()
	security_announcement_delta.Announce("The self-destruct mechanism has been engaged. All crew are instructed to obey all instructions given by heads of staff. Any violations of these orders can be punished by death. This is not a drill.", "Attention! Delta security level reached!")
	notify_station()
