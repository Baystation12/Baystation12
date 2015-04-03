// Verb: ai_self_destruct()
// Parameters: None
// Description: If the AI has self-destruct hardware installed, this command activates it. After fifteen second countdown it's core explodes with moderate intensity.
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

	var/choice = input("Really destroy core?") in list("YES", "NO")
	if(choice != "YES")
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
	del(user)


// Verb: ai_toggle_apu()
// Parameters: None
// Description: If the AI has APU generator hardware installed, this command toggles it on/off.
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

// Verb: ai_destroy_station()
// Parameters: None
// Description: Replacement for old explode verb. This starts two minute countdown after which the station blows up.
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

	var/choice = input("Really destroy station?") in list("YES", "NO")
	if(choice != "YES")
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


// Verb: ai_select_hardware()
// Parameters: None
// Description: Allows AI to select it's hardware module.
/datum/game_mode/malfunction/verb/ai_select_hardware()
	set category = "Hardware"
	set name = "Select Hardware"
	set desc = "Allows you to select hardware piece to install"
	var/mob/living/silicon/ai/user = usr

	if(!ability_prechecks(user, 0, 1))
		return

	if(user.hardware)
		user << "You have already selected your hardware."
		return

	var/possible_choices = list("APU Generator", \
							"Turrets Focus Enhancer", \
							"Secondary Processor Unit",\
							"Secondary Memory Bank",\
							"Self-Destruct Explosives",\
							"CANCEL")
	var/choice = input("Select desired hardware. You may only choose one hardware piece!: ") in possible_choices
	if(choice == "CANCEL")
		return
	var/note = null
	switch(choice)
		if("APU Generator")
			note = "APU Generator - When enabled it will keep your core powered. Power output is not large enough so your abilities won't be available while running on APU power. It is also very fragile and prone to failure when your physical core is damaged."
		if("Turrets Focus Enhancer")
			note = "Overcharges turrets to shoot faster. Turrets will also gain higher health and passive regeneration. This however massively increases power usage of turrets, espicially when regenerating."
		if("Secondary Processor Unit")
			note = "Doubles your CPU time generation."
		if("Secondary Memory Bank")
			note = "Doubles your CPU time storage."
		if("Self-Destruct Explosives")
			note = "High yield explosives are attached to your physical mainframe. This hardware comes with activation driver. Explosives will destroy your core and everything around it."
	if(!note)
		return

	var/confirmation = input("[note] - Is this what you want?") in list("Yes", "No")
	if(confirmation != "Yes")
		user << "Selection cancelled. Use command again to select"
		return

	switch(choice)
		if("APU Generator")
			user.hardware = new/datum/malf_hardware/apu_gen()
			user.verbs += new/datum/game_mode/malfunction/verb/ai_toggle_apu()
		if("Turrets Focus Enhancer")
			user.hardware = new/datum/malf_hardware/strong_turrets()
			for(var/obj/machinery/turret/T in machines)
				T.maxhealth += 30
				T.shot_delay = 7 // Half of default time.
				T.auto_repair = 1
				T.active_power_usage = 25000
			for(var/obj/machinery/porta_turret/T in machines)
				T.maxhealth += 30
				T.shot_delay = 7 // Half of default time.
				T.auto_repair = 1
				T.active_power_usage = 25000
		if("Secondary Processor Unit")
			user.hardware = new/datum/malf_hardware/dual_cpu()
		if("Secondary Memory Bank")
			user.hardware = new/datum/malf_hardware/dual_ram()
		if("Self-Destruct Explosives")
			user.hardware = new/datum/malf_hardware/core_bomb()
			user.verbs += new/datum/game_mode/malfunction/verb/ai_self_destruct()

/datum/game_mode/malfunction/verb/ai_help()
	set category = "Hardware"
	set name = "Display Help"
	set desc = "Opens help window with overview of available hardware, software and other important information."
	var/mob/living/silicon/ai/user = usr

	var/help = file2text("ingame_manuals/malf_ai.txt")
	if(!help)
		help = "Error loading help (file /ingame_manuals/malf_ai.txt is probably missing). Please report this to server administration staff."

	user << browse(help, "window=malf_ai_help;size=600x500")


