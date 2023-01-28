/obj/item/organ/internal/augment/changeling/ragecore
	name = "strange mass"
	desc = "a throbbing, writhing sack of meat that almost seems to beat like a living heart"
	icon_state = "berserk_sac"
	augment_slots = AUGMENT_GROIN
	status = ORGAN_CONFIGURE
	augment_flags = AUGMENT_BIOLOGICAL
	var/ticks_remaining = 0;
/obj/item/organ/internal/augment/changeling/ragecore/emp_act()
	..()
	return
/obj/item/organ/internal/augment/changeling/ragecore/Process()
	..()
	if (ticks_remaining > 0)
		owner.add_chemical_effect(CE_PAINKILLER, 160) // About twice as strong as tramadol at full strength
		owner.add_chemical_effect(CE_SPEEDBOOST, 1)
		owner.add_chemical_effect(CE_STIMULANT, 4)
		ticks_remaining -= 1
		if (ticks_remaining == 15)
			to_chat(owner, SPAN_WARNING("We feel our adrenal sacs beginning to exhaust themselves. If we do not retreat soon, we will be left vulnerable."))
		if (!ticks_remaining) // ...but comes at a price. Brief short term benefit for a long-term comedown
			to_chat(owner, SPAN_WARNING("We feel our body grow weak and sluggish, our adrenal sacs depleted."))
			owner.drowsyness = max(owner.drowsyness, 15)
			owner.set_confused(15)
			owner.slurring = max(owner.slurring, 30)
			owner.chem_effects[CE_PAINKILLER] = 0
			owner.stamina = 0
			if(MOVING_QUICKLY(owner))
				owner.set_moving_slowly()
