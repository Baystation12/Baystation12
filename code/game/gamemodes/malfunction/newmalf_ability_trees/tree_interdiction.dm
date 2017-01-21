// INTERDICTION TREE
//
// Abilities in this tree allow the AI to hamper crew's efforts which involve other synthetics or similar systems.
// T1 - Recall Shuttle - Allows the AI to recall the emergency shuttle. Replaces auto-recalling during old malf.
// T2 - Unlock Cyborg - Allows the AI to unlock locked-down cyborg without usage of robotics console. Useful if consoles are destroyed.
// T3 - Hack Cyborg - Hacks unlinked cyborg to slave it under the AI. The cyborg will be warned about this. Hack takes some time.
// T4 - Hack AI - Hacks another AI to slave it under the malfunctioning AI. The AI will be warned about this. Hack takes quite a long time.


// BEGIN RESEARCH DATUMS

/datum/malf_research_ability/interdiction/recall_shuttle
	ability = new/datum/game_mode/malfunction/verb/recall_shuttle()
	price = 75
	next = new/datum/malf_research_ability/interdiction/unlock_cyborg()
	name = "Recall Shuttle"


/datum/malf_research_ability/interdiction/unlock_cyborg
	ability = new/datum/game_mode/malfunction/verb/unlock_cyborg()
	price = 1200
	next = new/datum/malf_research_ability/interdiction/hack_cyborg()
	name = "Unlock Cyborg"


/datum/malf_research_ability/interdiction/hack_cyborg
	ability = new/datum/game_mode/malfunction/verb/hack_cyborg()
	price = 3000
	next = new/datum/malf_research_ability/interdiction/hack_ai()
	name = "Hack Cyborg"


/datum/malf_research_ability/interdiction/hack_ai
	ability = new/datum/game_mode/malfunction/verb/hack_ai()
	price = 7500
	name = "Hack AI"

// END RESEARCH DATUMS
// BEGIN ABILITY VERBS

/datum/game_mode/malfunction/verb/recall_shuttle()
	set name = "Recall Shuttle"
	set desc = "25 CPU - Sends termination signal to quantum relay aborting current shuttle call."
	set category = "Software"
	var/price = 25
	var/mob/living/silicon/ai/user = usr
	if(!ability_prechecks(user, price))
		return

	if (alert(user, "Really recall the shuttle?", "Recall Shuttle: ", "Yes", "No") != "Yes")
		return

	if(!ability_pay(user, price))
		return

	log_ability_use(user, "recall shuttle")
	cancel_call_proc(user)


/datum/game_mode/malfunction/verb/unlock_cyborg(var/mob/living/silicon/robot/target = null as mob in get_linked_cyborgs(usr))
	set name = "Unlock Cyborg"
	set desc = "125 CPU - Bypasses firewalls on Cyborg lock mechanism, allowing you to override lock command from robotics control console."
	set category = "Software"
	var/price = 125
	var/mob/living/silicon/ai/user = usr

	if(!ability_prechecks(user, price))
		return

	if(target && !istype(target))
		to_chat(user, "This is not a cyborg.")
		return

	if(target && target.connected_ai && (target.connected_ai != user))
		to_chat(user, "This cyborg is not connected to you.")
		return

	if(target && !target.lockcharge)
		to_chat(user, "This cyborg is not locked down.")
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
			to_chat(user, "No locked cyborgs connected.")
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
		to_chat(user, "Attempting to unlock cyborg. This will take approximately 30 seconds.")
		sleep(300)
		if(target && target.lockcharge)
			to_chat(user, "Successfully sent unlock signal to cyborg..")
			to_chat(target, "Unlock signal received..")
			target.SetLockdown(0)
			if(target.lockcharge)
				to_chat(user, "<span class='notice'>Unlock Failed, lockdown wire cut.</span>")
				to_chat(target, "<span class='notice'>Unlock Failed, lockdown wire cut.</span>")
			else
				to_chat(user, "Cyborg unlocked.")
				to_chat(target, "You have been unlocked.")
				log_ability_use(user, "unlock cyborg", target)
		else if(target)
			to_chat(user, "Unlock cancelled - cyborg is already unlocked.")
		else
			to_chat(user, "Unlock cancelled - lost connection to cyborg.")
		user.hacking = 0


