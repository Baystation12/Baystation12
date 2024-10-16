/datum/power/changeling/blind_sting
	name = "Blind Sting"
	desc = "We silently sting a human, completely blinding them for a short time."
	enhancedtext = "Duration is extended."
	ability_icon_state = "ling_sting_blind"
	genomecost = 2
	allowduringlesserform = 1
	verbpath = /mob/proc/changeling_blind_sting
	sting_effect = /mob/proc/ling_blind
	is_sting = TRUE
/mob/proc/apply_blind()
	src.disabilities &= ~NEARSIGHTED
/mob/proc/ling_blind(mob/living/carbon/M, duration)
	addtimer(new Callback(M,/mob/.proc/apply_blind),duration)
	M.eye_blind = 10
	M.eye_blurry = 20
/mob/proc/changeling_blind_sting()
	set category = "Changeling"
	set name = "Blind sting (20)"
	set desc="Sting target"

	var/mob/living/carbon/T = changeling_sting(20,/mob/proc/changeling_blind_sting)
	if(!T)
		return FALSE
	admin_attack_log(src,T,"Blind sting (changeling)")
	to_chat(T, "<span class='danger'>You are surrounded by darkness. You cannot see!</span>")
	T.disabilities |= NEARSIGHTED
	var/duration = 300
	if(src.mind.changeling.recursive_enhancement)
		duration = duration + 150
		to_chat(src, "<span class='notice'>They will be deprived of sight for longer.</span>")
	ling_blind(T,duration)
	return TRUE
