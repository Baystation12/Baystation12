/******************** Requests Console ********************/
/** Originally written by errorage, updated by: Carn, needs more work though. I just added some security fixes */

//Request Console Department Types
#define RC_ASSIST 1		//Request Assistance
#define RC_SUPPLY 2		//Request Supplies
#define RC_INFO   4		//Relay Info

//Request Console Screens
#define RCS_RQASSIST 1	// Request supplies
#define RCS_RQSUPPLY 2	// Request assistance
#define RCS_SENDINFO 3	// Relay information
#define RCS_SENTPASS 4	// Message sent successfully
#define RCS_SENTFAIL 5	// Message sent unsuccessfully
#define RCS_VIEWMSGS 6	// View messages
#define RCS_MESSAUTH 7	// Authentication before sending
#define RCS_ANNOUNCE 8	// Send announcement
#define RCS_MAINMENU 9	// Main menu

var/req_console_assistance = list()
var/req_console_supplies = list()
var/req_console_information = list()
var/list/obj/machinery/requests_console/allConsoles = list()

/obj/machinery/requests_console
	name = "Requests Console"
	desc = "A console intended to send requests to different departments on the station."
	anchored = 1
	icon = 'icons/obj/terminals.dmi'
	icon_state = "req_comp0"
	var/department = "Unknown" //The list of all departments on the station (Determined from this variable on each unit) Set this to the same thing if you want several consoles in one department
	var/list/messages = list() //List of all messages
	var/departmentType = 0 		//Bitflag. Zero is reply-only. Map currently uses raw numbers instead of defines.
	var/newmessagepriority = 0
		// 0 = no new message
		// 1 = normal priority
		// 2 = high priority
		// 3 = extreme priority - not implemented, will probably require some hacking... everything needs to have a hidden feature in this game.
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
	var/dpt = ""; //the department which will be receiving the message
	var/priority = -1 ; //Priority of the message being sent
	light_range = 0
	var/datum/announcement/announcement = new

/obj/machinery/requests_console/power_change()
	..()
	update_icon()

/obj/machinery/requests_console/update_icon()
	if(stat & NOPOWER)
		if(icon_state != "req_comp_off")
			icon_state = "req_comp_off"
	else
		if(icon_state == "req_comp_off")
			icon_state = "req_comp0"

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
	..()

/obj/machinery/requests_console/attack_hand(user as mob)
	if(..(user))
		return
	var/dat
	dat = text("<HEAD><TITLE>Requests Console</TITLE></HEAD><H3>[department] Requests Console</H3>")
	if(!open)
		switch(screen)
			if(RCS_RQASSIST)	//req. assistance
				dat += text("Which department do you need assistance from?<BR><BR>")
				for(var/dpt in req_console_assistance)
					if (dpt != department)
						dat += text("[dpt] (<A href='?src=\ref[src];write=[ckey(dpt)]'>Message</A> or ")
						dat += text("<A href='?src=\ref[src];write=[ckey(dpt)];priority=2'>High Priority</A>")
//						if (hackState == 1)
//							dat += text(" or <A href='?src=\ref[src];write=[ckey(dpt)];priority=3'>EXTREME</A>)")
						dat += text(")<BR>")
				dat += text("<BR><A href='?src=\ref[src];setScreen=[RCS_MAINMENU]'>Back</A><BR>")

			if(RCS_RQSUPPLY)	//req. supplies
				dat += text("Which department do you need supplies from?<BR><BR>")
				for(var/dpt in req_console_supplies)
					if (dpt != department)
						dat += text("[dpt] (<A href='?src=\ref[src];write=[ckey(dpt)]'>Message</A> or ")
						dat += text("<A href='?src=\ref[src];write=[ckey(dpt)];priority=2'>High Priority</A>")
//						if (hackState == 1)
//							dat += text(" or <A href='?src=\ref[src];write=[ckey(dpt)];priority=3'>EXTREME</A>)")
						dat += text(")<BR>")
				dat += text("<BR><A href='?src=\ref[src];setScreen=[RCS_MAINMENU]'>Back</A><BR>")

			if(RCS_SENDINFO)	//relay information
				dat += text("Which department would you like to send information to?<BR><BR>")
				for(var/dpt in req_console_information)
					if (dpt != department)
						dat += text("[dpt] (<A href='?src=\ref[src];write=[ckey(dpt)]'>Message</A> or ")
						dat += text("<A href='?src=\ref[src];write=[ckey(dpt)];priority=2'>High Priority</A>")
