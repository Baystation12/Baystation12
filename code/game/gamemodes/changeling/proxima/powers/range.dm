//Boosts the range of your next sting attack by 1
/mob/proc/changeling_boost_range()
	set category = "Changeling"
	set name = "Ranged Sting (10)"
	set desc="Your next sting ability can be used against targets 2 squares away."

	var/datum/changeling/changeling = changeling_power(10,0,100)
	if(changeling.sting_range == 2)
		to_chat(src, SPAN_LING("Мы уже приготовили жало"))
		return 0
	if(!changeling)	return 0
	changeling.chem_charges -= 10
	to_chat(src, SPAN_LING("Наше горло напряглось, готовясь выпустить жало."))
	changeling.sting_range = 2
	src.verbs -= /mob/proc/changeling_boost_range
	spawn(5)	src.verbs += /mob/proc/changeling_boost_range
	return 1
