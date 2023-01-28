/datum/power/changeling/epinephrine_overdose
	name = "Synaptizne Overdose"
	desc = "We evolve additional sacs of adrenaline throughout our body."
	helptext = "We can instantly recover from stuns and reduce the effect of future stuns, but we will suffer toxicity in the long term.  Can be used while unconscious."
	enhancedtext = "Immunity from most disabling effects for 30 seconds."
	ability_icon_state = "ling_synaptizine_overdose"
	genomecost = 2
	verbpath = /mob/proc/changeling_synaptizine_overdose

/datum/modifier/unstoppable
	name = "unstoppable"
	desc = "We feel limitless amounts of energy surge in our veins. Nothing can stop us!"

	stacks = MODIFIER_STACK_EXTEND
	on_created_text = "<span class='notice'>We feel unstoppable!</span>"
	on_expired_text = "<span class='warning'>We feel our newfound energy fade...</span>"
	disable_duration_percent = 0

//Recover from stuns.
/mob/proc/changeling_synaptizine_overdose()
	set category = "Changeling"
	set name = "Synaptizine Overdose (30)"
	set desc = "Removes all stuns instantly, and reduces future stuns."

	var/datum/changeling/changeling = changeling_power(30,0,100,UNCONSCIOUS)
	if(!changeling)
		return FALSE
	changeling.chem_charges -= 30

	var/mob/living/carbon/human/C = src
	to_chat(C, "<span class='notice'>Energy rushes through us.  [C.lying ? "We arise." : ""]</span>")
	C.set_stat(CONSCIOUS)
	C.SetParalysis(0)
	C.SetStunned(0)
	C.SetWeakened(0)
	C.lying = 0
//	C.reagents.add_reagent("toxin", 10)
	C.reagents.add_reagent("synaptizine", 10)

	if(src.mind.changeling.recursive_enhancement)
		C.add_modifier(/datum/modifier/unstoppable, 30 SECONDS)

	return TRUE
