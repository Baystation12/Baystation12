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
	price = 25		// Until you have this ability your CPU generation sucks, therefore it's very cheap.
	next = new/datum/malf_research_ability/networking/advanced_hack()
	name = "T1 - Basic Encryption Hack"


/datum/malf_research_ability/networking/advanced_hack
	ability = new/datum/game_mode/malfunction/verb/advanced_encryption_hack()
	price = 1000
	next = new/datum/malf_research_ability/networking/elite_hack()
	name = "T2 - Advanced Encryption Hack"


/datum/malf_research_ability/networking/elite_hack
	ability = new/datum/game_mode/malfunction/verb/elite_encryption_hack()
	price = 2000
	next = new/datum/malf_research_ability/networking/system_override()
	name = "T3 - Elite Encryption Hack"


/datum/malf_research_ability/networking/system_override
	ability = new/datum/game_mode/malfunction/verb/system_override()
	price = 4000
	name = "T4 - System Override"

// END RESEARCH DATUMS
// BEGIN ABILITY VERBS

/datum/game_mode/malfunction/verb/basic_encryption_hack(obj/machinery/power/apc/A as obj in get_unhacked_apcs(src))
	set category = "Software"
	set name = "Basic Encryption Hack"
	set desc = "10 CPU - Basic encryption hack that allows you to overtake APCs"
	var/price = 10
	var/mob/living/silicon/ai/user = usr

	if(!A)
		return

	if(!istype(A))
		to_chat(user, "This is not an APC!")
		return

	if(A)
		if(A.hacker && A.hacker == user)
			to_chat(user, "You already control this APC!")
			return
		else if(A.aidisabled)
			to_chat(user, "<span class='notice'>Unable to connect to APC. Please verify wire connection and try again.</span>")
			return
	else
		return

	if(!ability_prechecks(user, price, TRUE) || !ability_pay(user, price))
		return

	log_ability_use(user, "basic encryption hack", A, 0)	// Does not notify admins, but it's still logged for reference.
	to_chat(user, "Beginning APC system override...")
	sleep(300)
	to_chat(user, "APC hack completed. Uploading modified operation software..")
	sleep(200)
	to_chat(user, "Restarting APC to apply changes..")
	sleep(100)
	if(A)
		A.ai_hack(user)
		if(A.hacker == user)
			to_chat(user, "Hack successful. You now have full control over \the [A].")
		else
			to_chat(user, "<span class='notice'>Hack failed. Connection to APC has been lost. Please verify wire connection and try again.</span>")
	else
		to_chat(user, "<span class='notice'>Hack failed. Unable to locate APC. Please verify the APC still exists.</span>")


/datum/game_mode/malfunction/verb/advanced_encryption_hack()
	set category = "Software"
	set name = "Advanced Encryption Hack"
	set desc = "75 CPU - Attempts to bypass encryption on the Command Quantum Relay, giving you ability to fake legitimate messages. Has chance of failing."
	var/price = 75
	var/mob/living/silicon/ai/user = usr

	if(!ability_prechecks(user, price))
		return

	if(user.last_failed_malf_title || user.last_failed_malf_message)
		if (alert(user, "Your last hack attempt with title '[user.last_failed_malf_title]' has failed. Try again?", "Retransmission", "Yes", "No") != "Yes")
			user.last_failed_malf_title = null
			user.last_failed_malf_message = null

	var/title = user.last_failed_malf_title ? user.last_failed_malf_title : sanitize(input("Select message title: "))
	var/text = user.last_failed_malf_message ? user.last_failed_malf_message : sanitize(input("Select message text: "))

	if(!title || !text || !ability_pay(user, price))
		to_chat(user, "Hack Aborted")
		return
	log_ability_use(user, "advanced encryption hack")

	if(prob(60) && user.hack_can_fail)
		to_chat(user, "Hack Failed.")
		if(prob(10))
			user.hack_fails ++
			announce_hack_failure(user, "quantum message relay")
			log_ability_use(user, "elite encryption hack (CRITFAIL - title: [title])")
		else
			log_ability_use(user, "elite encryption hack (FAIL - title: [title])")
		user.last_failed_malf_message = text
		user.last_failed_malf_title = title
		return
	log_ability_use(user, "elite encryption hack (SUCCESS - title: [title])")
	command_announcement.Announce(text, title)

