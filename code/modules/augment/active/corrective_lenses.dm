/obj/item/organ/internal/augment/active/simple/equip/corrective_lenses
	name = "corrective lenses"
	allowed_organs = list(BP_AUGMENT_HEAD)
	icon_state = "corrective_lenses"
	desc = "A pair of retractable, ultrathin corrective lenses are installed into the eye sockets. They can be deployed or retracted at will and serve as prescription glasses."
	action_button_name = "Deploy lenses"
	augment_flags = AUGMENTATION_ORGANIC
	origin_tech = list(TECH_DATA = 2, TECH_BIO = 2)
	equip_slot = slot_glasses
	holding_type = /obj/item/clothing/glasses/prescription/augment

/obj/item/organ/internal/augment/active/simple/equip/corrective_lenses/onRoundstart()
	deploy()