//						if (hackState == 1)
//							dat += text(" or <A href='?src=\ref[src];write=[ckey(dpt)];priority=3'>EXTREME</A>)")
						dat += text(")<BR>")
				dat += text("<BR><A href='?src=\ref[src];setScreen=[RCS_MAINMENU]'>Back</A><BR>")

			if(RCS_SENTPASS)	//sent successfully
				dat += text("<FONT COLOR='GREEN'>Message sent</FONT><BR><BR>")
				dat += text("<A href='?src=\ref[src];setScreen=[RCS_MAINMENU]'>Continue</A><BR>")

			if(RCS_SENTFAIL)	//unsuccessful; not sent
				dat += text("<FONT COLOR='RED'>An error occurred. </FONT><BR><BR>")
				dat += text("<A href='?src=\ref[src];setScreen=[RCS_MAINMENU]'>Continue</A><BR>")

			if(RCS_VIEWMSGS)	//view messages
				for (var/obj/machinery/requests_console/Console in allConsoles)
					if (Console.department == department)
						Console.newmessagepriority = 0
						Console.icon_state = "req_comp0"
						Console.set_light(1)
				newmessagepriority = 0
				icon_state = "req_comp0"
				for(var/msg in messages)
					dat += text("[msg]<BR>")
				dat += text("<A href='?src=\ref[src];setScreen=[RCS_MAINMENU]'>Back to main menu</A><BR>")

			if(RCS_MESSAUTH)	//authentication before sending
				dat += text("<B>Message Authentication</B><BR><BR>")
				dat += text("<b>Message for [dpt]: </b>[message]<BR><BR>")
				dat += text("You may authenticate your message now by scanning your ID or your stamp<BR><BR>")
				dat += text("Validated by: [msgVerified]<br>");
				dat += text("Stamped by: [msgStamped]<br>");
				dat += text("<A href='?src=\ref[src];department=[dpt]'>Send</A><BR>");
				dat += text("<BR><A href='?src=\ref[src];setScreen=[RCS_MAINMENU]'>Back</A><BR>")

			if(RCS_ANNOUNCE)	//send announcement
				dat += text("<B>Station wide announcement</B><BR><BR>")
				if(announceAuth)
					dat += text("<b>Authentication accepted</b><BR><BR>")
				else
					dat += text("Swipe your card to authenticate yourself.<BR><BR>")
				dat += text("<b>Message: </b>[message] <A href='?src=\ref[src];writeAnnouncement=1'>Write</A><BR><BR>")
				if (announceAuth && message)
					dat += text("<A href='?src=\ref[src];sendAnnouncement=1'>Announce</A><BR>");
				dat += text("<BR><A href='?src=\ref[src];setScreen=[RCS_MAINMENU]'>Back</A><BR>")

			else	//main menu
				screen = RCS_MAINMENU
				reset_announce()
				if (newmessagepriority == 1)
					dat += text("<FONT COLOR='RED'>There are new messages</FONT><BR>")
				if (newmessagepriority == 2)
					dat += text("<FONT COLOR='RED'><B>NEW PRIORITY MESSAGES</B></FONT><BR>")
				dat += text("<A href='?src=\ref[src];setScreen=[RCS_VIEWMSGS]'>View Messages</A><BR><BR>")

				dat += text("<A href='?src=\ref[src];setScreen=[RCS_RQASSIST]'>Request Assistance</A><BR>")
				dat += text("<A href='?src=\ref[src];setScreen=[RCS_RQSUPPLY]'>Request Supplies</A><BR>")
				dat += text("<A href='?src=\ref[src];setScreen=[RCS_SENDINFO]'>Relay Anonymous Information</A><BR><BR>")
				if(announcementConsole)
					dat += text("<A href='?src=\ref[src];setScreen=[RCS_ANNOUNCE]'>Send station-wide announcement</A><BR><BR>")
				if (silent)
					dat += text("Speaker <A href='?src=\ref[src];setSilent=0'>OFF</A>")
				else
					dat += text("Speaker <A href='?src=\ref[src];setSilent=1'>ON</A>")

		user << browse("[dat]", "window=request_console")
		onclose(user, "req_console")
	return

