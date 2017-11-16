var/global/list/navbeacons = list()

/obj/machinery/navbeacon
	icon = 'icons/obj/objects.dmi'
	icon_state = "navbeacon0-f"
	name = "navigation beacon"
	desc = "A radio beacon used for bot navigation."
	level = 1
	plane = ABOVE_PLATING_PLANE
	layer = ABOVE_WIRE_LAYER
	anchored = 1

	var/open = 0		// true if cover is open
	var/locked = 1		// true if controls are locked
	var/location = ""	// location response text
	var/list/codes = list()		// assoc. list of transponder codes

	req_access = list(access_engine)

/obj/machinery/navbeacon/New()
	..()

	var/turf/T = loc
	hide(!T.is_plating())

	navbeacons += src

/obj/machinery/navbeacon/hide(var/intact)
	set_invisibility(intact ? 101 : 0)
	update_icon()

/obj/machinery/navbeacon/update_icon()
	var/state="navbeacon[open]"

	if(invisibility)
		icon_state = "[state]-f"	// if invisible, set icon to faded version
									// in case revealed by T-scanner
	else
		icon_state = "[state]"

/obj/machinery/navbeacon/attackby(var/obj/item/I, var/mob/user)
	var/turf/T = loc
	if(!T.is_plating())
		return		// prevent intraction when T-scanner revealed

	if(isScrewdriver(I))
		open = !open

		user.visible_message("\The [user] [open ? "opens" : "closes"] cover of \the [src].", "You [open ? "open" : "close"] cover of \the [src].")

		update_icon()

	else if(I.GetIdCard())
		if(open)
			if (src.allowed(user))
				src.locked = !src.locked
				to_chat(user, "Controls are now [src.locked ? "locked." : "unlocked."]")
			else
				to_chat(user, "<span class='warning'>Access denied.</span>")
			updateDialog()
		else
			to_chat(user, "You must open the cover first!")
	return

/obj/machinery/navbeacon/attack_ai(var/mob/user)
	interact(user, 1)

/obj/machinery/navbeacon/attack_hand(var/mob/user)

	if(!user.IsAdvancedToolUser())
		return 0

	interact(user, 0)

