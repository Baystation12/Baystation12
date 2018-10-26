GLOBAL_LIST_EMPTY(kigyar_pirate_spawns)

/datum/spawnpoint/kigyar_pirate
	display_name =  "Kig-Yar Pirate Spawn"
	restrict_job = list("Kig-Yar Ship - Pirate","Kig-Yar Ship - Captain")

/datum/spawnpoint/kigyar_pirate/New()
	..()
	turfs = GLOB.kigyar_pirate_spawns

/obj/effect/landmark/start/kigyar_pirate
	name = "Kig-Yar Pirate Spawn"

/obj/effect/landmark/start/kigyar_pirate/New()
	..()
	GLOB.kigyar_pirate_spawns += loc

GLOBAL_LIST_EMPTY(unggoy_pirate_spawns)

/datum/spawnpoint/unggoy_pirate
	display_name =  "Unggoy Pirate Spawn"
	restrict_job = list("Kig-Yar Ship - Unggoy Crewmember",)

/datum/spawnpoint/unggoy_pirate/New()
	..()
	turfs = GLOB.unggoy_pirate_spawns

/obj/effect/landmark/start/unggoy_pirate
	name = "Unggoy Pirate Spawn"

/obj/effect/landmark/start/unggoy_pirate/New()
	..()
	GLOB.unggoy_pirate_spawns += loc

//GALCOMM LANGUAGE LEARN OBJECT//
/obj/item/language_learner
	name = "Galactic Common Language Learner"
	desc = "A dataslate holding information on a single language. Enough to learn the basics of the language with."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper"
	item_state = "paper"
	w_class = ITEM_SIZE_SMALL

	var/language_string = "Galactic Common"

/obj/item/language_learner/attack_self(var/mob/living/carbon/human/h)
	to_chat(h,"<span class = 'notice'>You read [name]...</span>")
	for(var/datum/language/lang in h.languages)
		if(lang.name == language_string)
			to_chat(h,"<span class ='notice'>You already know [language_string]</span>")
			return
	to_chat(h,"<span class = 'notice'>You think you've learnt enough to speak [language_string].</span>")
	h.add_language(language_string)
	to_chat(h,"<span class = 'notice'>You discard [name].</span>")
	h.drop_from_inventory(src)
	qdel(src)

/obj/item/language_learner/kigyar_to_common
	name = "Assembled Observations"
	desc = "A paper scrap containing observations of this system's inhabitants, their habits and, most importantly, their valuable goods. Enough of it is written in their language for you to learn the basics."

/obj/item/language_learner/unggoy_to_common
	name = "Heretic Assessment"
	desc = "A sheet of paper holding outdated observations of the viability of this system's inhabitants for integration with the covenant empire. The observations of their language and it's structure seems most useful."

/decl/hierarchy/outfit/kigyarpirate
	name = "Kig-Yar Pirate"

	l_ear = /obj/item/device/radio/headset/covenant
	uniform = null
	shoes = null
	head = null
	suit = null

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/kigyarpirate/captain
	name = "Kig-Yar Ship-captain"

	l_ear = /obj/item/device/radio/headset/covenant
	uniform = /obj/item/clothing/under/covenant/kigyar
	suit = /obj/item/clothing/suit/armor/covenant/kigyar
	suit_store = /obj/item/weapon/gun/energy/plasmapistol
	back = /obj/item/weapon/gun/projectile/type51carbine
	l_pocket = /obj/item/weapon/melee/energy/sword/pirate
	r_pocket = /obj/item/ammo_magazine/type51mag
	belt = /obj/item/ammo_magazine/type51mag
	gloves = /obj/item/clothing/gloves/shield_gauntlet/kigyar
	head = /obj/item/clothing/head/helmet/kigyar
	l_hand = /obj/item/language_learner/kigyar_to_common

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/unggoy/first_contact
	l_hand = /obj/item/language_learner/unggoy_to_common

/decl/hierarchy/outfit/unggoy/major/first_contact
	l_hand = /obj/item/language_learner/unggoy_to_common

/datum/job/covenant/kigyarpirate
	title = "Kig-Yar Ship - Pirate"
	total_positions = 7
	spawn_positions = 7
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/kigyarpirate
	access = list(240,250)
	spawnpoint_override = "Kig-Yar Pirate Spawn"
	faction_whitelist = "Covenant"

/datum/job/covenant/kigyarpirate/captain
	title = "Kig-Yar Ship - Captain"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/kigyarpirate/captain
	access = list(240,250)
	spawnpoint_override = "Kig-Yar Pirate Spawn"
	faction_whitelist = "Covenant"

/datum/job/covenant/unggoy
	title = "Kig-Yar Ship - Unggoy Crewmember"
	total_positions = 6
	spawn_positions = 6
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/unggoy/first_contact
	access = list(230,250)
	spawnpoint_override = "Unggoy Pirate Spawn"

/datum/job/covenant/unggoy_deacon
	title = "Kig-Yar Ship - Unggoy Crewmember Deacon"
	total_positions = 3
	spawn_positions = 3
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/unggoy/major/first_contact
	access = list(230,250)
	spawnpoint_override = "Unggoy Pirate Spawn"
	faction_whitelist = "Covenant"
