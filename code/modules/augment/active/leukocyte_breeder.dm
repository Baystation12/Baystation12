/obj/item/organ/internal/augment/active/leukocyte_breeder
	name = "leukocyte breeder"
	allowed_organs = list(BP_AUGMENT_CHEST_ACTIVE)
	icon_state = "booster"
	desc = "These stimulators augment the immune system and promote the growth of hunter-killer cells in the presence of a foreign invader, effectively boosting the body's immunity to parasites and disease."
	action_button_name = "Toggle leukocyte breeder"
	augment_flags = AUGMENTATION_ORGANIC
	origin_tech = list(TECH_DATA = 2, TECH_BIO = 4)

	var/active = FALSE
	/// How many processing ticks the augment has been enabled for
	var/ticks_active = 0
	/// After this many ticks, the owner has "broken in" the augment, and will benefit more but suffer drawbacks if it's disabled
	var/ticks_to_acclimate = 120

/obj/item/organ/internal/augment/active/leukocyte_breeder/emp_act(severity)
	. = ..()
	if (owner && active)
		if (prob(100 - (20 * severity))) // 40% chance for 3, 60% chance for 2, and 80% chance for 1 severity, respectively
			to_chat(owner, SPAN_WARNING("You feel a wave of nausea as your [name] deactivates."))
			active = FALSE

/obj/item/organ/internal/augment/active/leukocyte_breeder/onRoundstart()
	active = TRUE // We can safely assume that someone starting off with the breeder will have it active
	ticks_active = ticks_to_acclimate
	to_chat(owner, SPAN_INFO("Your [name] has started the shift active, granting you its full benefits without needing to break it in."))

/obj/item/organ/internal/augment/active/leukocyte_breeder/onInstall()
	if (prob(10))
		ticks_active = ticks_to_acclimate // Some folks are just lucky and don't get any side effects

/obj/item/organ/internal/augment/active/leukocyte_breeder/activate()
	if (!can_activate())
		return
	if (active && ticks_active >= ticks_to_acclimate)
		// Give an alert if trying to deactivate while acclimated, so roundstart takers don't accidentally turn it off by learning the buttons
		if (alert(owner, "Deactivate \the [src]?", name, "Yes", "No") != "Yes" || !can_activate())
			return
	active = !active
	owner.playsound_local(null, 'sound/effects/fastbeep.ogg', 20, is_global = TRUE)
	if (active)
		to_chat(owner, SPAN_NOTICE("Leukocyte breeder engaged and improving immune response."))
	else
		to_chat(owner, SPAN_WARNING("Leukocyte breeder disengaged. Short-term health may suffer."))
		if (owner.immunity >= (owner.immunity_norm * 0.9)) // Reduce short-term immunity, but only if it's at around normal levels
			owner.immunity -= 10
		ticks_active = 0

/obj/item/organ/internal/augment/active/leukocyte_breeder/Process()
	if (!owner)
		return
	if (active)
		ticks_active++
		if (owner.immunity < owner.immunity_norm * 1.1) // Slightly boosts above baseline
			owner.immunity += 0.05 // Not as effective as immune boosters, but constant
			ticks_active++

		if (ticks_active < ticks_to_acclimate)
			// The body needs time to break in the augment, and may have minor side effects until it does
			// This is primarily for roleplay purposes, and not any actual gameplay impact - its benefits kick in immediately
			// The immune system just plays a huge role in the body, even if it doesn't in-game, and reflecting that could help with immersion!
			if (ticks_active < ticks_to_acclimate)
				if (prob(5))
					owner.emote(pick("cough", "sneeze"))
				if (prob(3))
					to_chat(owner, SPAN_WARNING(pick("You feel uncomfortably hot.", "Your head aches.", "You feel lightheaded.")))
					owner.dizziness += rand(3, 5)
