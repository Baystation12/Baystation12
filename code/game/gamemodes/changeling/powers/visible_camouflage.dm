/datum/power/changeling/visible_camouflage
	name = "Camouflage"
	desc = "We rapidly shape the color of our skin and secrete easily reversible dye on our clothes, to blend in with our surroundings.  \
	We are undetectable, so long as we move slowly.(Toggle)"
	helptext = "Running, and performing most acts will reveal us.  Our chemical regeneration is halted while we are hidden."
	enhancedtext = "True invisiblity while cloaked."
	genomecost = 3
	verbpath = /mob/proc/changeling_visible_camouflage

//Hide us from anyone who would do us harm.
/mob/proc/changeling_visible_camouflage()
	set category = "Changeling"
	set name = "Visible Camouflage (10)"
	set desc = "Turns yourself almost invisible, as long as you move slowly."


	if(istype(src,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = src

		if(H.mind.changeling.cloaked)
			H.mind.changeling.cloaked = 0
			return 1

		//We delay the check, so that people can uncloak without needing 10 chemicals to do so.
		var/datum/changeling/changeling = changeling_power(10,0,100,CONSCIOUS)

		if(!changeling)
			return 0

		var/old_regen_rate = H.mind.changeling.chem_recharge_rate

		H << "<span class='notice'>We vanish from sight, and will remain hidden, so long as we move carefully.</span>"
		H.set_m_intent("walk")
		H.mind.changeling.cloaked = 1
		H.mind.changeling.chem_recharge_rate = 0
		animate(src,alpha = 255, alpha = 10, time = 10)

		if(src.mind.changeling.recursive_enhancement)
			H.invisibility = INVISIBILITY_OBSERVER
			src << "<span class='notice'>We are now truly invisible.</span>"
			src.mind.changeling.recursive_enhancement = 0

		while(H.m_intent == "walk" && H.mind.changeling.cloaked) //This loop will keep going until the player uncloaks.
			if(mind.changeling.chem_recharge_rate != 0) //Without this, there is an exploit that can be done, if one buys engorged chem sacks while cloaked.
				old_regen_rate += mind.changeling.chem_recharge_rate //Unfortunately, it has to occupy this part of the proc.  This fixes it while at the same time
				mind.changeling.chem_recharge_rate = 0 //making sure nobody loses out on their bonus regeneration after they're done hiding.
			sleep(10)


		H.invisibility = initial(invisibility)
		visible_message("<span class='warning'>[src] suddenly fades in, seemingly from nowhere!</span>",
		"<span class='notice'>We revert our camouflage, revealing ourselves.</span>")
		H.set_m_intent("run")
		H.mind.changeling.cloaked = 0
		H.mind.changeling.chem_recharge_rate = old_regen_rate

		animate(src,alpha = 10, alpha = 255, time = 10)