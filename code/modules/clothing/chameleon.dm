/obj/item/clothing/under/chameleon
	name = "jumpsuit"
	icon_state = "jumpsuit"
	item_state = "jumpsuit"
	worn_state = "jumpsuit"
	desc = "It's a plain jumpsuit. It seems to have a small dial on the wrist."
	origin_tech = list(TECH_ESOTERIC = 3)
	item_flags = ITEM_FLAG_INVALID_FOR_CHAMELEON

/obj/item/clothing/under/chameleon/Initialize()
	. = ..()
	set_extension(src,/datum/extension/chameleon/clothing)

/obj/item/clothing/head/chameleon
	name = "cap"
	icon_state = "greysoft"
	desc = "It looks like a plain hat, but upon closer inspection, there's an advanced holographic array installed inside. It seems to have a small dial inside."
	origin_tech = list(TECH_ESOTERIC = 3)
	body_parts_covered = 0
	item_flags = ITEM_FLAG_INVALID_FOR_CHAMELEON

/obj/item/clothing/head/chameleon/Initialize()
	. = ..()
	set_extension(src,/datum/extension/chameleon/clothing)

/obj/item/clothing/suit/chameleon
	name = "armor"
	icon_state = "armor"
	item_state = "armor"
	desc = "It appears to be a vest of standard armor, except this is embedded with a hidden holographic cloaker, allowing it to change it's appearance, but offering no protection.. It seems to have a small dial inside."
	origin_tech = list(TECH_ESOTERIC = 3)
	item_flags = ITEM_FLAG_INVALID_FOR_CHAMELEON

/obj/item/clothing/suit/chameleon/Initialize()
	. = ..()
	set_extension(src,/datum/extension/chameleon/clothing)

/obj/item/clothing/shoes/chameleon
	name = "shoes"
	icon_state = "black"
	item_state = "black"
	desc = "They're comfy black shoes, with clever cloaking technology built in. It seems to have a small dial on the back of each shoe."
	origin_tech = list(TECH_ESOTERIC = 3)
	item_flags = ITEM_FLAG_INVALID_FOR_CHAMELEON

/obj/item/clothing/shoes/chameleon/Initialize()
	. = ..()
	set_extension(src,/datum/extension/chameleon/clothing)

/obj/item/storage/backpack/chameleon
	name = "backpack"
	icon_state = "backpack"
	item_state = "backpack"
	desc = "A backpack outfitted with cloaking tech. It seems to have a small dial inside, kept away from the storage."
	origin_tech = list(TECH_ESOTERIC = 3)
	item_flags = ITEM_FLAG_INVALID_FOR_CHAMELEON

/obj/item/storage/backpack/chameleon/Initialize()
	. = ..()
	set_extension(src,/datum/extension/chameleon/backpack,/obj/item/storage/backpack)

/obj/item/clothing/gloves/chameleon
	name = "gloves"
	icon_state = "black"
	item_state = "bgloves"
	desc = "It looks like a pair of gloves, but it seems to have a small dial inside."
	origin_tech = list(TECH_ESOTERIC = 3)
	item_flags = ITEM_FLAG_INVALID_FOR_CHAMELEON

/obj/item/clothing/gloves/chameleon/Initialize()
	. = ..()
	set_extension(src,/datum/extension/chameleon/clothing)

/obj/item/clothing/mask/chameleon
	name = "mask"
	icon_state = "fullgas"
	item_state = "gas_alt"
	desc = "It looks like a plain gask mask, but on closer inspection, it seems to have a small dial inside."
	origin_tech = list(TECH_ESOTERIC = 3)
	item_flags = ITEM_FLAG_INVALID_FOR_CHAMELEON

/obj/item/clothing/mask/chameleon/Initialize()
	. = ..()
	set_extension(src,/datum/extension/chameleon/clothing,/obj/item/clothing/mask)

/obj/item/clothing/glasses/chameleon
	name = "goggles"
	icon_state = "meson"
	item_state = "glasses"
	desc = "It looks like a plain set of mesons, but on closer inspection, it seems to have a small dial inside."
	origin_tech = list(TECH_ESOTERIC = 3)
	item_flags = ITEM_FLAG_INVALID_FOR_CHAMELEON

/obj/item/clothing/glasses/chameleon/Initialize()
	. = ..()
	set_extension(src,/datum/extension/chameleon/clothing)

/obj/item/device/radio/headset/chameleon
	name = "radio headset"
	icon_state = "headset"
	item_state = "headset"
	desc = "An updated, modular intercom that fits over the head. This one seems to have a small dial on it."
	origin_tech = list(TECH_ESOTERIC = 3)
	item_flags = ITEM_FLAG_INVALID_FOR_CHAMELEON

/obj/item/device/radio/headset/chameleon/Initialize()
	. = ..()
	set_extension(src,/datum/extension/chameleon/headset)

/obj/item/clothing/accessory/chameleon
	name = "tie"
	icon_state = "tie"
	item_state = ""
	desc = "A neosilk clip-on tie. It seems to have a small dial on its back."
	origin_tech = list(TECH_ESOTERIC = 3)
	item_flags = ITEM_FLAG_INVALID_FOR_CHAMELEON

/obj/item/clothing/accessory/chameleon/Initialize()
	. = ..()
	set_extension(src,/datum/extension/chameleon/clothing/accessory)

/obj/item/gun/energy/chameleon
	name = "chameleon gun"
	desc = "A hologram projector in the shape of a gun. There is a dial on the side to change the gun's disguise."
	icon = 'icons/obj/guns/revolvers.dmi'
	icon_state = "revolver"
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ESOTERIC = 8)
	item_flags = ITEM_FLAG_INVALID_FOR_CHAMELEON
	matter = list()

	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	projectile_type = /obj/item/projectile/chameleon
	charge_meter = 0
	charge_cost = 20 //uses next to no power, since it's just holograms
	max_shots = 50

/obj/item/gun/energy/chameleon/Initialize()
	. = ..()
	set_extension(src,/datum/extension/chameleon/gun)
