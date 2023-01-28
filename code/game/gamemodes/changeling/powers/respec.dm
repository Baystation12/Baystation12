/mob/proc/changeling_respec()
	set category = "Changeling"
	set name = "Re-adapt"
	set desc = "Allows us to refund our purchased abilities."

	var/datum/changeling/changeling = changeling_power(0,0,100)
	if(!changeling)
		return
	if(src.mind.changeling.readapts <= 0)
		to_chat(src, "<span class='warning'>We must first absorb another compatible creature!</span>")
		src.mind.changeling.readapts = 0
		return

	src.remove_changeling_powers() //First, remove the verbs.
	var/datum/changeling/ling_datum = src.mind.changeling
	ling_datum.readapts--
	ling_datum.purchased_powers = list() //Then wipe all the powers we bought.
	ling_datum.geneticpoints = ling_datum.max_geneticpoints //Now refund our points to the maximum.
	ling_datum.chem_recharge_rate = 0.5 //If glands were bought, revert that upgrade.
	ling_datum.thermal_sight = FALSE
	src.mind.changeling.recursive_enhancement = 0 //Ensures this is cleared

	ling_datum.chem_storage = 50
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
	//	H.does_not_breathe = 0 //If self respiration was bought, revert that too.
		H.remove_modifiers_of_type(/datum/modifier/endoarmor) //Revert endoarmor too.
	src.make_changeling() //And give back our freebies.

	to_chat(src, "<span class='notice'>We have removed our evolutions from this form, and are now ready to readapt.</span>")

	ling_datum.purchased_powers_history.Add("Re-adapt (Reset to [ling_datum.max_geneticpoints])")
