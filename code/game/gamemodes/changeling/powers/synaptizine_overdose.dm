/datum/power/changeling/epinephrine_overdose
	name = "Adrenaline Surge"
	desc = "We evolve additional sacs of adrenaline throughout our body."
	helptext = "We can instantly recover from stuns and reduce the effect of future stuns, but we will suffer toxicity in the long term.  Can be used while unconscious."
	enhancedtext = "Immunity from most disabling effects for 30 seconds."
	ability_icon_state = "ling_epinephrine_overdose"
	genomecost = 2
	verbpath = /mob/proc/changeling_synaptizine_overdose

//Recover from stuns.
/mob/proc/changeling_synaptizine_overdose()
	set category = "Changeling"
	set name = "Adrenaline Surge (20)"
	set desc = "Removes all stuns instantly, and reduces future stuns."

	var/datum/changeling/changeling = changeling_power(20,0,100,UNCONSCIOUS)
	if(!changeling)
		return FALSE
	changeling.chem_charges -= 20

	var/mob/living/carbon/human/C = src
	to_chat(C, "<span class='notice'>Energy rushes through us.  [C.lying ? "We arise." : ""]</span>")
	C.set_stat(CONSCIOUS)
	C.SetParalysis(0)
	C.SetStunned(0)
	C.SetWeakened(0)
	C.setHalLoss(0)
	C.lying = 0
	C.blinded = 0
	C.eye_blind = 0
	C.eye_blurry = 0
	C.ear_deaf = 0
	C.ear_damage = 0
	C.clear_confused()
	C.sleeping = 0
//	C.reagents.add_reagent("toxin", 10)
	C.reagents.add_reagent("synaptizine", 10)

	if(src.mind.changeling.recursive_enhancement)
		src.mind.changeling.recursive_enhancement = FALSE


	return TRUE
