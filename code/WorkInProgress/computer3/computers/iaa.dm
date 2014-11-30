//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31
/obj/machinery/computer3/iaa
	default_prog = /datum/file/program/iaa
	spawn_parts = list(/obj/item/part/computer/storage/hdd,/obj/item/part/computer/cardslot,/obj/item/part/computer/networking/radio)
	icon_state = "frame-sec"

/obj/machinery/computer3/laptop/iaa
	default_prog = /datum/file/program/iaa
	spawn_parts = list(/obj/item/part/computer/storage/hdd/big,/obj/item/part/computer/cardslot,/obj/item/part/computer/networking/radio)
	icon_state = "laptop"

/datum/file/program/iaa
	name = "Internal Affairs Console"
	active_state = "comm_logs"
	req_access = list(access_lawyer)

	var/obj/item/weapon/card/id/scan = null
	var/obj/item/weapon/card/id/scan2 = null
	var/authenticated = null
	var/rank = null
	var/id = 0.0
	var/temp = null
	var/status = 0
	var/timeleft = 60
	var/stop = 0.0
	var/screen = 0 // 0 - No Access Denied, 1 - Access allowed

	proc/authenticate()
		if(access_lawyer in scan.access)
			return 1
		return 0

	interact()
		if(!interactable())
			return
		var/dat
		dat += "<B>Internal Affairs Console</B><BR>"
		if(!computer.cardslot)
			computer.Crash(MISSING_PERIPHERAL)
			return
		usr.set_machine(src)
		scan = computer.cardslot.reader

		if (computer.cardslot.dualslot)
			scan2 = computer.cardslot.writer

		if(!interactable())
			return

		if (temp)
			dat = text("<TT>[]</TT><BR><BR><A href='?src=\ref[];choice=Clear Screen'>Clear Screen</A>", temp, src)
		else
			dat = text("Confirm Identity (R): <A href='?src=\ref[];choice=Confirm Identity R'>[]</A><HR>", src, (scan ? text("[]", scan.name) : "----------"))
			if (computer.cardslot.dualslot)
				dat += text("Check Identity (W): <A href='?src=\ref[];choice=Confirm Identity W'>[]</A><BR>", src, (scan2 ? text("[]", scan2.name) : ))
				if(scan2 && !scan)
					dat += text("<div class='notice'>Insert card into reader slot to log in.</div><br>")
			if (authenticated)
				dat += text("<A href='?src=\ref[];choice=Log Out'>Log Out</A>",src)
				if(screen == 1)
					dat += "<HR>Personnel of the NSS Phoenix<BR>"
					var/turf/Tr = null
					for(var/mob/living/carbon/human/M in world)
						var/iaarevoked = M.iaarevoked
						Tr = get_turf(M)
						if((Tr) && (Tr.z != computer.z))	continue//Out of range
						if(!M.mind.special_role == null)	continue
						if(iaarevoked == 1)
							dat += "[M.name] | <A href='?src=\ref[src];employ=\ref[M]'>(<font color=green><B>Assign Employment</B></font>)</A>"
							dat += "<BR>----------<BR>"
						else
							dat += "[M.name] | <A href='?src=\ref[src];terminate=\ref[M]'>(<font color=red><B>Terminate Employment</B></font>)</A>"
							dat += "<BR>----------<BR>"
			else
				dat += text("<A href='?src=\ref[];choice=Log In'>Log In</A>", src)

		popup.width = 400
		popup.height = 500
		popup.set_content(dat)
		popup.set_title_image(usr.browse_rsc_icon(computer.icon, computer.icon_state))
		popup.open()
		return


	process()
		if(!..())
			interact()
		return


	Topic(href, href_list)
		if(!interactable() || ..(href,href_list))
			return
		switch(href_list["choice"])
//BASIC FUNCTIONS
			if("Clear Screen")
				temp = null

			if ("Return")
				screen = 1

			if("Confirm Identity R")
				if (scan)
					if(istype(usr,/mob/living/carbon/human) && !usr.get_active_hand())
						computer.cardslot.remove(1)
					else
						scan.loc = get_turf(src)
					scan = null
				else
					var/obj/item/I = usr.get_active_hand()
					if (istype(I, /obj/item/weapon/card/id))
						computer.cardslot.insert(I, 1)
						scan = I

			if("Confirm Identity W")
				if (scan2)
					if(istype(usr,/mob/living/carbon/human) && !usr.get_active_hand())
						computer.cardslot.remove(2)
					else
						scan2.loc = get_turf(src)
					scan2 = null
				else
					var/obj/item/I = usr.get_active_hand()
					if (istype(I, /obj/item/weapon/card/id))
						computer.cardslot.insert(I, 2)
						scan2 = I

			if("Log Out")
				authenticated = null
				screen = null

			if("Log In")
				if (istype(usr, /mob/living/silicon/ai))
					src.authenticated = usr.name
					src.rank = "AI"
					src.screen = 1
				else if (istype(usr, /mob/living/silicon/robot))
					src.authenticated = usr.name
					var/mob/living/silicon/robot/R = usr
					src.rank = "[R.modtype] [R.braintype]"
					src.screen = 1
				else if (istype(scan, /obj/item/weapon/card/id))
					if(authenticate())
						authenticated = scan.registered_name
						rank = scan.assignment
						screen = 1

		if(href_list["terminate"])
			var/mob/living/carbon/human/M = locate(href_list["terminate"])
			if(M.iaa == 1)
				if(M.iaarevoked == 0)
					M.iaarevoked = 1
					M << "\red You hear your PDA beep informing you your contract with nanotrasen has been terminated."
			else
				usr << "You cannot terminate an employee without proper authorization from Nanotrasen, perhaps fax them first."

		if(href_list["employ"])
			var/mob/living/carbon/human/M = locate(href_list["employ"])
			if(M.iaa == 1)
				if(M.iaarevoked == 1)
					M.iaarevoked = 0
					M << "\green You hear your PDA beep informing you your contract with nanotrasen has been confirmed."
			else
				usr << "You cannot employ someone without proper authorization from Nanotrasen, perhaps fax them first."

		else if(href_list["lock"])
			screen = !screen

		interact()
		return