/obj/machinery/navbeacon/interact(var/mob/user, var/ai = 0)
	var/turf/T = loc
	if(!T.is_plating())
		return		// prevent intraction when T-scanner revealed

	if(!open && !ai)	// can't alter controls if not open, unless you're an AI
		to_chat(user, "The beacon's control cover is closed.")
		return

	var/t

	if(locked && !ai)
		t = {"<TT><B>Navigation Beacon</B><HR><BR>
<i>(swipe card to unlock controls)</i><BR><HR>
Location: [location ? location : "(none)"]</A><BR>
Transponder Codes:<UL>"}

		for(var/key in codes)
			t += "<LI>[key] ... [codes[key]]"
		t+= "<UL></TT>"

	else

		t = {"<TT><B>Navigation Beacon</B><HR><BR>
<i>(swipe card to lock controls)</i><BR><HR>
Location: <A href='byond://?src=\ref[src];locedit=1'>[location ? location : "(none)"]</A><BR>
Transponder Codes:<UL>"}

		for(var/key in codes)
			t += "<LI>[key] ... [codes[key]]"
			t += " <small><A href='byond://?src=\ref[src];edit=1;code=[key]'>(edit)</A>"
			t += " <A href='byond://?src=\ref[src];delete=1;code=[key]'>(delete)</A></small><BR>"
		t += "<small><A href='byond://?src=\ref[src];add=1;'>(add new)</A></small><BR>"
		t+= "<UL></TT>"

	user << browse(t, "window=navbeacon")
	onclose(user, "navbeacon")
	return

/obj/machinery/navbeacon/Topic(href, href_list)
	..()
	if (usr.stat)
		return
	if ((in_range(src, usr) && istype(src.loc, /turf)) || (istype(usr, /mob/living/silicon)))
		if(open && !locked)
			usr.set_machine(src)

			if(href_list["locedit"])
				var/newloc = sanitize(input("Enter New Location", "Navigation Beacon", location) as text|null)
				if(newloc)
					location = newloc
					updateDialog()

			else if(href_list["edit"])
				var/codekey = href_list["code"]

				var/newkey = input("Enter Transponder Code Key", "Navigation Beacon", codekey) as text|null
				if(!newkey)
					return

				var/codeval = codes[codekey]
				var/newval = input("Enter Transponder Code Value", "Navigation Beacon", codeval) as text|null
				if(!newval)
					newval = codekey
					return

				codes.Remove(codekey)
				codes[newkey] = newval

				updateDialog()

			else if(href_list["delete"])
				var/codekey = href_list["code"]
				codes.Remove(codekey)
				updateDialog()

			else if(href_list["add"])

				var/newkey = input("Enter New Transponder Code Key", "Navigation Beacon") as text|null
				if(!newkey)
					return

				var/newval = input("Enter New Transponder Code Value", "Navigation Beacon") as text|null
				if(!newval)
					newval = "1"
					return

				if(!codes)
					codes = new()

				codes[newkey] = newval

				updateDialog()

/obj/machinery/navbeacon/Destroy()
	navbeacons.Remove(src)
	..()

// Patrol beacon types below. So many.

/obj/machinery/navbeacon/Security
	location = "Security"
	codes = list("patrol" = 1, "next_patrol" = "EVA")

/obj/machinery/navbeacon/EVA
	location = "EVA"
	codes = list("patrol" = 1, "next_patrol" = "Lockers")

/obj/machinery/navbeacon/Lockers
	location = "Lockers"
	codes = list("patrol" = 1, "next_patrol" = "CHW")

/obj/machinery/navbeacon/CHW
	location = "CHW"
	codes = list("patrol" = 1, "next_patrol" = "QM")

/obj/machinery/navbeacon/QM
	location = "QM"
	codes = list("patrol" = 1, "next_patrol" = "AIW")

/obj/machinery/navbeacon/AIW
	location = "AIW"
	codes = list("patrol" = 1, "next_patrol" = "AftH")

/obj/machinery/navbeacon/AftH
	location = "AftH"
	codes = list("patrol" = 1, "next_patrol" = "AIE")

/obj/machinery/navbeacon/AIE
	location = "AIE"
	codes = list("patrol" = 1, "next_patrol" = "CHE")

/obj/machinery/navbeacon/CHE
	location = "CHE"
	codes = list("patrol" = 1, "next_patrol" = "HOP")

/obj/machinery/navbeacon/HOP
	location = "HOP"
	codes = list("patrol" = 1, "next_patrol" = "Stbd")

/obj/machinery/navbeacon/Stbd
	location = "Stbd"
	codes = list("patrol" = 1, "next_patrol" = "HOP2")

/obj/machinery/navbeacon/HOP2
	location = "HOP2"
	codes = list("patrol" = 1, "next_patrol" = "Dorm")

/obj/machinery/navbeacon/Dorm
	location = "Dorm"
	codes = list("patrol" = 1, "next_patrol" = "EVA2")

/obj/machinery/navbeacon/EVA2
	location = "EVA2"
	codes = list("patrol" = 1, "next_patrol" = "Security") // And the cycle is finished

// Delivery types below.

/obj/machinery/navbeacon/QM1
	location = "QM #1"
	codes = list("delivery" = 1, "dir" = 8)

/obj/machinery/navbeacon/QM2
	location = "QM #2"
	codes = list("delivery" = 1, "dir" = 8)

/obj/machinery/navbeacon/QM3
	location = "QM #3"
	codes = list("delivery" = 1, "dir" = 8)

/obj/machinery/navbeacon/QM4
	location = "QM #4"
	codes = list("delivery" = 1, "dir" = 8)

/obj/machinery/navbeacon/Research
	location = "Research Division"
	codes = list("delivery" = 1, "dir" = 8)

/obj/machinery/navbeacon/Janitor
	location = "Janitor"
	codes = list("delivery" = 1, "dir" = 8)

/obj/machinery/navbeacon/SecurityD
	location = "Security"
	codes = list("delivery" = 1, "dir" = 8)

/obj/machinery/navbeacon/ToolStorage
	location = "Tool Storage"
	codes = list("delivery" = 1, "dir" = 8)

/obj/machinery/navbeacon/Medbay
	location = "Medbay"
	codes = list("delivery" = 1, "dir" = 4)

/obj/machinery/navbeacon/Engineering
	location = "Engineering"
	codes = list("delivery" = 1, "dir" = 4)

/obj/machinery/navbeacon/Bar
	location = "Bar"
	codes = list("delivery" = 1, "dir" = 2)

/obj/machinery/navbeacon/Kitchen
	location = "Kitchen"
	codes = list("delivery" = 1, "dir" = 2)

/obj/machinery/navbeacon/Hydroponics
	location = "Hydroponics"
	codes = list("delivery" = 1, "dir" = 2)

// Torch types below

/obj/machinery/navbeacon/torch/bridge1
	location = "bridge1"
	codes = list("patrol" = 1, "next_patrol" = "bridge2")

/obj/machinery/navbeacon/torch/FDforehallway3
	location = "FDforehallway3"
	codes = list("patrol" = 1, "next_patrol" = "FDforehallway4")

/obj/machinery/navbeacon/torch/FDforehallway4
	location = "FDforehallway4"
	codes = list("patrol" = 1, "next_patrol" = "FDelevator2")

/obj/machinery/navbeacon/torch/FDelevator2
	location = "FDelevator2"
	codes = list("patrol" = 1, "next_patrol" = "Supply")

/obj/machinery/navbeacon/torch/Supply
	location = "Supply"
	codes = list("patrol" = 1, "next_patrol" = "FDelevator")

/obj/machinery/navbeacon/torch/FDelevator
	location = "FDelevator"
	codes = list("patrol" = 1, "next_patrol" = "FDforehallway1")

/obj/machinery/navbeacon/torch/FDforehallway1
	location = "FDforehallway1"
	codes = list("patrol" = 1, "next_patrol" = "FDforehallway2")

/obj/machinery/navbeacon/torch/telecomms
	location = "telecomms"
	codes = list("patrol" = 1, "next_patrol" = "briefingroom2")

/obj/machinery/navbeacon/torch/aiupload2
	location = "aiupload2"
	codes = list("patrol" = 1, "next_patrol" = "brig")

/obj/machinery/navbeacon/torch/brig
	location = "brig"
	codes = list("patrol" = 1, "next_patrol" = "aiupload")

/obj/machinery/navbeacon/torch/aiupload
	location = "aiupload"
	codes = list("patrol" = 1, "next_patrol" = "forehallway")

/obj/machinery/navbeacon/torch/briefingroom2
	location = "briefingroom2"
	codes = list("patrol" = 1, "next_patrol" = "forehallway2")

/obj/machinery/navbeacon/torch/forehallway2
	location = "forehallway2"
	codes = list("patrol" = 1, "next_patrol" = "aiupload2")

/obj/machinery/navbeacon/torch/briefingroom
	location = "briefingroom"
	codes = list("patrol" = 1, "next_patrol" = "telecomms")

/obj/machinery/navbeacon/torch/forehallway
	location = "forehallway"
	codes = list("patrol" = 1, "next_patrol" = "briefingroom")

/obj/machinery/navbeacon/torch/bridge1
	location = "bridge1"
	codes = list("patrol" = 1, "next_patrol" = "bridge2")

/obj/machinery/navbeacon/torch/bridge2
	location = "bridge2"
	codes = list("patrol" = 1, "next_patrol" = "rdoffice")

/obj/machinery/navbeacon/torch/vault2
	location = "vault2"
	codes = list("patrol" = 1, "next_patrol" = "medical")

/obj/machinery/navbeacon/torch/vault1
	location = "vault1"
	codes = list("patrol" = 1, "next_patrol" = "xooffice")

/obj/machinery/navbeacon/torch/medical
	location = "medical"
	codes = list("patrol" = 1, "next_patrol" = "vault1")

/obj/machinery/navbeacon/torch/bridge2
	location = "bridge2"
	codes = list("patrol" = 1, "next_patrol" = "rdoffice")

/obj/machinery/navbeacon/torch/rdoffice
	location = "rdoffice"
	codes = list("patrol" = 1, "next_patrol" = "vault2")

// Torch delivery types

/obj/machinery/navbeacon/torch/QM3
	location = "QM #3"
	codes = list("delivery" = 1)