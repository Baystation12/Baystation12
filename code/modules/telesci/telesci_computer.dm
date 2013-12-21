/obj/machinery/computer/telescience
	name = "Telepad Control Console"
	desc = "Used to teleport objects to and from the telescience telepad."
	icon_state = "teleport"
	var/x_co	// X coordinate
	var/y_co	// Y coordinate
	var/z_co	// Z coordinate

/obj/machinery/computer/telescience/update_icon()
	if(stat & BROKEN)
		icon_state = "telescib"
	else
		if(stat & NOPOWER)
			src.icon_state = "teleport0"
			stat |= NOPOWER
		else
			icon_state = initial(icon_state)
			stat &= ~NOPOWER

/obj/machinery/computer/telescience/attack_paw(mob/user)
	usr << "You are too primitive to use this computer."
	return

/obj/machinery/telescience/station/attack_ai(mob/user)
	src.attack_hand()

/obj/machinery/computer/telescience/attack_hand(mob/user)
	if(..())
		return
	if(stat & (NOPOWER|BROKEN))
		return
	var/t = ""
	t += "<A href='?src=\ref[src];setx=1'>Set X</A>"
	t += "<A href='?src=\ref[src];sety=1'>Set Y</A>"
	t += "<A href='?src=\ref[src];setz=1'>Set Z</A>"
	t += "<BR><BR>Current set coordinates:"
	t += "([x_co], [y_co], [z_co])"
	t += "<BR><BR><A href='?src=\ref[src];send=1'>Send</A>"
	t += " <A href='?src=\ref[src];receive=1'>Receive</A>"
	var/datum/browser/popup = new(user, "telesci", name, 640, 480)
	popup.set_content(t)
	popup.open()
	return

/obj/machinery/computer/telescience/proc/dosend()
	for(var/obj/machinery/telepad/E in world)
		var/A = get_turf(E)
		var/target = locate(x_co, y_co, z_co)
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, A)
		s.start()
		flick("pad-beam", E)
		usr << "\blue Teleport successful."
		investigate_log("[key_name(usr)]/[usr] has teleported with Telescience at [x_co],[y_co],[z_co], in [A ? A.name : "null area"].","telesci")
		for(var/atom/movable/ROI in A)
			// if is anchored, don't let through
			if(ROI.anchored)
				if(isliving(ROI))
					var/mob/living/L = ROI
					if(L.buckled)
						// TP people on office chairs
						if(L.buckled.anchored)
							continue
					else
						continue
				else if(!isobserver(ROI))
					continue
			do_teleport(ROI, target)
		return
	return

/obj/machinery/computer/telescience/proc/doreceive()
	for(var/obj/machinery/telepad/E in world)
		var/A = get_turf(E)
		var/T = locate(x_co, y_co, z_co)
		var/G = get_turf(T)
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, A)
		s.start()
		flick("pad-beam", E)
		usr << "\blue Teleport successful."
		investigate_log("[key_name(usr)]/[usr] has teleported with Telescience at [x_co],[y_co],[z_co], in [A ? A.name : "null area"].","telesci")
		for(var/atom/movable/ROI in G)
			// if is anchored, don't let through
			if(ROI.anchored)
				if(isliving(ROI))
					var/mob/living/L = ROI
					if(L.buckled)
						// TP people on office chairs
						if(L.buckled.anchored)
							continue
					else
						continue
				else if(!isobserver(ROI))
					continue
			do_teleport(ROI, A)
		return
	return

/obj/machinery/computer/telescience/proc/telesend()
	if(x_co == null || y_co == null || z_co == null)
		usr << "<span class = 'caution'>  Error: set coordinates.</span>"
		return
	if(x_co < 1 || x_co > 255)
		usr << "<span class = 'caution'>  Error: X is less than 1 or greater than 255.</span>"
		return
	if(y_co < 1 || y_co > 255)
		usr << "<span class = 'caution'>  Error: Y is less than 1 or greater than 255.</span>"
		return
	if(z_co == 2 || z_co < 1 || z_co > 7)
		usr << "<span class = 'caution'>  Error: Z is less than 1, greater than 7, or equal to 2.</span>"
		return
	else
		dosend()

/obj/machinery/computer/telescience/proc/telereceive()
	if(x_co == null || y_co == null || z_co == null)
		usr << "<span class = 'caution'>  Error: set coordinates.</span>"
		return
	if(x_co < 1 || x_co > 255)
		usr << "<span class = 'caution'>  Error: X is less than 1 or greater than 255.</span>"
		return
	if(y_co < 1 || y_co > 255)
		usr << "<span class = 'caution'>  Error: Y is less than 1 or greater than 255.</span>"
		return
	if(z_co == 2 || z_co < 1 || z_co > 7)
		usr << "<span class = 'caution'>  Error: Z is less than 1, greater than 7, or equal to 2.</span>"
		return
	else
		doreceive()

/obj/machinery/computer/telescience/Topic(href, href_list)
	if(..())
		return
	if(href_list["setx"])
		var/new_x = input("Please input desired X coordinate.", name, x_co) as num
		x_co = Clamp(new_x, 1, 9999)
		return
	if(href_list["sety"])
		var/new_y = input("Please input desired Y coordinate.", name, y_co) as num
		y_co = Clamp(new_y, 1, 9999)
		return
	if(href_list["setz"])
		var/new_z = input("Please input desired Z coordinate.", name, z_co) as num
		z_co = Clamp(new_z, 1, 9999)
		return
	if(href_list["send"])
		telesend()
		return
	if(href_list["receive"])
		telereceive()
		return