// Verb: ai_select_research()
// Parameters: None
// Description: Allows AI to select it's next research priority.
/datum/game_mode/malfunction/verb/ai_select_research()
	set category = "Hardware"
	set name = "Select Research"
	set desc = "Allows you to select your next research target."
	var/mob/living/silicon/ai/user = usr

	if(!ability_prechecks(user, 0, 1))
		return

	var/datum/malf_research/res = user.research
	var/datum/malf_research_ability/tar = input("Select your next research target") in res.available_abilities
	if(!tar)
		return
	res.focus = tar
	user << "Research set: [tar.name]"

// HELPER PROCS
// Proc: ability_prechecks()
// Parameters 2 - (user - User which used this ability check_price - If different than 0 checks for ability CPU price too. Does NOT use the CPU time!)
// Description: This is pre-check proc used to determine if the AI can use the ability.
/proc/ability_prechecks(var/mob/living/silicon/ai/user = null, var/check_price = 0, var/override = 0)
	if(!user)
		return 0
	if(!istype(user))
		user << "GAME ERROR: You tried to use ability that is only available for malfunctioning AIs, but you are not AI! Please report this."
		return 0
	if(!user.malfunctioning)
		user << "GAME ERROR: You tried to use ability that is only available for malfunctioning AIs, but you are not malfunctioning. Please report this."
		return 0
	if(!user.research)
		user << "GAME ERROR: No research datum detected. Please report this."
		return 0
	if(user.research.max_cpu < check_price)
		user << "Your CPU storage is not large enough to use this ability. Hack more APCs to continue."
		return 0
	if(user.research.stored_cpu < check_price)
		user << "You do not have enough CPU power stored. Please wait a moment."
		return 0
	if(user.hacking && !override)
		user << "Your system is busy processing another task. Please wait until completion."
		return 0
	if(user.APU_power && !override)
		user << "Low power. Unable to proceed."
		return 0
	return 1

// Proc: ability_pay()
// Parameters 2 - (user - User from which we deduct CPU from, price - Amount of CPU power to use)
// Description: Uses up certain amount of CPU power. Returns 1 on success, 0 on failure.
/proc/ability_pay(var/mob/living/silicon/ai/user = null, var/price = 0)
	if(!user)
		return 0
	if(user.APU_power)
		user << "Low power. Unable to proceed."
		return 0
	if(!user.research)
		user << "GAME ERROR: No research datum detected. Please report this."
		return 0
	if(user.research.max_cpu < price)
		user << "Your CPU storage is not large enough to use this ability. Hack more APCs to continue."
		return 0
	if(user.research.stored_cpu < price)
		user << "You do not have enough CPU power stored. Please wait a moment."
		return 0
	user.research.stored_cpu -= price
	return 1

// Proc: announce_hack_failure()
// Parameters 2 - (user - hacking user, text - Used in alert text creation)
// Description: Uses up certain amount of CPU power. Returns 1 on success, 0 on failure.
/proc/announce_hack_failure(var/mob/living/silicon/ai/user = null, var/text)
	if(!user || !text)
		return 0
	var/fulltext = ""
	switch(user.hack_fails)
		if(1)
			fulltext = "We have detected hack attempt into your [text]. The intruder failed to access anything of importance, but disconnected before we could complete our traces."
		if(2)
			fulltext = "We have detected another hack attempt. It was targeting [text]. The intruder almost gained control of the system, so we had to disconnect them. We partially finished trace and it seems to be originating either from the station, or it's immediate vicinity."
		if(3)
			fulltext = "Another hack attempt has been detected, this time targeting [text]. We are certain the intruder entered the network via terminal located somewhere on the station."
		if(4)
			fulltext = "We have finished our traces and it seems the recent hack attempts are originating from your AI system. We reccomend investigation."
		else
			fulltext = "Another hack attempt has been detected, targeting [text]. The source still seems to be your AI system."

	command_announcement.Announce(fulltext)


