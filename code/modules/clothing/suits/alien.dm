//Unathi clothing.

/obj/item/clothing/suit/unathi/robe
	name = "roughspun robes"
	desc = "A traditional Unathi garment."
	icon_state = "robe-unathi"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS

/obj/item/clothing/suit/unathi/mantle
	name = "hide mantle"
	desc = "A rather grisly selection of cured hides and skin, sewn together to form a ragged mantle."
	icon_state = "mantle-unathi"
	body_parts_covered = UPPER_TORSO

//Misc Xeno clothing.

/obj/item/clothing/suit/xeno/furs
	name = "heavy furs"
	desc = "A traditional Zhan-Khazan garment."
	icon_state = "zhan_furs"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS

/obj/item/clothing/head/xeno/scarf
	name = "headscarf"
	desc = "A scarf of coarse fabric. Seems to have ear-holes."
	icon_state = "zhan_scarf"
	body_parts_covered = HEAD|FACE

/obj/item/clothing/shoes/sandal/xeno/caligae
	name = "caligae"
	desc = "A pair of sandals modelled after the ancient Roman caligae."
	icon_state = "caligae"
	item_state = "caligae"
	body_parts_covered = FEET|LEGS

/obj/item/clothing/shoes/sandal/xeno/caligae/white
	desc = "A pair of sandals modelled after the ancient Roman caligae. This one has a white covering."
	icon_state = "whitecaligae"
	item_state = "whitecaligae"

/obj/item/clothing/shoes/sandal/xeno/caligae/grey
	desc = "A pair of sandals modelled after the ancient Roman caligae. This one has a grey covering."
	icon_state = "greycaligae"
	item_state = "greycaligae"

/obj/item/clothing/shoes/sandal/xeno/caligae/black
	desc = "A pair of sandals modelled after the ancient Roman caligae. This one has a black covering."
	icon_state = "blackcaligae"
	item_state = "blackcaligae"

/obj/item/clothing/accessory/shouldercape
	name = "shoulder cape"
	desc = "A simple shoulder cape."
	icon_state = "gruntcape"
	slot = ACCESSORY_SLOT_INSIGNIA // Adding again in case we want to change it in the future.

/obj/item/clothing/accessory/shouldercape/grunt
	name = "cape"
	desc = "A simple looking cape with a couple of runes woven into the fabric."
	icon_state = "gruntcape" // Again, just in case it is changed.

/obj/item/clothing/accessory/shouldercape/officer
	name = "officer's cape"
	desc = "A decorated cape. Runed patterns have been woven into the fabric."
	icon_state = "officercape"

/obj/item/clothing/accessory/shouldercape/command
	name = "command cape"
	desc = "A heavily decorated cape with rank emblems on the shoulders signifying prestige. An ornate runed design has been woven into the fabric of it"
	icon_state = "commandcape"

/obj/item/clothing/accessory/shouldercape/general
	name = "general's cape"
	desc = "An extremely decorated cape with an intricately runed design has been woven into the fabric of this cape with great care."
	icon_state = "leadercape"

//Voxclothing

/obj/item/clothing/suit/armor/vox_scrap
	name = "rusted metal armor"
	desc = "A hodgepodge of various pieces of metal scrapped together into a rudimentary vox-shaped piece of armor."
	allowed = list(/obj/item/weapon/gun, /obj/item/weapon/tank)
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH, 
		bullet = ARMOR_BALLISTIC_PISTOL, 
		laser = ARMOR_LASER_MINOR,
		bomb = ARMOR_BOMB_PADDED) //Higher melee armor versus lower everything else.
	icon_state = "vox-scrap"
	body_parts_covered = UPPER_TORSO|ARMS|LOWER_TORSO|LEGS
	species_restricted = list(SPECIES_VOX, SPECIES_VOX_ARMALIS)
	siemens_coefficient = 1 //Its literally metal
