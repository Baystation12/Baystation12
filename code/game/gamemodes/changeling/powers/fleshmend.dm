/datum/power/changeling/fleshmend
	name = "Fleshmend"
	desc = "Begins a slow rengeration of our form.  Does not effect stuns or chemicals."
	genomecost = 1
	verbpath = /mob/proc/changeling_fleshmend

//Starts healing you every second for 50 seconds. Can be used whilst unconscious.
/mob/proc/changeling_fleshmend()
	set category = "Changeling"
	set name = "Fleshmend (10)"
	set desc = "Begins a slow rengeration of our form.  Does not effect stuns or chemicals."

	var/datum/changeling/changeling = changeling_power(10,0,100,UNCONSCIOUS)
	if(!changeling)
		return 0
	src.mind.changeling.chem_charges -= 10

	var/mob/living/carbon/human/C = src
	spawn(0)
		src << "<span class='notice'>We begin to heal ourselves.</span>"
		for(var/i = 0, i<50,i++)
			if(C)
				C.adjustBruteLoss(-2)
				C.adjustOxyLoss(-2)
				C.adjustFireLoss(-2)
				sleep(10)

	src.verbs -= /mob/proc/changeling_fleshmend
	spawn(500)
		src << "<span class='notice'>Our regeneration has slowed to normal levels.</span>"
		src.verbs += /mob/proc/changeling_fleshmend
	feedback_add_details("changeling_powers","FM")
	return 1