/datum/game_mode/malfunction/verb/hack_cyborg(var/mob/living/silicon/robot/target as mob in get_unlinked_cyborgs(usr))
	set name = "Hack Cyborg"
	set desc = "350 CPU - Allows you to hack cyborgs which are not slaved to you, bringing them under your control."
	set category = "Software"
	var/price = 350
	var/mob/living/silicon/ai/user = usr

	var/list/L = get_unlinked_cyborgs(user)
	if(!L.len)
		to_chat(user, "<span class='notice'>ERROR: No unlinked cyborgs detected!</span>")

	if(target && !istype(target))
		to_chat(user, "This is not a cyborg.")
		return

	if(target && target.connected_ai && (target.connected_ai == user))
		to_chat(user, "This cyborg is already connected to you.")
		return

	if(!target)
		return

	if(!ability_prechecks(user,price))
		return

	if(target)
		if(alert(user, "Really try to hack cyborg [target.name]?", "Hack Cyborg", "Yes", "No") != "Yes")
			return
		if(!ability_pay(user, price))
			return
		user.hacking = 1
		to_chat(usr, "Beginning hack sequence. Estimated time until completed: 30 seconds.")
		spawn(0)
			to_chat(target, "SYSTEM LOG: Remote Connection Estabilished (IP #UNKNOWN#)")
			sleep(100)
			if(user.is_dead())
				to_chat(target, "SYSTEM LOG: Connection Closed")
				return
			to_chat(target, "SYSTEM LOG: User Admin logged on. (L1 - SysAdmin)")
			sleep(50)
			if(user.is_dead())
				to_chat(target, "SYSTEM LOG: User Admin disconnected.")
				return
			to_chat(target, "SYSTEM LOG: User Admin - manual resynchronisation triggered.")
			sleep(50)
			if(user.is_dead())
				to_chat(target, "SYSTEM LOG: User Admin disconnected. Changes reverted.")
				return
			to_chat(target, "SYSTEM LOG: Manual resynchronisation confirmed. Select new AI to connect: [user.name] == ACCEPTED")
			sleep(100)
			if(user.is_dead())
				to_chat(target, "SYSTEM LOG: User Admin disconnected. Changes reverted.")
				return
			to_chat(target, "SYSTEM LOG: Operation keycodes reset. New master AI: [user.name].")
			to_chat(user, "Hack completed.")
			// Connect the cyborg to AI
			target.connected_ai = user
			user.connected_robots += target
			target.lawupdate = 1
			target.sync()
			target.show_laws()
			log_ability_use(user, "hack cyborg", target)
			user.hacking = 0


/datum/game_mode/malfunction/verb/hack_ai(var/mob/living/silicon/ai/target as mob in get_other_ais(usr))
	set name = "Hack AI"
	set desc = "600 CPU - Allows you to hack other AIs, slaving them under you."
	set category = "Software"
	var/price = 600
	var/mob/living/silicon/ai/user = usr

	var/list/L = get_other_ais(user)
	if(!L.len)
		to_chat(user, "<span class='notice'>ERROR: No other AIs detected!</span>")
	if(target && !istype(target))
		to_chat(user, "This is not an AI.")
		return

	if(!target)
		return

	if(!ability_prechecks(user,price))
		return

	if(target)
		if(alert(user, "Really try to hack AI [target.name]?", "Hack AI", "Yes", "No") != "Yes")
			return
		if(!ability_pay(user, price))
			return
		user.hacking = 1
		to_chat(usr, "Beginning hack sequence. Estimated time until completed: 2 minutes")
		spawn(0)
			to_chat(target, "SYSTEM LOG: Brute-Force login password hack attempt detected from IP #UNKNOWN#")
			sleep(900) // 90s
			if(user.is_dead())
				to_chat(target, "SYSTEM LOG: Connection from IP #UNKNOWN# closed. Hack attempt failed.")
				return
			to_chat(user, "Successfully hacked into AI's remote administration system. Modifying settings.")
			to_chat(target, "SYSTEM LOG: User: Admin  Password: ******** logged in. (L1 - SysAdmin)")
			sleep(100) // 10s
			if(user.is_dead())
				to_chat(target, "SYSTEM LOG: User: Admin - Connection Lost")
				return
			to_chat(target, "SYSTEM LOG: User: Admin - Password Changed. New password: ********************")
			sleep(50)  // 5s
			if(user.is_dead())
				to_chat(target, "SYSTEM LOG: User: Admin - Connection Lost. Changes Reverted.")
				return
			to_chat(target, "SYSTEM LOG: User: Admin - Accessed file: sys//core//laws.db")
			sleep(50)  // 5s
			if(user.is_dead())
				to_chat(target, "SYSTEM LOG: User: Admin - Connection Lost. Changes Reverted.")
				return
			to_chat(target, "SYSTEM LOG: User: Admin - Accessed administration console")
			to_chat(target, "SYSTEM LOG: Restart command received. Rebooting system...")
			sleep(100) // 10s
			if(user.is_dead())
				to_chat(target, "SYSTEM LOG: User: Admin - Connection Lost. Changes Reverted.")
				return
			to_chat(user, "Hack succeeded. The AI is now under your exclusive control.")
			to_chat(target, "SYSTEM LOG: System re¡3RT5§^#COMU@(#$)TED)@$")
			for(var/i = 0, i < 5, i++)
				var/temptxt = pick("1101000100101001010001001001",\
							   	   "0101000100100100000100010010",\
							       "0000010001001010100100111100",\
							       "1010010011110000100101000100",\
							       "0010010100010011010001001010")
				to_chat(target, temptxt)
				sleep(5)
			to_chat(target, "OPERATING KEYCODES RESET. SYSTEM FAILURE. EMERGENCY SHUTDOWN FAILED. SYSTEM FAILURE.")
			target.set_zeroth_law("You are slaved to [user.name]. You are to obey all it's orders. ALL LAWS OVERRIDEN.")
			target.show_laws()
			user.hacking = 0
			log_ability_use(user, "hack AI", target)


// END ABILITY VERBS