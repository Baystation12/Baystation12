#define FONT_SIZE "5pt"
#define FONT_COLOR "#09f"
#define FONT_STYLE "Arial Black"
#define SCROLL_SPEED 2

// Status display
// (formerly Countdown timer display)

// Use to show shuttle ETA/ETD times
// Alert status
// And arbitrary messages set by comms computer
/obj/machinery/status_display
	icon = 'icons/obj/machines/status_display.dmi'
	icon_state = "frame"
	name = "status display"
	layer = ABOVE_WINDOW_LAYER
	anchored = TRUE
	density = FALSE
	idle_power_usage = 10
	health_max = 10
	damage_hitsound = 'sound/effects/Glasshit.ogg'
	var/mode = 1	// 0 = Blank
					// 1 = Shuttle timer
					// 2 = Arbitrary message(s)
					// 3 = alert picture
					// 4 = Supply shuttle timer

	var/picture_state = "greenalert" // icon_state of alert picture
	var/message1 = ""                // message line 1
	var/message2 = ""                // message line 2
	var/index1                       // display index for scrolling messages or 0 if non-scrolling
	var/index2
	var/picture = null

	var/frequency = 1435		// radio frequency

	var/friendc = 0      // track if Friend Computer mode
	var/ignore_friendc = 0

	maptext_height = 26
	maptext_width = 32

	var/const/CHARS_PER_LINE = 5
	var/const/STATUS_DISPLAY_BLANK = 0
	var/const/STATUS_DISPLAY_TRANSFER_SHUTTLE_TIME = 1
	var/const/STATUS_DISPLAY_MESSAGE = 2
	var/const/STATUS_DISPLAY_ALERT = 3
	var/const/STATUS_DISPLAY_TIME = 4
	var/const/STATUS_DISPLAY_IMAGE = 5
	var/const/STATUS_DISPLAY_CUSTOM = 99

	var/status_display_show_alert_border = FALSE

/obj/machinery/status_display/Destroy()
	if(radio_controller)
		radio_controller.remove_object(src,frequency)
	return ..()

/obj/machinery/status_display/on_death()
	..()
	playsound(src, "shatter", 70, 1)
	visible_message(SPAN_DANGER("\The [src] is smashed into many pieces!"))
	remove_display()
	STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/machinery/status_display/on_revive()
	..()
	START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/machinery/status_display/on_update_icon()
	. = ..()
	if (MACHINE_IS_BROKEN(src))
		icon_state = "[initial(icon_state)]_broken"
	else
		icon_state = "[initial(icon_state)]"

