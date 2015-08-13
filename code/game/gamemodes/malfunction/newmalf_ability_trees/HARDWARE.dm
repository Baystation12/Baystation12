// HARDWARE TREE
//
// These abilities are dependent on hardware, they may not be researched. They are not tiered.
// Destroy Core - Allows the AI to initiate a 15 second countdown that will destroy it's core. Use again to stop countdown.
// Toggle APU Generator - Allows the AI to toggle it's integrated APU generator.
// Destroy Station - Allows the AI to initiate station self destruct. Takes 2 minutes, gives warnings to crew. Use again to stop countdown.


/datum/game_mode/malfunction/verb/ai_self_destruct()
	set category = "Hardware"
	set name = "Destroy Core"
	set desc = "Activates or deactivates self destruct sequence of your physical mainframe."
	var/mob/living/silicon/ai/user = usr

	if(!ability_prechecks(user, 0, 1))
		return

	if(!user.hardware || !istype(user.hardware, /datum/malf_hardware/core_bomb))
		return

	if(user.bombing_core)
		user << "***** CORE SELF-DESTRUCT SEQUENCE ABORTED *****"
		user.bombing_core = 0
		return

	var/choice = alert("Really destroy core?", "Core self-destruct", "YES", "NO")
	if(choice != "YES")
		return

	if(!ability_prechecks(user, 0, 1))
		return

	user.bombing_core = 1

	user << "***** CORE SELF-DESTRUCT SEQUENCE ACTIVATED *****"
	user << "Use command again to cancel self-destruct. Destroying in 15 seconds."
	var/timer = 15
	while(timer)
		sleep(10)
		timer--
		if(!user || !user.bombing_core)
			return
		user << "** [timer] **"
	explosion(user.loc, 3,6,12,24)
	qdel(user)


/datum/game_mode/malfunction/verb/ai_toggle_apu()
	set category = "Hardware"
	set name = "Toggle APU Generator"
	set desc = "Activates or deactivates your APU generator, allowing you to operate even without power."
	var/mob/living/silicon/ai/user = usr

	if(!ability_prechecks(user, 0, 1))
		return

	if(!user.hardware || !istype(user.hardware, /datum/malf_hardware/apu_gen))
		return

	if(user.APU_power)
		user.stop_apu()
	else
		user.start_apu()


/datum/game_mode/malfunction/verb/ai_destroy_station()
	set category = "Hardware"
	set name = "Destroy Station"
	set desc = "Activates or deactivates self destruct sequence of this station. Sequence takes two minutes, and if you are shut down before timer reaches zero it will be cancelled."
	var/mob/living/silicon/ai/user = usr
	var/obj/item/device/radio/radio = new/obj/item/device/radio()


	if(!ability_prechecks(user, 0, 0))
		return

	if(user.system_override != 2)
		user << "You do not have access to self-destruct system."
		return

	if(user.bombing_station)
		user.bombing_station = 0
		return

	var/choice = alert("Really destroy station?", "Station self-destruct", "YES", "NO")
	if(choice != "YES")
		return
	if(!ability_prechecks(user, 0, 0))
		return
	user << "***** STATION SELF-DESTRUCT SEQUENCE INITIATED *****"
	user << "Self-destructing in 2 minutes. Use this command again to abort."
	user.bombing_station = 1
	set_security_level("delta")
	radio.autosay("Self destruct sequence has been activated. Self-destructing in 120 seconds.", "Self-Destruct Control")

	var/timer = 120
	while(timer)
		sleep(10)
		if(!user || !user.bombing_station || user.stat == DEAD)
			radio.autosay("Self destruct sequence has been cancelled.", "Self-Destruct Control")
			return
		if(timer in list(2, 3, 4, 5, 10, 30, 60, 90)) // Announcement times. "1" is not intentionally included!
			radio.autosay("Self destruct in [timer] seconds.", "Self-Destruct Control")
		if(timer == 1)
			radio.autosay("Self destructing now. Have a nice day.", "Self-Destruct Control")
		timer--

	if(ticker)
		ticker.station_explosion_cinematic(0,null)
		if(ticker.mode)
			ticker.mode:station_was_nuked = 1


