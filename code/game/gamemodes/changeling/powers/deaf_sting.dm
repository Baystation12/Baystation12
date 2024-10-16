/datum/power/changeling/deaf_sting
	name = "Deaf Sting"
	desc = "We silently sting a human, completely deafening them for a short time."
	enhancedtext = "Deafness duration is extended."
	ability_icon_state = "ling_sting_deafen"
	genomecost = 1
	allowduringlesserform = 1
	verbpath = /mob/proc/changeling_deaf_sting
	sting_effect = /mob/proc/ling_deaf
	sting_duration = 300
	is_sting = TRUE
/mob/proc/ling_deaf(mob/living/carbon/M, duration)
	M.ear_deaf += duration
/mob/proc/changeling_deaf_sting()
	set category = "Changeling"
	set name = "Deaf sting (5)"
	set desc="Sting target:"

	var/mob/living/carbon/T = changeling_sting(5,/mob/proc/changeling_deaf_sting)
	if(!T)
		return FALSE
	admin_attack_log(src,T,"Deaf sting (changeling)")
	var/duration = 300
	if(src.mind.changeling.recursive_enhancement)
		duration = duration + 100
		to_chat(src, "<span class='notice'>They will be unable to hear for a little longer.</span>")
	to_chat(T, "<span class='danger'>Your ears pop and begin ringing loudly!</span>")
	ling_deaf(T,duration)
	return TRUE
