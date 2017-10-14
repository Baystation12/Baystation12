//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/department_manager//TODO:SANITY
	name = "Department Management Console"
	desc = "Used to view, edit and maintain department-related business."
	icon_keyboard = "security_key"
	icon_screen = "security"
	light_color = "#a91515"
	req_one_access = list(access_heads)
	var/obj/item/weapon/card/id/scan = null
	var/authenticated = null
	var/department = "Command"
	var/screen = 1 //Main screen always
	var/mob/living/carbon/human/profiled
	var/datum/browser/popup
	var/mob/living/carbon/human/idowner
	var/list/pendingrequests = list()

/obj/machinery/computer/department_manager/Initialize()
	. = ..()
	load_requests()

/obj/machinery/computer/department_manager/verb/eject_id()
	set category = "Object"
	set name = "Eject ID Card"
	set src in oview(1)

	if(!usr || usr.stat || usr.lying)	return

	if(scan)
		to_chat(usr, "You remove \the [scan] from \the [src].")
		if(!usr.get_active_hand() && istype(usr,/mob/living/carbon/human))
			usr.put_in_hands(scan)
		else
			scan.dropInto(loc)
		scan = null
		idowner = null
		profiled = null
		screen = 1
	else
		to_chat(usr, "There is nothing to remove from the console.")
	return

/obj/machinery/computer/department_manager/attackby(obj/item/O as obj, user as mob)
	if(istype(O, /obj/item/weapon/card/id) && !scan)
		usr.drop_item()
		O.forceMove(src)
		scan = O
		to_chat(user, "You insert [O].")
	else
		..()

/obj/machinery/computer/department_manager/attack_ai(mob/user as mob)
	return attack_hand(user)

//Someone needs to break down the dat += into chunks instead of long ass lines.
/obj/machinery/computer/department_manager/attack_hand(mob/user as mob)
	if(..())
		return
	ui_interact(user)