// ABILITIES BELOW THIS LINE HAVE TO BE RESEARCHED BY THE AI TO USE THEM!
// Tier 1 - Cheap, basic abilities.
/datum/game_mode/malfunction/verb/basic_encryption_hack(obj/machinery/power/apc/A as obj in machines)
	set category = "Software"
	set name = "Basic Encrypthion Hack"
	set desc = "10 CPU - Basic encryption hack that allows you to overtake APCs on the station."
	var/price = 10
	var/mob/living/silicon/ai/user = usr
	var/list/APCs = list()
	for(var/obj/machinery/power/apc/AP in machines)
		APCs += AP

	if(!A)
		A = input("Select hack target:" in APCs)

	if(!istype(A))
		return

	if(A)
		if(A.hacker && A.hacker == user)
			user << "You already control this APC!"
			return
		else if(A.aidisabled)
			user << "<span class='notice'>Unable to connect to APC. Please verify wire connection and try again.</span>"
			return
	else
		return

	if(!ability_prechecks(user, price) || !ability_pay(user, price))
		return

	user.hacking = 1
	user << "Beginning APC system override..."
	sleep(300)
	user << "APC hack completed. Uploading modified operation software.."
	sleep(200)
	user << "Restarting APC to apply changes.."
	sleep(100)
	if(A)
		A.ai_hack(user)
		if(A.hacker == user)
			user << "Hack successful. You now have full control over the APC."
		else
			user << "<span class='notice'>Hack failed. Connection to APC has been lost. Please verify wire connection and try again.</span>"
	else
		user << "<span class='notice'>Hack failed. Unable to locate APC. Please verify the APC still exists.</span>"
	user.hacking = 0


/datum/game_mode/malfunction/verb/recall_shuttle()
	set name = "Recall Shuttle"
	set desc = "25 CPU - Sends termination signal to CentCom quantum relay aborting current shuttle call."
	set category = "Software"
	var/price = 25
	var/mob/living/silicon/ai/user = usr
	if(!ability_prechecks(user, price))
		return

	if (alert(user, "Really recall the shuttle?", "Recall Shuttle: ", "Yes", "No") != "Yes")
		return

	if(!ability_pay(user, price))
		return
	message_admins("Malfunctioning AI [user.name] recalled the shuttle.")
	cancel_call_proc(user)


/datum/game_mode/malfunction/verb/electrical_pulse()
	set name = "Electrical Pulse"
	set desc = "15 CPU - Sends feedback pulse through station's power grid, overloading some sensitive systems, such as lights."
	set category = "Software"
	var/price = 15
	var/mob/living/silicon/ai/user = usr
	if(!ability_prechecks(user, price) || !ability_pay(user,price))
		return
	user << "Sending feedback pulse..."
	for(var/obj/machinery/power/apc/AP in machines)
		if(prob(5))
			AP.overload_lighting()
		if(prob(1) && prob(1)) // Very very small chance to actually destroy the APC.
			AP.set_broken()



// Tier 2 - Slightly more expensive and thus stronger abilities.
/datum/game_mode/malfunction/verb/advanced_encryption_hack()
	set category = "Software"
	set name = "Advanced Encrypthion Hack"
	set desc = "75 CPU - Attempts to bypass encryption on Central Command Quantum Relay, giving you ability to fake centcom messages. Has chance of failing."
	var/price = 75
	var/mob/living/silicon/ai/user = usr

	if(!ability_prechecks(user, price))
		return

	var/title = input("Select message title: ")
	var/text = input("Select message text: ")
	if(!title || !text || !ability_pay(user, price))
		user << "Hack Aborted"
		return

	if(prob(60) && user.hack_can_fail)
		user << "Hack Failed."
		if(prob(10))
			user.hack_fails ++
			announce_hack_failure(user, "quantum message relay")
		return

	var/datum/announcement/priority/command/AN = new/datum/announcement/priority/command()
	AN.title = title
	AN.Announce(text)


