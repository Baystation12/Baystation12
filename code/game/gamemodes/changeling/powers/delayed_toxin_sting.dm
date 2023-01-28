/datum/power/changeling/delayed_toxic_sting
	name = "Delayed Toxic Sting"
	desc = "We silently sting a biological, causing a significant amount of toxins after a few minutes, allowing us to not \
	implicate ourselves."
	helptext = "The toxin takes effect in about two minutes.  Multiple applications within the two minutes will not cause increased toxicity."
	enhancedtext = "The toxic damage is doubled."
	ability_icon_state = "ling_sting_del_toxin"
	genomecost = 1
	verbpath = /mob/proc/changeling_delayed_toxic_sting

/datum/modifier/delayed_toxin_sting
	name = "delayed toxin injection"
	hidden = TRUE
	stacks = MODIFIER_STACK_FORBID
	on_expired_text = "<span class='danger'>You feel a burning sensation flowing through your veins!</span>"

/datum/modifier/delayed_toxin_sting/on_expire()
	holder.adjustToxLoss(rand(20, 30))

/datum/modifier/delayed_toxin_sting/strong/on_expire()
	holder.adjustToxLoss(rand(40, 60))

/mob/proc/changeling_delayed_toxic_sting()
	set category = "Changeling"
	set name = "Delayed Toxic Sting (20)"
	set desc = "Injects the target with a toxin that will take effect after a few minutes."

	var/mob/living/carbon/T = changeling_sting(20,/mob/proc/changeling_delayed_toxic_sting)
	if(!T)
		return 0
	admin_attack_log(src,T,"Delayed toxic sting (chagneling)")
	var/type_to_give = /datum/modifier/delayed_toxin_sting
	if(src.mind.changeling.recursive_enhancement)
		type_to_give = /datum/modifier/delayed_toxin_sting/strong
		to_chat(src, "<span class='notice'>Our toxin will be extra potent, when it strikes.</span>")

	T.add_modifier(type_to_give, 2 MINUTES)



	return TRUE
