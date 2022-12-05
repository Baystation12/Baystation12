/*********************
 tactical accessories
*********************/
/datum/gear/tactical/ubac
	display_name = "UBAC shirt selection"
	path = /obj/item/clothing/accessory/ubac
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/tactical/armor_deco
	allowed_roles = list(/datum/job/hos, /datum/job/warden, /datum/job/detective, /datum/job/officer)

/datum/gear/tactical/helm_covers
	allowed_roles = ARMORED_ROLES

/datum/gear/tactical/armor_pouches
	allowed_roles = ARMORED_ROLES

/datum/gear/tactical/large_pouches
	allowed_roles = ARMORED_ROLES

/datum/gear/tactical/tacticool

/datum/gear/tactical/bloodpatch
	allowed_roles = ARMED_ROLES

/datum/gear/tactical/security_belt
	display_name = "security belt"
	path = /obj/item/storage/belt/security
	slot = slot_belt
	allowed_roles = ARMED_ROLES

/datum/gear/tactical/holster/New()
	allowed_roles = ARMED_ROLES
	allowed_roles += /datum/job/iaa
	..()

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

/datum/gear/tactical/camo_inf
	display_name = "camo uniform - colorable"
	path = /obj/item/clothing/under/grayson
	slot = slot_w_uniform
	flags = GEAR_HAS_COLOR_SELECTION
