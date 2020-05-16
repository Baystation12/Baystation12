
/datum/job/unsc
	title = "UNSC"
	spawnpoint_override = "UNSC Base Spawns"
	fallback_spawnpoint = "UNSC Base Fallback Spawns"
	access = list(access_unsc,access_unsc_armoury)
	selection_color = "#0A0A95"
	whitelisted_species = list(/datum/species/human)
	spawn_faction = "UNSC"
	loadout_allowed = TRUE
	lace_access = TRUE
	total_positions = -1
	spawn_positions = -1

/decl/hierarchy/outfit/job/unsc
	name = "UNSC Ship Crew"
	l_ear = /obj/item/device/radio/headset/unsc
	starting_accessories = list(/obj/item/clothing/accessory/rank/fleet/enlisted/e3)
	shoes = /obj/item/clothing/shoes/black
	uniform = /obj/item/clothing/under/unsc/red
	id_type = /obj/item/weapon/card/id/unsc
	pda_slot = null
	flags = 0
