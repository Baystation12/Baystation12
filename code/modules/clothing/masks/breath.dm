/obj/item/clothing/mask/breath
	desc = "A close-fitting mask that can be connected to an air supply."
	name = "breath mask"
	icon_state = "breath"
	item_state = "breath"
	item_flags = AIRTIGHT|FLEXIBLEMATERIAL
	body_parts_covered = FACE
	w_class = ITEM_SIZE_SMALL
	gas_transfer_coefficient = 0.10
	permeability_coefficient = 0.50
	down_gas_transfer_coefficient = 1
	down_body_parts_covered = null
	down_item_flags = FLEXIBLEMATERIAL
	down_icon_state = "breathdown"
	pull_mask = 1

/obj/item/clothing/mask/breath/medical
	desc = "A close-fitting sterile mask that can be connected to an air supply."
	name = "medical mask"
	icon_state = "medical"
	item_state = "medical"
	permeability_coefficient = 0.01

/obj/item/clothing/mask/breath/bogani
	name = "large alien mask"
	desc = "Some form of alien breathing apparatus."
	icon_state = "bmask_large"
	item_state = "bmask_large"
	pull_mask = 0
	species_restricted = list("Bogani")

/obj/item/clothing/mask/breath/bogani/egyno
	name = "alien mask"
	icon_state = "bmask"
	item_state = "bmask"
	species_restricted = list("Egyno")
