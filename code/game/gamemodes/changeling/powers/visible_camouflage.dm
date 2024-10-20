/datum/power/changeling/visible_camouflage
	name = "Camouflage"
	desc = "We rapidly shape the color of our skin and secrete easily reversible dye on our clothes, to blend in with our surroundings.  \
	We are undetectable, so long as we move slowly.(Toggle)"
	helptext = "Running, and performing most acts will reveal us.  Our chemical regeneration is halted while we are hidden."
	enhancedtext = "Can run while hidden."
	ability_icon_state = "ling_camoflage"
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
			return TRUE

		//We delay the check, so that people can uncloak without needing 10 chemicals to do so.
		var/datum/changeling/changeling = changeling_power(10,0,100,CONSCIOUS)

		if(!changeling)
			return FALSE
		changeling.chem_charges -= 10
		var/old_regen_rate = H.mind.changeling.chem_recharge_rate

		to_chat(H, "<span class='notice'>We vanish from sight, and will remain hidden, so long as we move carefully.</span>")
		H.mind.changeling.cloaked = 1
		H.mind.changeling.chem_recharge_rate = 0
		animate(src,alpha = 255, alpha = 10, time = 10)

		var/must_walk = TRUE
		if(src.mind.changeling.recursive_enhancement)
			src.mind.changeling.recursive_enhancement = FALSE
			must_walk = FALSE
			to_chat(src, "<span class='notice'>We may move at our normal speed while hidden.</span>")

		if(must_walk)
			H.set_move_intent(default_walk_intent)

		var/remain_cloaked = TRUE
		while(remain_cloaked) //This loop will keep going until the player uncloaks.
			sleep(1 SECOND) // Sleep at the start so that if something invalidates a cloak, it will drop immediately after the check and not in one second.

			if(MOVING_QUICKLY(H) && must_walk) // Moving too fast uncloaks you.
				remain_cloaked = 0
			if(!H.mind.changeling.cloaked)
				remain_cloaked = 0
			if(H.stat) // Dead or unconscious lings can't stay cloaked.
				remain_cloaked = 0
			//using or equipping an item will uncloak you
			if(H.l_hand || H.r_hand)
				remain_cloaked = 0
			if(H.incapacitated(INCAPACITATION_DISABLED)) // Stunned lings also can't stay cloaked.
				remain_cloaked = 0

			if(mind.changeling.chem_recharge_rate != 0) //Without this, there is an exploit that can be done, if one buys engorged chem sacks while cloaked.
				old_regen_rate += mind.changeling.chem_recharge_rate //Unfortunately, it has to occupy this part of the proc.  This fixes it while at the same time
				mind.changeling.chem_recharge_rate = 0 //making sure nobody loses out on their bonus regeneration after they're done hiding.



		H.invisibility = initial(invisibility)
		visible_message("<span class='warning'>[src] suddenly fades in, seemingly from nowhere!</span>",
		"<span class='notice'>We revert our camouflage, revealing ourselves.</span>")
		H.mind.changeling.cloaked = 0
		H.mind.changeling.chem_recharge_rate = old_regen_rate

		animate(src,alpha = 10, alpha = 255, time = 10)
