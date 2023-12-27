/datum/terminal_command/connect
	name = "connect"
	man_entry = list(
		"Format: connect \[REMOTE id].",
		"Standard format show you data about REMOTE, it needn't access of REMOTE.",
		"Open format: connect \[REMOTE id] -open. To close REMOTE, replace '-open' by '-close'. Need airlock accessible",
		"Locking (bolting) format: connect \[REMOTE id] -lock. To unlock use -unlock. Need airlock access.",
		"In red and orange code you can override airlock access by using override key. Like this: 'connect y421 -open -override Yota11'"
	)
	pattern = "^connect"
	skill_needed = SKILL_TRAINED

/datum/terminal_command/connect/proper_input_entered(text, mob/user, datum/terminal/terminal)
	var/list/txt = splittext(text, " ")


	if ((length(txt)==1) || ((length(txt)==2) && (length(txt[2])!=5)))
		return "[name]: syntax error. Use 'man [name]'"

// AIRLOCK
	if (copytext(txt[2],1,3) == "AL")
		var/NTID = txt[2]
		var/obj/machinery/door/airlock/REMOTE = terminal.get_remote_ID(NTID)
		if (length(txt)==2)
			. += "Outputting data about airlock([NTID]):<hr>"
			. += "Name:   [REMOTE.name]<br>"
			. += "Energy: [REMOTE.main_power_lost_until ? "<font color = '#ff0000'>OFFLINE</font>" : "<font color = '#00ff00'>ONLINE</font>"]"
			. += "<pre>Network data:<br>"
			. += "	NTNet connection: [REMOTE.ai_control_disabled ? "<font color = '#ff0000'>ERROR</font>" : "<font color = '#00ff00'>STABLE</font>"].<br>"
//			. += "	AI cover: [REMOTE.hackProof ? "<font color = '#00ff00'>ACTIVE</font>" : "<font color = '#ff0000'>OUT OF SERVICE</font>"].<hr></pre>"
			var/electrified_state
			switch(REMOTE.electrified_until)
				if(-1)
					electrified_state = "<font color = '#fffa29'>PERMANENT</font>"
				if(0)
					electrified_state = "<font color ='#00ff00'>FALSE</font>"
				else
					electrified_state = "<font color = '#ff0000'>TRUE</font>"
			. += "<pre>Local functional data:<br>"
			. += "	Electrified: [electrified_state].<br>"
			. += "	Bolts: [REMOTE.locked ? "<font color = '#ff0000'>LOCKED DOWN</font>" : "<font color = '#00ff00'>OUT OF SERVICE</font>"].<br>"
			. += "	Lights: [REMOTE.lights ? "<font color = '#00ff00'>STABLE</font>" : "<font color = '#ff0000'>OUT OF SERVICE</font>"].<br><hr>"
			. += "SAFETY DATA:<br>"
			. += "	Airlock timing: [REMOTE.normalspeed ? "<font color = '#00ff00'>STABLE</font>" : "<font color = '#ff0000'>OVERRIDEN</font>"].<br>"
			. += "	Safety protocols: [REMOTE.safe ? "<font color = '#00ff00'>STABLE</font>" : "<font color = '#ff0000'>OVERRIDEN</font>"].<br></pre>"
			. += "Required Access: [length(REMOTE.req_access)>=1 ? "([jointext(REMOTE.req_access, ", ") ])" : "ACCESS NOT REQUIRED"].<hr>"
			. += "Acces check: [has_access(REMOTE.req_access, user.GetAccess()) ? "<font color = '#00ff00'>GRANTED</font>" : "<font color = '#ff0000'>DENIED</font>"]."
			return

		if(!has_access(REMOTE.req_access, user.GetAccess())) // && !override)
			return "[name]: <font color = '#ff0000'>ACCESS ERROR.</font>"


		else if (length(txt)==3)
			switch(txt[3])
				if("-open")
					if(!REMOTE.open()) // лютая хуета, но тока так корректно отрабатывает
						. += "[name]: unable to open airlock, maybe it bolted or already opened or lack for energy."
						return
					. += "[name]: Airlock with id([NTID]) was opened."
					return
				if("-close")
					REMOTE.close()
					if(!REMOTE.density)
						. += "[name]: FALSE."
						return
					. += "[name]: Airlock with id([NTID]) TRUE."
					return
				if("-lock")
					if(!REMOTE.lock())
						. += "[name]: unable to close airlock, maybe it bolted or already locked or lack for energy."
						return
					. += "[name]: Airlock with id([NTID]) was locked."
					return
				if("-unlock")
					if(!REMOTE.unlock())
						. += "[name]: unable to close airlock, maybe it bolted or already unlocked or lack for energy."
						return
					. += "[name]: Airlock with id([NTID]) was unlocked."
					return

				else
					return "[text[3]]: <font color = '#ff0000'>ERROR</font>: Unknown parametr."
		else
			. += "[name]: <font color = '#ff0000'>ERROR 404:</font>: Unknown ID."

