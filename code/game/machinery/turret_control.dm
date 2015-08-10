////////////////////////
//Turret Control Panel//
////////////////////////

/area
	// Turrets use this list to see if individual power/lethal settings are allowed
	var/list/turret_controls = list()

/obj/machinery/turretid
	name = "turret control panel"
	desc = "Used to control a room's automated defenses."
	icon = 'icons/obj/machines/turret_control.dmi'
	icon_state = "control_standby"
	anchored = 1
	density = 0
	var/enabled = 0
	var/lethal = 0
	var/locked = 1
	var/control_area //can be area name, path or nothing.

	var/check_arrest = 1	//checks if the perp is set to arrest
	var/check_records = 1	//checks if a security record exists at all
	var/check_weapons = 0	//checks if it can shoot people that have a weapon they aren't authorized to have
	var/check_access = 1	//if this is active, the turret shoots everything that does not meet the access requirements
	var/check_anomalies = 1	//checks if it can shoot at unidentified lifeforms (ie xenos)
	var/check_synth = 0 	//if active, will shoot at anything not an AI or cyborg
	var/ailock = 0 			// AI cannot use this

	req_access = list(access_ai_upload)

/obj/machinery/turretid/stun
	enabled = 1
	icon_state = "control_stun"

/obj/machinery/turretid/lethal
	enabled = 1
	lethal = 1
	icon_state = "control_kill"

/obj/machinery/turretid/Del()
	if(control_area)
		var/area/A = control_area
		if(A && istype(A))
			A.turret_controls -= src
	..()

/obj/machinery/turretid/initialize()
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
	power_change() //Checks power and initial settings
	//don't have to check if control_area is path, since get_area_all_atoms can take path.

	if(control_area)
		var/area/A = control_area
		if(A && istype(A))
			A.turret_controls += src
	return

/obj/machinery/turretid/proc/can_use(mob/user)
	if(ailock && issilicon(user))
		user << "<span class='notice'>There seems to be a firewall preventing you from accessing this device.</span>"
		return 0

	if (get_dist(src, user) > 0 && !issilicon(user))
		user << "<span class='notice'>You are too far away.</span>"
		user.unset_machine()
		user << browse(null, "window=turretid")
		return 0

	if(locked && !issilicon(user))
		user << "<span class='notice'>Access denied.</span>"
		return 0

	return 1

/obj/machinery/turretid/attackby(obj/item/weapon/W, mob/user)
	if(stat & BROKEN) return
	if (istype(user, /mob/living/silicon))
		return src.attack_hand(user)

	if (istype(W, /obj/item/weapon/card/emag) && !emagged)
		user << "<span class='danger'>You short out the turret controls' access analysis module.</span>"
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
	return attack_hand(user)

/obj/machinery/turretid/attack_hand(mob/user as mob)
	if(!can_use(user))
		return

	user.set_machine(src)
	var/loc = src.loc
	if (istype(loc, /turf))
		var/turf/T = loc
		loc = T.loc
	if (!istype(loc, /area))
		return
	var/area/area = loc
	var/dat = text({"Status: []<BR>
				Behaviour controls are [locked ? "locked" : "unlocked"]"},
				"<A href='?src=\ref[src];operation=toggleon'>[enabled ? "On" : "Off"]</A>" )

	if(!locked || issilicon(user))
		dat += text({"<BR><BR>
					Lethal Mode: []<BR>
					Neutralize All Non-Synthetics: []<BR>"},

					"<A href='?src=\ref[src];operation=togglelethal'>[lethal ? "Enabled" : "Disabled"]</A>",
					"<A href='?src=\ref[src];operation=toggleai'>[check_synth ? "Yes" : "No"]</A>")
		if(!check_synth)
			dat += text({"Check for Weapon Authorization: []<BR>
					Check Security Records: []<BR>
					Check Arrest Status: []<BR>
					Neutralize All Non-Authorized Personnel: []<BR>
					Neutralize All Unidentified Life Signs: []<BR>"},

					"<A href='?src=\ref[src];operation=authweapon'>[check_weapons ? "Yes" : "No"]</A>",
					"<A href='?src=\ref[src];operation=checkrecords'>[check_records ? "Yes" : "No"]</A>",
					"<A href='?src=\ref[src];operation=checkarrest'>[check_arrest ? "Yes" : "No"]</A>",
					"<A href='?src=\ref[src];operation=checkaccess'>[check_access ? "Yes" : "No"]</A>",
					"<A href='?src=\ref[src];operation=checkxenos'>[check_anomalies ? "Yes" : "No"]</A>" )
	else
		dat += "<div class='notice icon'>Swipe ID card to unlock interface</div>"

	//user << browse(t, "window=turretid")
	//onclose(user, "turretid")
	var/datum/browser/popup = new(user, "turretid", "Turret Control Panel ([area.name])", 500, 500)
	popup.set_content(dat)
	popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()

/obj/machinery/turretid/Topic(href, href_list, var/nowindow = 0)
	if(..())
		return 1

	if(!can_use(usr))
		return 1

	switch(href_list["operation"])	//toggles customizable behavioural protocols
		if("toggleon")
			enabled = !enabled
		if("togglelethal")
			lethal = !lethal
		if("toggleai")
			check_synth = !check_synth
		if("authweapon")
			check_weapons = !check_weapons
		if("checkrecords")
			check_records = !check_records
		if("checkarrest")
			check_arrest = !check_arrest
		if("checkaccess")
			check_access = !check_access
		if("checkxenos")
			check_anomalies = !check_anomalies

	src.updateTurrets()

	if(!nowindow)
		attack_hand(usr)

/obj/machinery/turretid/updateDialog()
	if (stat & (BROKEN|MAINT))
		return
	..()

/obj/machinery/turretid/proc/updateTurrets()
	var/datum/turret_checks/TC = new
	TC.on = enabled
	TC.lethal = lethal
	TC.check_synth = check_synth
	TC.check_access = check_access
	TC.check_records = check_records
	TC.check_arrest = check_arrest
	TC.check_weapons = check_weapons
	TC.check_anomalies = check_anomalies
	TC.ailock = ailock

	if(control_area)
		for (var/obj/machinery/porta_turret/aTurret in get_area_all_atoms(control_area))
			aTurret.setState(TC)
	src.update_icon()

/obj/machinery/turretid/power_change()
	..()
	updateTurrets()
	update_icon()

/obj/machinery/turretid/update_icon()
	..()
	if(stat & NOPOWER)
		icon_state = "control_off"
	else if (enabled)
		if (lethal)
			icon_state = "control_kill"
		else
			icon_state = "control_stun"
	else
		icon_state = "control_standby"

/obj/machinery/turretid/emp_act(severity)
	if(enabled)
		//if the turret is on, the EMP no matter how severe disables the turret for a while
		//and scrambles its settings, with a slight chance of having an emag effect

		check_arrest = pick(0, 1)
		check_records = pick(0, 1)
		check_weapons = pick(0, 1)
		check_access = pick(0, 0, 0, 0, 1)	// check_access is a pretty big deal, so it's least likely to get turned on
		check_anomalies = pick(0, 1)

		enabled=0
		updateTurrets()

		spawn(rand(60,600))
			if(!enabled)
				enabled=1
				updateTurrets()

	..()