/obj/machinery/requests_console/Topic(href, href_list)
	if(..())	return
	usr.set_machine(src)
	add_fingerprint(usr)

	if(reject_bad_text(href_list["write"]))
		dpt = ckey(href_list["write"]) //write contains the string of the receiving department's name

		var/new_message = sanitize(input("Write your message:", "Awaiting Input", ""))
		if(new_message)
			message = new_message
			screen = RCS_MESSAUTH
			switch(href_list["priority"])
				if("2")	priority = 2
				else	priority = -1
		else
			dpt = "";
			msgVerified = ""
			msgStamped = ""
			screen = RCS_MAINMENU
			priority = -1

	if(href_list["writeAnnouncement"])
		var/new_message = sanitize(input("Write your message:", "Awaiting Input", ""))
		if(new_message)
			message = new_message
			switch(href_list["priority"])
				if("2")	priority = 2
				else	priority = -1
		else
			reset_announce()
			screen = RCS_MAINMENU

	if(href_list["sendAnnouncement"])
		if(!announcementConsole)	return
		announcement.Announce(message, msg_sanitized = 1)
		reset_announce()
		screen = RCS_MAINMENU

	if( href_list["department"] && message )
		var/log_msg = message
		var/pass = 0
		screen = RCS_SENTFAIL
		for (var/obj/machinery/message_server/MS in world)
			if(!MS.active) continue
			MS.send_rc_message(href_list["department"],department,log_msg,msgStamped,msgVerified,priority)
			pass = 1
		if(pass)
			screen = RCS_SENTPASS
			messages += "<B>Message sent to [dpt]</B><BR>[message]"
		else
			audible_message(text("\icon[src] *The Requests Console beeps: 'NOTICE: No server detected!'"),,4)


	//Handle screen switching
	var/tempScreen = text2num(href_list["setScreen"])
	if(tempScreen)
		if(tempScreen == RCS_ANNOUNCE && !announcementConsole)
			return
		if(tempScreen == RCS_MAINMENU)
			dpt = ""
			msgVerified = ""
			msgStamped = ""
			message = ""
			priority = -1
		screen = tempScreen

	//Handle silencing the console
	switch( href_list["setSilent"] )
		if(null)	//skip
		if("1")	silent = 1
		else	silent = 0

	updateUsrDialog()
	return

					//err... hacking code, which has no reason for existing... but anyway... it's supposed to unlock priority 3 messanging on that console (EXTREME priority...) the code for that actually exists.
/obj/machinery/requests_console/attackby(var/obj/item/weapon/O as obj, var/mob/user as mob)
	/*
	if (istype(O, /obj/item/weapon/crowbar))
		if(open)
			open = 0
			icon_state="req_comp0"
		else
			open = 1
			if(hackState == 0)
				icon_state="req_comp_open"
			else if(hackState == 1)
				icon_state="req_comp_rewired"
	if (istype(O, /obj/item/weapon/screwdriver))
		if(open)
			if(hackState == 0)
				hackState = 1
				icon_state="req_comp_rewired"
			else if(hackState == 1)
				hackState = 0
				icon_state="req_comp_open"
		else
			user << "You can't do much with that."*/

	if (istype(O, /obj/item/weapon/card/id))
		if(screen == RCS_MESSAUTH)
			var/obj/item/weapon/card/id/T = O
			msgVerified = text("<font color='green'><b>Verified by [T.registered_name] ([T.assignment])</b></font>")
			updateUsrDialog()
		if(screen == RCS_ANNOUNCE)
			var/obj/item/weapon/card/id/ID = O
			if (access_RC_announce in ID.GetAccess())
				announceAuth = 1
				announcement.announcer = ID.assignment ? "[ID.assignment] [ID.registered_name]" : ID.registered_name
			else
				reset_announce()
				user << "<span class='warning'>You are not authorized to send announcements.</span>"
			updateUsrDialog()
	if (istype(O, /obj/item/weapon/stamp))
		if(screen == RCS_MESSAUTH)
			var/obj/item/weapon/stamp/T = O
			msgStamped = text("<font color='blue'><b>Stamped with the [T.name]</b></font>")
			updateUsrDialog()
	return

/obj/machinery/requests_console/proc/reset_announce()
	announceAuth = 0
	message = ""
	announcement.announcer = ""

#undef RCS_RQASSIST
#undef RCS_RQSUPPLY
#undef RCS_SENDINFO
#undef RCS_SENTPASS
#undef RCS_SENTFAIL
#undef RCS_VIEWMSGS
#undef RCS_MESSAUTH
#undef RCS_ANNOUNCE
#undef RCS_MAINMENU
