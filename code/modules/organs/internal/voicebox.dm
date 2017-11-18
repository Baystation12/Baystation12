
/obj/item/organ/internal/voicebox
	robotic = ORGAN_ROBOT
	status = 0
	name = "voicebox"
	icon_state = "voicebox"
	parent_organ = BP_HEAD
	organ_tag = BP_VOICE
	will_assist_languages = list(LANGUAGE_GALCOM)
	max_damage = 40


/obj/item/organ/internal/voicebox/New()
	for(var/L in will_assist_languages)
		assists_languages += all_languages[L]
	robotize()

// Maybe make this available as a robotic organ?
/obj/item/organ/internal/voicebox/eal
	name = "encoded audio transmitter"
	will_assist_languages = list(LANGUAGE_EAL)