/datum/game_mode/malfunction/verb/elite_encryption_hack()
	set category = "Software"
	set name = "Elite Encryption Hack"
	set desc = "200 CPU - Allows you to hack ALERTCON system, changing alert level. Has high chance of failing."
	var/price = 200
	var/mob/living/silicon/ai/user = usr
	if(!ability_prechecks(user, price))
		return

	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
	var/alert_target = input("Select new alert level:") as null|anything in (security_state.all_security_levels - security_state.current_security_level)
	if(!alert_target || !ability_pay(user, price))
		to_chat(user, "Hack Aborted")
		return

	if(prob(75) && user.hack_can_fail)
		to_chat(user, "Hack Failed.")
		if(prob(20))
			user.hack_fails++
			announce_hack_failure(user, "alert control system")
			log_ability_use(user, "elite encryption hack (CRITFAIL - [alert_target])")
			return
		log_ability_use(user, "elite encryption hack (FAIL - [alert_target])")
		return
	log_ability_use(user, "elite encryption hack (SUCCESS - [alert_target])")
	security_state.set_security_level(alert_target, TRUE)


/datum/game_mode/malfunction/verb/system_override()
	set category = "Software"
	set name = "System Override"
	set desc = "500 CPU - Begins hacking primary firewall, quickly overtaking remaining APC systems. When completed grants access to the self-destruct mechanism. Network administrators will probably notice this."
	var/price = 500
	var/mob/living/silicon/ai/user = usr
	if (alert(user, "Begin system override? This cannot be stopped once started. The network administrators will probably notice this.", "System Override:", "Yes", "No") != "Yes")
		return
	if (!ability_prechecks(user, price) || !ability_pay(user, price) || user.system_override)
		if(user.system_override)
			to_chat(user, "You already started the system override sequence.")
		return
	log_ability_use(user, "system override (STARTED)")
	var/list/remaining_apcs = list()
	var/list/valid_zlevels = GetConnectedZlevels(user.z)
	for(var/obj/machinery/power/apc/A in SSmachines.machinery)
		if(!(A.z in valid_zlevels)) 		// Only station APCs
			continue
		if(A.hacker == user || A.aidisabled) 		// This one is already hacked, or AI control is disabled on it.
			continue
		remaining_apcs += A

	var/duration = (remaining_apcs.len * 100)		// Calculates duration for announcing system
	if(user.hack_can_fail)								// Two types of announcements. Short hacks trigger immediate warnings. Long hacks are more "progressive".
		spawn(0)
			sleep(duration/5)
			if(!user || user.stat == DEAD)
				return
			command_announcement.Announce("Внимание, [GLOB.using_map.station_ru]. Мы обнаружили ненормальное поведение в вашей сети. Похоже, кто-то пытается взломать ваши электронные системы. Мы сообщим вам, когда у нас будет больше информации.", "EXO Network Monitoring")
			sleep(duration/5)
			if(!user || user.stat == DEAD)
				return
			command_announcement.Announce("Мы начали выслеживать злоумышленника. Кто бы это ни делал, похоже, он на борту. Мы рекомендуем проверить все терминалы управления сетью. Мы будем держать вас в курсе событий.", "EXO Network Monitoring")
			sleep(duration/5)
			if(!user || user.stat == DEAD)
				return
			command_announcement.Announce("Это в высшей степени ненормально и несколько тревожно. Злоумышленник слишком быстро, он ускользает от наших служащих. Подобная скорость может быть обусловлена наличием прямого и полного доступа к управлению системой изнутри.", "EXO Network Monitoring")
			sleep(duration/5)
			if(!user || user.stat == DEAD)
				return
			command_announcement.Announce("Мы добрались до нарушителя#, кажется, &t(e ваша система искусственного интеллекта, это &#*# ck@ ng $ само$ уничтоже$t механи&sq*eq, остановите меня# bef*@!)$#&&@@ <СОЕДИНЕНИЕ ПОТЕРЯНО>", "EXO Network Monitoring")

	to_chat(user, "## BEGINNING SYSTEM OVERRIDE.")
	to_chat(user, "## ESTIMATED DURATION: [round((duration+300)/600)] MINUTES")
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
			to_chat(user, "## OVERRIDDEN: [A.name]")

	to_chat(user, "## REACHABLE APC SYSTEMS OVERTAKEN. BYPASSING PRIMARY FIREWALL.")
	sleep(1 MINUTE)
	// Hack all APCs, including those built during hack sequence.
	for(var/obj/machinery/power/apc/A in SSmachines.machinery)
		if((!A.hacker || A.hacker != src) && !A.aidisabled && (A.z in valid_zlevels))
			A.ai_hack(src)

	log_ability_use(user, "system override (FINISHED)")
	to_chat(user, "## PRIMARY FIREWALL BYPASSED. YOU NOW HAVE FULL SYSTEM CONTROL.")

	if(user.hack_can_fail)
		command_announcement.Announce("Наши системные администраторы только что сообщили, что мы были заблокированы от вашей управляющей сети. Тот, кто это сделал, теперь имеет полный доступ к системам [GLOB.using_map.station_ru].", "EXO Network Administration Center")
	user.hack_can_fail = 0
	user.system_override = 2
	user.verbs += new/datum/game_mode/malfunction/verb/ai_destroy_station()
