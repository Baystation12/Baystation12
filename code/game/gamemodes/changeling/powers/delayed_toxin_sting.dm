/datum/power/changeling/delayed_toxic_sting
	name = "Delayed Toxic Sting"
	desc = "We silently sting a biological, causing a significant amount of toxins after a few minutes, allowing us to not \
	implicate ourselves. While rarely lethal, highly effective for making organics leave their post to seek medical attention."
	helptext = "The toxin takes effect in about two minutes.  Multiple applications within the two minutes will not cause increased toxicity."
	enhancedtext = "The toxic damage is doubled."
	ability_icon_state = "ling_sting_del_toxin"
	genomecost = 1
	verbpath = /mob/proc/changeling_delayed_toxic_sting
	sting_effect = /mob/proc/ling_delay_toxin
	is_sting = TRUE
//disgusting copypasta, but the alternative is a new prop to ling powers just for this one sting
/mob/proc/ling_delay_toxin(mob/living/carbon/M, null)
	sleep(2 MINUTES)
	M.adjustToxLoss(rand(20,30))
/mob/proc/changeling_delayed_toxic_sting()
	set category = "Changeling"
	set name = "Delayed Toxic Sting (20)"
	set desc = "Injects the target with a toxin that will take effect after a few minutes."

	var/effect_delay = 2 MINUTES
	var/damage = rand(20,30)
	var/mob/living/carbon/T = changeling_sting(20,/mob/proc/changeling_delayed_toxic_sting)
	if(!T)
		return FALSE
	admin_attack_log(src,T,"Delayed toxic sting (changeling)")
	if(src.mind.changeling.recursive_enhancement)
		//type_to_give = /datum/modifier/delayed_toxin_sting/strong
		to_chat(src, "<span class='notice'>Our toxin will be extra potent, when it strikes.</span>")
		damage = rand(40,60)
		src.mind.changeling.recursive_enhancement = FALSE
	if(!(T in src.mind.changeling.toxin_victims))
		src.mind.changeling.toxin_victims.Add(T)
	sleep(effect_delay)
	if(!(T in src.mind.changeling.toxin_victims))
		return FALSE
	T.adjustToxLoss(damage)
	src.mind.changeling.toxin_victims.Remove(T)

	//var/test = new /datum/delayed_toxin_sting()
	//var/sting_delay = /datum/modifier/delayed_toxin_sting




	//T.add_modifier(type_to_give, 10 SECONDS)



	return TRUE