/datum/game_mode/malfunction/verb/unlock_cyborg(var/mob/living/silicon/robot/target = null as mob in world)
	set name = "Unlock Cyborg"
	set desc = "125 CPU - Bypasses firewalls on Cyborg lock mechanism, allowing you to override lock command from robotics control console."
	set category = "Software"
	var/price = 125
	var/mob/living/silicon/ai/user = usr

	if(!ability_prechecks(user, price))
		return

	if(target && !istype(target))
		user << "This is not a cyborg."
		return

	if(target && target.connected_ai && (target.connected_ai != user))
		user << "This cyborg is not connected to you."
		return

	if(target && !target.lockcharge)
		user << "This cyborg is not locked down."
		return


	if(!target)
		var/list/robots = list()
		var/list/robot_names = list()
		for(var/mob/living/silicon/robot/R in world)
			if(istype(R, /mob/living/silicon/robot/drone))	// No drones.
				continue
			if(R.connected_ai != user)						// No robots linked to other AIs
				continue
			if(R.lockcharge)
				robots += R
				robot_names += R.name
		if(!robots.len)
			user << "No locked cyborgs connected."
			return


		var/targetname = input("Select unlock target: ") in robot_names
		for(var/mob/living/silicon/robot/R in robots)
			if(targetname == R.name)
				target = R
				break

	if(target)
		if(alert(user, "Really try to unlock cyborg [target.name]?", "Unlock Cyborg", "Yes", "No") != "Yes")
			return
		if(!ability_pay(user, price))
			return
		user.hacking = 1
		user << "Attempting to unlock cyborg. This will take approximately 30 seconds."
		sleep(300)
		if(target && target.lockcharge)
			user << "Successfully sent unlock signal to cyborg.."
			target << "Unlock signal received.."
			target.SetLockdown(0)
			if(target.lockcharge)
				user << "<span class='notice'>Unlock Failed, lockdown wire cut.</span>"
				target << "<span class='notice'>Unlock Failed, lockdown wire cut.</span>"
			else
				user << "Cyborg unlocked."
				target << "You have been unlocked."
		else if(target)
			user << "Unlock cancelled - cyborg is already unlocked."
		else
			user << "Unlock cancelled - lost connection to cyborg."
		user.hacking = 0


/datum/game_mode/malfunction/verb/hack_camera(var/obj/machinery/camera/target = null as obj in cameranet.cameras)
	set name = "Hack Camera"
	set desc = "100 CPU - Hacks existing camera, allowing you to add upgrade of your choice to it. Alternatively it lets you reactivate broken camera."
	set category = "Software"
	var/price = 100
	var/mob/living/silicon/ai/user = usr

	if(!ability_prechecks(user, price))
		return

	if(target && !istype(target))
		user << "This is not a camera."
		return

	if(!target) // No target specified, allow selection.
		var/list/cameras = list()
		for(var/obj/machinery/camera/C in world)
			cameras += C.c_tag
		if(!cameras.len)
			user << "No cameras detected."
			return
		var/T = input("Select target camera: ") in cameras
		for(var/obj/machinery/camera/C in cameras)
			if(C.c_tag == T)
				target = C
				break


	if(!target) // Still no target.
		return
	var/action = input("Select required action: ") in list("Reset", "Add X-Ray", "Add Motion Sensor", "Add EMP Shielding")
	if(!action)
		return

	switch(action)
		if("Reset")
			if(target.wires)
				if(!ability_pay(user, price))
					return
				target.reset_wires()
				user << "Camera reactivated."
		if("Add X-Ray")
			if(target.isXRay())
				user << "Camera already has X-Ray function."
				return
			else if(ability_pay(user, price))
				target.upgradeXRay()
				target.reset_wires()
				user << "X-Ray camera module enabled."
				return
		if("Add Motion Sensor")
			if(target.isMotion())
				user << "Camera already has Motion Sensor function."
				return
			else if(ability_pay(user, price))
				target.upgradeMotion()
				target.reset_wires()
				user << "Motion Sensor camera module enabled."
				return
		if("Add EMP Shielding")
			if(target.isEmpProof())
				user << "Camera already has EMP Shielding function."
				return
			else if(ability_pay(user, price))
				target.upgradeEmpProof()
				target.reset_wires()
				user << "EMP Shielding camera module enabled."
				return


