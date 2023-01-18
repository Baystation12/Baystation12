/******************** Requests Console ********************/
/** Originally written by errorage, updated by: Carn, needs more work though. I just added some security fixes */

//Request Console Department Types
#define RC_ASSIST 1		//Request Assistance
#define RC_SUPPLY 2		//Request Supplies
#define RC_INFO   4		//Relay Info

//Request Console Screens
#define RCS_MAINMENU 0	// Main menu
#define RCS_RQASSIST 1	// Request supplies
#define RCS_RQSUPPLY 2	// Request assistance
#define RCS_SENDINFO 3	// Relay information
#define RCS_SENTPASS 4	// Message sent successfully
#define RCS_SENTFAIL 5	// Message sent unsuccessfully
#define RCS_VIEWMSGS 6	// View messages
#define RCS_MESSAUTH 7	// Authentication before sending
#define RCS_ANNOUNCE 8	// Send announcement

var/global/req_console_assistance = list()
var/global/req_console_supplies = list()
var/global/req_console_information = list()
var/global/list/obj/machinery/requests_console/allConsoles = list()

/obj/machinery/requests_console
	name = "Requests Console"
	desc = "A console intended to send requests to different departments."
	anchored = TRUE
	icon = 'icons/obj/terminals.dmi'
	icon_state = "req_comp0"
	var/department = "Unknown" //The list of all departments on the station (Determined from this variable on each unit) Set this to the same thing if you want several consoles in one department
	var/list/message_log = list() //List of all messages
	var/departmentType = 0 		//Bitflag. Zero is reply-only. Map currently uses raw numbers instead of defines.
	var/newmessagepriority = 0
		// 0 = no new message
		// 1 = normal priority
		// 2 = high priority
	var/screen = RCS_MAINMENU
	var/silent = 0 // set to 1 for it not to beep all the time
//	var/hackState = 0
		// 0 = not hacked
		// 1 = hacked
	var/announcementConsole = 0
		// 0 = This console cannot be used to send department announcements
		// 1 = This console can send department announcementsf
	var/open = 0 // 1 if open
	var/announceAuth = 0 //Will be set to 1 when you authenticate yourself for announcements
	var/msgVerified = "" //Will contain the name of the person who varified it
	var/msgStamped = "" //If a message is stamped, this will contain the stamp name
	var/message = "";
	var/recipient = ""; //the department which will be receiving the message
	var/priority = -1 ; //Priority of the message being sent
	light_outer_range = 0
	var/datum/announcement/announcement = new

/obj/machinery/requests_console/on_update_icon()
	if(!is_powered())
		if(icon_state != "req_comp_off")
			icon_state = "req_comp_off"
	else
		if(icon_state == "req_comp_off")
			icon_state = "req_comp[newmessagepriority]"

/obj/machinery/requests_console/New()
	..()

	announcement.title = "[department] announcement"
	announcement.newscast = 1

	name = "[department] Requests Console"
	allConsoles += src
	if (departmentType & RC_ASSIST)
		req_console_assistance |= department
	if (departmentType & RC_SUPPLY)
		req_console_supplies |= department
	if (departmentType & RC_INFO)
		req_console_information |= department

	set_light(1)

/obj/machinery/requests_console/Destroy()
	allConsoles -= src
	var/lastDeptRC = 1
	for (var/obj/machinery/requests_console/Console in allConsoles)
		if (Console.department == department)
			lastDeptRC = 0
			break
	if(lastDeptRC)
		if (departmentType & RC_ASSIST)
			req_console_assistance -= department
		if (departmentType & RC_SUPPLY)
			req_console_supplies -= department
		if (departmentType & RC_INFO)
			req_console_information -= department
	. = ..()

