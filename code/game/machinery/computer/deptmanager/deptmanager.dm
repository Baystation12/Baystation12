/obj/machinery/computer/department_manager
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
	var/employeecount = 0
	var/changedrecord = 0
	var/next_run = 0

/obj/machinery/computer/department_manager/Initialize()
	. = ..()
	load_requests()

/obj/machinery/computer/department_manager/Process()
	if(world.time < next_run + 30 SECONDS)
		return
	next_run = world.time

	employeecount = 0
	for(var/mob/living/carbon/human/M in GLOB.player_list)
		if(M.CharRecords.char_department == get_department(department, 0) || department == "NanoTrasen")
			employeecount++
//	if(!DeptRequests && department == "NanoTrasen")
//		DeptRequests = new("data/ntrequests.sav")
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
	if(authenticated)
		switch(screen)
			if(1)
				dat = {"
						<html>
						<head>
						<title>[department] Management Console</title>
						</head>
						<body>
						<b>Department:</b> [department]<br>
						<b>Employee Count:</b> [employeecount] Employees<br>
						<hr>
						<h3>Financial Information (Current Shift)</h3>
						<b>Current Balance: (Handled by NT Administration)</b><br>
						<b>Total Earnings: (Handled by NT Administration)</b><br>
						<b>Total Loss: (Handled by NT Administration)</b><hr>
						<div font-size="medium">
						<a href='?src=\ref[src];choice=employeedb'>Employee Database</a>
						<a href='?src=\ref[src];choice=finances'>Financial Manager</a>
						"}
				if(department == "NanoTrasen") //NT console
					dat += "<a href='?src=\ref[src];choice=ntpanel'>Administrative Requests</a>"
				dat += "</div>"
			if(2)
				dat = "<ul>"
				for(var/mob/living/carbon/human/M in GLOB.player_list)
					if(M.CharRecords.char_department == get_department(department, 0) || department == "NanoTrasen")
						dat += {"<li><b>Name:</b> [M.real_name]<br>
						<b>Age:</b> [M.age]<br>
						<b>Occupation:</b> [M.job]<br>
						<b>Occupation Experience: [get_department_rank_title(get_department(M.CharRecords.char_department, 1), M.CharRecords.department_rank)]<br>
						<b>Clocked Hours:</b> [round(M.CharRecords.department_playtime/3600, 0.1)]<br>
						<b>Employee Grade:</b> [round(M.CharRecords.employeescore, 0.01)]<hr>
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
						<b>Occupation Rank: [get_department_rank_title(get_department(profiled.CharRecords.char_department, 1), profiled.CharRecords.department_rank)]<br>
						<b>Clocked Hours:</b> [round(profiled.CharRecords.department_playtime/3600, 0.1)]<br>
						<b>Employee Grade:</b> [round(profiled.CharRecords.employeescore, 0.01)]<hr>
						<A href='?src=\ref[src];choice=records'>Employee Records</A><br><A href='?src=\ref[src];choice=promote'>Promote</A><br><A href='?src=\ref[src];choice=demote'>Demote</A><br>"}
				dat += "</body></html>"
			if(2.2) //Character Employee Records
				dat = {"
				<html>
				<body>
				<b>[profiled.real_name] Character records:</b>
				"}
				var/list/records = profiled.CharRecords.display_employeerecords()
				dat += "<ul>"
				for(var/REC in records)
					dat += "<li>[REC]</li><br>"
				dat += "<A href='?src=\ref[src];choice=addrecord'>Add Record</A><br>"
				dat += {"
				</ul>
				</html>
				</body>
				"}
			if(3)
				dat += "<A href='?src=\ref[src];choice=return'>Return</A>"
				return //Nothin yet son!
			if(4)
				if(department == "NanoTrasen")
					dat = {"
					<html>
					<body>
					<h3>Administrative Section</h3><br>
					<i>(Beware, changes are permanent, only authorized personnel allowed!)</i>
					<hr>
					"}
					dat += "<ul>"
					for(var/datum/ntrequest/N in pendingdeptrequests)
						dat += "<li>REQUEST-#[N.requestid]<b>|</b>[N.requesttype], FROM [N.fromchar]. TO [N.tochar]. FOR [N.requesttext] <a href='?src=\ref[src];choice=handlereq;requestid=[N.requestid]'>Handle</a></li><br>"
					dat += {"
					</ul>
					</html>
					</body>
					"}
		dat += "<A href='?src=\ref[src];choice=return'>Return</A>"
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
							screen = 1
			if("employeedb")
				screen = 2
			if("finances")
				screen = 3
			if("ntpanel")
				screen = 4
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
					if(4)
						screen = 1
			if("Profile")
				profiled = locate(href_list["profiled"])
				if(!profiled)	return to_chat(usr, "Unknown system error occurred, could not retrieve profile.")
				screen = 2.1
				popup.update()
/*--------------PROFILE BUTTONS--------------*/
			if("records")
				if(!profiled)	return to_chat(usr, "Unknown system error occurred, could not retrieve profile.")
				screen = 2.2
			if("addrecord")
				if(!profiled)	return to_chat(usr, "Unknown system error occurred, could not retrieve profile.")
				if(profiled.CharRecords.char_department != "Command" || profiled.job == "Captain" || profiled.CharRecords.promoted == 2) //Can't see your bosses, Captain or Heads.
					to_chat(usr, "Leave blank to cancel.")
					var/record = input("Insert Record:", "Record Management - Department Management") as text
					var/score = input("Insert record score (1-10) for the employee rating.", "Record Management - Department Management") as num
					if(!record)	return
					if(!score || !score in 1 to 10)	score = 0
					var/datum/ntrequest/NR = new()
					NR.make_request(src, "record", idowner, profiled, record, score)
				changedrecord = 1
			if("promote")
				if(!profiled)	return to_chat(usr, "Unknown system error occurred, could not retrieve profile.")
				switch(alert("Promote [profiled.real_name] to a Senior- or Head Position?", "Promotion Screen", "Senior Position", "Head Position"))
					if("Head Position")
						if(department == "Command" && idowner.job == "Captain" || department == "NanoTrasen") //Captain can promote to head.
							var/record = input("Insert Reason/Record:", "Promotion Management - Department Management") as text
							var/datum/ntrequest/NR = new()
							NR.make_request(src, "promote",idowner, profiled, record)
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
				changedrecord = 1
			if("demote")
				if(!profiled)	return to_chat(usr, "Unknown system error occurred, could not retrieve profile.")
				switch(alert("demote [profiled.real_name] from Senior- or Head Position?", "Promotion Screen", "Senior Position", "Head Position"))
					if("Head Position")
						if(department == "Command" && idowner.job == "Captain" || department == "NanoTrasen") //Captain can promote to head.
							var/record = input("Insert Reason/Record:", "Promotion Management - Department Management") as text
							if(!record)	return
							var/datum/ntrequest/NR = new()
							NR.make_request(src, "demote", idowner, profiled, record)
							profiled.CharRecords.add_employeerecord(idowner.real_name, record, 0, 0, 0, 0)
							to_chat(usr, "Request has been sent to NanoTrasen for review.")
					if("Senior Position")
						if(profiled.CharRecords.promoted == 0)
							to_chat(usr, "[profiled.real_name] is not a senior employee!")
							return
						else
							var/record = input("Insert Reason/Record:", "Demotion Management - Department Management") as text
							profiled.CharRecords.add_employeerecord(idowner.real_name, record, 0, 0, 0, 0)
							profiled.CharRecords.promoted = 0
							calculate_department_rank(profiled) //Re-calculate to set proper rank.
							to_chat(usr, "Demotion complete.")
				changedrecord = 1
			if("reqaccept")
				var/id = locate(href_list["requestid"])
				switch(alert("Are you sure you wish to accept?", "Pending requests", "Cancel", "Accept Request"))
					if("Cancel")
						return
					if("Accept Request")
						for(var/datum/ntrequest/N in pendingdeptrequests)
							if(N.requestid == id)
								for(var/mob/living/carbon/human/H in GLOB.player_list)
									if(H && N.real_name == H.real_name && N.ckey == H.ckey) //You're matched, say hello!
										switch(N.requesttype)
											if("record")
												H.CharRecords.add_employeerecord(N.fromchar,"[N.requesttext] (ACCEPTED)", N.score, 0, 0, 0, 0)
												pendingdeptrequests.Remove(N) //Remove from system after all is applied.
												qdel(N)
											if("promote")
												if(!H.CharRecords.promoted) //No can do..?
													pendingdeptrequests.Remove(N) //Remove from system after all is applied.
													qdel(N)
													return
												else if(H.CharRecords.promoted == 1)
													H.CharRecords.add_employeerecord(N.fromchar,"[N.requesttext] (ACCEPTED)", N.score, 0, 10, 0, 0)
													H.CharRecords.promoted = 2
													pendingdeptrequests.Remove(N) //Remove from system after all is applied.
													qdel(N)
											if("demote")
												if(!H.CharRecords.promoted) //No can do..?
													pendingdeptrequests.Remove(N) //Remove from system after all is applied.
													qdel(N)
													return
												H.CharRecords.add_employeerecord(N.fromchar,"[N.requesttext] (DENIED)", N.score, 0, 0, 0, 0)
												switch(H.CharRecords.promoted)
													if(1) //Promoted to Senior
														H.CharRecords.promoted = 0 //Back down yee!
													if(2) //Promoted to Head.
														H.CharRecords.promoted = 1 //Back down yee!
												pendingdeptrequests.Remove(N) //Remove from system after all is applied.
												qdel(N)
			if("reqdeny")
				var/id = locate(href_list["requestid"])
				switch(alert("Are you sure you wish to deny?", "Pending requests", "Cancel", "Deny Request"))
					if("Cancel")
						return
					if("Deny Request")
						for(var/datum/ntrequest/N in pendingdeptrequests)
							if(N.requestid == id)
								for(var/mob/living/carbon/human/H in GLOB.player_list)
									if(H && N.real_name == H.real_name && N.ckey == H.ckey) //You're matched, say hello!
										switch(N.requesttype)
											if("record")
												H.CharRecords.add_employeerecord(N.fromchar,"[N.requesttext] (DENIED)", N.score, 0, 0, 0, 0)
												pendingdeptrequests.Remove(N) //Remove from system after all is applied.
												qdel(N)
											if("promote")
												H.CharRecords.add_employeerecord(N.fromchar,"[N.requesttext] (DENIED)", N.score, 0, 0, 0, 0)
												pendingdeptrequests.Remove(N) //Remove from system after all is applied.
												qdel(N)
											if("demote")
												if(!H.CharRecords.promoted) //No can do..?
													pendingdeptrequests.Remove(N) //Remove from system after all is applied.
													qdel(N)
													return
												H.CharRecords.add_employeerecord(N.fromchar,"[N.requesttext] (DENIED)", N.score, 0, -10, 0, 0)
												switch(H.CharRecords.promoted)
													if(1) //Promoted to Senior
														H.CharRecords.promoted = 0 //Back down yee!
													if(2) //Promoted to Head.
														H.CharRecords.promoted = 1 //Back down yee!
												pendingdeptrequests.Remove(N) //Remove from system after all is applied.
												qdel(N)

		Save_Changes()
	add_fingerprint(usr)
//	popup.update()
	updateUsrDialog()
	return

/obj/machinery/computer/department_manager/proc/Save_Changes()
	if(profiled && changedrecord)
		if(profiled.CharRecords.save_persistent()) //If succeeded..
			changedrecord = 0