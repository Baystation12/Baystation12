/mob/proc/changeling_unstun()
	set category = "Changeling"
	set name = "Epinephrine Sacs (45)"
	set desc = "Removes all stuns"

	var/datum/changeling/changeling = changeling_power(45,0,100,UNCONSCIOUS)
	if(!changeling)	return 0
	changeling.chem_charges -= 45

	var/mob/living/carbon/human/C = src
	C.set_stat(CONSCIOUS)
	C.SetParalysis(0)
	C.SetStunned(0)
	C.SetWeakened(0)
	C.lying = 0
	C.UpdateLyingBuckledAndVerbStatus()

	src.verbs -= /mob/proc/changeling_unstun
	spawn(5)	src.verbs += /mob/proc/changeling_unstun
	return 1
