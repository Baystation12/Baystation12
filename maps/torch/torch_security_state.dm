/datum/map/torch // setting the map to use this list
	security_state = /decl/security_state/default/torchdept

//Torch map alert levels. Refer to security_state.dm.
/decl/security_state/default/torchdept
	all_security_levels = list(/decl/security_level/default/torchdept/code_green, /decl/security_level/default/torchdept/code_violet, /decl/security_level/default/torchdept/code_orange, /decl/security_level/default/torchdept/code_blue, /decl/security_level/default/torchdept/code_red, /decl/security_level/default/code_delta)
	standard_security_levels = list(/decl/security_level/default/torchdept/code_green, /decl/security_level/default/torchdept/code_violet, /decl/security_level/default/torchdept/code_orange, /decl/security_level/default/torchdept/code_blue)

/decl/security_level/default/torchdept
	icon = 'maps/torch/icons/security_state.dmi'

/decl/security_level/default/torchdept/code_green
	name = "code green"
	icon = 'icons/misc/security_state.dmi'

	light_range = 2
	light_power = 1
	light_color_alarm = COLOR_GREEN
	light_color_status_display = COLOR_GREEN

	overlay_alarm = "alarm_green"
	overlay_status_display = "status_display_green"

	var/static/datum/announcement/priority/security/security_announcement_green = new(do_log = 0, do_newscast = 1, new_sound = sound('sound/misc/notice2.ogg'))

/decl/security_level/default/torchdept/code_green/switching_down_to()
	security_announcement_green.Announce("The situation has been resolved, and all crew are to return to their regular duties.", "Attention! Alert level lowered to code green.")
	notify_station()

/decl/security_level/default/torchdept/code_violet
	name = "code violet"

	light_range = 3
	light_power = 2
	light_color_alarm = COLOR_VIOLET
	light_color_status_display = COLOR_VIOLET

	overlay_alarm = "alarm_violet"
	overlay_status_display = "status_display_violet"

	up_description = "A major medical emergency has developed. Medical personnel are required to report to their supervisor for orders, and non-medical personnel are required to obey all relevant instructions from medical staff."
	down_description = "Code violet procedures are now in effect; Medical personnel are required to report to their supervisor for orders, and non-medical personnel are required to obey relevant instructions from medical staff."

/decl/security_level/default/torchdept/code_orange
	name = "code orange"

	light_range = 3
	light_power = 2
	light_color_alarm = COLOR_ORANGE
	light_color_status_display = COLOR_ORANGE
	overlay_alarm = "alarm_orange"
	overlay_status_display = "status_display_orange"

	up_description = "A major engineering emergency has developed. Engineering personnel are required to report to their supervisor for orders, and non-engineering personnel are required to evacuate any affected areas and obey relevant instructions from engineering staff."
	down_description = "Code orange procedures are now in effect; Engineering personnel are required to report to their supervisor for orders, and non-engineering personnel are required to evacuate any affected areas and obey relevant instructions from engineering staff."


/decl/security_level/default/torchdept/code_blue
	name = "code blue"
	icon = 'icons/misc/security_state.dmi'

	light_range = 3
	light_power = 2
	light_color_alarm = COLOR_BLUE
	light_color_status_display = COLOR_BLUE
	overlay_alarm = "alarm_blue"
	overlay_status_display = "status_display_blue"

	up_description = "A major security emergency has developed. Security personnel are to report to their supervisor for orders, are permitted to search staff and facilities, and may have weapons visible on their person."
	down_description = "Code blue procedures are now in effect. Security personnel are to report to their supervisor for orders, are permitted to search staff and facilities, and may have weapons visible on their person."

/decl/security_level/default/torchdept/code_red
	name = "code red"
	icon = 'icons/misc/security_state.dmi'

	light_range = 4
	light_power = 2
	light_color_alarm = COLOR_RED
	light_color_status_display = COLOR_RED
	overlay_alarm = "alarm_red"
	overlay_status_display = "status_display_red"

	var/static/datum/announcement/priority/security/security_announcement_red = new(do_log = 0, do_newscast = 1, new_sound = sound('sound/misc/redalert1.ogg'))

/decl/security_level/default/torchdept/code_red/switching_up_to()
	security_announcement_red.Announce("A severe emergency has occurred. All staff are to report to their supervisor for orders. All crew should obey orders from relevant emergency personnel. Security personnel are permitted to search staff and facilities, and may have weapons unholstered at any time.", "Attention! Code red alert procedures now in effect!")
	notify_station()

/decl/security_level/default/torchdept/code_red/switching_down_to()
	security_announcement_red.Announce("The self-destruct mechanism has been deactivated. All staff are to report to their supervisor for orders. All crew should obey orders from relevant emergency personnel. Security personnel are permitted to search staff and facilities, and may have weapons unholstered at any time.", "Attention! Code red alert procedures now in effect!")
	notify_station()