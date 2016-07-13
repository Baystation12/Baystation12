/datum/power/changeling/panacea
	name = "Anatomic Panacea"
	desc = "Expels impurifications from our form; curing diseases, removing toxins, chemicals, radiation, and resetting our genetic code completely."
	helptext = "Can be used while unconscious.  This will also purge any reagents inside ourselves, both harmful and beneficial."
	enhancedtext = "We heal more toxins."
	genomecost = 1
	verbpath = /mob/proc/changeling_panacea

//Heals the things that the other regenerative abilities don't.
/mob/proc/changeling_panacea()
	set category = "Changeling"
	set name = "Anatomic Panacea (20)"
	set desc = "Clense ourselves of impurities."

	var/datum/changeling/changeling = changeling_power(20,0,100,INCAPACITATION_DEAD)
	if(!changeling)
		return 0
	src.mind.changeling.chem_charges -= 20
	feedback_add_details("changeling_powers","AP")

	src << "<span class='notice'>We cleanse impurities from our form.</span>"

	radiation = 0
	var/mob/living/carbon/C = src
	if(istype(C))
		C.clear_all_reagents()

		for(var/virus in C.virus2)
			var/datum/disease2/disease/D = C.virus2[virus]
			D.cure(src)

		var/mob/living/carbon/human/H = src
		if(istype(H))
			H.sdisabilities = 0
			H.disabilities = 0

	var/heal_amount = 5
	if(src.mind.changeling.recursive_enhancement)
		heal_amount = heal_amount * 2
		src << "<span class='notice'>We will heal much faster.</span>"
		src.mind.changeling.recursive_enhancement = 0

	var/mob/living/L = src
	if(istype(L))
		for(var/i = 0, i<10,i++)
			if(L)
				L.adjustToxLoss(-heal_amount)
				sleep(10)

	return 1
