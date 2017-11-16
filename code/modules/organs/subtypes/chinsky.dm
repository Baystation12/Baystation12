
/obj/item/organ/internal/voicebox/monkey
	robotic = ORGAN_ROBOT
	status = 0
	name = "vocal aid"
	icon_state = "voicebox"
	parent_organ = BP_HEAD
	organ_tag = BP_VOICE
	will_assist_languages = list(LANGUAGE_GALCOM, LANGUAGE_LUNAR, LANGUAGE_SOL_COMMON, LANGUAGE_INDEPENDENT, LANGUAGE_SPACER)


/obj/item/organ/internal/voicebox/monkey/New()
	for(var/L in will_assist_languages)
		assists_languages += all_languages[L]
//	robotize()
