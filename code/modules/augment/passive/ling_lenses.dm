/obj/item/organ/internal/augment/ling_lenses
	name = "organic eyelid lense"
	desc = "a thin, almost transparent lense surrounded by nerve fibers"
	icon_state = "thermal_eyes"
	status = ORGAN_CONFIGURE
	augment_slots = AUGMENT_HEAD
	augment_flags = AUGMENT_BIOLOGICAL
	var/is_active = FALSE
/obj/item/organ/internal/augment/ling_lenses/emp_act()
	..()
	return
/obj/item/organ/internal/augment/ling_lenses/Process()
	..()
	if(is_active && (owner.mind.changeling.chem_charges > 0))
		owner.set_sight(owner.sight | SEE_MOBS)
		owner.mind.changeling.chem_charges -= 3
		if(owner.mind.changeling.chem_charges < 3)
			to_chat(owner,SPAN_NOTICE("Our lenses retract, causing us to lose our augmented vision."))
			is_active = FALSE
