//Prevents AIs tracking you but makes you easily detectable to the human-eye.
/mob/proc/changeling_digitalcamo()
	set category = "Changeling"
	set name = "Toggle Digital Camoflague"
	set desc = "The AI can no longer track us, but we will look different if examined.  Has a constant cost while active."

	var/datum/changeling/changeling = changeling_power()
	if(!changeling)	return 0

	var/mob/living/carbon/human/C = src
	if(C.digitalcamo)	to_chat(C, SPAN_LING("We return to normal."))
	else				to_chat(C, SPAN_LING("We distort our form to prevent AI-tracking."))
	C.digitalcamo = !C.digitalcamo

	spawn(0)
		while(C.digitalcamo && C.mind?.changeling)
			C.mind.changeling.chem_charges = max(C.mind.changeling.chem_charges - 1, 0)
			sleep(40)

	src.verbs -= /mob/proc/changeling_digitalcamo
	spawn(5)	src.verbs += /mob/proc/changeling_digitalcamo
	return 1