// APC
	if (copytext(txt[2],1,3) == "PC")
		var/NTID = txt[2]
		var/obj/machinery/power/apc/REMOTE = terminal.get_remote_ID(NTID)
		if (length(txt)==2)
			var/obj/item/cell/BAT = REMOTE.get_cell()
			. += "Outputting data about APC([NTID]):<hr>"
			. += "Name:[copytext(REMOTE.name,2)]<br>"
			. += "Batery:[BAT ? num2text(BAT.percent())+"%" : "<font color = '#ff0000'>NONE</font>"]<br>"
			. += "Status:[REMOTE.locked ? "<font color = '#00ff00'>BLOCKED</font>" : "<font color = '#ff0000'>OPEN</font>"]<br><hr>"
			return


		if ((length(txt)==3) && (has_access(REMOTE.req_access, user.GetAccess() || !REMOTE.locked)))
			switch(txt[3])
				//lock-unlock panel
				if("-lock")
					REMOTE.locked = 1
					. += "APC panel <font color = '#00ff00'>BLOCKED</font>"
					REMOTE.update_icon()
				if("-unlock")
					REMOTE.locked = 0
					. += "APC panel <font color = '#ff0000'>OPEN</font>"
					REMOTE.update_icon()
				//lock-unlock cover
				if("-lock-cover")
					REMOTE.coverlocked  = 1
					. += "APC cover <font color = '#00ff00'>BLOCKED</font>"
				if("-unlock-cover")
					REMOTE.coverlocked  = 0
					. += "APC cover <font color = '#ff0000'>OPEN</font>"
				//light control
				if("-light-up")
					REMOTE.lighting = 3
					REMOTE.update_overlay_chan["Lighting"] = 3
					. += "Light up"
				if("-light-down")
					REMOTE.lighting  = 0
					REMOTE.update_overlay_chan["Lighting"] = 0
					. += "Light down"
				if("-light-auto")
					REMOTE.lighting = 4
					REMOTE.update_overlay_chan["Lighting"] = 4
					. += "Light automated"


				else
					return "Wrong parametr"
			REMOTE.update()
			return
		else
			return "ACCESS ERROR"


// FIREALARM
	if (copytext(txt[2],1,3) == "FA")
		var/NTID = txt[2]
		var/obj/machinery/firealarm/REMOTE = terminal.get_remote_ID(NTID)
		if (length(txt)==2)
			. += "Outputting data about firealarm([NTID]):<hr>"
			. += "Name:   [REMOTE.name]<br> <hr>"
			. += "Status:   [REMOTE.detecting  ? "<font color = '#00ff00'>Automatic</font>" : "<font color = '#ff0000'>OFF</font>"].<br><hr>"
			return
		else if (length(txt)==3)
			switch(txt[3])
				if("-alarm")
					REMOTE.alarm()
					return "Activated"
				if("-reset")
					REMOTE.reset()
					return "Deactivated"
				if("-detect")
					REMOTE.detecting = !REMOTE.detecting
					return "Automatic switched to: [REMOTE.detecting  ? "<font color = '#00ff00'>ON</font>" : "<font color = '#ff0000'>OFF</font>"]."

	else
		. += "Syntax mismach"
