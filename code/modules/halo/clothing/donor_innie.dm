#define URF_HAND 'code/modules/halo/clothing/head.dmi'
#define URF_OVERRIDE 'code/modules/halo/clothing/urf_commando.dmi'

////////eluxor\\\\\\\\

//URFC

/obj/item/clothing/under/urfc_jumpsuit/eluxor
	name = "SOE Commando uniform"
	desc = "Standard issue SOE Commando uniform, more badass than that, you die."
	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_state = "harun_clothes"
	item_state = "harun_clothes"
	worn_state = "harun_clothes"

/obj/item/clothing/head/helmet/urfccommander/eluxor
	name = "Harun's Turban"
	desc = "A turban made of some kind of resistant material, it has an emblem with an Eagle and a fist on the front."
	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	item_state = "harun_turban"
	icon_state = "harun_turban_obj"

/obj/item/clothing/suit/armor/special/urfc/eluxor
	name = "Harun's Custom Armor"
	desc = "A custom made armorset with a cape included, clearly made by an armorsmisth in a very rough and old fashioned way. Clearly made by the Khoros Raiders."
	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	item_state = "harun_armor"
	icon_state = "harun_armor_obj"
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'

/obj/item/clothing/shoes/magboots/urfc/eluxor
	name = "SOE Magboots"
	desc = "Experimental black magnetic boots, used to ensure the user is safely attached to any surfaces during extra-vehicular operations. They're large enough to be worn over other footwear."
	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_state = "harun_boots_obj0"
	icon_base = "harun_boots_obj"
	item_state = "harun_boots"

/obj/item/clothing/gloves/soegloves/urfc/eluxor
	name = "SOE Gloves"
	desc = "These  gloves are somewhat fire and impact-resistant."
	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	item_state = "harun_gloves"
	icon_state = "harun_gloves_obj"

/obj/item/clothing/mask/gas/soebalaclava/eluxor
	name = "SOE Balaclava"
	desc = "Designed to both hide identities and keep your face comfy and warm, a mask that can be connected to an air supply. Filters harmful gases from the air."
	icon_state = "harun_balaclava"
	item_state = "harun_balaclava"

/obj/item/weapon/storage/box/large/donator/eluxor
	startswith = list(/obj/item/clothing/under/urfc_jumpsuit/eluxor,
					/obj/item/clothing/head/helmet/urfccommander/eluxor,
					/obj/item/clothing/suit/armor/special/urfc/eluxor,
					/obj/item/clothing/shoes/magboots/urfc/eluxor,
					/obj/item/clothing/gloves/soegloves/urfc/eluxor,
					/obj/item/clothing/mask/gas/soebalaclava/eluxor,
					)
	can_hold = list(/obj/item/clothing/under/urfc_jumpsuit/eluxor,
					/obj/item/clothing/head/helmet/urfccommander/eluxor,
					/obj/item/clothing/suit/armor/special/urfc/eluxor,
					/obj/item/clothing/shoes/magboots/urfc/eluxor,
					/obj/item/clothing/gloves/soegloves/urfc/eluxor,
					/obj/item/clothing/mask/gas/soebalaclava/eluxor,
					)

/decl/hierarchy/outfit/eluxor
	name = "eluxor - urfc"
	uniform = /obj/item/clothing/under/urfc_jumpsuit/eluxor
	head = /obj/item/clothing/head/helmet/urfccommander/eluxor
	suit = /obj/item/clothing/suit/armor/special/urfc/eluxor
	gloves = /obj/item/clothing/gloves/soegloves/urfc/eluxor
	shoes = /obj/item/clothing/shoes/magboots/urfc/eluxor
	mask = /obj/item/clothing/mask/gas/soebalaclava/eluxor


////////MCLOVIN\\\\\\\\

//URFC


/obj/item/clothing/head/helmet/urfc/mclovin
	name = "Jaguar Helmet"

	item_state = "mclovin-jaguar_worn"
	icon_state = "mclovin-jaguar_helmet"

/obj/item/clothing/suit/armor/special/urfc/mclovin
	name = "Jaguar Armour"

	item_state = "mclovin-jaguar_armour_worn"
	icon_state = "mclovin-jaguar_armour_obj"

/obj/item/clothing/head/helmet/zeal/mclovin
	name = "Eagle Helmet"
	desc = "A heavily modified helmet resembling an Eagle"

	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	item_state = "mclovin-eagle_worn"
	icon_state = "mclovin-eagle_helmet"

/obj/item/clothing/suit/justice/zeal/mclovin/New()
	. = ..()
	slowdown_per_slot[slot_wear_suit] = 1

/obj/item/clothing/suit/justice/zeal/mclovin
	name = "Eagle Armour"
	desc = "A heavily modified piece of armour resembling an Eagle"

	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	item_state = "mclovin-eagle_armour_worn"
	icon_state = "mclovin-eagle_armour_obj"

/obj/item/weapon/material/machete/mclovin
	name = "Aztec Sword"
	desc = "An Aztec sword used to spill the blood of a warrior's enemy."
	icon_state = "mclovin-machete_obj"
	item_state = "mclovin-machete"
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)

