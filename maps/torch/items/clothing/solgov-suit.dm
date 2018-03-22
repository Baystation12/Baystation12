/obj/item/clothing/suit/storage/solgov/
	name = "master solgov jacket"
	icon = 'maps/torch/icons/obj/solgov-suit.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/torch/icons/mob/solgov-suit.dmi')

//Service

/obj/item/clothing/suit/storage/solgov/service
	name = "service jacket"
	desc = "A uniform service jacket, plain and undecorated."
	icon_state = "blackservice"
	item_state = "blackservice"
	body_parts_covered = UPPER_TORSO|ARMS
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	allowed = list(/obj/item/weapon/tank/emergency,/obj/item/device/flashlight,/obj/item/weapon/pen,/obj/item/clothing/head/soft,/obj/item/clothing/head/beret,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter,/obj/item/device/taperecorder,/obj/item/device/analyzer,/obj/item/device/radio,/obj/item/taperoll)
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND,ACCESSORY_SLOT_MEDAL,ACCESSORY_SLOT_INSIGNIA,ACCESSORY_SLOT_RANK,ACCESSORY_SLOT_DEPT)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)

/obj/item/clothing/suit/storage/solgov/service/expeditionary
	name = "expeditionary jacket"
	desc = "A uniform service jacket belonging to the SCG Expeditionary Corps."
	icon_state = "ecservice_crew"

/obj/item/clothing/suit/storage/solgov/service/expeditionary/medical
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/medical/service)

/obj/item/clothing/suit/storage/solgov/service/expeditionary/medical/command
	icon_state = "ecservice_officer"

/obj/item/clothing/suit/storage/solgov/service/expeditionary/engineering
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/engineering/service)

/obj/item/clothing/suit/storage/solgov/service/expeditionary/engineering/command
	icon_state = "ecservice_officer"

/obj/item/clothing/suit/storage/solgov/service/expeditionary/supply
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/supply/service)

/obj/item/clothing/suit/storage/solgov/service/expeditionary/security
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/security/service)

/obj/item/clothing/suit/storage/solgov/service/expeditionary/security/command
	icon_state = "ecservice_officer"

/obj/item/clothing/suit/storage/solgov/service/expeditionary/service
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/service/service)

/obj/item/clothing/suit/storage/solgov/service/expeditionary/service/command
	icon_state = "ecservice_officer"

/obj/item/clothing/suit/storage/solgov/service/expeditionary/exploration
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/exploration/service)

/obj/item/clothing/suit/storage/solgov/service/expeditionary/exploration/command
	icon_state = "ecservice_officer"

/obj/item/clothing/suit/storage/solgov/service/expeditionary/command
	icon_state = "ecservice_officer"
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/command/service)


/obj/item/clothing/suit/storage/solgov/service/marine
	name = "marine coat"
	desc = "An SCG Marine Corps service coat. Green and undecorated."
	icon_state = "greenservice"
	item_state = "greenservice"

/obj/item/clothing/suit/storage/solgov/service/marine/medical
	name = "marine medical jacket"
	desc = "An SCG Marine Corps service coat. This one has blue markings."
	icon_state = "greenservice_med"
	item_state = "greenservice_med"

/obj/item/clothing/suit/storage/solgov/service/marine/medical/command
	name = "marine medical command jacket"
	desc = "An SCG Marine Corps service coat. This one has blue and gold markings."
	icon_state = "greenservice_medcom"
	item_state = "greenservice_medcom"

/obj/item/clothing/suit/storage/solgov/service/marine/engineering
	name = "marine engineering jacket"
	desc = "An SCG Marine Corps service coat. This one has orange markings."
	icon_state = "greenservice_eng"
	item_state = "greenservice_eng"

/obj/item/clothing/suit/storage/solgov/service/marine/engineering/command
	name = "marine engineering command jacket"
	desc = "An SCG Marine Corps service coat. This one has orange and gold markings."
	icon_state = "greenservice_engcom"
	item_state = "greenservice_engcom"

/obj/item/clothing/suit/storage/solgov/service/marine/supply
	name = "marine supply jacket"
	desc = "An SCG Marine Corps service coat. This one has brown markings."
	icon_state = "greenservice_sup"
	item_state = "greenservice_sup"

/obj/item/clothing/suit/storage/solgov/service/marine/security
	name = "marine security jacket"
	desc = "An SCG Marine Corps service coat. This one has red markings."
	icon_state = "greenservice_sec"
	item_state = "greenservice_sec"

/obj/item/clothing/suit/storage/solgov/service/marine/security/command
	name = "marine security command jacket"
	desc = "An SCG Marine Corps service coat. This one has red and gold markings."
	icon_state = "greenservice_seccom"
	item_state = "greenservice_seccom"

/obj/item/clothing/suit/storage/solgov/service/marine/service
	name = "marine service jacket"
	desc = "An SCG Marine Corps service coat. This one has green markings."
	icon_state = "greenservice_srv"
	item_state = "greenservice_srv"

