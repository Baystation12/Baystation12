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
	display_name = "Security HUD"
	path = /obj/item/clothing/glasses/hud/security
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/eyes/security/prescription
	display_name = "Security HUD, prescription"
	path = /obj/item/clothing/glasses/hud/security/prescription
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/eyes/secaviators
	display_name = "Security HUD Aviators"
	path = /obj/item/clothing/glasses/sunglasses/sechud/toggle
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/eyes/medical
	display_name = "Medical HUD"
	path = /obj/item/clothing/glasses/hud/health
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist")

/datum/gear/eyes/medical/prescription
	display_name = "Medical HUD, prescription"
	path = /obj/item/clothing/glasses/hud/health/prescription
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist")

/datum/gear/eyes/shades
	display_name = "sunglasses, fat"
	path = /obj/item/clothing/glasses/sunglasses/big
	cost = 2

/datum/gear/eyes/shades/prescriptionsun
	display_name = "sunglasses, presciption"
	path = /obj/item/clothing/glasses/sunglasses/prescription
	cost = 2

/datum/gear/eyes/mesonocle
	display_name = "Meson Scanner, monocle"
	path = /obj/item/clothing/glasses/meson/monocle
	allowed_roles = list("Chief Engineer","Atmospheric Technician", "Station Engineer")
