/obj/item/clothing/head/helmet/nt/blueshift
	name = "research division security helmet"
	desc = "A helmet with 'RESEARCH DIVISION SECURITY' printed on the back in red lettering."
	icon = 'mods/loadout_items/icons/obj_head.dmi'
	item_icons = list(slot_head_str = 'mods/loadout_items/icons/onmob_head.dmi')
	icon_state = "blueshift_helm"

/obj/item/clothing/suit/armor/vest/blueshift
	name = "research division armored vest"
	desc = "A synthetic armor vest. This one is marked with a hazard markings and 'RESEARCH DIVISION SECURITY' tag."
	icon = 'mods/loadout_items/icons/obj_suit.dmi'
	item_icons = list(slot_wear_suit_str = 'mods/loadout_items/icons/onmob_suit.dmi')
	icon_state = "blueshift_armor"

/*
Armor Patches, covers, ect
*/

/obj/item/clothing/accessory/armor/helmcover/scp_cover
	name = "SCP cover"
	desc = "A fabric cover for armored helmets. This one has SCP's colors."
	icon_override = 'mods/loadout_items/icons/obj_accessory.dmi'
	icon = 'mods/loadout_items/icons/obj_accessory.dmi'
	icon_state = "scp_cover"
	accessory_icons = list(slot_tie_str = 'mods/loadout_items/icons/onmob_accessory.dmi', slot_head_str = 'mods/loadout_items/icons/onmob_accessory.dmi')

/obj/item/clothing/accessory/armor/tag/scp
	name = "SCP tag"
	desc = "An armor tag with the words SECURITY CORPORATE PERSONAL printed in red lettering on it."
	icon_override = 'mods/loadout_items/icons/onmob_accessory.dmi'
	icon = 'mods/loadout_items/icons/obj_accessory.dmi'
	icon_state = "scp_tag"
	accessory_icons = list(slot_tie_str = 'mods/loadout_items/icons/onmob_accessory.dmi', slot_wear_suit_str = 'mods/loadout_items/icons/onmob_accessory.dmi')

/obj/item/clothing/accessory/armor/tag/zpci
	name = "\improper ZPCI tag"
	desc = "An armor tag with the words ZONE PROTECTION CONTROL INCORPORATED printed in cyan lettering on it."
	icon_state = "pcrctag"
