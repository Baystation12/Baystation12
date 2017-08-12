/datum/phenomena/exhude_blood
	name = "Exhude Blood"
	cost = 10
	flags = PHENOMENA_FOLLOWER
	expected_type = /mob/living/carbon/human

/datum/phenomena/exhude_blood/can_activate(var/mob/living/carbon/human/H)
	if(!..())
		return 0

	if(!H.should_have_organ(BP_HEART) || H.vessel.total_volume == H.species.blood_volume)
		to_chat(linked, "<span class='warning'>\The [H] doesn't require anymore blood.</span>")
		return 0
	return 1

/datum/phenomena/exhude_blood/activate(var/mob/living/carbon/human/H, var/mob/living/deity/user)
	H.vessel.add_reagent("blood", 30)
	to_chat(H,"<span class='notice'>You feel a rush as new blood enters your system.</span>")


/datum/phenomena/hellscape
	name = "Reveal Hellscape"
	cost = 30
	flags = PHENOMENA_NONFOLLOWER
	expected_type = /mob/living
	var/static/list/creepy_notes = list("Your knees give out as an unnatural screaming rings your ears.",
										"You breathe in ash and decay, your lungs gasping for air as your body gives way to the floor.",
										"An extreme pressure comes over you, as if an unknown force has marked you.")

/datum/phenomena/hellscape/activate(var/mob/living/L)
	to_chat(L, "<font size='3'><span class='cult'>[pick(creepy_notes)]</span></font>")
	L.damageoverlaytemp = 100
	sound_to(L, 'sound/hallucinations/far_noise.ogg')
	L.Weaken(2)