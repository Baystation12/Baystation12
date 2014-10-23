/obj/machinery/turretid
	name = "Turret deactivation control"
	icon = 'icons/obj/device.dmi'
	icon_state = "motion3"
	anchored = 1
	density = 0
	var/enabled = 1
	var/lethal = 0
	var/locked = 1
	var/control_area //can be area name, path or nothing.
	var/ailock = 0 // AI cannot use this
	req_access = list(access_ai_upload)

/obj/machinery/turretid/New()
	..()
	if(!control_area)
		var/area/CA = get_area(src)
		if(CA.master && CA.master != CA)
			control_area = CA.master
		else
			control_area = CA
	else if(istext(control_area))
		for(var/area/A in world)
			if(A.name && A.name==control_area)
				control_area = A
				break
	//don't have to check if control_area is path, since get_area_all_atoms can take path.
	return

/obj/machinery/turretid/attackby(obj/item/weapon/W, mob/user)
	if(stat & BROKEN) return
	if (istype(user, /mob/living/silicon))
		return src.attack_hand(user)

	if (istype(W, /obj/item/weapon/card/emag) && !emagged)
		user << "\red You short out the turret controls' access analysis module."
		emagged = 1
		locked = 0
		if(user.machine==src)
			src.attack_hand(user)

		return

	else if( get_dist(src, user) == 0 )		// trying to unlock the interface
		if (src.allowed(usr))
			if(emagged)
				user << "<span class='notice'>The turret control is unresponsive.</span>"
				return

			locked = !locked
			user << "<span class='notice'>You [ locked ? "lock" : "unlock"] the panel.</span>"
			if (locked)
				if (user.machine==src)
					user.unset_machine()
					user << browse(null, "window=turretid")
			else
				if (user.machine==src)
					src.attack_hand(user)
		else
			user << "<span class='warning'>Access denied.</span>"

/obj/machinery/turretid/attack_ai(mob/user as mob)
	if(!ailock)
		return attack_hand(user)
	else
		user << "<span class='notice'>There seems to be a firewall preventing you from accessing this device.</span>"

/obj/machinery/turretid/attack_hand(mob/user as mob)
	if ( get_dist(src, user) > 0 )
		if ( !issilicon(user) )
			user << "<span class='notice'>You are too far away.</span>"
			user.unset_machine()
			user << browse(null, "window=turretid")
			return

	user.set_machine(src)
	var/loc = src.loc
	if (istype(loc, /turf))
		loc = loc:loc
	if (!istype(loc, /area))
		user << text("Turret badly positioned - loc.loc is [].", loc)
		return
	var/area/area = loc
	var/t = "<TT><B>Turret Control Panel</B> ([area.name])<HR>"

	if(src.locked && (!istype(user, /mob/living/silicon)))
		t += "<I>(Swipe ID card to unlock control panel.)</I><BR>"
	else
		t += text("Turrets [] - <A href='?src=\ref[];toggleOn=1'>[]?</a><br>\n", src.enabled?"activated":"deactivated", src, src.enabled?"Disable":"Enable")
		t += text("Currently set for [] - <A href='?src=\ref[];toggleLethal=1'>Change to []?</a><br>\n", src.lethal?"lethal":"stun repeatedly", src,  src.lethal?"Stun repeatedly":"Lethal")

	user << browse(t, "window=turretid")
	onclose(user, "turretid")

/obj/machinery/turretid/Topic(href, href_list, var/nowindow = 0)
	if(..(href, href_list))
		return
	if (src.locked)
		if (!istype(usr, /mob/living/silicon))
			usr << "Control panel is locked!"
			return
	if ( get_dist(src, usr) == 0 || issilicon(usr))
		if (href_list["toggleOn"])
			src.enabled = !src.enabled
			src.updateTurrets()
		else if (href_list["toggleLethal"])
			src.lethal = !src.lethal
			src.updateTurrets()
	if(!nowindow)
		src.attack_hand(usr)

/obj/machinery/turretid/proc/updateTurrets()
	if(control_area)
		for (var/obj/machinery/turret/aTurret in get_area_all_atoms(control_area))
			aTurret.setState(enabled, lethal)
	src.update_icons()

/obj/machinery/turretid/proc/update_icons()
	if (src.enabled)
		if (src.lethal)
			icon_state = "motion1"
		else
			icon_state = "motion3"
	else
		icon_state = "motion0"
																				//CODE FIXED BUT REMOVED
//	if(control_area)															//USE: updates other controls in the area
//		for (var/obj/machinery/turretid/Turret_Control in world)				//I'm not sure if this is what it was
//			if( Turret_Control.control_area != src.control_area )	continue	//supposed to do. Or whether the person
//			Turret_Control.icon_state = icon_state								//who coded it originally was just tired
//			Turret_Control.enabled = enabled									//or something. I don't see  any situation
//			Turret_Control.lethal = lethal										//in which this would be used on the current map.
																				//If he wants it back he can uncomment it