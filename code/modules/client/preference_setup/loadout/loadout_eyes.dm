// Eyes
/datum/gear/eyes
	display_name = "eyepatch"
	path = /obj/item/clothing/glasses/eyepatch
	slot = slot_glasses
	sort_category = "Glasses and Eyewear"

/datum/gear/eyes/glasses
	display_name = "glasses, prescription"
	path = /obj/item/clothing/glasses/regular

/datum/gear/eyes/glasses/green
	display_name = "glasses, green"
	path = /obj/item/clothing/glasses/gglasses

/datum/gear/eyes/glasses/prescriptionhipster
	display_name = "glasses, hipster"
	path = /obj/item/clothing/glasses/regular/hipster

/datum/gear/eyes/glasses/monocle
	display_name = "monocle"
	path = /obj/item/clothing/glasses/monocle

/datum/gear/eyes/scanning_goggles
	display_name = "scanning goggles"
	path = /obj/item/clothing/glasses/regular/scanners

/datum/gear/eyes/sciencegoggles
	display_name = "Science Goggles"
	path = /obj/item/clothing/glasses/science

/datum/gear/eyes/security
	display_name = "security HUD"
	path = /obj/item/clothing/glasses/hud/security
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/eyes/secaviators
	display_name = "security HUD aviators"
	path = /obj/item/clothing/glasses/sunglasses/sechud/toggle
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/eyes/medical
	display_name = "medical HUD"
	path = /obj/item/clothing/glasses/hud/health
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist")

/datum/gear/eyes/shades
	display_name = "sunglasses"
	path = /obj/item/clothing/glasses/sunglasses
	allowed_roles = list("Security Officer","Head of Security","Warden","Captain","Head of Personnel","Quartermaster","Internal Affairs Agent","Detective")

/datum/gear/eyes/shades/big
	display_name = "sunglasses, fat"
	path = /obj/item/clothing/glasses/sunglasses/big
	allowed_roles = list("Security Officer","Head of Security","Warden","Captain","Head of Personnel","Quartermaster","Internal Affairs Agent","Detective")

/datum/gear/eyes/shades/prescriptionsun
	display_name = "sunglasses, presciption"
	path = /obj/item/clothing/glasses/sunglasses/prescription
	allowed_roles = list("Security Officer","Head of Security","Warden","Captain","Head of Personnel","Quartermaster","Internal Affairs Agent","Detective")

/datum/gear/eyes/security/prescription
	display_name = "security HUD, prescription"
	path = /obj/item/clothing/glasses/hud/security/prescription
	allowed_roles = list("Security Officer","Head of Security","Warden","Captain","Head of Personnel","Quartermaster","Internal Affairs Agent","Detective")
	cost = 2

/datum/gear/eyes/medical/prescription
	display_name = "medical HUD, prescription"
	path = /obj/item/clothing/glasses/hud/health/prescription
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist")
	cost = 2

/datum/gear/eyes/glasses/shutters
	display_name = "glasses, shutter"
	path = /obj/item/clothing/glasses/shutters