/datum/event/minispasm
	startWhen = 60
	endWhen = 90
	var/static/list/psi_operancy_messages = list(
		"There's something in your skull!",
		"Something is eating your thoughts!",
		"You can feel your brain being rewritten!",
		"Something is crawling over your frontal lobe!",
		"<b>THE SIGNAL THE SIGNAL THE SIGNAL THE SIGNAL THE</b>"
		)

/datum/event/minispasm/announce()
	priority_announcement.Announce( \
		"PRIORITY ALERT: SIGMA-[rand(50,80)] PSIONIC SIGNAL LOCAL TRAMISSION DETECTED (97% MATCH, NONVARIANT) \
		(SIGNAL SOURCE TRIANGULATED ADJACENT LOCAL SITE): All personnel are advised to avoid \
		exposure to active audio transmission equipment including radio headsets and intercoms \
		for the duration of the signal broadcast.", \
		"Cuchulain Sensor Array Automated Message" \
		)

/datum/event/minispasm/start()
	var/list/victims = list()
	for(var/obj/item/device/radio/radio in GLOB.listening_objects)
		if(radio.on)
			for(var/mob/living/victim in range(radio.canhear_range, radio.loc))
				if(isnull(victims[victim]) && victim.stat == CONSCIOUS && !victim.ear_deaf)
					victims[victim] = radio
	for(var/thing in victims)
		var/mob/living/victim = thing
		var/obj/item/device/radio/source = victims[victim]
		do_spasm(victim, source)

/datum/event/minispasm/proc/do_spasm(var/mob/living/victim, var/obj/item/device/radio/source)
	set waitfor = 0

	if(iscarbon(victim) && !victim.isSynthetic())
		var/list/disabilities = list(NEARSIGHTED, EPILEPSY, TOURETTES, NERVOUS)
		for(var/disability in disabilities)
			if(victim.disabilities & disability)
				disabilities -= disability
		if(disabilities.len)
			victim.disabilities |= pick(disabilities)

	if(victim.psi)
		to_chat(victim, SPAN_DANGER("A hauntingly familiar sound hisses from \icon[source] \the [source], and your vision flickers!"))
		victim.psi.backblast(rand(5,15))
		victim.Paralyse(5)
		victim.make_jittery(100)
	else
		to_chat(victim, SPAN_DANGER("An indescribable, brain-tearing sound hisses from \icon[source] \the [source], and you collapse in a seizure!"))
		victim.seizure()
		var/new_latencies = rand(2,4)
		var/list/faculties = list(PSI_COERCION, PSI_REDACTION, PSI_ENERGISTICS, PSI_PSYCHOKINESIS)
		for(var/i = 1 to new_latencies)
			to_chat(victim, SPAN_DANGER("<font size = 3>[pick(psi_operancy_messages)]</font>"))
			victim.adjustBrainLoss(rand(10,20))
			victim.set_psi_rank(pick_n_take(faculties), 1)
			sleep(30)
		victim.psi.update()
	sleep(45)
	victim.psi.check_latency_trigger(100, "a psionic scream", redactive = TRUE)

/datum/event/minispasm/end()
	priority_announcement.Announce( \
		"PRIORITY ALERT: SIGNAL BROADCAST HAS CEASED. Personnel are cleared to resume use of non-hardened radio transmission equipment. Have a nice day.", \
		"Cuchulain Sensor Array Automated Message" \
		)
