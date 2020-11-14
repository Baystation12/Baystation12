/obj/item/clothing/accessory/cloak/boh
	desc = "A simple, yet fancy cloak."
	icon = 'icons/boh/obj/clothing/obj_cloak.dmi'
	icon_override = 'icons/boh/mob/onmob/onmob_cloak.dmi'
	accessory_icons = list(slot_tie_str = 'icons/boh/mob/onmob/onmob_cloak.dmi', slot_w_uniform_str = 'icons/boh/mob/onmob/onmob_cloak.dmi', slot_wear_suit_str = 'icons/boh/mob/onmob/onmob_cloak.dmi')

/obj/item/clothing/accessory/cloak/boh/dress
	name = "boatcloak"
	desc = "A fancy NTEF boatcloak with silver ribbon."
	icon_state = "boatcloak"
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/accessory/cloak/boh/dress/command
	name = "command boatcloak"
	desc = "A fancy NTEF boatcloak with golden ribbon."
	icon_state = "boatcloak_com"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS

/obj/item/clothing/accessory/cloak/boh/command
	name = "command cloak"
	desc = "A white NTEF dress cloak with gold details."
	icon_state = "cloak_com"

/obj/item/clothing/accessory/cloak/boh/command/support
	name = "command support cloak"

/obj/item/clothing/accessory/cloak/boh/engineering
	name = "engineering cloak"
	desc = "A white NTEF dress cloak with orange details."
	icon_state = "cloak_eng"

/obj/item/clothing/accessory/cloak/boh/explorer
	name = "explorer cloak"
	desc = "A white NTEF dress cloak with purple details."
	icon_state = "cloak_exp"

/obj/item/clothing/accessory/cloak/boh/explorer/science
	name = "researcher cloak"

/obj/item/clothing/accessory/cloak/boh/medical
	name = "medical cloak"
	desc = "A white NTEF dress cloak with light-blue details."
	icon_state = "cloak_med"

/obj/item/clothing/accessory/cloak/boh/security
	name = "security cloak"
	desc = "A white NTEF dress cloak with red details."
	icon_state = "cloak_sec"

/obj/item/clothing/accessory/cloak/boh/service
	name = "service cloak"
	desc = "A white NTEF dress cloak with green details."
	icon_state = "cloak_service"

/obj/item/clothing/accessory/cloak/boh/supply
	name = "supply cloak"
	desc = "A white NTEF dress cloak with brown details."
	icon_state = "cloak_supply"

// Map-wise Modular Override to include ACCESSORY_SLOT_OVER
/obj/item/clothing/suit/storage/solgov/service
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND,ACCESSORY_SLOT_MEDAL,ACCESSORY_SLOT_INSIGNIA,ACCESSORY_SLOT_RANK,ACCESSORY_SLOT_DEPT,ACCESSORY_SLOT_OVER)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND,ACCESSORY_SLOT_OVER)

/obj/item/clothing/suit/storage/solgov/dress
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL,ACCESSORY_SLOT_RANK, ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_OVER)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_OVER)

/obj/item/clothing/suit/dress/solgov
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL,ACCESSORY_SLOT_RANK,ACCESSORY_SLOT_OVER)

/obj/item/clothing/suit/storage/hooded/wintercoat/solgov
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA,ACCESSORY_SLOT_RANK,ACCESSORY_SLOT_OVER)

/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA,ACCESSORY_SLOT_RANK,ACCESSORY_SLOT_OVER)

/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/fleet
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA,ACCESSORY_SLOT_RANK,ACCESSORY_SLOT_OVER)

/obj/item/clothing/suit/dress/terran
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL,ACCESSORY_SLOT_RANK,ACCESSORY_SLOT_OVER)

//Psionic Advisor

/decl/hierarchy/outfit/job/command/psiadvisor
	name = OUTFIT_JOB_NAME("Foundation Advisor")
	uniform = /obj/item/clothing/under/det/grey
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/foundation
	gloves = /obj/item/clothing/gloves/white
	shoes = /obj/item/clothing/shoes/dress
	pda_type = /obj/item/modular_computer/pda/heads
	id_types = /obj/item/weapon/card/id/torch/crew/psiadvisor
	l_hand =   /obj/item/weapon/storage/briefcase/foundation
	holster =  /obj/item/clothing/accessory/storage/holster/waist

/decl/hierarchy/outfit/job/command/psiadvisor/nt
	name = OUTFIT_JOB_NAME("NTPC Agent")
	glasses = /obj/item/clothing/glasses/sunglasses
	suit = /obj/item/clothing/suit/storage/toggle/suit/black/agent
	gloves = /obj/item/clothing/ring/material/nullglass
	shoes = /obj/item/clothing/shoes/dutyboots
	l_hand =   /obj/item/weapon/storage/briefcase/foundation/nt
	holster =  /obj/item/clothing/accessory/storage/holster/armpit


/obj/item/clothing/accessory/cloak
	name = "cloak"
	desc = "A simple, bland cloak."
	icon_state = "cloak"
	icon = 'icons/boh/obj/clothing/obj_cloak.dmi'
	icon_override = 'icons/boh/mob/onmob/onmob_cloak.dmi'
	accessory_icons = list(slot_tie_str = 'icons/boh/mob/onmob/onmob_cloak.dmi', slot_w_uniform_str = 'icons/boh/mob/onmob/onmob_cloak.dmi', slot_wear_suit_str = 'icons/boh/mob/onmob/onmob_cloak.dmi')
	var/fire_resist = T0C+100
	allowed = list(/obj/item/weapon/tank/emergency)
	slot_flags = SLOT_OCLOTHING | SLOT_TIE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	siemens_coefficient = 0.9
	w_class = ITEM_SIZE_NORMAL
	slot = ACCESSORY_SLOT_OVER