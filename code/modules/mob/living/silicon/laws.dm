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

/mob/living/silicon/robot/set_zeroth_law(var/law, var/law_borg)
	..()
	if(tracking_entities)
		src << "<span class='warning'>Internal camera is currently being accessed.</span>"

/mob/living/silicon/proc/add_ion_law(var/law)
	laws_sanity_check()
	laws.add_ion_law(law)

/mob/living/silicon/proc/add_inherent_law(var/law, var/state_law = 1)
	laws_sanity_check()
	laws.add_inherent_law(law, state_law)

/mob/living/silicon/proc/clear_inherent_laws()
	laws_sanity_check()
	laws.clear_inherent_laws()

/mob/living/silicon/proc/clear_ion_laws()
	laws_sanity_check()
	laws.clear_ion_laws()

/mob/living/silicon/proc/add_supplied_law(var/number, var/law, var/state_law = 1)
	laws_sanity_check()
	laws.add_supplied_law(number, law, state_law)

/mob/living/silicon/proc/clear_supplied_laws()
	laws_sanity_check()
	laws.clear_supplied_laws()

/mob/living/silicon/proc/statelaws(var/datum/ai_laws/laws, var/use_statement_order = 1) // -- TLE
	var/prefix = ""
	switch(lawchannel)
		if(MAIN_CHANNEL) prefix = ";"
		if("Binary") prefix = ":b "
		else
			prefix = get_radio_key_from_channel(lawchannel == "Holopad" ? "department" : lawchannel) + " "

	dostatelaws(lawchannel, prefix, laws, use_statement_order)

/mob/living/silicon/proc/dostatelaws(var/method, var/prefix, var/datum/ai_laws/laws, var/use_statement_order)
	if(stating_laws[prefix])
		src << "<span class='notice'>[method]: Already stating laws using this communication method.</span>"
		return

	stating_laws[prefix] = 1

	var/can_state = statelaw("[prefix]Current Active Laws:")

	for(var/datum/ai_law/law in laws.laws_to_state())
		can_state = statelaw("[prefix][law.get_index(use_statement_order)]. [law.law]")

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
