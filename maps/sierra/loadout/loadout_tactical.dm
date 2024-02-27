/*********************
 tactical accessories
*********************/
/datum/gear/tactical/ubac
	display_name = "UBAC shirt selection"
	path = /obj/item/clothing/accessory/ubac
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/tactical/helm_covers
	allowed_roles = ARMORED_ROLES

/datum/gear/tactical/security_belt
	display_name = "security belt"
	path = /obj/item/storage/belt/security
	slot = slot_belt
	allowed_roles = ARMED_ROLES

/datum/gear/tactical/holster/New()
	allowed_roles = ARMED_ROLES
	allowed_roles += /datum/job/iaa
	..()

/datum/gear/tactical/holster/New()
	..()
	var/holsters = list()
	holsters += /obj/item/clothing/accessory/storage/holster
	holsters += /obj/item/clothing/accessory/storage/holster/armpit
	holsters += /obj/item/clothing/accessory/storage/holster/hip
	holsters += /obj/item/clothing/accessory/storage/holster/thigh
	holsters += /obj/item/clothing/accessory/storage/holster/waist
	gear_tweaks += new/datum/gear_tweak/path/specified_types_list(holsters)

/*
/datum/gear/tactical/pcarrier_press
	display_name = "journalist's plate carrier"
	path = /obj/item/clothing/suit/armor/pcarrier/light/press
	cost = 3
	allowed_roles = list("Journalist") //etc.broken
*/

/datum/gear/tactical/security_uniforms
	display_name = "security uniform"
	allowed_roles = SECURITY_ROLES
	path = /obj/item/clothing/under
	slot = slot_w_uniform

/datum/gear/tactical/security_uniforms/New()
	..()
	var/uniforms = list()
	uniforms +=	/obj/item/clothing/under/rank/security/corp/alt
	uniforms +=	/obj/item/clothing/under/rank/security/navyblue
	uniforms +=	/obj/item/clothing/under/rank/security/navyblue/alt
	gear_tweaks += new/datum/gear_tweak/path/specified_types_list(uniforms)

/datum/gear/tactical/bloodpatch
	display_name = "blood patch selection"
	path = /obj/item/clothing/accessory/armor_tag
	allowed_roles = ARMORED_ROLES

/datum/gear/tactical/bloodpatch/New()
	..()
	var/blatch = list()
	blatch["O+ blood patch"] = /obj/item/clothing/accessory/armor_tag/opos
	blatch["O- blood patch"] = /obj/item/clothing/accessory/armor_tag/oneg
	blatch["A+ blood patch"] = /obj/item/clothing/accessory/armor_tag/apos
	blatch["A- blood patch"] = /obj/item/clothing/accessory/armor_tag/aneg
	blatch["B+ blood patch"] = /obj/item/clothing/accessory/armor_tag/bpos
	blatch["B- blood patch"] = /obj/item/clothing/accessory/armor_tag/bneg
	blatch["AB+ blood patch"] = /obj/item/clothing/accessory/armor_tag/abpos
	blatch["AB- blood patch"] = /obj/item/clothing/accessory/armor_tag/abneg
	gear_tweaks += new/datum/gear_tweak/path(blatch)


/datum/gear/tactical/armor_pouches
	display_name = "armor pouches selection"
	path = /obj/item/clothing/accessory/storage/pouches
	allowed_roles = ARMORED_ROLES
	cost = 3

/datum/gear/tactical/armor_pouches/New()
	..()
	var/pouches = list()
	pouches["tan storage pouches"] = /obj/item/clothing/accessory/storage/pouches/tan
	pouches["navy storage pouches"] = /obj/item/clothing/accessory/storage/pouches/navy
	pouches["green storage pouches"] = /obj/item/clothing/accessory/storage/pouches/green
	pouches["blue storage pouches"] = /obj/item/clothing/accessory/storage/pouches/blue
	pouches["black storage pouches"] = /obj/item/clothing/accessory/storage/pouches
	gear_tweaks += new/datum/gear_tweak/path(pouches)

/datum/gear/tactical/large_pouches
	display_name = "large armor pouches selection"
	path = /obj/item/clothing/accessory/storage/pouches/large
	allowed_roles = ARMORED_ROLES
	cost = 6

/datum/gear/tactical/large_pouches/New()
	..()
	var/lpouches = list()
	lpouches["large tan storage pouches"] = /obj/item/clothing/accessory/storage/pouches/large/tan
	lpouches["large navy storage pouches"] = /obj/item/clothing/accessory/storage/pouches/large/navy
	lpouches["large green storage pouches"] = /obj/item/clothing/accessory/storage/pouches/large/green
	lpouches["large blue storage pouches"] = /obj/item/clothing/accessory/storage/pouches/large/blue
	lpouches["large black storage pouches"] = /obj/item/clothing/accessory/storage/pouches/large
	gear_tweaks += new/datum/gear_tweak/path(lpouches)


/datum/gear/tactical/armor_deco
	display_name = "armor tags selection"
	path = /obj/item/clothing/accessory/armor_tag
	allowed_roles = ARMORED_ROLES

/datum/gear/tactical/armor_deco/New()
	..()
	var/atags = list()
	atags["NTSF tag"] = /obj/item/clothing/accessory/armor_tag/nt
	atags["PCRC tag"] = /obj/item/clothing/accessory/armor_tag/pcrc
	atags["SAARE tag"] = /obj/item/clothing/accessory/armor_tag/saare
	atags["SCP tag"] = /obj/item/clothing/accessory/armor_tag/scp
	atags["ZPCI tag"] = /obj/item/clothing/accessory/armor_tag/zpci
	gear_tweaks += new/datum/gear_tweak/path(atags)

/datum/gear/tactical/press_tag
	display_name = "Press tag"
	path = /obj/item/clothing/accessory/armor_tag/press

/datum/gear/tactical/pcarrier
	display_name = "empty plate carriers selection"
	path = /obj/item/clothing/suit/armor/pcarrier
	cost = 1
	slot = slot_wear_suit
	allowed_roles = ARMORED_ROLES

/datum/gear/tactical/pcarrier/New()
	..()
	var/armor = list()
	armor["black plate carrier"]	= /obj/item/clothing/suit/armor/pcarrier
	armor["blue plate carrier"] 	= /obj/item/clothing/suit/armor/pcarrier/blue
	armor["navy plate carrier"] 	= /obj/item/clothing/suit/armor/pcarrier/navy
	armor["green plate carrier"] 	= /obj/item/clothing/suit/armor/pcarrier/green
	armor["tan plate carrier"] 		= /obj/item/clothing/suit/armor/pcarrier/tan
	gear_tweaks += new/datum/gear_tweak/path(armor)