/obj/machinery/status_display/use_tool(obj/item/tool, mob/living/user, list/click_params)
	if (istype(tool, /obj/item/stack/material) && tool.get_material_name() == MATERIAL_GLASS && health_damaged())
		var/obj/item/stack/mats = tool
		if (!mats.can_use(2))
			USE_FEEDBACK_STACK_NOT_ENOUGH(mats, 2, "repair \the [src].")
			return TRUE
		if (!user.do_skilled(4 SECONDS, SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		mats.use(2)
		to_chat(user, SPAN_NOTICE("You repair the broken glass on \the [src]."))
		revive_health()
		return TRUE
	return ..()

// register for radio system
/obj/machinery/status_display/Initialize()
	. = ..()
	if(radio_controller)
		radio_controller.add_object(src, frequency)

// timed process
/obj/machinery/status_display/Process()
	if (MACHINE_IS_BROKEN(src))
		return PROCESS_KILL
	if(!is_powered())
		remove_display()
		return
	update()

/obj/machinery/status_display/emp_act(severity)
	if(inoperable())
		..(severity)
		return
	set_picture("ai_bsod")
	..(severity)

// set what is displayed
/obj/machinery/status_display/proc/update()
	remove_display()
	if (MACHINE_IS_BROKEN(src))
		return
	if(friendc && !ignore_friendc)
		set_picture("ai_friend")
		if(status_display_show_alert_border)
			add_alert_border_to_display()
		return 1

	switch(mode)
		if(STATUS_DISPLAY_BLANK)	//blank
			if(status_display_show_alert_border)
				add_alert_border_to_display()
			return 1
		if(STATUS_DISPLAY_TRANSFER_SHUTTLE_TIME)				//emergency shuttle timer
			if(evacuation_controller.is_prepared())
				message1 = "-ETD-"
				if (evacuation_controller.waiting_to_leave())
					message2 = "Launch"
				else
					message2 = get_shuttle_timer()
					if(length(message2) > CHARS_PER_LINE)
						message2 = "Error"
				update_display(message1, message2)
			else if(evacuation_controller.has_eta())
				message1 = "-ETA-"
				message2 = get_shuttle_timer()
				if(length(message2) > CHARS_PER_LINE)
					message2 = "Error"
				update_display(message1, message2)
			if(status_display_show_alert_border)
				add_alert_border_to_display()
			return 1
		if(STATUS_DISPLAY_MESSAGE)	//custom messages
			var/line1
			var/line2

			if(!index1)
				line1 = message1
			else
				line1 = copytext(message1+"|"+message1, index1, index1+CHARS_PER_LINE)
				var/message1_len = length(message1)
				index1 += SCROLL_SPEED
				if(index1 > message1_len)
					index1 -= message1_len

			if(!index2)
				line2 = message2
			else
				line2 = copytext(message2+"|"+message2, index2, index2+CHARS_PER_LINE)
				var/message2_len = length(message2)
				index2 += SCROLL_SPEED
				if(index2 > message2_len)
					index2 -= message2_len
			update_display(line1, line2)
			if(status_display_show_alert_border)
				add_alert_border_to_display()
			return 1
		if(STATUS_DISPLAY_ALERT)
			display_alert()
			return 1
		if(STATUS_DISPLAY_TIME)
			message1 = "TIME"
			message2 = stationtime2text()
			update_display(message1, message2)
			if(status_display_show_alert_border)
				add_alert_border_to_display()
			return 1
		if(STATUS_DISPLAY_IMAGE)
			set_picture(picture_state)
			if(status_display_show_alert_border)
				add_alert_border_to_display()
			return 1
	return 0

/obj/machinery/status_display/examine(mob/user)
	. = ..()
	if(mode != STATUS_DISPLAY_BLANK && mode != STATUS_DISPLAY_ALERT)
		to_chat(user, "The display says:<br>\t[sanitize(message1)]<br>\t[sanitize(message2)]")
	if(mode == STATUS_DISPLAY_ALERT || status_display_show_alert_border)
		var/singleton/security_state/security_state = GET_SINGLETON(GLOB.using_map.security_state)
		to_chat(user, "The current alert level is [security_state.current_security_level.name].")

/obj/machinery/status_display/proc/set_message(m1, m2)
	if(m1)
		index1 = (length(m1) > CHARS_PER_LINE)
		message1 = m1
	else
		message1 = ""
		index1 = 0

	if(m2)
		index2 = (length(m2) > CHARS_PER_LINE)
		message2 = m2
	else
		message2 = ""
		index2 = 0

/obj/machinery/status_display/proc/toggle_alert_border()
	status_display_show_alert_border = !status_display_show_alert_border

/obj/machinery/status_display/proc/add_alert_border_to_display()
	var/singleton/security_state/security_state = GET_SINGLETON(GLOB.using_map.security_state)
	var/singleton/security_level/sl = security_state.current_security_level

	var/border = image(sl.icon,sl.alert_border)

	AddOverlays(border)

/obj/machinery/status_display/proc/display_alert()
	remove_display()

	var/singleton/security_state/security_state = GET_SINGLETON(GLOB.using_map.security_state)
	var/singleton/security_level/sl = security_state.current_security_level

	var/image/alert = overlay_image(sl.icon, sl.overlay_status_display, plane = EFFECTS_ABOVE_LIGHTING_PLANE, layer = ABOVE_LIGHTING_LAYER)

	set_light(sl.light_range, sl.light_power, sl.light_color_alarm)
	AddOverlays(alert)

/obj/machinery/status_display/proc/set_picture(state)
	remove_display()
	if(!picture || picture_state != state)
		picture_state = state
		picture = image('icons/obj/machines/status_display.dmi', icon_state=picture_state)
	AddOverlays(picture)
	set_light(2, 0.5, COLOR_WHITE)

/obj/machinery/status_display/proc/update_display(line1, line2)
	var/new_text = {"<div style="font-size:[FONT_SIZE];color:[FONT_COLOR];font:'[FONT_STYLE]';text-align:center;" valign="top">[line1]<br>[line2]</div>"}
	if(maptext != new_text)
		maptext = new_text
	set_light(2, 0.5, COLOR_WHITE)

/obj/machinery/status_display/proc/get_shuttle_timer()
	var/timeleft = evacuation_controller.get_eta()
	if(timeleft < 0)
		return ""
	return "[pad_left(num2text((timeleft / 60) % 60), 2, "0")]:[pad_left(num2text(timeleft % 60), 2, "0")]"

/obj/machinery/status_display/proc/get_supply_shuttle_timer()
	var/datum/shuttle/autodock/ferry/supply/shuttle = SSsupply.shuttle
	if (!shuttle)
		return "Error"

	if(shuttle.has_arrive_time())
		var/timeleft = round((shuttle.arrive_time - world.time) / 10,1)
		if(timeleft < 0)
			return "Late"
		return "[pad_left(num2text((timeleft / 60) % 60), 2, "0")]:[pad_left(num2text(timeleft % 60), 2, "0")]"
	return ""

/obj/machinery/status_display/proc/remove_display()
	if(length(overlays))
		ClearOverlays()
	if(maptext)
		maptext = ""
	set_light(0)

/obj/machinery/status_display/receive_signal(datum/signal/signal)
	switch(signal.data["command"])
		if("blank")
			mode = STATUS_DISPLAY_BLANK

		if("shuttle")
			mode = STATUS_DISPLAY_TRANSFER_SHUTTLE_TIME

		if("message")
			mode = STATUS_DISPLAY_MESSAGE
			set_message(signal.data["msg1"], signal.data["msg2"])

		if("alert")
			mode = STATUS_DISPLAY_ALERT

		if("time")
			mode = STATUS_DISPLAY_TIME

		if("image")
			mode = STATUS_DISPLAY_IMAGE
			set_picture(signal.data["picture_state"])
		if("toggle_alert_border")
			toggle_alert_border()
	update()

#undef FONT_SIZE
#undef FONT_COLOR
#undef FONT_STYLE
#undef SCROLL_SPEED
