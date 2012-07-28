
/obj/machinery/computer/rust/fuel_control
	name = "Fuel Injection Control"
	icon_state = "power"
	var/list/fuel_injectors
	var/list/stage_status
	var/announce_fueldepletion = 0
	var/announce_stageprogression = 0
	//var/obj/machinery/rust/fuel_injector/Injector = null
	New()
		..()
		//these are the only three stages we can accept
		//we have another console for SCRAM
		fuel_injectors = new/list
		stage_status = new/list

		fuel_injectors.Add("One")
		fuel_injectors["One"] = new/list
		stage_status.Add("One")
		stage_status["One"] = 0
		fuel_injectors.Add("Two")
		fuel_injectors["Two"] = new/list
		stage_status.Add("Two")
		stage_status["Two"] = 0
		fuel_injectors.Add("Three")
		fuel_injectors["Three"] = new/list
		stage_status.Add("Three")
		stage_status["Three"] = 0
		fuel_injectors.Add("SCRAM")
		fuel_injectors["SCRAM"] = new/list
		stage_status.Add("SCRAM")
		stage_status["SCRAM"] = 0

		spawn(0)
			for(var/obj/machinery/rust/fuel_injector/Injector in world)
				if(Injector.stage in fuel_injectors)
					var/list/targetlist = fuel_injectors[Injector.stage]
					targetlist.Add(Injector)

	attack_ai(mob/user)
		attack_hand(user)

	attack_hand(mob/user)
		add_fingerprint(user)
		/*if(stat & (BROKEN|NOPOWER))
			return*/
		interact(user)

	/*updateDialog()
		for(var/mob/M in range(1))
			if(M.machine == src)
				interact(m)*/

	Topic(href, href_list)
		..()
		if( href_list["close"] )
			usr << browse(null, "window=fuel_monitor")
			usr.machine = null
			return
		if( href_list["beginstage"] )
			var/stage_name = href_list["beginstage"]
			if(stage_name in fuel_injectors)
				var/success = 1
				for(var/obj/machinery/rust/fuel_injector/Injector in fuel_injectors[stage_name])
					if(!Injector.BeginInjecting())
						success = 0
				if(!success)	//may still partially complete
					usr << "\red Unable to complete command."
				stage_status[stage_name] = 1
			updateDialog()
			return
		if( href_list["begincool"] )
			var/stage_name = href_list["begincool"]
			if(stage_name in fuel_injectors)
				for(var/obj/machinery/rust/fuel_injector/Injector in fuel_injectors[stage_name])
					Injector.StopInjecting()
				stage_status[stage_name] = 0
			updateDialog()
			return
		if( href_list["restart"] )
			updateDialog()
			return
		if( href_list["cooldown"] )
			for(var/stage_name in fuel_injectors)
				for(var/obj/machinery/rust/fuel_injector/Injector in fuel_injectors[stage_name])
					Injector.StopInjecting()
				stage_status[stage_name] = 0
			updateDialog()
			return
		if( href_list["update"] )
			updateDialog()
			return
		//
		if( href_list["disable_fueldepletion"] )
			announce_fueldepletion = 0
			updateDialog()
			return
		if( href_list["announce_fueldepletion"] )
			announce_fueldepletion = 1
			updateDialog()
			return
		if( href_list["broadcast_fueldepletion"] )
			announce_fueldepletion = 2
			updateDialog()
			return
		//
		if( href_list["disable_stageprogression"] )
			announce_stageprogression = 0
			updateDialog()
			return
		if( href_list["announce_stageprogression"] )
			announce_stageprogression = 1
			updateDialog()
			return
		if( href_list["broadcast_stageprogression"] )
			announce_stageprogression = 2
			updateDialog()
			return

	process()
		..()
		src.updateDialog()

	proc
		interact(mob/user)
			if ( (get_dist(src, user) > 1 ) || (stat & (BROKEN|NOPOWER)) )
				if (!istype(user, /mob/living/silicon))
					user.machine = null
					user << browse(null, "window=fuel_monitor")
					return
			var/t = "<B>Reactor Core Fuel Control</B><BR>"
			var/cooling = 0
			for(var/stage in stage_status)
				if(stage_status[stage])
					t += "Fuel injection: <font color=blue>Active</font><br>"
					t += "<a href='?src=\ref[src];cooldown=1;'>Enter cooldown phase</a><br>"
					cooling = 1
					break
			if(!cooling)
				t += "Fuel injection: <font color=blue>Cooling</font><br>"
				t += "----<br>"
			//
			t += "Fuel depletion announcement: "
			t += "[announce_fueldepletion ? 		"<a href='?src=\ref[src];disable_fueldepletion=1'>Disable</a>" : "<b>Disabled</b>"] "
			t += "[announce_fueldepletion == 1 ? 	"<b>Announcing</b>" : "<a href='?src=\ref[src];announce_fueldepletion=1'>Announce</a>"] "
			t += "[announce_fueldepletion == 2 ? 	"<b>Broadcasting</b>" : "<a href='?src=\ref[src];broadcast_fueldepletion=1'>Broadcast</a>"]<br>"
			t += "Stage progression announcement: "
			t += "[announce_stageprogression ? 		"<a href='?src=\ref[src];disable_stageprogression=1'>Disable</a>" : "<b>Disabled</b>"] "
			t += "[announce_stageprogression == 1 ? 	"<b>Announcing</b>" : "<a href='?src=\ref[src];announce_stageprogression=1'>Announce</a>"] "
			t += "[announce_stageprogression == 2 ? 	"<b>Broadcasting</b>" : "<a href='?src=\ref[src];broadcast_stageprogression=1'>Broadcast</a>"] "
			t += "<hr>"
			t += "<table border=1><tr>"
			t += "<td><b>Injector Status</b></td>"
			t += "<td><b>Injection interval (sec)</b></td>"
			t += "<td><b>Assembly consumption per injection</b></td>"
			t += "<td><b>Fuel Assembly Port</b></td>"
			t += "<td><b>Assembly depletion percentage</b></td>"
			t += "</tr>"
			for(var/stage_name in fuel_injectors)
				var/list/cur_stage = fuel_injectors[stage_name]
				t += "<tr><td colspan=5><b>Fuel Injection Stage:</b> [stage_name]</font>, [stage_status[stage_name] ? "<font color=green>Active</font>  <a href='?src=\ref[src];begincool=[stage_name]'>\[Enter cooldown\]</a>" : "Cooling <a href='?src=\ref[src];beginstage=[stage_name]'>\[Begin injection\]</a>"]</td></tr>"
				for(var/obj/machinery/rust/fuel_injector/Injector in cur_stage)
					t += "<tr>"
					t += "<td>[Injector.on && Injector.remote_enabled ? "<font color=green>Operational</font>" : "<font color=red>Unresponsive</font>"]</td>"
					t += "<td>[Injector.rate/10] <a href='?src=\ref[Injector];cyclerate=1'>Modify</a></td>"
					t += "<td>[Injector.fuel_usage*100]% <a href='?src=\ref[Injector];fuel_usage=1'>Modify</a></td>"
					t += "<td>[Injector.owned_assembly_port ? "[Injector.owned_assembly_port.cur_assembly ? "<font color=green>Loaded</font>": "<font color=blue>Empty</font>"]" : "<font color=red>Disconnected</font>" ]</td>"
					t += "<td>[Injector.owned_assembly_port && Injector.owned_assembly_port.cur_assembly ? "[Injector.owned_assembly_port.cur_assembly.percent_depleted]%" : ""]</td>"
					t += "</tr>"
			t += "</table>"
			t += "<A href='?src=\ref[src];close=1'>Close</A><BR>"
			user << browse(t, "window=fuel_monitor;size=500x600")
			user.machine = src
