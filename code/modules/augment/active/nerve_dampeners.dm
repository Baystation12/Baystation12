/obj/item/organ/internal/augment/active/nerve_dampeners
	name = "nerve dampeners"
	augment_slots = AUGMENT_CHEST
	icon_state = "muscule"
	desc = "Each activation of this augment provides a strong painkilling effect for around thirty seconds, but will be followed by a powerful comedown. Excessive short-term use may cause brain damage."
	augment_flags = AUGMENT_BIOLOGICAL
	origin_tech = list(TECH_DATA = 4, TECH_BIO = 4)
	var/ticks_remaining = 0


/obj/item/organ/internal/augment/active/nerve_dampeners/can_activate()
	if (ticks_remaining)
		to_chat(owner, SPAN_WARNING("Your [name] is already active."))
		return
	. = ..()


/obj/item/organ/internal/augment/active/nerve_dampeners/activate()
	if (!can_activate())
		return
	to_chat(owner, SPAN_NOTICE("You activate your [name], and feel a wave of numbness wash over you!"))
	ticks_remaining = 15
	if (owner.drowsyness)
		to_chat(owner, SPAN_DANGER("Your body slackens as you lose sensation."))
		if (prob(owner.getBrainLoss()))
			to_chat(owner, SPAN_DANGER("You slump to the ground and black out."))
			owner.Paralyse(10)
		owner.adjustBrainLoss(owner.drowsyness)


/obj/item/organ/internal/augment/active/nerve_dampeners/Process()
	if (!owner)
		return
	if (ticks_remaining)
		ticks_remaining--
		owner.add_chemical_effect(CE_PAINKILLER, 160) // About twice as strong as tramadol at full strength
		if (!ticks_remaining) // ...but comes at a price. Brief short term benefit for a long-term comedown
			to_chat(owner, SPAN_WARNING("You abruptly feel intensely exhausted as sensation returns."))
			owner.drowsyness = max(owner.drowsyness, 15)
			owner.confused = max(owner.confused, 15)
			owner.slurring = max(owner.slurring, 30)
			owner.chem_effects[CE_PAINKILLER] = 0
			owner.stamina = 0
			if(MOVING_QUICKLY(owner))
				owner.set_moving_slowly()
