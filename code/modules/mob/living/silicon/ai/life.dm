/mob/living/silicon/ai/Life()
	if (src.stat == DEAD)
		return
	else //I'm not removing that shitton of tabs, unneeded as they are. -- Urist
		//Being dead doesn't mean your temperature never changes
		var/turf/T = get_turf(src)

		if (src.stat!=CONSCIOUS)
			src.cameraFollow = null
			src.reset_view(null)

		src.updatehealth()

		if (!hardware_integrity() || !backup_capacitor())
			death()
			return

		// If our powersupply object was destroyed somehow, create new one.
		if(!psupply)
			create_powersupply()


		// Handle power damage (oxy)
		if(aiRestorePowerRoutine != 0 && !APU_power)
			// Lose power
			adjustOxyLoss(1)
		else
			// Gain Power
			aiRestorePowerRoutine = 0 // Necessary if AI activated it's APU AFTER losing primary power.
			adjustOxyLoss(-1)

		handle_stunned()	// Handle EMP-stun
		lying = 0			// Handle lying down

		malf_process()

		if(APU_power && (hardware_integrity() < 50))
			src << "<span class='notice'><b>APU GENERATOR FAILURE! (System Damaged)</b></span>"
			stop_apu(1)

		var/blind = 0
		var/area/loc = null
		if (istype(T, /turf))
			loc = T.loc
			if (istype(loc, /area))
				if (!loc.power_equip && !istype(src.loc,/obj/item) && !APU_power)
					blind = 1

		if (!blind)
			src.sight |= SEE_TURFS
			src.sight |= SEE_MOBS
			src.sight |= SEE_OBJS
			src.see_in_dark = 8
			src.see_invisible = SEE_INVISIBLE_LIVING

			if (aiRestorePowerRoutine==2)
				src << "Alert cancelled. Power has been restored without our assistance."
				aiRestorePowerRoutine = 0
				src.blind.layer = 0
				updateicon()
				return
			else if (aiRestorePowerRoutine==3)
				src << "Alert cancelled. Power has been restored."
				aiRestorePowerRoutine = 0
				src.blind.layer = 0
				updateicon()
				return
			else if (APU_power)
				aiRestorePowerRoutine = 0
				src.blind.layer = 0
				updateicon()
				return
		else
			var/area/current_area = get_area(src)

			if (lacks_power())
				if (aiRestorePowerRoutine==0)
					aiRestorePowerRoutine = 1

					//Blind the AI
					updateicon()
					src.blind.screen_loc = "1,1 to 15,15"
					if (src.blind.layer!=18)
						src.blind.layer = 18
					src.sight = src.sight&~SEE_TURFS
					src.sight = src.sight&~SEE_MOBS
					src.sight = src.sight&~SEE_OBJS
					src.see_in_dark = 0
					src.see_invisible = SEE_INVISIBLE_LIVING

					//Now to tell the AI why they're blind and dying slowly.

					src << "You've lost power!"

					spawn(20)
						src << "Backup battery online. Scanners, camera, and radio interface offline. Beginning fault-detection."
						sleep(50)
						if (loc.power_equip)
							if (!istype(T, /turf/space))
								src << "Alert cancelled. Power has been restored without our assistance."
								aiRestorePowerRoutine = 0
								src.blind.layer = 0
								return
						src << "Fault confirmed: missing external power. Shutting down main control system to save power."
						sleep(20)
						src << "Emergency control system online. Verifying connection to power network."
						sleep(50)
						if (istype(T, /turf/space))
							src << "Unable to verify! No power connection detected!"
							aiRestorePowerRoutine = 2
							return
						src << "Connection verified. Searching for APC in power network."
						sleep(50)
						var/obj/machinery/power/apc/theAPC = null

						var/PRP
						for (PRP=1, PRP<=4, PRP++)
							for (var/obj/machinery/power/apc/APC in current_area)
								if (!(APC.stat & BROKEN))
									theAPC = APC
									break
							if (!theAPC)
								switch(PRP)
									if (1) src << "Unable to locate APC!"
									else src << "Lost connection with the APC!"
								src:aiRestorePowerRoutine = 2
								return
							if (loc.power_equip)
								if (!istype(T, /turf/space))
									src << "Alert cancelled. Power has been restored without our assistance."
									aiRestorePowerRoutine = 0
									src.blind.layer = 0 //This, too, is a fix to issue 603
									return
							switch(PRP)
								if (1) src << "APC located. Optimizing route to APC to avoid needless power waste."
								if (2) src << "Best route identified. Hacking offline APC power port."
								if (3) src << "Power port upload access confirmed. Loading control program into APC power port software."
								if (4)
									src << "Transfer complete. Forcing APC to execute program."
									sleep(50)
									src << "Receiving control information from APC."
									sleep(2)
									theAPC.operating = 1
									theAPC.equipment = 3
									theAPC.update()
									aiRestorePowerRoutine = 3
									src << "Here are your current laws:"
									show_laws()
									updateicon()
							sleep(50)
							theAPC = null

	process_queued_alarms()
	handle_regular_hud_updates()
	switch(src.sensor_mode)
		if (SEC_HUD)
			process_sec_hud(src,0,src.eyeobj)
		if (MED_HUD)
			process_med_hud(src,0,src.eyeobj)

/mob/living/silicon/ai/proc/lacks_power()
	if(APU_power)
		return 0
	var/turf/T = get_turf(src)
	var/area/A = get_area(src)
	return ((!A.power_equip) && A.requires_power == 1 || istype(T, /turf/space)) && !istype(src.loc,/obj/item)

/mob/living/silicon/ai/updatehealth()
	if(status_flags & GODMODE)
		health = 100
		stat = CONSCIOUS
		setOxyLoss(0)
	else
		health = 100 - getFireLoss() - getBruteLoss() // Oxyloss is not part of health as it represents AIs backup power. AI is immune against ToxLoss as it is machine.

/mob/living/silicon/ai/rejuvenate()
	..()
	add_ai_verbs(src)

