/datum/equip_slot
	var/equip_plane
	var/list/equip_layers = list()

	var/equip_tag

/datum/equip_slot/skin
	equip_plane = FLESH_EQP_PLANE
	equip_layers = list(SKIN_EQP_LAYER)

	equip_tag = EQP_SKIN

/datum/equip_slot/underwear
	equip_plane = CLOTHING_EQP_PLANE
	equip_layers = list(UNDERWEAR_EQP_LAYER)

	equip_tag = EQP_UNDERWEAR

/datum/equip_slot/clothes
	equip_plane = CLOTHING_EQP_PLANE
	equip_layers = list(CLOTHES_EQP_LAYER)

	equip_tag = EQP_CLOTHES

/datum/equip_slot/jacket
	equip_plane = CLOTHING_EQP_PLANE
	equip_layers = list(JACKET_EQP_LAYER)

	equip_tag = EQP_JACKET

/datum/equip_slot/soft_armour
	equip_plane = ARMOUR_EQP_PLANE
	equip_layers = list(SOFT_ARMOUR_EQP_LAYER)

	equip_tag = EQP_SOFT_ARMOUR

/datum/equip_slot/hard_armour
	equip_plane = ARMOUR_EQP_PLANE
	equip_layers = list(HARD_ARMOUR_EQP_LAYER)

	equip_tag = EQP_HARD_ARMOUR

/datum/equip_slot/storage
	equip_plane = OVERWEAR_EQP_PLANE
	equip_layers = list(STORAGE_EQP_LAYER)

	equip_tag = EQP_STORAGE

/datum/equip_slot/overcoat
	equip_plane = OVERWEAR_EQP_PLANE
	equip_layers = list(OVERCOAT_EQP_LAYER)

	equip_tag = EQP_OVERCOAT

/datum/equip_slot/both_armour
	equip_plane = ARMOUR_EQP_PLANE
	equip_layers = list(SOFT_ARMOUR_EQP_LAYER, HARD_ARMOUR_EQP_LAYER)

	equip_tag = EQP_BOTH_ARMOUR
