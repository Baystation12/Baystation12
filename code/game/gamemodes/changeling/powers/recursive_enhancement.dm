/datum/power/changeling/recursive_enhancement
	name = "Recursive Enhancement"
	desc = "We cause our next ability use to have increased or additional effects."
	helptext = "To check the effects for each ability, check the blue text underneath the ability in the evolution menu."
	genomecost = 3
	verbpath = /mob/proc/changeling_recursive_enhancement

//Increases macimum chemical storage
/mob/proc/changeling_recursive_enhancement()
	set category = "Changeling"
	set name = "Recursive Enhancement (10)"
	set desc = "Empowers our next ability."
	var/datum/changeling/changeling = changeling_power(10,0,100,UNCONSCIOUS)
	if(!changeling)
		return 0
	if(src.mind.changeling.recursive_enhancement)
		src << "<span class='warning'>We have already prepared to enhance our next ability.</span>"
		return 0
	src << "<span class='notice'>We empower ourselves.  Our next ability will be extra potent.</span>"
	src.mind.changeling.recursive_enhancement = 1
	src.mind.changeling.chem_charges -= 10
	feedback_add_details("changeling_powers","RE")
	return 1