//Starts healing you every second for 10 seconds. Can be used whilst unconscious.
/mob/proc/changeling_rapidregen(mob/user as mob)
	set category = "Changeling"
	set name = "Rapid Regeneration (30)"
	set desc = "Begins rapidly regenerating.  Does not effect stuns or chemicals."

	var/datum/changeling/changeling = changeling_power(30,0,100,UNCONSCIOUS)
	if(!changeling)	return 0
	src.mind.changeling.chem_charges -= 30

	var/mob/living/carbon/human/C = src
	spawn(0)
		for(var/i = 0, i<10,i++)
			if(C)
				C.adjustBruteLoss(-10)
				C.adjustToxLoss(-10)
				C.adjustOxyLoss(-10)
				C.adjustFireLoss(-10)
				sleep(10)

	src.verbs -= /mob/proc/changeling_rapidregen
	spawn(5)	src.verbs += /mob/proc/changeling_rapidregen
	return 1
