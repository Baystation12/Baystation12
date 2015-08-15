/datum/power/changeling/boost_range
	name = "Boost Range"
	desc = "We evolve the ability to shoot our stingers at humans, with some preperation."
	helptext = "Allows us to prepare the next sting to have a range of two tiles."
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
	changeling.sting_range = 2
	src.verbs -= /mob/proc/changeling_boost_range
	spawn(5)
		src.verbs += /mob/proc/changeling_boost_range
	feedback_add_details("changeling_powers","RS")
	return 1