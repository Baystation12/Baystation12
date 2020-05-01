
/obj/item/clothing/under/gao_battlejumper
	name = "Gao Battlejumper Uniform"
	desc = "Feetfirst into hell, outer colonies style."
	icon = 'code/modules/halo/factions/npc_factions/gear/gao.dmi'
	icon_override = 'code/modules/halo/factions/npc_factions/gear/gao.dmi'
	icon_state = "Gao Battle Jumper Jumpsuit"
	item_state = "Gao Battle Jumper Jumpsuit"
	worn_state = "Gao Battle Jumper Jumpsuit"
	//item_state_slots = list(slot_l_hand_str = "commando_uniform", slot_r_hand_str = "commando_uniform")

/obj/item/clothing/head/helmet/gao_battlejumper
	name = "Gao Battlejumper Helmet"
	desc = "Feetfirst into hell, outer colonies style."
	icon = 'code/modules/halo/factions/npc_factions/gear/gao.dmi'
	icon_override = 'code/modules/halo/factions/npc_factions/gear/gao.dmi'
	item_state = "Gao Battle Jumper Helmet"
	icon_state = "Gao Battle Jumper Helmet"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD|FACE
	flags_inv = BLOCKHAIR
	armor = list(melee = 60, bullet = 35, laser = 25,energy = 25, bomb = 20, bio = 50, rad = 25)
	integrated_hud = /obj/item/clothing/glasses/hud/tactical/innie

/obj/item/clothing/suit/armor/special/gao_battlejumper
	name = "Gao Battlejumper Armour"
	desc = "Feetfirst into hell, outer colonies style."
	icon = 'code/modules/halo/factions/npc_factions/gear/gao.dmi'
	icon_override = 'code/modules/halo/factions/npc_factions/gear/gao.dmi'
	item_state = "Gao Battle Jumper Armour"
	icon_state = "Gao Battle Jumper Armour"
	blood_overlay_type = "armor"
	armor = list(melee = 55, bullet = 50, laser = 55, energy = 45, bomb = 40, bio = 50, rad = 25)
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	armor_thickness = 20
	item_flags = THICKMATERIAL

/obj/item/clothing/shoes/magboots/gao_battlejumper
	name = "Gao Battlejumper Magboots"
	desc = "Feetfirst into hell, outer colonies style."
	icon = 'code/modules/halo/factions/npc_factions/gear/gao.dmi'
	icon_override = 'code/modules/halo/factions/npc_factions/gear/gao.dmi'
	icon_state = "Gao Battle Jumper Boots0"
	icon_base = "Gao Battle Jumper Boots"
	item_state = "Gao Battle Jumper Boots1"
	can_hold_knife = 1
	force = 5

/obj/item/clothing/gloves/gao_battlejumper
	name = "Gao Battlejumper Gloves"
	desc = "Feetfirst into hell, outer colonies style."
	icon = 'code/modules/halo/factions/npc_factions/gear/gao.dmi'
	icon_override = 'code/modules/halo/factions/npc_factions/gear/gao.dmi'
	item_state = "Gao Battle Jumper Gloves"
	icon_state = "Gao Battle Jumper Gloves"
	force = 5
	armor = list(melee = 80, bullet = 60, laser = 60,energy = 25, bomb = 50, bio = 10, rad = 0)
