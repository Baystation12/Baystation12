/mob/proc/changeling_respec()
	set category = "Changeling"
	set name = "Re-adapt"
	set desc = "Allows us to refund our purchased abilities."

	var/datum/changeling/changeling = changeling_power(0,0,100)
	if(!changeling)
		return

	src.remove_changeling_powers() //First, remove the verbs.
	var/datum/changeling/ling_datum = src.mind.changeling
	ling_datum.purchasedpowers = list() //Then wipe all the powers we bought.
	ling_datum.geneticpoints = ling_datum.max_geneticpoints //Now refund our points to the maximum.
	ling_datum.chem_recharge_rate = 0.5 //If glands were bought, revert that upgrade.
	ling_datum.chem_storage = 50
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		H.does_not_breathe = 0 //If self respiration was bought, revert that too.
		H.maxHealth = initial(H.maxHealth) //Revert endoarmor too.
	src.make_changeling() //And give back our freebies.

	src << "<span class='notice'>We have removed our evolutions from this form, and are now ready to readapt.</span>"

	//Now to lose the verb, so no unlimited resets.
	src.verbs -= /mob/proc/changeling_respec