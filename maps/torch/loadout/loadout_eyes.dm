// Eyes
/datum/gear/eyes
	display_name = "eyepatch"
	path = /obj/item/clothing/glasses/eyepatch
	slot = slot_glasses
	sort_category = "Glasses and Eyewear"

/datum/gear/eyes/glasses
	display_name = "prescription glasses"
	path = /obj/item/clothing/glasses/regular

/datum/gear/eyes/fashionglasses
	display_name = "glasses"
	path = /obj/item/clothing/glasses
	allowed_roles = NON_MILITARY_ROLES

/datum/gear/eyes/fashionglasses/New()
	..()
	var/glasses = list()
	glasses["green glasses"] = /obj/item/clothing/glasses/gglasses
	glasses["hipster glasses"] = /obj/item/clothing/glasses/regular/hipster
	glasses["monocle"] = /obj/item/clothing/glasses/monocle
	glasses["scanning goggles"] = /obj/item/clothing/glasses/regular/scanners
	gear_tweaks += new/datum/gear_tweak/path(glasses)

/datum/gear/eyes/sciencegoggles
	display_name = "Science Goggles"
	path = /obj/item/clothing/glasses/science
	allowed_roles = RESEARCH_ROLES

/datum/gear/eyes/security
	display_name = "Security HUD"
	path = /obj/item/clothing/glasses/hud/security
	allowed_roles = SECURITY_ROLES

/datum/gear/eyes/security/prescription
	display_name = "Security HUD, prescription"
	path = /obj/item/clothing/glasses/hud/security/prescription
	allowed_roles = SECURITY_ROLES

/datum/gear/eyes/security/sunglasses
	display_name = "Security HUD Sunglasses"
	path = /obj/item/clothing/glasses/sunglasses/sechud
	allowed_roles = SECURITY_ROLES

/datum/gear/eyes/secaviators
	display_name = "Security HUD Aviators"
	path = /obj/item/clothing/glasses/sunglasses/sechud/toggle
	allowed_roles = SECURITY_ROLES

/datum/gear/eyes/medical
	display_name = "Medical HUD"
	path = /obj/item/clothing/glasses/hud/health
	allowed_roles = MEDICAL_ROLES

/datum/gear/eyes/medical/prescription
	display_name = "Medical HUD, prescription"
	path = /obj/item/clothing/glasses/hud/health/prescription
	allowed_roles = MEDICAL_ROLES

/datum/gear/eyes/meson
	display_name = "Meson Goggles"
	path = /obj/item/clothing/glasses/meson
	allowed_roles = list(/datum/job/chief_engineer, /datum/job/senior_engineer, /datum/job/engineer, /datum/job/engineer_contractor, /datum/job/mining, /datum/job/scientist_assistant, /datum/job/pathfinder, /datum/job/explorer)

/datum/gear/eyes/meson/prescription
	display_name = "Meson Goggles, prescription"
	path = /obj/item/clothing/glasses/meson/prescription
	allowed_roles = list(/datum/job/chief_engineer, /datum/job/senior_engineer, /datum/job/engineer, /datum/job/engineer_contractor, /datum/job/mining, /datum/job/scientist_assistant, /datum/job/pathfinder, /datum/job/explorer)

/datum/gear/eyes/material
	display_name = "Material Goggles"
	path = /obj/item/clothing/glasses/material
	allowed_roles = list(/datum/job/chief_engineer, /datum/job/senior_engineer, /datum/job/engineer, /datum/job/engineer_contractor, /datum/job/mining, /datum/job/scientist_assistant)

/datum/gear/eyes/shades/
	display_name = "sunglasses"
	path = /obj/item/clothing/glasses/sunglasses
	cost = 3

/datum/gear/eyes/shades/sunglasses
	display_name = "sunglasses, fat"
	path = /obj/item/clothing/glasses/sunglasses/big
	cost = 3

/datum/gear/eyes/shades/prescriptionsun
	display_name = "sunglasses, presciption"
	path = /obj/item/clothing/glasses/sunglasses/prescription
	cost = 3
