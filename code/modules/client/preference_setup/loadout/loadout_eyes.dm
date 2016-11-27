// Eyes
/datum/gear/eyes
	display_name = "eyepatch"
	path = /obj/item/clothing/glasses/eyepatch
	slot = slot_glasses
	sort_category = "Glasses and Eyewear"

/datum/gear/eyes/glasses
	display_name = "glasses"
	path = /obj/item/clothing/glasses/regular

/datum/gear/eyes/glasses/New()
	..()
	var/glasses = list()
	glasses["prescription glasses"] = /obj/item/clothing/glasses/regular
	glasses["green glasses"] = /obj/item/clothing/glasses/gglasses
	glasses["hipster glasses"] = /obj/item/clothing/glasses/regular/hipster
	glasses["monocle"] = /obj/item/clothing/glasses/monocle
	glasses["scanning goggles"] = /obj/item/clothing/glasses/regular/scanners
	gear_tweaks += new/datum/gear_tweak/path(glasses)

/datum/gear/eyes/sciencegoggles
	display_name = "Science Goggles"
	path = /obj/item/clothing/glasses/science

/datum/gear/eyes/security
	display_name = "security HUD"
	path = /obj/item/clothing/glasses/hud/security
	allowed_roles = list("Security Officer","Head of Security","Warden","Detective")

/datum/gear/eyes/security/prescription
	display_name = "Security HUD, prescription"
	path = /obj/item/clothing/glasses/hud/security/prescription
	allowed_roles = list("Security Officer","Head of Security","Warden","Detective")

/datum/gear/eyes/secaviators
	display_name = "security HUD aviators"
	path = /obj/item/clothing/glasses/sunglasses/sechud/toggle
	allowed_roles = list("Security Officer","Head of Security","Warden","Detective")

/datum/gear/eyes/medical
	display_name = "medical HUD"
	path = /obj/item/clothing/glasses/hud/health
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist")

/datum/gear/eyes/medical/prescription
	display_name = "Medical HUD, prescription"
	path = /obj/item/clothing/glasses/hud/health/prescription
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist")

/datum/gear/eyes/shades
	display_name = "sunglasses"
	path = /obj/item/clothing/glasses/sunglasses

/datum/gear/eyes/shades/big
	display_name = "sunglasses, fat"
	path = /obj/item/clothing/glasses/sunglasses/big

/datum/gear/eyes/shades/prescriptionsun
	display_name = "sunglasses, presciption"
	path = /obj/item/clothing/glasses/sunglasses/prescription

/datum/gear/eyes/shutters
	display_name = "glasses, shutter"
	path = /obj/item/clothing/glasses/shutters

/datum/gear/eyes/engineering/welding
	display_name = "welding goggles (Engineering)"
	path = /obj/item/clothing/glasses/welding
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer")
	cost = 3

/datum/gear/eyes/stylish/welding
	display_name = "welding goggles, stylish"
	path = /obj/item/clothing/glasses/welding/stylish
