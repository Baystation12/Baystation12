/mob/living/silicon
	var/datum/ai_laws/laws = null
	var/list/additional_law_channels = list("State")

/mob/living/silicon/proc/laws_sanity_check()
	if (!src.laws)
		laws = new base_law_type

/mob/living/silicon/proc/has_zeroth_law()
	return laws.zeroth_law != null

/mob/living/silicon/proc/set_zeroth_law(var/law, var/law_borg)
	laws_sanity_check()
	laws.set_zeroth_law(law, law_borg)
	log_and_message_admins("has given [src] the zeroth laws: [law]/[law_borg ? law_borg : "N/A"]")

/mob/living/silicon/robot/set_zeroth_law(var/law, var/law_borg)
	..()
	if(tracking_entities)
		src << "<span class='warning'>Internal camera is currently being accessed.</span>"

/mob/living/silicon/proc/add_ion_law(var/law)
	laws_sanity_check()
	laws.add_ion_law(law)
	log_and_message_admins("has given [src] the ion law: [law]")

/mob/living/silicon/proc/add_inherent_law(var/law)
	laws_sanity_check()
	laws.add_inherent_law(law)
	log_and_message_admins("has given [src] the inherent law: [law]")

/mob/living/silicon/proc/add_supplied_law(var/number, var/law)
	laws_sanity_check()
	laws.add_supplied_law(number, law)
	log_and_message_admins("has given [src] the supplied law: [law]")

/mob/living/silicon/proc/delete_law(var/datum/ai_law/law)
	laws_sanity_check()
	laws.delete_law(law)
	log_and_message_admins("has deleted a law belonging to [src]: [law.law]")

/mob/living/silicon/proc/clear_inherent_laws(var/silent = 0)
	laws_sanity_check()
	laws.clear_inherent_laws()
	if(!silent)
		log_and_message_admins("cleared the inherent laws of [src]")

/mob/living/silicon/proc/clear_ion_laws(var/silent = 0)
	laws_sanity_check()
	laws.clear_ion_laws()
	if(!silent)
		log_and_message_admins("cleared the ion laws of [src]")

/mob/living/silicon/proc/clear_supplied_laws(var/silent = 0)
	laws_sanity_check()
	laws.clear_supplied_laws()
	if(!silent)
		log_and_message_admins("cleared the supplied laws of [src]")

/mob/living/silicon/proc/statelaws(var/datum/ai_laws/laws)
	var/prefix = ""
	switch(lawchannel)
		if(MAIN_CHANNEL) prefix = ";"
		if("Binary") prefix = ":b "
		else
			prefix = get_radio_key_from_channel(lawchannel == "Holopad" ? "department" : lawchannel) + " "

	dostatelaws(lawchannel, prefix, laws)

/mob/living/silicon/proc/dostatelaws(var/method, var/prefix, var/datum/ai_laws/laws)
	if(stating_laws[prefix])
		src << "<span class='notice'>[method]: Already stating laws using this communication method.</span>"
		return

	stating_laws[prefix] = 1

	var/can_state = statelaw("[prefix]Current Active Laws:")

	for(var/datum/ai_law/law in laws.laws_to_state())
		can_state = statelaw("[prefix][law.get_index()]. [law.law]")

	if(!can_state)
		src << "<span class='danger'>[method]: Unable to state laws. Communication method unavailable.</span>"
	stating_laws[prefix] = 0

/mob/living/silicon/proc/statelaw(var/law)
	if(src.say(law))
		sleep(10)
		return 1

	return 0

/mob/living/silicon/proc/law_channels()
	var/list/channels = new()
	channels += MAIN_CHANNEL
	channels += common_radio.channels
	channels += additional_law_channels
	return channels

/mob/living/silicon/proc/lawsync()
	laws_sanity_check()
	laws.sort_laws()
