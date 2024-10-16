/datum/power/changeling/silence_sting
	name = "Silence Sting"
	desc = "We silently sting a human, completely silencing them for a short time."
	helptext = "Does not provide a warning to a victim that they have been stung, until they try to speak and cannot."
	enhancedtext = "Silence duration is extended."
	ability_icon_state = "ling_sting_mute"
	genomecost = 2
	allowduringlesserform = 1
	verbpath = /mob/proc/changeling_silence_sting
	sting_effect = /mob/proc/silence
	is_sting = TRUE
	sting_duration = 30
/mob/proc/silence(mob/living/carbon/M, duration)
	M.silent += duration
/mob/proc/changeling_silence_sting()
	set category = "Changeling"
	set name = "Silence sting (10)"
	set desc="Sting target"

	var/mob/living/carbon/T = changeling_sting(10,/mob/proc/changeling_silence_sting)
	if(!T)	return 0
	admin_attack_log(src,T,"Silence sting (changeling)")
	var/duration = 30
	if(src.mind.changeling.recursive_enhancement)
		src.mind.changeling.recursive_enhancement = FALSE
		duration = duration + 10
		to_chat(src, "<span class='notice'>They will be unable to cry out in fear for a little longer.</span>")
	silence(T,duration)
	return TRUE
