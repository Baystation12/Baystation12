/datum/phenomena/exhude_blood
	name = "Exhude Blood"
	desc = "Take pity on a follower, converting a pitance of your power into blood. Don't let them forget your mercy."
	cost = 20
	flags = PHENOMENA_FOLLOWER
	expected_type = /mob/living/carbon/human

/datum/phenomena/exhude_blood/can_activate(mob/living/carbon/human/H)
	if(!..())
		return FALSE

	if(!H.should_have_organ(BP_HEART) || H.vessel.total_volume == H.species.blood_volume)
		to_chat(linked, SPAN_WARNING("\The [H] doesn't require anymore blood."))
		return FALSE
	return TRUE

/datum/phenomena/exhude_blood/activate(mob/living/carbon/human/H, mob/living/deity/user)
	H.vessel.add_reagent(/datum/reagent/blood, 30)
	to_chat(H,SPAN_NOTICE("You feel a rush as new blood enters your system."))

/datum/phenomena/hellscape
	name = "Reveal Hellscape"
	desc = "Show a non-follower what awaits their souls after you are through with them."
	cost = 60
	cooldown = 450
	flags = PHENOMENA_NONFOLLOWER
	expected_type = /mob/living
	var/static/list/creepy_notes = list(
		"Your knees give out as an unnatural screaming rings your ears.",
		"You breathe in ash and decay, your lungs gasping for air as your body gives way to the floor.",
		"An extreme pressure comes over you as if an unknown force has marked you."
	)

/datum/phenomena/hellscape/activate(mob/living/L)
	to_chat(L, SPAN_OCCULT("[pick(creepy_notes)]"))
	L.damageoverlaytemp = 100
	sound_to(L, 'sound/hallucinations/far_noise.ogg')
	L.Weaken(2)
