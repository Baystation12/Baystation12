/datum/power/changeling/boost_range
	name = "Boost Range"
	desc = "We evolve the ability to shoot our stingers at humans, with some preperation."
	helptext = "Allows us to prepare the next sting to have a range of two tiles."
	enhancedtext = "The range is extended to five tiles."
	genomecost = 1
	allowduringlesserform = 1
	verbpath = /mob/proc/changeling_boost_range

//Boosts the range of your next sting attack by 1
/mob/proc/changeling_boost_range()
	set category = "Changeling"
	set name = "Ranged Sting (10)"
	set desc="Your next sting ability can be used against targets 2 squares away."

	var/datum/changeling/changeling = changeling_power(10,0,100)
	if(!changeling)
		return 0
	changeling.chem_charges -= 10
	src << "<span class='notice'>Your throat adjusts to launch the sting.</span>"
	var/range = 2
	if(src.mind.changeling.recursive_enhancement)
		range = range + 3
		src << "<span class='notice'>We can fire our next sting from five squares away.</span>"
		src.mind.changeling.recursive_enhancement = 0
	changeling.sting_range = range
	src.verbs -= /mob/proc/changeling_boost_range
	spawn(5)
		src.verbs += /mob/proc/changeling_boost_range
	feedback_add_details("changeling_powers","RS")
	return 1