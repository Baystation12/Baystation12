// Heals the vampire at the cost of blood.
/spell/targeted/vampire/bloodheal
	name = "Blood Heal"
	desc = "At the cost of blood and time, heal any injuries you have sustained."
	spell_flags = NEEDSVAMPIRE
	invocation_type = SpI_NONE

/spell/targeted/vampire/bloodheal/cast()
	var/mob/living/carbon/human/H = usr
	H.bloodheal()

/mob/living/carbon/human/proc/bloodheal()

	var/datum/vampire/vampire = vampire_power(0, 0)
	if (!vampire)
		return

	// Kick out of the already running loop.
	if (vampire.status & VAMP_HEALING)
		vampire.status &= ~VAMP_HEALING
		return
	else if (vampire.blood_usable < 15)
		to_chat(src, "<span class='warning'>You do not have enough usable blood. 15 needed.</span>")
		return

	vampire.status |= VAMP_HEALING
	to_chat(src, "<span class='notice'>You begin the process of blood healing. Do not move, and ensure that you are not interrupted.</span>")

	log_and_message_admins("activated blood heal.")

	while (do_after(src, 20, null, 0))
		if (!(vampire.status & VAMP_HEALING))
			to_chat(src, "<span class='warning'>Your concentration is broken! You are no longer regenerating!</span>")
			break

		var/tox_loss = getToxLoss()
		var/oxy_loss = getOxyLoss()
		var/ext_loss = getBruteLoss() + getFireLoss()
		var/clone_loss = getCloneLoss()

		var/blood_used = 0
		var/to_heal = 0

		if (tox_loss)
			to_heal = min(10, tox_loss)
			adjustToxLoss(0 - to_heal)
			blood_used += round(to_heal * 1.2)
		if (oxy_loss)
			to_heal = min(10, oxy_loss)
			adjustOxyLoss(0 - to_heal)
			blood_used += round(to_heal * 1.2)
		if (ext_loss)
			to_heal = min(20, ext_loss)
			heal_overall_damage(min(10, getBruteLoss()), min(10, getFireLoss()))
			blood_used += round(to_heal * 1.2)
		if (clone_loss)
			to_heal = min(10, clone_loss)
			adjustCloneLoss(0 - to_heal)
			blood_used += round(to_heal * 1.2)

		var/list/organs = get_damaged_organs(1, 1)
		if (organs.len)
			// Heal an absurd amount, basically regenerate one organ.
			heal_organ_damage(50, 50)
			blood_used += 12

		var/list/emotes_lookers = list("[src]'s skin appears to liquefy for a moment, sealing up their wounds.",
									"[src]'s veins turn black as their damaged flesh regenerates before your eyes!",
									"[src]'s skin begins to split open. It turns to ash and falls away, revealing the wound to be fully healed.",
									"Whispering arcane things, [src]'s damaged flesh appears to regenerate.",
									"Thick globs of blood cover a wound on [src]'s body, eventually melding to be one with \his flesh.",
									"[src]'s body crackles, skin and bone shifting back into place.")
		var/list/emotes_self = list("Your skin appears to liquefy for a moment, sealing up your wounds.",
									"Your veins turn black as their damaged flesh regenerates before your eyes!",
									"Your skin begins to split open. It turns to ash and falls away, revealing the wound to be fully healed.",
									"Whispering arcane things, your damaged flesh appears to regenerate.",
									"Thick globs of blood cover a wound on your body, eventually melding to be one with your flesh.",
									"Your body crackles, skin and bone shifting back into place.")

		if (prob(20))
			visible_message("<span class='danger'>[pick(emotes_lookers)]</span>", "<span class='notice'>[pick(emotes_self)]</span>")

		if (vampire.blood_usable <= blood_used)
			vampire.blood_usable = 0
			vampire.status &= ~VAMP_HEALING
			to_chat(src, "<span class='warning'>You ran out of blood, and are unable to continue!</span>")
			break
		else if (!blood_used)
			vampire.status &= ~VAMP_HEALING
			to_chat(src, "<span class='notice'>Your body has finished healing. You are ready to continue.</span>")
			break

	// We broke out of the loop naturally. Gotta catch that.
	if (vampire.status & VAMP_HEALING)
		vampire.status &= ~VAMP_HEALING
		to_chat(src, "<span class='warning'>Your concentration is broken! You are no longer regenerating!</span>")

	return
