// NETWORKING TREE
//
// Abilities in this tree are oriented around giving the AI more control of normally uncontrollable systems.
// T1 - Basic Encryption Hack - Allows hacking of APCs. Hacked APCs can be controlled even when AI Control is cut and give exclusive control to the AI and linked cyborgs.
// T2 - Advanced Encryption Hack - Allows the AI to send fake CentCom message. Has high chance of failing.
// T3 - Elite Encryption Hack - Allows the AI to change alert levels. Has high chance of failing.
// T4 - System Override - Allows the AI to rapidly hack remaining APCs. When completed, grants access to the self destruct nuclear warhead.


// BEGIN RESEARCH DATUMS

/datum/malf_research_ability/networking/basic_hack
	ability = new/datum/game_mode/malfunction/verb/basic_encryption_hack()
	price = 25
	next = new/datum/malf_research_ability/networking/advanced_hack()
	name = "Basic Encryption Hack"


/datum/malf_research_ability/networking/advanced_hack
	ability = new/datum/game_mode/malfunction/verb/advanced_encryption_hack()
	price = 400
	next = new/datum/malf_research_ability/networking/elite_hack()
	name = "Advanced Encryption Hack"


/datum/malf_research_ability/networking/elite_hack
	ability = new/datum/game_mode/malfunction/verb/elite_encryption_hack()
	price = 1000
	next = new/datum/malf_research_ability/networking/system_override()
	name = "Elite Encryption Hack"


/datum/malf_research_ability/networking/system_override
	ability = new/datum/game_mode/malfunction/verb/system_override()
	price = 2750
	name = "System Override"

// END RESEARCH DATUMS
// BEGIN ABILITY VERBS

/datum/game_mode/malfunction/verb/basic_encryption_hack(obj/machinery/power/apc/A as obj in get_unhacked_apcs(src))
	set category = "Software"
	set name = "Basic Encryption Hack"
	set desc = "10 CPU - Basic encryption hack that allows you to overtake APCs on the station."
	var/price = 10
	var/mob/living/silicon/ai/user = usr

	if(!A)
		return

	if(!istype(A))
		user << "This is not an APC!"
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


/datum/game_mode/malfunction/verb/advanced_encryption_hack()
	set category = "Software"
	set name = "Advanced Encrypthion Hack"
	set desc = "75 CPU - Attempts to bypass encryption on the Command Quantum Relay, giving you ability to fake legitimate messages. Has chance of failing."
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
		if(!(A.z in config.station_levels)) 		// Only station APCs
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
			command_announcement.Announce("This is highly abnormal and somewhat concerning. The intruder is too fast, he is evading our traces. No man could be this fast...", "Network Monitoring")
			sleep(duration/5)
			if(!user || user.stat == DEAD)
				return
			command_announcement.Announce("We have traced the intrude#, it seem& t( e yo3r AI s7stem, it &# *#ck@ng th$ sel$ destru$t mechani&m, stop i# bef*@!)$#&&@@  <CONNECTION LOST>", "Network Monitoring")
	else
		command_announcement.Announce("We have detected a strong brute-force attack on your firewall which seems to be originating from your AI system. It already controls almost the whole network, and the only thing that's preventing it from accessing the self-destruct is this firewall. You don't have much time before it succeeds.", "Network Monitoring")
	user << "## BEGINNING SYSTEM OVERRIDE."
	user << "## ESTIMATED DURATION: [round((duration+300)/600)] MINUTES"
	user.hacking = 1
	user.system_override = 1
	// Now actually begin the hack. Each APC takes 10 seconds.
	for(var/obj/machinery/power/apc/A in shuffle(remaining_apcs))
		sleep(100)
		if(!user || user.stat == DEAD)
			return
		if(!A || !istype(A) || A.aidisabled)
			continue
		A.ai_hack(user)
		if(A.hacker == user)
			user << "## OVERRIDDEN: [A.name]"

	user << "## REACHABLE APC SYSTEMS OVERTAKEN. BYPASSING PRIMARY FIREWALL."
	sleep(300)
	// Hack all APCs, including those built during hack sequence.
	for(var/obj/machinery/power/apc/A in machines)
		if((!A.hacker || A.hacker != src) && !A.aidisabled && A.z in config.station_levels)
			A.ai_hack(src)


	user << "## PRIMARY FIREWALL BYPASSED. YOU NOW HAVE FULL SYSTEM CONTROL."
	command_announcement.Announce("Our system administrators just reported that we've been locked out from your control network. Whoever did this now has full access to the station's systems.", "Network Administration Center")
	user.hack_can_fail = 0
	user.hacking = 0
	user.system_override = 2
	user.verbs += new/datum/game_mode/malfunction/verb/ai_destroy_station()


// END ABILITY VERBS