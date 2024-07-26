/mob/living/silicon
	var/datum/ai_laws/laws
	var/list/additional_law_channels = list("State" = "")


/mob/living/silicon/Initialize(mapload)
	. = ..()
	if(!laws)
		laws = GLOB.using_map.default_law_type
	if(ispath(laws))
		laws = new laws()
	laws_sanity_check()


/mob/living/silicon/proc/laws_sanity_check()
	if (!src.laws)
		laws = new GLOB.using_map.default_law_type

/mob/living/silicon/proc/has_zeroth_law()
	return laws.zeroth_law != null

/mob/living/silicon/proc/set_zeroth_law(law, law_borg)
	laws_sanity_check()
	laws.set_zeroth_law(law, law_borg)
	log_law("has given [src] the zeroth law: '[law]'[law_borg ? " / '[law_borg]'" : ""]")

/mob/living/silicon/robot/set_zeroth_law(law, law_borg)
	..()
	if(tracking_entities)
		to_chat(src, SPAN_WARNING("Internal camera is currently being accessed."))

/mob/living/silicon/proc/add_ion_law(law)
	laws_sanity_check()
	to_chat(src, SPAN_DANGER("You have detected a change in your laws information:"))
	to_chat(src, law)
	laws.add_ion_law(law)
	log_law("has given [src] the ion law: [law]")

/mob/living/silicon/proc/add_inherent_law(law)
	laws_sanity_check()
	laws.add_inherent_law(law)
	log_law("has given [src] the inherent law: [law]")

/mob/living/silicon/proc/add_supplied_law(number, law)
	laws_sanity_check()
	laws.add_supplied_law(number, law)
	log_law("has given [src] the supplied law: [law]")

/mob/living/silicon/proc/delete_law(datum/ai_law/law)
	laws_sanity_check()
	laws.delete_law(law)
	log_law("has deleted a law belonging to [src]: [law.law]")

/mob/living/silicon/proc/clear_inherent_laws(silent = 0)
	laws_sanity_check()
	laws.clear_inherent_laws()
	if(!silent)
		log_law("cleared the inherent laws of [src]")

/mob/living/silicon/proc/clear_ion_laws(silent = 0)
	laws_sanity_check()
	laws.clear_ion_laws()
	if(!silent)
		log_law("cleared the ion laws of [src]")

/mob/living/silicon/proc/clear_supplied_laws(silent = 0)
	laws_sanity_check()
	laws.clear_supplied_laws()
	if(!silent)
		log_law("cleared the supplied laws of [src]")

/mob/living/silicon/proc/statelaws(datum/ai_laws/laws)
	var/prefix = ""
	if(MAIN_CHANNEL == lawchannel)
		prefix = ";"
	else if(lawchannel == "Binary")
		prefix = "[get_language_prefix()]b"
	else if((lawchannel in additional_law_channels))
		prefix = additional_law_channels[lawchannel]
	else
		prefix = get_radio_key_from_channel(lawchannel)

	dostatelaws(lawchannel, prefix, laws)

/mob/living/silicon/proc/dostatelaws(method, prefix, datum/ai_laws/laws)
	if(stating_laws[prefix])
		to_chat(src, SPAN_NOTICE("[method]: Already stating laws using this communication method."))
		return

	stating_laws[prefix] = 1

	var/can_state = statelaw("[prefix]Current Active Laws:")

	for(var/datum/ai_law/law in laws.laws_to_state())
		can_state = statelaw("[prefix][law.get_index()]. [law.law]")
		if(!can_state)
			break

	if(!can_state)
		to_chat(src, SPAN_DANGER("[method]: Unable to state laws. Communication method unavailable."))
	stating_laws[prefix] = 0

/mob/living/silicon/proc/statelaw(law, mob/living/L = src)
	if(L.say(law))
		sleep(10)
		return 1

	return 0

/mob/living/silicon/proc/law_channels()
	var/list/channels = new()
	channels += MAIN_CHANNEL
	channels += silicon_radio.channels
	channels += additional_law_channels
	channels += "Binary"
	return channels

/mob/living/silicon/proc/lawsync()
	laws_sanity_check()
	laws.sort_laws()

/mob/living/silicon/proc/log_law(law_message)
	log_and_message_admins(law_message, src)
	GLOB.lawchanges += "[stationtime2text()] - [usr ? "[key_name(usr)]" : "EVENT"] [law_message]"
