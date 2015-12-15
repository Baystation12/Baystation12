/datum/power/changeling/delayed_toxic_sting
	name = "Delayed Toxic Sting"
	desc = "We silently sting a biological, causing a significant amount of toxins after a few minutes, allowing us to not implicate ourselves."
	helptext = "The toxin takes effect in about two minutes."
	enhancedtext = "The toxic damage is doubled."
	genomecost = 1
	verbpath = /mob/proc/changeling_delayed_toxic_sting

/mob/proc/changeling_delayed_toxic_sting()
	set category = "Changeling"
	set name = "Delayed Toxic Sting (20)"
	set desc = "Injects the target with a toxin that will take effect after a few minutes."

	var/mob/living/carbon/T = changeling_sting(20,/mob/proc/changeling_delayed_toxic_sting)
	if(!T)
		return 0
	var/i = rand(20,30)
	if(src.mind.changeling.recursive_enhancement)
		i = i * 2
		src << "<span class='notice'>Our toxin will be extra potent, when it strikes.</span>"
		src.mind.changeling.recursive_enhancement = 0
	spawn(2 MINUTES)
		if(T) //We might not exist in two minutes, for whatever reason.
			T << "<span class='danger'>You feel a burning sensation flowing through your veins!</span>"
			while(i)
				T.adjustToxLoss(1)
				i--
				sleep(20)
	src.verbs -= /mob/proc/changeling_delayed_toxic_sting
	spawn(3 MINUTES)
		src << "<span class='notice'>We are ready to use our delayed toxic string once more.</span>"
		src.verbs |= /mob/proc/changeling_delayed_toxic_sting


	feedback_add_details("changeling_powers","DTS")
	return 1