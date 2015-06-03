// Machine Hardsuits. Yee.
/obj/item/clothing/head/helmet/space/void/machine
	name = "Liquid cooled helmet"
	desc = "Looks almost like a useless metal box. Does a head even fit in this thing?"
	armor = list(melee = 40, bullet = 5, laser = 20,energy = 5, bomb = 35, bio = 100, rad = 50)
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	species_restricted = list("Machine")
	slowdown = 1

/obj/item/clothing/head/helmet/space/void/machine/blue
	icon_state = "void0-ipcblue"  //Sprites by Miss Teddybears
	item_state = "void0-ipcblue"
	item_color = "ipcblue"

/obj/item/clothing/head/helmet/space/void/machine/syndie
	icon_state = "void0-ipcsyndie"  //Sprites by Miss Teddybears, Modified by 5crownix
	item_state = "void0-ipcsyndie"
	item_color = "ipcsyndie"

/obj/item/clothing/head/helmet/space/void/machine/miner
	icon_state = "void0-ipcminer"  //Sprites by Miss Teddybears, Modified by 5crownix
	item_state = "void0-ipcminer"
	item_color = "ipcminer"

/obj/item/clothing/suit/space/void/machine
	name = "Liquid cooled hardsuit"
	desc = "A heavy chassis with ports lining the inside. Would not recommend being inside if you don't have anywhere to plug in."
	armor = list(melee = 40, bullet = 5, laser = 20,energy = 5, bomb = 35, bio = 100, rad = 50)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/weapon/storage/bag/ore,/obj/item/device/t_scanner,/obj/item/weapon/pickaxe, /obj/item/weapon/rcd)
	heat_protection = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	species_restricted = list("Machine")
	slowdown = 1

/obj/item/clothing/suit/space/void/machine/blue
	icon_state = "void-ipcblue"  //Sprites by Miss Teddybears
	item_state = "void-ipcblue"

/obj/item/clothing/suit/space/void/machine/syndie
	icon_state = "void-ipcsyndie"  //Sprites by Miss Teddybears, Modified by 5crownix
	item_state = "void-ipcsyndie"

/obj/item/clothing/suit/space/void/machine/miner
	icon_state = "void-ipcminer"  //Sprites by Miss Teddybears, Modified by 5crownix
	item_state = "void-ipcminer"

//Custom Race Hardsuit
/obj/item/clothing/head/helmet/space/void/merc/Jamie
	name = "Jamie's Helmet"
	desc = "A special helmet that protects against hazardous, low pressure environments. Has radiation shielding. This one doesn't look like it was made for humans, it has the words Jamie scratched on the back."
	icon_state = "rig0-jamie"
	item_state = "rig0-jamie"
	item_color = "jamie" //Determines used sprites: rig[on]-[color] and rig[on]-[color]2 (lying down sprite)
	icon_action_button = "action_hardhat"
	armor = list(melee = 40, bullet = 5, laser = 20,energy = 5, bomb = 35, bio = 100, rad = 80)
	species_restricted = list("Avisaran")

/obj/item/clothing/suit/space/void/merc/Jamie
	name = "Jamie's Hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has radiation shielding. This one doesn't look like it was made for humans, it has the words Jamie scratched on the back. It has two large slits for wings to be put through."
	icon_state = "rig-jamie"
	item_state = "rig-jamie"
	armor = list(melee = 40, bullet = 5, laser = 20,energy = 5, bomb = 35, bio = 100, rad = 80)
	species_restricted = list("Avisaran")