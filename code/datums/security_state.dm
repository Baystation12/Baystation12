/decl/security_state
	// When defining any of these values type paths should be used, not instances. Instances will be acquired in /New()
	var/decl/security_level/defcon_1_security_level // The security level corresponding to DEFCON 1, previously known as code Delta. Defaults to the last entry in available_security_levels if unset.
	var/decl/security_level/defcon_2_security_level // The security level corresponding to DEFCON 2. Previously known as code red. Defaults to the second to last entry in available_security_levels if unset.
	var/decl/security_level/defcon_3_security_level // The security level corresponding to DEFCON 3. Previously known as code blue. Defaults to the third to last entry in available_security_levels if unset.
	var/decl/security_level/current_security_level  // The current security level. Defaults to the first entry in available_security_levels if unset.
	var/list/available_security_levels              // List of available security levels

/decl/security_state/New()
	if(!(defcon_1_security_level in available_security_levels))
		defcon_1_security_level = available_security_levels[available_security_levels.len]
	defcon_1_security_level = GLOB.decl_repository.get_decl(defcon_1_security_level)

	if(!(defcon_2_security_level in available_security_levels))
		defcon_2_security_level = available_security_levels[available_security_levels.len - 1]
	defcon_2_security_level = GLOB.decl_repository.get_decl(defcon_2_security_level)

	if(!(defcon_3_security_level in available_security_levels))
		defcon_3_security_level = available_security_levels[available_security_levels.len - 2]
	defcon_3_security_level = GLOB.decl_repository.get_decl(defcon_3_security_level)

	if(current_security_level in available_security_levels)
		current_security_level = GLOB.decl_repository.get_decl(current_security_level)
	else
		current_security_level = GLOB.decl_repository.get_decl(available_security_levels[1])

	var/list/security_level_instances = list()
	for(var/security_level_type in available_security_levels)
		security_level_instances += GLOB.decl_repository.get_decl(security_level_type)
	available_security_levels = security_level_instances

	// Finally switch up to the default starting security level.
	current_security_level.switching_up_to()

/decl/security_state/proc/current_security_level_is_lower_than(var/given_security_level)
	var/current_index = available_security_levels.Find(current_security_level)
	var/given_index   = available_security_levels.Find(given_security_level)

	return given_index && current_index < given_index

/decl/security_state/proc/current_security_level_is_higher_than(var/given_security_level)
	var/current_index = available_security_levels.Find(current_security_level)
	var/given_index   = available_security_levels.Find(given_security_level)

	return given_index && current_index > given_index

/decl/security_state/proc/set_security_level(var/decl/security_level/new_security_level)
	if(new_security_level == current_security_level)
		return FALSE
	if(!(new_security_level in available_security_levels))
		return FALSE

	var/current_index = available_security_levels.Find(current_security_level)
	var/new_index = available_security_levels.Find(new_security_level)

	if(new_index > current_index)
		current_security_level.switching_up_from()
		new_security_level.switching_up_to()
	else
		current_security_level.switching_down_from()
		new_security_level.switching_down_to()

	log_and_message_admins("has changed the security level from [current_security_level.name] to [new_security_level.name].")
	current_security_level = new_security_level

	return TRUE

// This proc only changes the security level if the given level is higher than the current level
/decl/security_state/proc/switch_up_to_security_level(var/new_security_level)
	var/current_index = available_security_levels.Find(current_security_level)
	var/new_index = available_security_levels.Find(new_security_level)

	if(new_index && new_index > current_index)
		return set_security_level(new_security_level)
	return FALSE

// This proc increases the current security level, if possible
/decl/security_state/proc/increase_security_level()
	var/current_index = available_security_levels.Find(current_security_level)
	if(current_index == available_security_levels.len)
		return FALSE
	return set_security_level(available_security_levels[current_index + 1])

// This proc decreases the current security level, if possible
/decl/security_state/proc/decrease_security_level()
	var/current_index = available_security_levels.Find(current_security_level)
	if(current_index == 1)
		return FALSE
	return set_security_level(available_security_levels[current_index - 1])

