/obj/item/clothing/head/helmet/space/void/cosmic_cult
	name = "entropic headgear"
	desc = "This headpiece seems to extrude from the suit it's attached to as if the material is one single, contiguous whole."
	icon = 'icons/coscult/entropic-armor.dmi'
	icon_state = "icon-helmet"
	item_icons = list(
		slot_head_str = 'icons/coscult/entropic-armor.dmi',
	)
	item_state = "equipped-head"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	siemens_coefficient = 0.3
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_IPC)
	sprite_sheets = list(
		SPECIES_HUMAN = 'icons/coscult/entropic-armor.dmi',
		SPECIES_IPC = 'icons/coscult/entropic-armor.dmi',
		SPECIES_SKRELL = 'icons/coscult/entropic-armor-skrell.dmi',
		SPECIES_UNATHI = 'icons/coscult/entropic-armor-unathi.dmi',
	)
	light_overlay = "equipped-suit-light"

/obj/item/clothing/suit/space/void/cosmic_cult
	name = "entropic armor"
	desc = "An unsettling hardsuit, numbing to the touch. It pulses with a glow that makes you feel like you've forgotten something."
	icon = 'icons/coscult/entropic-armor.dmi'
	icon_state = "icon"
	item_icons = list(
		slot_wear_suit_str = 'icons/coscult/entropic-armor.dmi',
		slot_l_hand_str = 'icons/coscult/entropic-armor.dmi',
		slot_r_hand_str = 'icons/coscult/entropic-armor.dmi',
	)
	item_state_slots = list(
		slot_wear_suit_str = "equipped-suit",
		slot_l_hand_str = "inhand-left",
		slot_r_hand_str = "inhand-right",
	)
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.3
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_IPC)
	sprite_sheets = list(
		SPECIES_SKRELL = 'icons/coscult/entropic-armor-skrell.dmi',
		SPECIES_UNATHI = 'icons/coscult/entropic-armor-unathi.dmi',
	)

/obj/item/clothing/suit/space/void/cosmic_cult/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/cosmic_cult
	tank = /obj/item/tank/oxygen
	item_flags = ITEM_FLAG_THICKMATERIAL | ITEM_FLAG_INVALID_FOR_CHAMELEON
