/obj/item/organ/internal/augment/boost/shooting
	name = "gunnery booster"
	desc = "Hephaestus Industries' AIM-4 model improves gun accuracy by filtering unnecessary nerve signals."
	buffs = list(SKILL_WEAPONS = 1)
	injury_debuffs = list(SKILL_WEAPONS = -1)


/obj/item/organ/internal/augment/boost/reflex/buff()
	. = ..()
	if (.)
		to_chat(owner, SPAN_NOTICE("Notice: AIM-4 finished reboot."))


/obj/item/organ/internal/augment/boost/reflex/debuff()
	. = ..()
	if (.)
		to_chat(owner, SPAN_WARNING("Catastrophic damage detected: AIM-4 shutting down."))
