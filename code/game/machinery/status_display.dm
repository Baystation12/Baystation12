#define MAX_STATIC_WIDTH 24
#define SCROLL_RATE 0.045 SECONDS
#define SCROLL_PADDING 2 // how many pixels we chop to make a smooth loop
#define LINE1_X 1
#define LINE1_Y -4
#define LINE2_X 1
#define LINE2_Y -11
#define STATUS_DISPLAY_FONT /singleton/font/tiny_unicode/size_12pt

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
	obj_flags = OBJ_FLAG_WALL_MOUNTED
	var/mode = 1	// 0 = Blank
					// 1 = Shuttle timer
					// 2 = Arbitrary message(s)
					// 3 = alert picture
					// 4 = Supply shuttle timer

	var/picture_state = "greenalert" // icon_state of alert picture
	var/message1 = ""                // message line 1
	var/message2 = ""                // message line 2
	var/obj/overlay/status_display_text/message1_overlay
	var/obj/overlay/status_display_text/message2_overlay
	var/picture = null

	var/frequency = 1435		// radio frequency

	var/friendc = 0      // track if Friend Computer mode
	var/ignore_friendc = 0

	maptext_height = 26
	maptext_width = 32

	var/const/STATUS_DISPLAY_BLANK = 0
	var/const/STATUS_DISPLAY_TRANSFER_SHUTTLE_TIME = 1
	var/const/STATUS_DISPLAY_MESSAGE = 2
	var/const/STATUS_DISPLAY_ALERT = 3
	var/const/STATUS_DISPLAY_TIME = 4
	var/const/STATUS_DISPLAY_IMAGE = 5
	var/const/STATUS_DISPLAY_CUSTOM = 99

	/// Normal text color
	var/text_color = COLOR_DISPLAY_BLUE
	/// Color for headers, eg. "- ETA -"
	var/header_text_color =  COLOR_DISPLAY_PURPLE
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
	if (!is_powered())
		remove_display()
		set_light(0)
		return
	if (mode == STATUS_DISPLAY_TRANSFER_SHUTTLE_TIME || mode == STATUS_DISPLAY_TIME || mode == STATUS_DISPLAY_CUSTOM)
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
		return 1

	switch(mode)
		if(STATUS_DISPLAY_BLANK)	//blank
			remove_messages()
			return 1
		if(STATUS_DISPLAY_TRANSFER_SHUTTLE_TIME)				//emergency shuttle timer
			if(evacuation_controller.is_prepared())
				message1 = "-ETD-"
				if (evacuation_controller.waiting_to_leave())
					message2 = "Launch"
				else
					message2 = get_shuttle_timer()
				update_display(message1, message2)
			else if(evacuation_controller.has_eta())
				message1 = "-ETA-"
				message2 = get_shuttle_timer()
				update_display(message1, message2)
			return 1
		if(STATUS_DISPLAY_MESSAGE)	//custom messages
			update_display(message1, message2)
			return 1
		if(STATUS_DISPLAY_ALERT)
			display_alert()
			return 1
		if(STATUS_DISPLAY_TIME)
			message1 = "TIME"
			message2 = stationtime2text()
			update_display(message1, message2)
			return 1
		if(STATUS_DISPLAY_IMAGE)
			set_picture(picture_state)
			return 1
	return 0

/obj/machinery/status_display/examine(mob/user)
	. = ..()
	if(mode != STATUS_DISPLAY_BLANK && mode != STATUS_DISPLAY_ALERT)
		to_chat(user, "The display says:<br>\t[sanitize(message1)]<br>\t[sanitize(message2)]")
	if(mode == STATUS_DISPLAY_ALERT || status_display_show_alert_border)
		var/singleton/security_state/security_state = GET_SINGLETON(GLOB.using_map.security_state)
		to_chat(user, "The current alert level is [security_state.current_security_level.name].")

/obj/machinery/status_display/proc/update_display(line1, line2)
	if (message1_overlay?.message == line1 && message2_overlay?.message == line2)
		return

	var/line1_metric
	var/line2_metric
	var/line_pair
	var/singleton/font/display_font = GET_SINGLETON(/singleton/font/tiny_unicode/size_12pt)
	line1_metric = display_font.get_metrics(line1)
	line2_metric = display_font.get_metrics(line2)
	line_pair = (line1_metric > line2_metric ? line1_metric : line2_metric)
	var/overlay = update_message(message1_overlay, LINE1_Y, line1, LINE1_X, line_pair)
	if (overlay)
		message1_overlay = overlay
	overlay = update_message(message2_overlay, LINE2_Y, line2, LINE2_X, line_pair)
	if (overlay)
		message2_overlay = overlay
	var/pending_overlays = list()
	pending_overlays += emissive_appearance(icon, "outline", src, alpha = src.alpha)
	if (status_display_show_alert_border)
		pending_overlays += get_alert_border()
	AddOverlays(pending_overlays)
	set_light(2, 0.5, COLOR_WHITE)

/**
 * Remove both message objs and null the fields.
 */
/obj/machinery/status_display/proc/remove_messages()
	SHOULD_NOT_OVERRIDE(TRUE)
	if (message1_overlay)
		QDEL_NULL(message1_overlay)
	if (message2_overlay)
		QDEL_NULL(message2_overlay)

/**
 * Create/update message overlay.
 * They must be handled as real objects for the animation to run.
 * Don't call this in subclasses.
 * Arguments:
 * * overlay - the current /obj/effect/overlay/status_display_text instance
 * * line_y - The Y offset to render the text.
 * * x_offset - Used to offset the text on the X coordinates, not usually needed.
 * * message - the new message text.
 * Returns new /obj/effect/overlay/status_display_text or null if unchanged.
 */
