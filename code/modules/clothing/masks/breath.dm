/obj/item/clothing/mask/breath
	desc = "A close-fitting mask that can be connected to an air supply."
	name = "breath mask"
	icon_state = "breath"
	item_state = "breath"
	item_flags = ITEM_FLAG_AIRTIGHT|ITEM_FLAG_FLEXIBLEMATERIAL
	body_parts_covered = FACE
	w_class = ITEM_SIZE_SMALL
	gas_transfer_coefficient = 0.10
	permeability_coefficient = 0.50
	down_gas_transfer_coefficient = 1
	down_body_parts_covered = null
	down_item_flags = ITEM_FLAG_THICKMATERIAL
	down_icon_state = "breathdown"
	pull_mask = 1
	sprite_sheets = list(
		SPECIES_VOX = 'icons/mob/species/vox/onmob_mask_vox.dmi',
		SPECIES_VOX_ARMALIS = 'icons/mob/species/vox/onmob_mask_vox_armalis.dmi',
		SPECIES_UNATHI = 'icons/mob/species/unathi/generated/onmob_mask_unathi.dmi',
		)

/obj/item/clothing/mask/breath/medical
	desc = "A close-fitting sterile mask that can be manually connected to an air supply for treatment."
	name = "medical mask"
	icon_state = "medical"
	item_state = "medical"
	permeability_coefficient = 0.01

/obj/item/clothing/mask/breath/anesthetic
	desc = "A close-fitting sterile mask that is used by the anesthetic wallmounted pump."
	name = "anesthetic mask"
	icon_state = "medical"
	item_state = "medical"
	permeability_coefficient = 0.01

/obj/item/clothing/mask/breath/emergency
	desc = "A close-fitting  mask that is used by the wallmounted emergency oxygen pump."
	name = "emergency mask"
	icon_state = "breath"
	item_state = "breath"
	permeability_coefficient = 0.50

/obj/item/clothing/mask/breath/scba
	desc = "A close-fitting self contained breathing apparatus mask. Can be connected to an air supply."
	name = "\improper SCBA mask"
	icon_state = "scba_mask"
	item_state = "scba_mask"
	down_icon_state = "scba_maskdown"
	item_flags = ITEM_FLAG_AIRTIGHT|ITEM_FLAG_FLEXIBLEMATERIAL
	flags_inv = HIDEEYES
	body_parts_covered = FACE|EYES
	gas_transfer_coefficient = 0.01

