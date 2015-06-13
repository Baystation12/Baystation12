/var/global/security_level = 0
//0 = code green
//1 = code blue
//2 = code red
//3 = code delta
//4 = code black

//config.alert_desc_blue_downto
/var/datum/announcement/priority/security/security_announcement_up = new(do_log = 0, do_newscast = 1, new_sound = sound('sound/misc/notice1.ogg'))
/var/datum/announcement/priority/security/security_announcement_down = new(do_log = 0, do_newscast = 1)
/var/datum/announcement/priority/security/security_announcement_red = new(do_log = 0, do_newscast = 1, new_sound = sound('sound/misc/bloblarm.ogg'))
/var/datum/announcement/priority/security/security_announcement_delta = new(do_log = 0, do_newscast = 1, new_sound = sound('sound/effects/siren.ogg'))

/proc/givesecaccess()

	for(var/obj/item/weapon/card/id/M in world)
		if (M.assignment == "Security Officer")
			M.access += access_medical
			M.access += access_research
			M.access += access_engine_equip
			M.access += access_mining
			M.access += access_cargo

		if (M.assignment == "Security Guard")
			M.access += access_medical
			M.access += access_research
			M.access += access_engine_equip
			M.access += access_mining
			M.access += access_cargo

		if (M.assignment == "Warden")
			M.access += access_medical
			M.access += access_research
			M.access += access_engine_equip
			M.access += access_mining
			M.access += access_cargo

		if (M.assignment == "Head of Security")
			M.access += access_research
			M.access += access_engine_equip
			M.access += access_mining

		if (M.assignment == "Security Commander")
			M.access += access_research
			M.access += access_engine_equip
			M.access += access_mining

/proc/opencodeblueaccess()
	for(var/obj/machinery/door/blast/shutters/bluealert/D in world)
		D.open()

/proc/opencoderedaccess()
	for(var/obj/machinery/door/blast/reddoors/D in world)
		D.open()

/proc/removesecaccess()

	for(var/obj/item/weapon/card/id/M in world)
		if (M.assignment == "Security Officer")
			M.access -= access_medical
			M.access -= access_research
			M.access -= access_engine_equip
			M.access -= access_mining
			M.access -= access_cargo

		if (M.assignment == "Security Guard")
			M.access -= access_medical
			M.access -= access_research
			M.access -= access_engine_equip
			M.access -= access_mining
			M.access -= access_cargo

		if (M.assignment == "Warden")
			M.access -= access_medical
			M.access -= access_research
			M.access -= access_engine_equip
			M.access -= access_mining
			M.access -= access_cargo

		if (M.assignment == "Head of Security")
			M.access -= access_research
			M.access -= access_engine_equip
			M.access -= access_mining

		if (M.assignment == "Security Commander")
			M.access -= access_research
			M.access -= access_engine_equip
			M.access -= access_mining

/proc/closecodeblueaccess()
	for(var/obj/machinery/door/blast/shutters/bluealert/D in world)
		D.close()

/proc/closecoderedaccess()
	for(var/obj/machinery/door/blast/reddoors/D in world)
		D.close()

