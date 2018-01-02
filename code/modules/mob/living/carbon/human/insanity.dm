/mob/living/carbon/human/proc/handle_insanity()
	if(locate(/obj/structure/cult_floor) in get_turf(src))
		insanity += 0.01

	if(iscultist(src))
		insanity += 0.01
	else
		insanity -= 0.01

	update_insanity()
	return

/mob/living/carbon/human/proc/update_insanity()
	insanity = Clamp(0, insanity, 100)
	if(iscultist(src))
		if(insanity < 5)
			if(!(/mob/living/carbon/human/proc/free_from_cult in src.verbs))
				src.verbs += /mob/living/carbon/human/proc/free_from_cult
				to_chat(src, "<span class='notice'>You can free yourself from the infulence of the cult now, if you wish.</span>")
		else if(insanity < 1)
			cult.make_neophyte(src)
		else
			src.verbs -= /mob/living/carbon/human/proc/free_from_cult
	else if(isneophyte(src))
		if(insanity > 40)
			if(!(/mob/living/carbon/human/proc/embrace_cult in src.verbs) && cult.can_become_antag(src.mind, 1))
				to_chat(src, "<span class='notice'>You can join the cult now, if you wish.</span>")
				src.verbs += /mob/living/carbon/human/proc/embrace_cult
		else
			src.verbs -= /mob/living/carbon/human/proc/embrace_cult
	else
		if(insanity > 99 && cult.can_become_antag(src.mind, 1))
			to_chat(src, "<span class='cult'>Madness engulfs your mind. You see everything so clearly now...</span>")
			cult.make_neophyte(src)

/mob/living/carbon/human/proc/add_insanity(var/amount, var/min, var/max)
	if(insanity < 0)
		return
	if(src.mind.assigned_job.is_holy && amount > 0)
		amount /= 2
	if(amount > 0 && !isnull(max) && insanity <= max && insanity + amount > max)
		insanity = max
	else if(amount < 0 && !isnull(min) && insanity >= min && insanity + amount < min)
		insanity = min
	else
		insanity += amount
	update_insanity()

/mob/living/carbon/human/proc/set_insanity(var/amount)
	if(insanity < 0)
		return
	insanity = amount
	update_insanity()