/obj/machinery/requests_console/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/requests_console/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1)
	var/data[0]

	data["department"] = department
	data["screen"] = screen
	data["message_log"] = message_log
	data["newmessagepriority"] = newmessagepriority
	data["silent"] = silent
	data["announcementConsole"] = announcementConsole

	data["assist_dept"] = req_console_assistance
	data["supply_dept"] = req_console_supplies
	data["info_dept"]   = req_console_information

	data["message"] = message
	data["recipient"] = recipient
	data["priortiy"] = priority
	data["msgStamped"] = msgStamped
	data["msgVerified"] = msgVerified
	data["announceAuth"] = announceAuth

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "request_console.tmpl", "[department] Request Console", 520, 410)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/requests_console/OnTopic(href, href_list)
	if(reject_bad_text(href_list["write"]))
		recipient = href_list["write"] //write contains the string of the receiving department's name

		var/new_message = sanitize(input("Write your message:", "Awaiting Input", ""))
		if(new_message)
			message = new_message
			screen = RCS_MESSAUTH
			switch(href_list["priority"])
				if("1") priority = 1
				if("2")	priority = 2
				else	priority = 0
		else
			reset_message(1)
		return TOPIC_REFRESH

	if(href_list["writeAnnouncement"])
		var/new_message = sanitize(input("Write your message:", "Awaiting Input", ""))
		if(new_message)
			message = new_message
		else
			reset_message(1)
		return TOPIC_REFRESH

	if(href_list["sendAnnouncement"])
		if(!announcementConsole)	return
		announcement.Announce(message, msg_sanitized = 1)
		reset_message(1)
		return TOPIC_REFRESH

	if( href_list["department"] && message )
		var/log_msg = message
		screen = RCS_SENTFAIL
		var/obj/machinery/message_server/MS = get_message_server(get_z(src))
		if(MS)
			if(MS.send_rc_message(ckey(href_list["department"]),department,log_msg,msgStamped,msgVerified,priority))
				screen = RCS_SENTPASS
				message_log += "<B>Message sent to [recipient]</B><BR>[message]"
		else
			audible_message(text("[icon2html(src, viewers(get_turf(src)))] *The Requests Console beeps: 'NOTICE: No server detected!'"),,4)
		return TOPIC_REFRESH

	//Handle screen switching
	if(href_list["setScreen"])
		var/tempScreen = text2num(href_list["setScreen"])
		if(tempScreen == RCS_ANNOUNCE && !announcementConsole)
			return
		if(tempScreen == RCS_VIEWMSGS)
			for (var/obj/machinery/requests_console/Console in allConsoles)
				if (Console.department == department)
					Console.newmessagepriority = 0
					Console.icon_state = "req_comp0"
					Console.set_light(1)
		if(tempScreen == RCS_MAINMENU)
			reset_message()
		screen = tempScreen
		return TOPIC_REFRESH

	//Handle silencing the console
	if(href_list["toggleSilent"])
		silent = !silent
		return TOPIC_REFRESH


/obj/machinery/requests_console/use_tool(obj/item/tool, mob/user, list/click_params)
	// ID Card - Verify message/send announcement
	var/obj/item/card/id/id = tool.GetIdCard()
	if (istype(id))
		var/id_name = GET_ID_CARD_NAME(tool, id)
		if (inoperable(MACHINE_STAT_MAINT))
			to_chat(user, SPAN_WARNING("\The [src] does not respond to [id_name]"))
			return TRUE
		switch (screen)
			if (RCS_MESSAUTH)
				msgVerified = text(SPAN_COLOR("green", "<b>Verified by [id.get_display_name()]</b>"))
				SSnano.update_uis(src)
				user.visible_message(
					SPAN_NOTICE("\The [user] scans \a [tool] over \the [src]."),
					SPAN_NOTICE("You verify \the [src]'s pending message with [id_name].")
				)
				return TRUE
			if (RCS_ANNOUNCE)
				if (!has_access(access_RC_announce, id.GetAccess()))
					to_chat(user, SPAN_WARNING("\The [src] refuses [id_name]."))
					return TRUE
				announceAuth = TRUE
				announcement.announcer = id.get_display_name()
				SSnano.update_uis(src)
				user.visible_message(
					SPAN_NOTICE("\The [user] scans \a [tool] over \the [src]."),
					SPAN_NOTICE("You verify \the [src]'s pending announcement with [id_name].")
				)
				return TRUE
			else
				to_chat(user, SPAN_WARNING("\The [src] is not currently accepting ID scans."))
				return TRUE

	// Stamp - Stamp message
	if (istype(tool, /obj/item/stamp))
		if (inoperable(MACHINE_STAT_MAINT))
			to_chat(user, SPAN_WARNING("\The [src] does not respond to \the [tool]"))
			return TRUE
		if (screen == RCS_MESSAUTH)
			msgStamped = text(SPAN_COLOR("blue", "<b>Stamped with \the [tool]</b>"))
			SSnano.update_uis(src)
			user.visible_message(
				SPAN_NOTICE("\The [user] scans \a [tool] over \the [src]."),
				SPAN_NOTICE("You stamp \the [src]'s announcement with \the [tool].")
			)
			return TRUE
		to_chat(user, SPAN_WARNING("\The [src] is not currently accepting stamps."))
		return TRUE

	return ..()


/obj/machinery/requests_console/proc/reset_message(mainmenu = 0)
	message = ""
	recipient = ""
	priority = 0
	msgVerified = ""
	msgStamped = ""
	announceAuth = 0
	announcement.announcer = ""
	if(mainmenu)
		screen = RCS_MAINMENU