/proc/set_security_level(var/level)
	switch(level)
		if("green")
			level = SEC_LEVEL_GREEN
		if("blue")
			level = SEC_LEVEL_BLUE
		if("red")
			level = SEC_LEVEL_RED
		if("delta")
			level = SEC_LEVEL_DELTA
		if("black")
			level = SEC_LEVEL_BLACK

	//Will not be announced if you try to set to the same level as it already is
	if(level >= SEC_LEVEL_GREEN && level <= SEC_LEVEL_BLACK && level != security_level)
		switch(level)
			if(SEC_LEVEL_GREEN)
				security_announcement_down.Announce("[config.alert_desc_green]", "Attention! Security level lowered to green")
				security_level = SEC_LEVEL_GREEN
				for(var/obj/machinery/firealarm/FA in machines)
					if(FA.z in config.contact_levels)
						FA.overlays = list()
						FA.overlays += image('icons/obj/monitors.dmi', "overlay_green")
				removesecaccess()
				closecoderedaccess()
				closecodeblueaccess()


			if(SEC_LEVEL_BLUE)
				if(security_level < SEC_LEVEL_BLUE)
					security_announcement_up.Announce("[config.alert_desc_blue_upto]", "Attention! Security level elevated to blue")
				else
					security_announcement_down.Announce("[config.alert_desc_blue_downto]", "Attention! Security level lowered to blue")
				security_level = SEC_LEVEL_BLUE
				for(var/obj/machinery/firealarm/FA in machines)
					if(FA.z in config.contact_levels)
						FA.overlays = list()
						FA.overlays += image('icons/obj/monitors.dmi', "overlay_blue")
				removesecaccess()
				closecoderedaccess()
				opencodeblueaccess()

			if(SEC_LEVEL_RED)
				if(security_level < SEC_LEVEL_RED)
					security_announcement_red.Announce("[config.alert_desc_red_upto]", "Attention! Code red!")
				else
					security_announcement_down.Announce("[config.alert_desc_red_downto]", "Attention! Code red!")
				security_level = SEC_LEVEL_RED
				/*	- At the time of commit, setting status displays didn't work properly
				var/obj/machinery/computer/communications/CC = locate(/obj/machinery/computer/communications,world)
				if(CC)
					CC.post_status("alert", "redalert")*/
				for(var/obj/machinery/firealarm/FA in machines)
					if(FA.z == 1 || FA.z == 5 || FA.z == 7 || FA.z == 8)
						FA.overlays = list()
						FA.overlays += image('icons/obj/monitors.dmi', "overlay_red")
				givesecaccess()
				opencoderedaccess()
				opencodeblueaccess()

			if(SEC_LEVEL_BLACK)
				security_announcement_up.Announce("A biological threat to the station has been confirmed. The station is now under quarantine. No personnel are allowed to leave the stations at this time. Security personnel are to ensure quarantine protocols are upheld. Medical and research personnel are to remain on stand-by. All personnel must report to their supervisors immediately.", "Attention! Code black!")
				security_level = SEC_LEVEL_BLACK
				for(var/obj/machinery/firealarm/FA in machines)
					if(FA.z in config.contact_levels)
						FA.overlays = list()
						FA.overlays += image('icons/obj/monitors.dmi', "overlay_black")
				opencoderedaccess()

			if(SEC_LEVEL_DELTA)
				security_announcement_delta.Announce("[config.alert_desc_delta]", "Attention! Delta security level reached!")
				security_level = SEC_LEVEL_DELTA
				for(var/obj/machinery/firealarm/FA in machines)
					if(FA.z in config.contact_levels)
						FA.overlays = list()
						FA.overlays += image('icons/obj/monitors.dmi', "overlay_delta")
				opencoderedaccess()

		for(var/obj/machinery/light/emergency/EL in world)
			EL.update()
	else
		return

/proc/get_security_level()
	switch(security_level)
		if(SEC_LEVEL_GREEN)
			return "green"
		if(SEC_LEVEL_BLUE)
			return "blue"
		if(SEC_LEVEL_RED)
			return "red"
		if(SEC_LEVEL_DELTA)
			return "delta"
		if(SEC_LEVEL_BLACK)
			return "black"

/proc/num2seclevel(var/num)
	switch(num)
		if(SEC_LEVEL_GREEN)
			return "green"
		if(SEC_LEVEL_BLUE)
			return "blue"
		if(SEC_LEVEL_RED)
			return "red"
		if(SEC_LEVEL_DELTA)
			return "delta"
		if(SEC_LEVEL_BLACK)
			return "black"

/proc/seclevel2num(var/seclevel)
	switch( lowertext(seclevel) )
		if("green")
			return SEC_LEVEL_GREEN
		if("blue")
			return SEC_LEVEL_BLUE
		if("red")
			return SEC_LEVEL_RED
		if("delta")
			return SEC_LEVEL_DELTA
		if("black")
			return SEC_LEVEL_BLACK


/*DEBUG
/mob/verb/set_thing0()
	set_security_level(0)
/mob/verb/set_thing1()
	set_security_level(1)
/mob/verb/set_thing2()
	set_security_level(2)
/mob/verb/set_thing3()
	set_security_level(3)
*/