/obj/machinery/status_display/proc/update_message(obj/overlay/status_display_text/overlay, line_y, message, x_offset, line_pair)
	if (overlay && message == overlay.message)
		return null

	if (overlay)
		qdel(overlay)

	var/obj/overlay/status_display_text/new_status_display_text = new(src, line_y, message, text_color, header_text_color, x_offset, line_pair)
	// Draw our object visually "in front" of this display, taking advantage of sidemap
	new_status_display_text.pixel_y = -32
	new_status_display_text.pixel_z = 32
	vis_contents += new_status_display_text
	return new_status_display_text

/obj/machinery/status_display/proc/toggle_alert_border()
	status_display_show_alert_border = !status_display_show_alert_border

/obj/machinery/status_display/proc/get_alert_border()
	var/singleton/security_state/security_state = GET_SINGLETON(GLOB.using_map.security_state)
	var/singleton/security_level/sl = security_state.current_security_level

	return image(sl.icon, sl.alert_border)

/obj/machinery/status_display/proc/display_alert()
	remove_display()

	var/singleton/security_state/security_state = GET_SINGLETON(GLOB.using_map.security_state)
	var/singleton/security_level/sl = security_state.current_security_level

	var/pending_overlays = list(overlay_image(sl.icon, sl.overlay_status_display, plane = EFFECTS_ABOVE_LIGHTING_PLANE, layer = ABOVE_LIGHTING_LAYER))
	if (status_display_show_alert_border)
		pending_overlays += get_alert_border()

	set_light(sl.light_range, sl.light_power, sl.light_color_alarm)
	AddOverlays(pending_overlays)

/obj/machinery/status_display/proc/set_picture(state)
	remove_display()
	if (!picture || picture_state != state)
		picture_state = state
		picture = image('icons/obj/machines/status_display.dmi', icon_state=picture_state)
	var/pending_overlays = list(emissive_appearance(icon, "outline", src, alpha = src.alpha), picture)
	if (status_display_show_alert_border)
		pending_overlays += get_alert_border()
	AddOverlays(pending_overlays)
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
	if (length(overlays))
		ClearOverlays()
	vis_contents.Cut()
	remove_messages()
	set_light(0)

/obj/machinery/status_display/receive_signal(datum/signal/signal)
	switch(signal.data["command"])
		if("blank")
			mode = STATUS_DISPLAY_BLANK

		if("shuttle")
			mode = STATUS_DISPLAY_TRANSFER_SHUTTLE_TIME

		if("message")
			mode = STATUS_DISPLAY_MESSAGE
			message1 = signal.data["msg1"]
			message2 = signal.data["msg2"]

		if("alert")
			mode = STATUS_DISPLAY_ALERT

		if("time")
			mode = STATUS_DISPLAY_TIME

		if("image")
			mode = STATUS_DISPLAY_IMAGE
			set_picture(signal.data["picture_state"])
			return
		if("toggle_alert_border")
			toggle_alert_border()
	update()

/**
 * Nice overlay to make text smoothly scroll with no client updates after setup.
 */
/obj/overlay/status_display_text
	icon = 'icons/obj/machines/status_display.dmi'
	icon_state = "blank"
	vis_flags = VIS_INHERIT_LAYER | VIS_INHERIT_PLANE | VIS_INHERIT_ID

	/// The message this overlay is displaying.
	var/message

	// If the line is short enough to not marquee, and it matches this, it's a header.
	var/static/regex/header_regex = regex("^-.*-$")

/obj/overlay/status_display_text/Initialize(mapload, yoffset, line, text_color, header_text_color, xoffset = 0, line_pair)
	. = ..()

	maptext_y = yoffset
	message = line

	var/singleton/font/display_font = GET_SINGLETON(/singleton/font/tiny_unicode/size_12pt)
	var/line_width = display_font.get_metrics(line)

	if (line_width > MAX_STATIC_WIDTH)
		// Marquee text
		var/marquee_message = "[line]    [line]    [line]"

		// Width of full content. Must of these is never revealed unless the user inputted a single character.
		var/full_marquee_width = display_font.get_metrics("[marquee_message]    ")
		// We loop after only this much has passed.
		var/looping_marquee_width = (display_font.get_metrics("[line]    ]") - SCROLL_PADDING)

		maptext = generate_text(marquee_message, center = FALSE, text_color = text_color)
		maptext_width = full_marquee_width
		maptext_x = 0

		// Mask off to fit in screen.
		filters += filter(type = "alpha", icon = icon(icon, "outline"))

		// Scroll.
		var/time = line_pair * SCROLL_RATE
		animate(src, maptext_x = (-looping_marquee_width) + MAX_STATIC_WIDTH, time = time, loop = -1)
		animate(maptext_x = MAX_STATIC_WIDTH, time = 0)
	else
		// Centered text
		var/color = header_regex.Find(line) ? header_text_color : text_color
		maptext = generate_text(line, center = TRUE, text_color = color)
		maptext_x = xoffset // Defaults to 0, this would be centered unless overided

/**
 * Generate the actual maptext.
 * Arguments:
 * * text - the text to display
 * * center - center the text if TRUE, otherwise right-align (the direction the text is coming from)
 * * text_color - the text color
 */
/obj/overlay/status_display_text/proc/generate_text(text, center, text_color)
	return {"<div style="color:[text_color];font:12pt 'TinyUnicode';[center ? "text-align:center" : ""]" valign="top">[text]</div>"}