/decl/security_level
	var/icon
	var/name

	// These values are primarily for station alarms and status displays, and which light colors and overlays to use
	var/light_range
	var/light_power
	var/light_color

	var/overlay_alarm
	var/overlay_status_display

// Called when we're switching from a lower security level to this one.
/decl/security_level/proc/switching_up_to()
	return

// Called when we're switching from a higher security level to this one.
/decl/security_level/proc/switching_down_to()
	return

// Called when we're switching from this security level to a higher one.
/decl/security_level/proc/switching_up_from()
	return

// Called when we're switching from this security level to a lower one.
/decl/security_level/proc/switching_down_from()
	return

/*
* The default security state and levels setup
*/
/decl/security_state/default
	available_security_levels = list(/decl/security_level/default/code_green, /decl/security_level/default/code_blue, /decl/security_level/default/code_red, /decl/security_level/default/code_delta)

/decl/security_level/default
	icon = 'icons/misc/security_state.dmi'
	var/up_description
	var/down_description

	var/static/datum/announcement/priority/security/security_announcement_up = new(do_log = 0, do_newscast = 1, new_sound = sound('sound/misc/notice1.ogg'))
	var/static/datum/announcement/priority/security/security_announcement_down = new(do_log = 0, do_newscast = 1)

/decl/security_level/default/switching_up_to()
	if(up_description)
		security_announcement_up.Announce(up_description, "Attention! Security level elevated to [name]")
	notify_station()

/decl/security_level/default/switching_down_to()
	if(down_description)
		security_announcement_down.Announce(down_description, "Attention! Security level lowered to [name]")
	notify_station()

/decl/security_level/default/proc/notify_station()
	for(var/obj/machinery/firealarm/FA in GLOB.machines)
		if(FA.z in GLOB.using_map.contact_levels)
			FA.update_icon()
	post_status("alert")

/decl/security_level/default/code_green
	name = "code green"

	light_range = 2
	light_power = 0.5
	light_color = COLOR_GREEN

	overlay_alarm = "alarm_green"
	overlay_status_display = "status_display_green"

	down_description = "All threats to the station have passed. Security may not have weapons visible, privacy laws are once again fully enforced."

/decl/security_level/default/code_blue
	name = "code blue"

	light_range = 2
	light_power = 0.5
	light_color = COLOR_BLUE

	overlay_alarm = "alarm_blue"
	overlay_status_display = "status_display_blue"

	up_description = "The station has received reliable information about possible hostile activity on the station. Security staff may have weapons visible, random searches are permitted."
	down_description = "The immediate threat has passed. Security may no longer have weapons drawn at all times, but may continue to have them visible. Random searches are still allowed."

/decl/security_level/default/code_red
	name = "code red"

	light_range = 4
	light_power = 2
	light_color = COLOR_RED

	overlay_alarm = "alarm_red"
	overlay_status_display = "status_display_red"

	up_description = "There is an immediate serious threat to the station. Security may have weapons unholstered at all times. Random searches are allowed and advised."
	down_description = "The self-destruct mechanism has been deactivated, there is still however an immediate serious threat to the station. Security may have weapons unholstered at all times, random searches are allowed and advised."

/decl/security_level/default/code_delta
	name = "code delta"

	light_range = 4
	light_power = 2
	light_color = COLOR_RED

	overlay_alarm = "alarm_delta"
	overlay_status_display = "status_display_delta"

	var/static/datum/announcement/priority/security/security_announcement_delta = new(do_log = 0, do_newscast = 1, new_sound = sound('sound/effects/siren.ogg'))

/decl/security_level/default/code_delta/switching_up_to()
	security_announcement_delta.Announce("The station's self-destruct mechanism has been engaged. All crew are instructed to obey all instructions given by heads of staff. Any violations of these orders can be punished by death. This is not a drill.", "Attention! Delta security level reached!")