/obj/item/clothing/suit/storage/solgov/service/marine/service/command
	name = "marine service command jacket"
	desc = "An SCG Marine Corps service coat. This one has green and gold markings."
	icon_state = "greenservice_srvcom"
	item_state = "greenservice_srvcom"

/obj/item/clothing/suit/storage/solgov/service/marine/exploration
	name = "marine exploration jacket"
	desc = "An SCG Marine Corps service coat. This one has purple markings."
	icon_state = "greenservice_exp"
	item_state = "greenservice_exp"

/obj/item/clothing/suit/storage/solgov/service/marine/exploration/command
	name = "marine exploration command jacket"
	desc = "An SCG Marine Corps service coat. This one has purple and gold markings."
	icon_state = "greenservice_expcom"
	item_state = "greenservice_expcom"

/obj/item/clothing/suit/storage/solgov/service/marine/command
	name = "marine command jacket"
	desc = "An SCG Marine Corps service coat. This one has gold markings."
	icon_state = "greenservice_com"
	item_state = "greenservice_com"

//Dress - murder me with a gun why are these 3 different types

/obj/item/clothing/suit/dress/solgov
	name = "dress jacket"
	desc = "A uniform dress jacket, fancy."
	icon_state = "greydress"
	item_state = "greydress"
	icon = 'maps/torch/icons/obj/solgov-suit.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/torch/icons/mob/solgov-suit.dmi')
	body_parts_covered = UPPER_TORSO|ARMS
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	allowed = list(/obj/item/weapon/tank/emergency,/obj/item/device/flashlight,/obj/item/clothing/head/soft,/obj/item/clothing/head/beret,/obj/item/device/radio,/obj/item/weapon/pen)
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL,ACCESSORY_SLOT_RANK)

/obj/item/clothing/suit/dress/solgov/expedition
	name = "expeditionary dress jacket"
	desc = "A silver and grey dress jacket belonging to the SCG Expeditionary Corps. Fashionable, for the 25th century at least."
	icon_state = "greydress"
	item_state = "greydress"

/obj/item/clothing/suit/dress/solgov/expedition/command
	name = "expeditionary officer's dress jacket"
	desc = "A gold and grey dress jacket belonging to the SCG Expeditionary Corps. The height of fashion."
	icon_state = "greydress_com"
	item_state = "greydress_com"

/obj/item/clothing/suit/storage/toggle/dress
	name = "clasped dress jacket"
	desc = "A uniform dress jacket with gold toggles."
	icon_state = "whitedress"
	//item_state = "labcoat"
	icon_open = "whitedress_open"
	icon_closed = "whitedress"
	icon = 'maps/torch/icons/obj/solgov-suit.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/torch/icons/mob/solgov-suit.dmi')
	blood_overlay_type = "coat"
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL,ACCESSORY_SLOT_RANK)

/obj/item/clothing/suit/storage/toggle/dress/fleet
	name = "fleet dress jacket"
	desc = "A crisp white SCG Fleet dress jacket with blue and gold accents. Don't get near pasta sauce or vox."

/obj/item/clothing/suit/storage/toggle/dress/fleet/command
	name = "fleet officer's dress jacket"
	desc = "A crisp white SCG Fleet dress jacket dripping with gold accents. So bright it's blinding."
	icon_state = "whitedress_com"
	//item_state = "labcoat"
	icon_open = "whitedress_com_open"
	icon_closed = "whitedress_com"
	blood_overlay_type = "coat"

/obj/item/clothing/suit/dress/solgov/marine
	name = "marine dress jacket"
	desc = "A tailored black SCG Marine Corps dress jacket with red trim. So sexy it hurts."
	icon_state = "blackdress"
	item_state = "blackdress"

/obj/item/clothing/suit/dress/solgov/marine/command
	name = "marine officer's dress jacket"
	desc = "A tailored black SCG Marine Corps dress jacket with gold trim. Smells like ceremony."
	icon_state = "blackdress_com"
	item_state = "blackdress_com"

//Misc

/obj/item/clothing/suit/storage/hooded/wintercoat/solgov
	name = "expeditionary winter coat"
	icon_state = "coatec"
	icon = 'maps/torch/icons/obj/solgov-suit.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/torch/icons/mob/solgov-suit.dmi')
	armor = list(melee = 25, bullet = 10, laser = 5, energy = 10, bomb = 20, bio = 0, rad = 10)
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA,ACCESSORY_SLOT_RANK)

/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/marine
	name = "marine winter coat"
	icon_state = "coatmc"
	armor = list(melee = 30, bullet = 10, laser = 10, energy = 15, bomb = 20, bio = 0, rad = 0)
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA,ACCESSORY_SLOT_RANK)

/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/fleet
	name = "fleet winter coat"
	icon_state = "coatfl"
	armor = list(melee = 20, bullet = 10, laser = 10, energy = 20, bomb = 20, bio = 0, rad = 10)
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)