/obj/item/clothing/suit/armor/special/urfc/aztec
	name = "Aztec Armour"

	item_state = "aztecpack_worn"
	icon_state = "aztecpack_obj"

/obj/item/clothing/shoes/magboots/urfc/aztec
	name = "Aztec Boots"

	item_state = "aztecboots_worn"
	icon_state = "scpboots_obj"

/obj/item/clothing/gloves/soegloves/urfc/aztec
	name = "Aztec Gloves"

	item_state = "aztecgloves_worn"
	icon_state = "scpgloves_obj"

/decl/hierarchy/outfit/mclovin_urfc
	name = "mclovin - urfc"
	head = /obj/item/clothing/head/helmet/urfc/mclovin
	suit = /obj/item/clothing/suit/armor/special/urfc/mclovin
	l_hand = /obj/item/weapon/material/machete/mclovin

/obj/item/weapon/storage/box/large/donator/mclovin_urfc
	startswith = list(/obj/item/clothing/head/helmet/urfc/mclovin,
					/obj/item/clothing/suit/armor/special/urfc/mclovin,
					/obj/item/weapon/material/machete/mclovin
					)
	can_hold = list(/obj/item/clothing/head/helmet/urfc/mclovin,
					/obj/item/clothing/suit/armor/special/urfc/mclovin,
					/obj/item/weapon/material/machete/mclovin
					)

/decl/hierarchy/outfit/mclovin_zeal
	name = "mclovin - zeal"
	head = /obj/item/clothing/head/helmet/zeal/mclovin
	suit = /obj/item/clothing/suit/justice/zeal/mclovin
	l_hand = /obj/item/weapon/material/machete/mclovin

/obj/item/weapon/storage/box/large/donator/mclovin_zeal
	startswith = list(/obj/item/clothing/head/helmet/zeal/mclovin,
					/obj/item/clothing/suit/justice/zeal/mclovin,
					/obj/item/weapon/material/machete/mclovin
					)
	can_hold = list(/obj/item/clothing/head/helmet/zeal/mclovin,
					/obj/item/clothing/suit/justice/zeal/mclovin,
					/obj/item/weapon/material/machete/mclovin
					)

/decl/hierarchy/outfit/mclovin_aztec
	name = "mclovin - aztec"
	head = /obj/item/clothing/head/helmet/zeal/mclovin
	suit = /obj/item/clothing/suit/justice/zeal/mclovin
	l_hand = /obj/item/weapon/material/machete/mclovin

/obj/item/weapon/storage/box/large/donator/aztec
	startswith = list(/obj/item/clothing/suit/armor/special/urfc/aztec,
					/obj/item/clothing/shoes/magboots/urfc/aztec,
					/obj/item/clothing/gloves/soegloves/urfc/aztec
					)
	can_hold = list(/obj/item/clothing/suit/armor/special/urfc/aztec,
					/obj/item/clothing/shoes/magboots/urfc/aztec,
					/obj/item/clothing/gloves/soegloves/urfc/aztec
					)


////////PANTAS\\\\\\\\

//URFC


/obj/item/clothing/head/helmet/urfc/pantas
	name = "Darko's SoE Combat Engineer Helmet"
	desc = "A simple helmet. Despite the old age, a lot of work has been put into adding additional armor and refining the base processes. It's quite heavy, but a lot of soft material has been added to the inside to make the metal more comfy. Outdated, but can be expected in combat engagements to perform on par with modern equipment, due to the extensive modifications."
	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	item_state = "pantas_soe_helmet_worn"
	icon_state = "pantas_soe_helmet_obj"
	item_state_slots = list(slot_l_hand_str = "pantas_soe_helmet_worn", slot_r_hand_str = "pantas_soe_helmet_worn")

/obj/item/clothing/suit/armor/special/urfc/pantas
	name = "Darko's SoE Combat Engineer Armor"
	desc = "A bulletproof vest. Filled with pouches and storage compartments, while still keeping a scary amount of both mobility and protection. An ideal collage of the strengths of the URF, but with the added protection found only in high tier UNSC equipment. It's quite comfy, probably won't last long in space."
	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	item_state = "pantas_soe_armor_worn"
	icon_state = "pantas_soe_armor_obj"
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	item_state_slots = list(slot_l_hand_str = "pantas_soe_armor_worn", slot_r_hand_str = "pantas_soe_armor_worn")

/obj/item/clothing/head/helmet/soe/pantas
	name = "SOE Venerator Helmet"
	desc = "Non-Standard issue short-EVA capable helmet issued to commandos."
	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	item_state = "pantas_soe_space_helmet_worn"
	icon_state = "pantas_soe_space_helmet_obj"
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	item_state_slots = list(slot_l_hand_str = "pantas_soe_space_helmet_worn", slot_r_hand_str = "pantas_soe_space_helmet_worn")

