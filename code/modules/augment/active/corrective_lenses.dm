/obj/item/organ/internal/augment/active/item/corrective_lenses
	name = "corrective lenses"
	augment_slots = AUGMENT_HEAD
	icon_state = "corrective_lenses"
	desc = "A pair of retractable, ultrathin corrective lenses are installed into the eye sockets. They can be deployed or retracted at will and serve as prescription glasses."
	action_button_name = "Deploy lenses"
	augment_flags = AUGMENT_BIOLOGICAL | AUGMENT_SCANNABLE | AUGMENT_INSPECTABLE
	origin_tech = list(TECH_DATA = 2, TECH_BIO = 2)
	item = /obj/item/clothing/glasses/augment


/obj/item/organ/internal/augment/active/item/corrective_lenses/onRoundstart()
	deploy()


/obj/item/clothing/glasses/augment
	name = "corrective lenses"
	desc = "The most expensive prescription on this side of Sol."
	body_parts_covered = EMPTY_BITFIELD
	prescription = 7
	unacidable = TRUE
