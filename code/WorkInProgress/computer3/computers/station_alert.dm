/obj/machinery/computer3/station_alert
	default_prog = /datum/file/program/station_alert
	spawn_parts = list(/obj/item/part/computer/storage/hdd,/obj/item/part/computer/networking/radio)
	icon_state = "frame-eng"


/datum/file/program/station_alert
	name = "Station Alert Console"
	desc = "Used to access the station's automated alert system."
	active_state = "alert:0"
	var/alarms = list("Fire"=list(), "Atmosphere"=list(), "Power"=list())

	interact(mob/user)
		usr.set_machine(src)
		if(!interactable())
			return
		var/dat = "<HEAD><TITLE>Current Station Alerts</TITLE><META HTTP-EQUIV='Refresh' CONTENT='10'></HEAD><BODY>\n"
		dat += "<A HREF='?src=\ref[user];mach_close=alerts'>Close</A><br><br>"
		for (var/cat in src.alarms)
			dat += text("<B>[]</B><BR>\n", cat)
			var/list/L = src.alarms[cat]
			if (L.len)
				for (var/alarm in L)
					var/list/alm = L[alarm]
					var/area/A = alm[1]
					var/list/sources = alm[3]
					dat += "<NOBR>"
					dat += "&bull; "
					dat += "[A.name]"
					if (sources.len > 1)
						dat += text(" - [] sources", sources.len)
					dat += "</NOBR><BR>\n"
			else
				dat += "-- All Systems Nominal<BR>\n"
			dat += "<BR>\n"
		//user << browse(dat, "window=alerts")
		//onclose(user, "alerts")
		popup.set_content(dat)
		popup.set_title_image(usr.browse_rsc_icon(computer.icon, computer.icon_state))
		popup.open()
		return


	Topic(href, href_list)
		if(..())
			return
		return


	proc/triggerAlarm(var/class, area/A, var/O, var/alarmsource)
		var/list/L = src.alarms[class]
		for (var/I in L)
			if (I == A.name)
				var/list/alarm = L[I]
				var/list/sources = alarm[3]
				if (!(alarmsource in sources))
					sources += alarmsource
				return 1
		var/obj/machinery/camera/C = null
		var/list/CL = null
		if (O && istype(O, /list))
			CL = O
			if (CL.len == 1)
				C = CL[1]
		else if (O && istype(O, /obj/machinery/camera))
			C = O
		L[A.name] = list(A, (C) ? C : O, list(alarmsource))
		return 1


	proc/cancelAlarm(var/class, area/A as area, obj/origin)
		var/list/L = src.alarms[class]
		var/cleared = 0
		for (var/I in L)
			if (I == A.name)
				var/list/alarm = L[I]
				var/list/srcs  = alarm[3]
				if (origin in srcs)
					srcs -= origin
				if (srcs.len == 0)
					cleared = 1
					L -= I
		return !cleared



	process()
		var/active_alarms = 0
		for (var/cat in src.alarms)
			var/list/L = src.alarms[cat]
			if(L.len) active_alarms = 1
		if(active_alarms)
			active_state = "alert:2"
		else
			active_state = "alert:0"
		..()
		return