obj/item/clothing/suit/armor/special/soe/pantas
	name = "SOE Venerator Armor"
	desc = "Heavyweight, somewhat durable armour issued to commandos for increased survivability in space."
	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	item_state = "pantas_soe_spacesuit_worn"
	icon_state = "pantas_soe_spacesuit_obj"
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	item_state_slots = list(slot_l_hand_str = "pantas_soe_spacesuit_worn", slot_r_hand_str = "pantas_soe_spacesuit_worn")

/obj/item/weapon/material/machete/pantascmdo
	name = "Judgement of Eridanus"
	desc = "A Holy-Looking sword used to Judge the enemies of Eridanus"
	icon_state = "pantascmdo-machete_obj"
	item_state = "pantascmdo-machete"
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)

/obj/item/weapon/gun/projectile/br85/pantasma3
	name = "Ancient AK-47"
	desc = "An ancient weapon used in forgettable times. How does it even still work?"
	icon_state = "pantasAK47"
	item_state = "pantasAK47"
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)

/obj/item/weapon/gun/projectile/br85/pantasma3/update_icon()
	. = ..()
	if(ammo_magazine)
		icon_state = "pantasAK47"
	else
		icon_state = "pantasAK47_unloaded"

/obj/item/weapon/tank/jetpack/void/urfc/pantas
	icon_state = "pantas_soe_airtank_obj"
	item_state = "pantas_soe_airtank_worn"

/obj/item/weapon/storage/box/large/donator/pantas_urfc
	startswith = list(/obj/item/clothing/head/helmet/urfc/pantas,
					/obj/item/clothing/suit/armor/special/urfc/pantas,
					/obj/item/clothing/head/helmet/soe/pantas,
					/obj/item/clothing/suit/armor/special/soe/pantas,
					/obj/item/weapon/material/machete/pantascmdo,
					/obj/item/weapon/gun/projectile/br85/pantasma3,
					/obj/item/weapon/tank/jetpack/void/urfc/pantas
					)
	can_hold = list(/obj/item/clothing/head/helmet/urfc/pantas,
					/obj/item/clothing/suit/armor/special/urfc/pantas,
					/obj/item/clothing/head/helmet/soe/pantas,
					/obj/item/clothing/suit/armor/special/soe/pantas,
					/obj/item/weapon/material/machete/pantascmdo,
					/obj/item/weapon/gun/projectile/br85/pantasma3,
					/obj/item/weapon/tank/jetpack/void/urfc/pantas
					)

/decl/hierarchy/outfit/pantas_urfc
	name = "pantas - urfc"
	head = /obj/item/clothing/head/helmet/urfc/pantas
	suit = /obj/item/clothing/suit/armor/special/urfc/pantas
	l_hand = /obj/item/weapon/material/machete/pantascmdo
	r_hand = /obj/item/weapon/gun/projectile/br85/pantasma3

/decl/hierarchy/outfit/pantas_soe
	name = "pantas - soe"
	head = /obj/item/clothing/head/helmet/soe/pantas
	suit = /obj/item/clothing/suit/armor/special/urfc/pantas
	l_hand = /obj/item/weapon/material/machete/pantascmdo
	r_hand = /obj/item/weapon/gun/projectile/br85/pantasma3
	back = /obj/item/weapon/tank/jetpack/void/urfc/pantas


//Socks URFC

/obj/item/clothing/head/helmet/urfc/socks
	name = "H34D Dome Protector (TEXUS)"

	item_state = "socks-helmet_worn"
	icon_state = "socks-helmet_obj"

/obj/item/clothing/suit/armor/special/urfc/socks
	name = "I25B Heavy Chest Rig (TEXUS)"

	item_state = "socks-armor_worn"
	icon_state = "socks-armor_obj"

/obj/item/clothing/under/urfc_jumpsuit/socks
	name = "Eridanus Uniform (TEXUS)"

	item_state = "socks-jumpsuit_worn"
	icon_state = "socks-jumpsuit_obj"

/obj/item/clothing/shoes/magboots/urfc/socks
	name = "F76F Mag Boots (TEXUS)"

	item_state = "socks-boots_worn"
	icon_state = "socks-boots_obj"

/obj/item/weapon/storage/box/large/donator/socks
	startswith = list(/obj/item/clothing/head/helmet/urfc/socks,
					/obj/item/clothing/suit/armor/special/urfc/socks,
					/obj/item/clothing/under/urfc_jumpsuit/socks,
					/obj/item/clothing/shoes/magboots/urfc/socks
					)
	can_hold = list(/obj/item/clothing/head/helmet/urfc/socks,
					/obj/item/clothing/suit/armor/special/urfc/socks,
					/obj/item/clothing/under/urfc_jumpsuit/socks,
					/obj/item/clothing/shoes/magboots/urfc/socks
					)

/decl/hierarchy/outfit/socks_urfc
	name = "socks - URFC"
	uniform = /obj/item/clothing/under/urfc_jumpsuit/socks
	shoes = /obj/item/clothing/shoes/magboots/urfc/socks
	head = /obj/item/clothing/head/helmet/urfc/socks
	suit = /obj/item/clothing/suit/armor/special/urfc/socks

#undef URF_HAND
#undef URF_OVERRIDE