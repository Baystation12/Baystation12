/obj/item/organ/internal/augment/active/item/adaptive_binoculars
	name = "adaptive binoculars"
	augment_slots = AUGMENT_HEAD
	icon_state = "adaptive_binoculars"
	desc = "Digital glass 'screens' can be deployed over the eyes. At the user's control, their image can be greatly enhanced, providing a view of distant areas."
	action_button_name = "Deploy lenses"
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 2)
	item = /obj/item/clothing/glasses/augment_binoculars


/obj/item/organ/internal/augment/active/item/adaptive_binoculars/hidden
	augment_flags = AUGMENT_MECHANICAL | AUGMENT_BIOLOGICAL


/obj/item/organ/internal/augment/active/item/adaptive_binoculars/emp_act(severity)
	. = ..()
	if (item?.zoom)
		to_chat(owner, SPAN_WARNING("Your eyes fill with static as \the [item.name] malfunction\s!"))
		owner.eye_blind += 10
		owner.eye_blurry += 20
		item.unzoom()