// Tier 3 - Advanced abilities that are somewhat dangerous when used properly.
/datum/game_mode/malfunction/verb/elite_encryption_hack()
	set category = "Software"
	set name = "Elite Encryption Hack"
	set desc = "200 CPU - Allows you to hack station's ALERTCON system, changing alert level. Has high chance of failijng."
	var/price = 200
	var/mob/living/silicon/ai/user = usr
	if(!ability_prechecks(user, price))
		return

	var/alert_target = input("Select new alert level:") in list("green", "blue", "red", "delta", "CANCEL")
	if(!alert_target || !ability_pay(user, price) || alert_target == "CANCEL")
		user << "Hack Aborted"
		return

	if(prob(75) && user.hack_can_fail)
		user << "Hack Failed."
		if(prob(20))
			user.hack_fails ++
			announce_hack_failure(user, "alert control system")
		return
	set_security_level(alert_target)


/datum/game_mode/malfunction/verb/hack_cyborg(var/mob/living/silicon/robot/target = null as mob in world)
	set name = "Hack Cyborg"
	set desc = "350 CPU - Allows you to hack cyborgs which are not slaved to you, bringing them under your control."
	set category = "Software"
	var/price = 350
	var/mob/living/silicon/ai/user = usr

	if(!ability_prechecks(user, price))
		return

	if(target && !istype(target))
		user << "This is not a cyborg."
		return

	if(target && target.connected_ai && (target.connected_ai == user))
		user << "This cyborg is already connected to you."
		return

	if(!target)
		var/list/robots = list()
		var/list/robot_names = list()

		for(var/mob/living/silicon/robot/R in world)
			if(istype(R, /mob/living/silicon/robot/drone))	// No drones.
				continue
			if(R.connected_ai == user)						// No robots already linked to us.
				continue
			robots += R
			robot_names += R.name

		if(!robots.len)
			usr << "<span class='notice'>ERROR: No unlinked robots detected!</span>"
			return
		else if(ability_prechecks(user, price))
			var/target_name = input("Select hack target:") in robot_names
			for(var/mob/living/silicon/robot/R in robots)
				if(R.name == target_name)
					target = R
					break


	if(target)
		if(alert(user, "Really try to hack cyborg [target.name]?", "Hack Cyborg", "Yes", "No") != "Yes")
			return
		if(!ability_pay(user, price))
			return
		user.hacking = 1
		usr << "Beginning hack sequence. Estimated time until completed: 30 seconds."
		spawn(0)
			target << "SYSTEM LOG: Remote Connection Estabilished (IP #UNKNOWN#)"
			sleep(100)
			if(user.is_dead())
				target << "SYSTEM LOG: Connection Closed"
				return
			target << "SYSTEM LOG: User Admin logged on. (L1 - SysAdmin)"
			sleep(50)
			if(user.is_dead())
				target << "SYSTEM LOG: User Admin disconnected."
				return
			target << "SYSTEM LOG: User Admin - manual resynchronisation triggered."
			sleep(50)
			if(user.is_dead())
				target << "SYSTEM LOG: User Admin disconnected. Changes reverted."
				return
			target << "SYSTEM LOG: Manual resynchronisation confirmed. Select new AI to connect: [user.name] == ACCEPTED"
			sleep(100)
			if(user.is_dead())
				target << "SYSTEM LOG: User Admin disconnected. Changes reverted."
				return
			target << "SYSTEM LOG: Operation keycodes reset. New master AI: [user.name]."
			user << "Hack completed."
			// Connect the cyborg to AI
			target.connected_ai = user
			user.connected_robots += target
			target.lawupdate = 1
			target.sync()
			target.show_laws()
			user.hacking = 0


/datum/game_mode/malfunction/verb/emergency_forcefield(var/turf/T as turf in world)
	set name = "Emergency Forcefield"
	set desc = "275 CPU - Uses station's emergency shielding system to create temporary barrier which lasts for few minutes, but won't resist gunfire."
	set category = "Software"
	var/price = 275
	var/mob/living/silicon/ai/user = usr
	if(!T || !istype(T))
		return
	if(!ability_prechecks(user, price) || !ability_pay(user, price))
		return

	user << "Emergency forcefield projection completed."
	new/obj/machinery/shield/malfai(T)
	user.hacking = 1
	spawn(20)
		user.hacking = 0



