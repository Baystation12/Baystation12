/datum/power/changeling/epinephrine_overdose
	name = "Epinephrine Overdose"
	desc = "We evolve additional sacs of adrenaline throughout our body."
	helptext = "We can instantly recover from stuns and reduce the effect of future stuns, but we will suffer toxicity in the long term.  Can be used while unconscious."
	genomecost = 2
	verbpath = /mob/proc/changeling_epinephrine_overdose

//Recover from stuns.
/mob/proc/changeling_epinephrine_overdose()
	set category = "Changeling"
	set name = "Epinephrine Overdose (30)"
	set desc = "Removes all stuns instantly, and reduces future stuns."

	var/datum/changeling/changeling = changeling_power(30,0,100,UNCONSCIOUS)
	if(!changeling)
		return 0
	changeling.chem_charges -= 30

	var/mob/living/carbon/human/C = src
	C << "<span class='notice'>Energy rushes through us.  [C.lying ? "We arise." : ""]</span>"
	C.stat = 0
	C.SetParalysis(0)
	C.SetStunned(0)
	C.SetWeakened(0)
	C.lying = 0
	C.update_canmove()
//	C.reagents.add_reagent("toxin", 10)
	C.reagents.add_reagent("epinephrine", 20)

	feedback_add_details("changeling_powers","UNS")
	return 1

/datum/reagent/epinephrine
	name = "Epinephrine"
	id = "epinephrine"
	description = "Reduces stun times, but causing toxicity due to high concentration."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolism = REM * 2
	overdose = 5 //This is intentionally low, as we want the ling to take some tox damage, to discourage spamming the ability.

/datum/reagent/epinephrine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.add_chemical_effect(CE_SPEEDBOOST, 3)
	M.add_chemical_effect(CE_PAINKILLER, 60)
	M.adjustHalLoss(-30)
	M.AdjustParalysis(-2)
	M.AdjustStunned(-2)
	M.AdjustWeakened(-2)
	..()
	return