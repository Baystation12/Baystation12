/obj/item/organ/internal/augment/active/simple/equip/adaptive_binoculars
	name = "adaptive binoculars"
	allowed_organs = list(BP_AUGMENT_HEAD)
	icon_state = "adaptive_binoculars"
	desc = "Digital glass 'screens' can be deployed over the eyes. At the user's control, their image can be greatly enhanced, providing a view of distant areas."
	action_button_name = "Deploy lenses"
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 2)
	equip_slot = slot_glasses
	holding_type = /obj/item/clothing/glasses/augment_binoculars

/obj/item/organ/internal/augment/active/simple/equip/adaptive_binoculars/hidden
	known = FALSE

/obj/item/organ/internal/augment/active/simple/equip/adaptive_binoculars/emp_act(severity)
	. = ..()
	if (holding?.zoom)
		to_chat(owner, SPAN_WARNING("Your eyes fill with static as your [holding.name] malfunction."))
		owner.eye_blind += 10
		owner.eye_blurry += 20
		holding.unzoom()