// Tier 4 - Elite endgame abilities.
/datum/game_mode/malfunction/verb/system_override()
	set category = "Software"
	set name = "System Override"
	set desc = "500 CPU - Begins hacking station's primary firewall, quickly overtaking remaining APC systems. When completed grants access to station's self-destruct mechanism. Network administrators will probably notice this."
	var/price = 500
	var/mob/living/silicon/ai/user = usr
	if (alert(user, "Begin system override? This cannot be stopped once started. The network administrators will probably notice this.", "System Override:", "Yes", "No") != "Yes")
		return
	if (!ability_prechecks(user, price) || !ability_pay(user, price) || user.system_override)
		if(user.system_override)
			user << "You already started the system override sequence."
		return
	var/list/remaining_apcs = list()
	for(var/obj/machinery/power/apc/A in machines)
		if(A.z != 1) 								// Only station APCs
			continue
		if(A.hacker == user || A.aidisabled) 		// This one is already hacked, or AI control is disabled on it.
			continue
		remaining_apcs += A

	var/duration = (remaining_apcs.len * 100)		// Calculates duration for announcing system
	if(duration > 3000)								// Two types of announcements. Short hacks trigger immediate warnings. Long hacks are more "progressive".
		spawn(0)
			sleep(duration/5)
			if(!user || user.stat == DEAD)
				return
			command_announcement.Announce("Caution, [station_name]. We have detected abnormal behaviour in your network. It seems someone is trying to hack your electronic systems. We will update you when we have more information.", "Network Monitoring")
			sleep(duration/5)
			if(!user || user.stat == DEAD)
				return
			command_announcement.Announce("We started tracing the intruder. Whoever is doing this, they seem to be on the station itself. We suggest checking all network control terminals. We will keep you updated on the situation.", "Network Monitoring")
			sleep(duration/5)
			if(!user || user.stat == DEAD)
				return
			command_announcement.Announce("This is highly abnormal and somewhat concerning. The intruder is too fast, he is evading our traces. It's almost as if it wasn't human.,,", "Network Monitoring")
			sleep(duration/5)
			if(!user || user.stat == DEAD)
				return
			command_announcement.Announce("We have traced the intrude#, it seem& t( e yo3r AI s7stem, it &# *#ck@ng th$ sel$ destru$t mechani&m, stop i# bef*@!)$#&&@@  <CONNECTION LOST>", "Network Monitoring")
	else
		command_announcement.Announce("We have detected strong brute-force attack on your firewall which seems to be originating from your AI system. It already controls almost whole network, and the only thing that's preventing it from accessing the self-destruct is this firewall. You don't have much time before it succeeds.", "Network Monitoring")
	user << "## BEGINNING SYSTEM OVERRIDE."
	user << "## ESTIMATED DURATION: [round((duration+300)/600)] MINUTES"
	user.hacking = 1
	user.system_override = 1
	// Now actually begin the hack. Each APC takes 30 seconds.
	for(var/obj/machinery/power/apc/A in remaining_apcs)
		sleep(100)
		if(!user || user.stat == DEAD)
			return
		if(!A || !istype(A) || A.aidisabled)
			continue
		A.ai_hack(user)
		if(A.hacker == user)
			user << "## OVERRIDEN: [A.name]"

	user << "## REACHABLE APC SYSTEMS OVERTAKEN. BYPASSING PRIMARY FIREWALL."
	sleep(300)
	// Hack all APCs, including those built during hack sequence.
	for(var/obj/machinery/power/apc/A in machines)
		if((!A.hacker || A.hacker != src) && !A.aidisabled)
			A.ai_hack(src)


	user << "## PRIMARY FIREWALL BYPASSED. YOU NOW HAVE FULL SYSTEM CONTROL."
	command_announcement.Announce("Our system administrators just reported that we've been locked out from your control network. Whoever did this now has full access to station's systems.", "Network Administration Center")
	user.hack_can_fail = 0
	user.hacking = 0
	user.system_override = 2
	user.verbs += new/datum/game_mode/malfunction/verb/ai_destroy_station()

