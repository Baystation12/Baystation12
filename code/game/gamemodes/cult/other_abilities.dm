// -1 - haven't encountered anything cultish yet
// 0 - 5 - completely safe, cultists and neophytes can be deconverted
// 5 - 10 - safe
// 10 - 20 - showing interest in occult
// 20 - 40 - typical neophyte level, common people can become neophytes
// 40+ - normal cultist level
// induce rune can get you to 80
// null rod can bring it down to 30
// holy water down to 0
// at <1 cultists and neophytes are deconverted
// at >99 normal people become neophytes

/mob/living/carbon/human
	var/insanity = -1
	var/last_prayer = 0

/mob/living/carbon/human/proc/prayer()
	set category = "Cult Magic" // This isn't super fitting, but I guess it'll have to do
	set name = "Prayer"
	set desc = "Pray to your god for protection against evil. Or, if your god is evil, the opposite."

	if(last_prayer + cult.prayer_cooldown < world.time)
		to_chat(src, "<span class='notice'>You've already made a prayer recently.</span>")
		return

	if(iscultist(src))
		src.visible_message("<span class='notice'>You begin praying to the Geometer of Blood...</span>", "<span class='notice'>[src] holds \his hands to \his face and begins to chant quietly.</span>")
		if(!do_after(src, 50))
			return
	else
		if(src.insanity > 70)
			to_chat(src, "<span class='warning'>Your mind is far too jumbled to focus your thoughts on a prayer.</span>")
			return

		if(!cult.atheist_prayer && (src.religion == "None" || src.religion == "Atheism" || src.religion == "Deism") && !src.mind.assigned_job.is_holy)
			to_chat(src, "<span class='notice'>The idea of praying seems silly to you.</span>")
			return

		var/prayer_strength = 1
		if(src.mind.assigned_job.is_holy)
			prayer_strength *= 3
		if(src.insanity > 60)
			prayer_strength /= 2
		else if(src.insanity > 40)
			prayer_strength /= 1.5

		var/message_self
		var/message_others
		switch(src.religion)
			if("Christianity", "Unitarianism")
				switch(rand(2))
					if(1)
						message_self = "You hold your hands together and begin praying to God."
						message_others = "[src] holds \his hands together and whispers quietly."
					if(2)
						message_self = "You cross yourself and begin praying to God."
						message_others = "[src] cross themselves and whispers quietly."
			if("Judaism")

			if("Islam")

			if("Buddhism")

			if("Hinduism")

			if("None", "Atheism", "Agnosticism", "Deism")
				message_self = "Unsure how to do it, you hold your hands together and begin praying."
				message_others = "[src] holds \his hands together."
			else
				message_self = "You start your prayer."
				message_others = "[src] begins to pray."

		src.visible_message("<span class='notice'>[message_self]</span>", "<span class='notice'>[message_others]</span>")
		if(!do_after(src, 50))
			return

		if(cult.endgame)
			to_chat(src, "<span class='cult'>BUT NOBODY CAME</span>")
			return

		// Okay, let's try to figure out why you're praying

		if(src.insanity > 40) // Very high insanity
			to_chat(src, "<span class='notice'>Your mind becomes clearer.</span>")
			src.add_insanity(-5 * prayer_strength)
			return

		if(locate(/obj/structure/cult_floor) in view(min(prayer_strength, 1))) // Remove corruption
			for(var/obj/structure/cult_floor/C in view(min(prayer_strength, 1)))
				qdel(C)
				src.visible_message("<span class='notice'>The engravings on the floor retreat from \the [src].</span>")
			return

		var/obj/effect/rune/R = locate() in view(min(prayer_strength, 1))
		if(R) // You're praying to remove a rune
			R.visible_message("<span class='notice'>\The [src] disappears in a flash of light.</span>")
			qdel(R)
			return

		for(var/mob/living/carbon/human/H in view(min(prayer_strength, 1))) // Praying for someone else?
			if(H.insanity > 40)
				to_chat(src, "<span class='notice'>.</span>") // TODO
				to_chat(H, "<span class='notice'>Your mind becomes clearer.</span>")
				H.add_insanity(-5 * prayer_strength)

	last_prayer = world.time

/mob/living/carbon/human/proc/embrace_cult()
	set category = "Cult Magic"
	set name = "Embrace Occultism"
	set desc = "Accept your insanity and become a cult member."


/mob/living/carbon/human/proc/free_from_cult()
	set category = "Cult Magic"
	set name = "Embrace Salvation"
	set desc = "Defy the cult and leave it."
