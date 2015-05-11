/obj/machinery/computer/crew
	name = "crew monitoring computer"
	desc = "Used to monitor active health sensors built into most of the crew's uniforms."
	icon_state = "crew"
	use_power = 1
	idle_power_usage = 250
	active_power_usage = 500
	circuit = "/obj/item/weapon/circuitboard/crew"
	var/obj/nano_module/crew_monitor/crew_monitor

/obj/machinery/computer/crew/New()
	crew_monitor = new(src)
	..()


/obj/machinery/computer/crew/attack_ai(mob/user)
	attack_hand(user)
	ui_interact(user)


/obj/machinery/computer/crew/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	ui_interact(user)

/obj/machinery/computer/crew/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	crew_monitor.ui_interact(user, ui_key, ui, force_open)

/obj/machinery/computer/crew/update_icon()

	if(stat & BROKEN)
		icon_state = "crewb"
	else
		if(stat & NOPOWER)
			src.icon_state = "c_unpowered"
			stat |= NOPOWER
		else
			icon_state = initial(icon_state)
			stat &= ~NOPOWER

/*/obj/machinery/computer/crew/Topic(href, href_list)
	if(..()) return
	if (src.z > 8)
		usr << "\red <b>Unable to establish a connection</b>: \black You're too far away from the station!"
		return 0
	if( href_list["close"] )
		var/mob/user = usr
		var/datum/nanoui/ui = nanomanager.get_open_ui(user, src, "main")
		usr.unset_machine()
		ui.close()
		return 0
	if(href_list["update"])
		src.updateDialog()
		return 1
*/

/obj/machinery/computer/crew/interact(mob/user)
/*	ui_interact(user)
		if((C) && (C.has_sensor) && (pos) && C.sensor_mode)
				var/newz = pos.z
				if (pos.z == 1)
					newz = 1
				else if (pos.z == 7)
					newz = 0
				else if (pos.z == 8)
					newz = 2
				else
					newz = pos.z
				crewmemberData["Floor"] = newz
			if (H.iscorpse == 1) continue
	return 1*/
	crew_monitor.ui_interact(user)