/obj/machinery/computer/department_manager/ui_interact(user)
	if (!isPlayerLevel(z))
		to_chat(user, "<span class='warning'>Unable to establish a connection:</span> You're too far away from the [station_name()]!")
		return
	var/dat
	if (authenticated)
		switch(screen)
			if(1)
				dat = {"
						<html>
						<head>
						<title>[department] Management Console</title>
						</head>
						<body>
						<h2>[department] Management Console</h2><br>
						<div font-size="medium">
						<a href='?src=\ref[src];screen=2'>Employee Database</a>
						<a href='?src=\ref[src];screen=3'>Financial Manager</a>
						"}
				if(department == "NanoTrasen") //NT console
					dat += "<a href='?src=\ref[src];screen=4'>Administrative Requests</a>"
				dat += "</div>"
			if(2)
				dat = "<ul>"
				for(var/mob/living/carbon/human/M in GLOB.mob_list)
					if(M.client && M.CharRecords.char_department == get_department(department, 0) || department == "NanoTrasen")
						dat += {"<li><b>Name:</b> [M.real_name]<br>
						<b>Age:</b> [M.age]<br>
						<b>Occupation:</b> [M.job]<br>
						<b>Occupation Experience: [get_department_rank_title(get_department(M.CharRecords.char_department, 1), M.CharRecords.department_rank)]<br>
						<b>Clocked Hours:</b> [round(M.CharRecords.department_playtime/3600, 0.1)]<br>
						<b>Employee Grade:</b> [round(M.CharRecords.employeescore, 0.01)]
						<a href='?src=\ref[src];choice=Profile;profiled=\ref[M]'>Profile</a></li>"}
				dat += "</ul></body></html>"
			if(2.1) //Character Employee Profile
				dat = {"
						<html>
						<head>
							<title>[department] Management Console</title>
						</head>
						<body>
							<h1>[department] Management Console</h1>
							"}
				dat += {"
						<b>Name:</b> [profiled.real_name]<br>
						<b>Age:</b> [profiled.age]<br>
						<b>Occupation:</b> [profiled.job]<br>
						<b>Occupation Experience: [get_department_rank_title(get_department(profiled.CharRecords.char_department, 1), profiled.CharRecords.department_rank)]<br>
						<b>Clocked Hours:</b> [round(profiled.CharRecords.department_playtime/3600, 0.1)]<br>
						<b>Employee Grade:</b> [round(profiled.CharRecords.employeescore, 0.01)]
						"}
				dat += "<A href='?src=\ref[src];choice=records'>Employee Records</A><br><A href='?src=\ref[src];choice=promote'>Promote</A><br><A href='?src=\ref[src];choice=demote'>Demote</A><br>"
				dat += ""
				dat += "<A href='?src=\ref[src];choice=return'>Return</A>"
				dat += "</body></html>"
			if(2.2) //Character Employee Records
				dat = {"
				<html>
				<body>
				<b>[profiled.real_name] Character records:</b>
				"}
				for(var/N in profiled.CharRecords.employee_records)
					dat += "[N]<br>"
				dat += {"
				<A href='?src=\ref[src];choice=return'>Return</A>
				</html>
				</body>
				"}
			if(3)
				return //Nothin yet son!
	else
		dat += text("<A href='?src=\ref[];choice=Log In'>Log In</A>", src)

	popup = new(user, "dept_console", "[department] Management Console", 420, 480)
	popup.add_stylesheet("dept_console", 'html/browser/department_management_console.css')
	popup.set_content(jointext(dat, null))
	popup.open()
//	user.set_machine(src)
	return


/obj/machinery/computer/department_manager/Topic(href, href_list)
	if(..())
		return 1
	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.set_machine(src)
		switch(href_list["choice"])
			if("Log Out")
				authenticated = null
				if(!usr.get_active_hand() && istype(usr,/mob/living/carbon/human))
					usr.put_in_hands(scan)
				else
					scan.dropInto(loc)
				scan = null
				idowner = null
				profiled = null
				screen = 1
			if("Log In")
				if (istype(scan, /obj/item/weapon/card/id))
					if(check_access(scan))
						authenticated = scan.registered_name
						if(ishuman(usr))
							src.idowner = usr

			if("Profile")
				profiled = locate(href_list["profiled"])
				if(!profiled)	return to_chat(usr, "Unknown system error occurred, could not retrieve profile.")
				screen = 2
				popup.update()
			if("Return")
				screen = 1
				profiled = null
				popup.update()
/*--------------PROFILE BUTTONS--------------*/
			if("records")
				if(!profiled)	return to_chat(usr, "Unknown system error occurred, could not retrieve profile.")
				if(profiled.CharRecords.char_department != "Command" || profiled.job == "Captain") //Can't recommend your bosses?
					to_chat(usr, "Leave blank to cancel.")
					var/record = input("Insert Record:", "Record Management - Department Management") as text
					var/score = input("Insert record score (1-10) for the employee rating.", "Record Management - Department Management") as num
					if(!record)	return
					if(!score || !score in 1 to 10)	score = 0
					var/datum/ntrequest/NR = new()
					NR.make_request("record", idowner.ckey, idowner.real_name, profiled.ckey, profiled.real_name, record)
			if("promote")
				if(!profiled)	return to_chat(usr, "Unknown system error occurred, could not retrieve profile.")
				switch(alert("Promote [profiled.real_name] to a Senior- or Head Position?", "Promotion Screen", "Senior Position", "Head Position"))
					if("Head Position")
						if(department == "Command" && idowner.job == "Captain" || department == "NanoTrasen") //Captain can promote to head.
							var/record = input("Insert Reason/Record:", "Promotion Management - Department Management") as text
							var/datum/ntrequest/NR = new()
							NR.make_request("promote", idowner.ckey, idowner.real_name, profiled.ckey, profiled.real_name, record)
							to_chat(usr, "Request has been sent to NanoTrasen for review.")
					if("Senior Position")
						if(calculate_department_rank(profiled) < 3)
							to_chat(usr, "[profiled.real_name]'s rank is insufficient to allow for a promotion.")
							return
						else if(profiled.CharRecords.employeescore < 7)
							to_chat(usr, "[profiled.real_name]'s employee score is insufficient to allow for a promotion. (Minimum of 7 required)")
							return
						else if(profiled.CharRecords.promoted == 1)
							to_chat(usr, "[profiled.real_name] is already promoted!")
							return
						else
							var/record = input("Insert Reason/Record:", "Promotion Management - Department Management") as text
							var/score = input("Insert record score (1-10) for the employee rating.", "Record Management - Department Management") as num
							profiled.CharRecords.add_employeerecord(idowner.real_name, record, score, 0, 0, 0)
							profiled.CharRecords.promoted = 1
							calculate_department_rank(profiled) //Re-calculate to set proper rank.
							to_chat(usr, "Promotion complete.")
			if("demote")
				if(!profiled)	return to_chat(usr, "Unknown system error occurred, could not retrieve profile.")
				switch(alert("demote [profiled.real_name] from Senior- or Head Position?", "Promotion Screen", "Senior Position", "Head Position"))
					if("Head Position")
						if(department == "Command" && idowner.job == "Captain" || department == "NanoTrasen") //Captain can promote to head.
							var/record = input("Insert Reason/Record:", "Promotion Management - Department Management") as text
							var/score = input("Insert record score (1-10) for the employee rating.", "Record Management - Department Management") as num
							if(!record)	return
							if(!score || !score in 1 to 10)	score = 0
							var/datum/ntrequest/NR = new()
							NR.make_request("promote", idowner.ckey, idowner.real_name, profiled.ckey, profiled.real_name, record)
							profiled.CharRecords.add_employeerecord(idowner.real_name, record, score, 0, 0, 0)
							to_chat(usr, "Request has been sent to NanoTrasen for review.")
					if("Senior Position")
						if(profiled.CharRecords.promoted == 0)
							to_chat(usr, "[profiled.real_name] is not a senior employee!")
							return
						else
							var/record = input("Insert Reason/Record:", "Demotion Management - Department Management") as text
							var/score = input("Insert record score (1-10) for the employee rating.", "Record Management - Department Management") as num
							profiled.CharRecords.add_employeerecord(idowner.real_name, record, score, 0, 0, 0)
							profiled.CharRecords.promoted = 0
							calculate_department_rank(profiled) //Re-calculate to set proper rank.
							to_chat(usr, "Demotion complete.")

/*
			if("promote")
				if(!profiled)	return to_chat(usr, "Unknown system error occurred, could not retrieve profile.")
				switch(alert("Promote [profiled.real_name] to a Senior position or Head Role?","Promotion", "Senior Position", "Head Position", "No"))
					if("Senior Position")
						if(calculate_department_rank(profiled) < 3)
							to_chat(usr, "[profiled.real_name]'s rank is insufficient to allow for a promotion.")
							return
						else
							if(!profiled.CharRecords.promoted)
								profiled.CharRecords.promoted = 1
								calculate_department_rank(profiled) //Re-calculate to set proper rank.
					if("Head Position")
						if(department == "Command" && scan.assignment == "Captain") //Can promote to head I guess?
							if(!profiled.client.command_whitelist) //Not yet whitelisted
								if(profiled.CharRecords.promoted && profiled.CharRecords.recommendations.len == 3)
									profiled.client.command_whitelist = 1
									profiled.CharRecords.promoted = 2
									return to_chat(usr, "[profiled.real_name] has been promoted.")
								else
									return to_chat(usr, "[profiled.real_name] insufficient info to process.")
							else
								return to_chat(usr, "[profiled.real_name] is already eligible for head roles.")
					if("No")
						return
			if("demote")
				if(!profiled)	return to_chat(usr, "Unknown system error occurred, could not retrieve profile.")
				switch(alert("Would you like to demote [profiled.real_name] from his Senior position?","Senior Deomotion", "Yes", "No"))
					if("Yes")
						if(calculate_department_rank(profiled) < 3)
							return to_chat(usr, "[profiled.real_name]'s rank is insufficient to allow for a demotion.")
						else
							if(!profiled.CharRecords.promoted)
								return to_chat(usr, "[profiled.real_name] has not been promoted.")
							else
								profiled.CharRecords.promoted = 0
								calculate_department_rank(profiled) //Re-calculate to set proper rank.
					if("No")
						return
*/
			if("return")
				switch(screen)
					if(2)
						screen = 1
					if(2.1)
						screen = 2
					if(2.2)
						screen = 2.1
					if(3)
						screen = 1
				updateUsrDialog()

		if(profiled)
			profiled.CharRecords.save_persistent()
	add_fingerprint(usr)
	updateUsrDialog()
	return

/obj/machinery/computer/department_manager/proc/make_request(var/fromckey, var/fromchar, var/tockey, var/tochar, var/request)
