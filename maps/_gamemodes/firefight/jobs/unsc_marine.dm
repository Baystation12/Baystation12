
/datum/job/firefight_unsc_marine
	title = "UNSC Marine"
	spawn_faction = "UNSC"
	total_positions = -1
	spawn_positions = -1
	outfit_type = /decl/hierarchy/outfit/job/firefight_unsc_marine
	selection_color = "#0A0A95"
	access = list(access_unsc)
	whitelisted_species = list(/datum/species/human)
	loadout_allowed = TRUE

	alt_titles = list("Machine Gunner Marine","Marine Combat Medic","Assault Recon Marine",\
	"Designated Marksman Marine","Scout Sniper Marine","Anti-Tank Missile Gunner Marine",\
	"EVA Combat Marine","Marine Combat Technician")

/decl/hierarchy/outfit/job/firefight_unsc_marine
	name = "Firefight UNSC Marine"

	l_ear = /obj/item/device/radio/headset/unsc/marine
	mask = /obj/item/clothing/mask/marine
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/marine_fatigues
	shoes = /obj/item/clothing/shoes/marine
	head = /obj/item/clothing/head/helmet/marine
	suit = /obj/item/clothing/suit/storage/marine
	belt = /obj/item/weapon/storage/belt/marine_ammo
	gloves = /obj/item/clothing/gloves/thick/unsc
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/enlisted/e2, /obj/item/clothing/accessory/holster/thigh, /obj/item/clothing/accessory/badge/tags)

	l_hand = /obj/item/weapon/gun/projectile/ma5b_ar
	l_pocket = /obj/item/ammo_magazine/m762_ap/MA5B

	flags = 0