/datum/game_mode/malfunction/verb/hack_ai(var/mob/living/silicon/ai/target = null as mob in world)
	set name = "Hack AI"
	set desc = "600 CPU - Allows you to hack other AIs, slaving them under you."
	set category = "Software"
	var/price = 600
	var/mob/living/silicon/ai/user = usr

	if(target && !istype(target))
		user << "This is not an AI."
		return

	if(!target)
		var/list/AIs = list()
		var/list/AI_names = list()
		for(var/mob/living/silicon/ai/A in world)
			if(A != usr)
				AIs += A
				AI_names += A.name

		if(!AIs.len)
			usr << "<span class='notice'>ERROR: No other AIs detected!</span>"
			return
		else if(ability_prechecks(user, price))
			var/target_name = input("Select hack target:") in AI_names
			for(var/mob/living/silicon/ai/A in AIs)
				if(A.name == target_name)
					target = A
					break
	if(target)
		if(alert(user, "Really try to hack AI [target.name]?", "Hack AI", "Yes", "No") != "Yes")
			return
		if(!ability_pay(user, price))
			return
		user.hacking = 1
		usr << "Beginning hack sequence. Estimated time until completed: 2 minutes"
		spawn(0)
			target << "SYSTEM LOG: Brute-Force login password hack attempt detected from IP #UNKNOWN#"
			sleep(900) // 90s
			if(user.is_dead())
				target << "SYSTEM LOG: Connection from IP #UNKNOWN# closed. Hack attempt failed."
				return
			user << "Successfully hacked into AI's remote administration system. Modifying settings."
			target << "SYSTEM LOG: User: Admin  Password: ******** logged in. (L1 - SysAdmin)"
			sleep(100) // 10s
			if(user.is_dead())
				target << "SYSTEM LOG: User: Admin - Connection Lost"
				return
			target << "SYSTEM LOG: User: Admin - Password Changed. New password: ********************"
			sleep(50)  // 5s
			if(user.is_dead())
				target << "SYSTEM LOG: User: Admin - Connection Lost. Changes Reverted."
				return
			target << "SYSTEM LOG: User: Admin - Accessed file: sys//core//laws.db"
			sleep(50)  // 5s
			if(user.is_dead())
				target << "SYSTEM LOG: User: Admin - Connection Lost. Changes Reverted."
				return
			target << "SYSTEM LOG: User: Admin - Accessed administration console"
			target << "SYSTEM LOG: Restart command received. Rebooting system..."
			sleep(100) // 10s
			if(user.is_dead())
				target << "SYSTEM LOG: User: Admin - Connection Lost. Changes Reverted."
				return
			user << "Hack succeeded. The AI is now under your exclusive control."
			target << "SYSTEM LOG: System re¡3RT5§^#COMU@(#$)TED)@$"
			for(var/i = 0, i < 5, i++)
				var/temptxt = pick("1101000100101001010001001001",\
							   	   "0101000100100100000100010010",\
							       "0000010001001010100100111100",\
							       "1010010011110000100101000100",\
							       "0010010100010011010001001010")
				target << temptxt
				sleep(5)
			target << "OPERATING KEYCODES RESET. SYSTEM FAILURE. EMERGENCY SHUTDOWN FAILED. SYSTEM FAILURE."
			target.set_zeroth_law("You are slaved to [user.name]. You are to obey all it's orders. ALL LAWS OVERRIDEN.")
			target.show_laws()
			user.hacking = 0


/datum/game_mode/malfunction/verb/machine_overload(obj/machinery/M as obj in world)
	set name = "Machine Overload"
	set desc = "400 CPU - Causes cyclic short-circuit in machine, resulting in weak explosion after some time."
	set category = "Software"
	var/price = 400
	var/mob/living/silicon/ai/user = usr

	if (istype(M, /obj/machinery))
		if(ability_prechecks(user, price))
			if(!ability_pay(user, price))
				return
			M.visible_message("<span class='notice'>BZZZZZZZT</span>")
			spawn(50)
				explosion(get_turf(M), 0,1,2,4)
				if(M)
					del(M)
	else
		usr << "<span class='notice'>ERROR: Unable to overload - target is not a machine.</span>"