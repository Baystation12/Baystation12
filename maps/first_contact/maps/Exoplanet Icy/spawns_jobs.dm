GLOBAL_LIST_EMPTY(ice_staff_spawns)

/datum/spawnpoint/ice_staff
	display_name =  "Depot Guard Spawn"
	restrict_job = list("Depot Guard")

/datum/spawnpoint/ice_staff/New()
	..()
	turfs = GLOB.ice_staff_spawns

/obj/effect/landmark/start/ice_staff
	name = "Depot Guard Spawn"

/obj/effect/landmark/start/ice_staff/New()
	..()
	GLOB.ice_staff_spawns += loc

GLOBAL_LIST_EMPTY(emsville_staff_spawns)

/datum/spawnpoint/emsville_staff
	display_name =  "Emsville Spawn"
	restrict_job = list("Emsville Colonist")

/datum/spawnpoint/emsville_staff/New()
	..()
	turfs = GLOB.emsville_staff_spawns

/obj/effect/landmark/start/emsville_staff
	name = "Emsville Spawn"

/obj/effect/landmark/start/emsville_staff/New()
	..()
	GLOB.emsville_staff_spawns += loc

GLOBAL_LIST_EMPTY(emsville_marshall_spawns)

/datum/spawnpoint/emsville_marshall
	display_name =  "Emsville Spawn Marshall"
	restrict_job = list("Emsville Marshall")

/datum/spawnpoint/emsville_marshall/New()
	..()
	turfs = GLOB.emsville_marshall_spawns

/obj/effect/landmark/start/emsville_marshall
	name = "Emsville Spawn Marshall"

/obj/effect/landmark/start/emsville_marshall/New()
	..()
	GLOB.emsville_marshall_spawns += loc

/decl/hierarchy/outfit/job/Outer_Colonist
	name = "Outer_Colonist"

	head = null
	uniform = null
	belt = /obj/item/weapon/storage/wallet/random
	shoes = /obj/item/clothing/shoes/brown
	pda_slot = null

	flags = 0

/decl/hierarchy/outfit/job/Outer_Colonist/equip_id(mob/living/carbon/human/H)
	var/obj/item/weapon/card/id/C = ..()
	C.assignment = "Outer_Colonist"
	H.set_id_info(C)

/decl/hierarchy/outfit/job/Outer_Colonist/proc/equip_special(mob/living/carbon/human/H)
	if(prob(30))
		var/obj/item/weapon/gun/projectile/G = new /obj/item/weapon/gun/projectile/colt
		G.ammo_magazine = new /obj/item/ammo_magazine/c45m
		H.equip_to_slot_or_del(G,slot_belt)

/decl/hierarchy/outfit/job/Outer_Colonist/equip_base(mob/living/carbon/human/H)

	var/random_uniform = pick(/obj/item/clothing/under/serviceoveralls,\
		/obj/item/clothing/under/frontier,\
		/obj/item/clothing/under/overalls,\
		/obj/item/clothing/under/focal,\
		/obj/item/clothing/under/grayson,\
		/obj/item/clothing/under/hazard,\
		/obj/item/clothing/under/aether)
	H.equip_to_slot_or_del(new random_uniform(H),slot_w_uniform)

	equip_special(H)

	. = ..()

	hierarchy_type = /decl/hierarchy/outfit/job



/decl/hierarchy/outfit/job/IGUARD
	name = "Depot Guard"
	l_ear = /obj/item/device/radio/headset/unsc
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/marine_fatigues
	gloves = /obj/item/clothing/gloves/thick/unsc
	shoes = /obj/item/clothing/shoes/marine
	belt = /obj/item/weapon/storage/belt/marine_ammo
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/enlisted/e3, /obj/item/clothing/accessory/holster/thigh, /obj/item/clothing/accessory/badge/tags)

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job


/datum/job/IGUARD
	title = "Depot Guard"
	total_positions = 3
	spawn_positions = 3
	outfit_type = /decl/hierarchy/outfit/job/IGUARD
	selection_color = "#008000"
	access = list(532,110)
	spawnpoint_override = "Depot Guard Spawn"
	is_whitelisted = 0


/datum/job/Emsville_Colonist
	title = "Emsville Colonist"
	total_positions = 15
	spawn_positions = 15
	outfit_type = /decl/hierarchy/outfit/job/Outer_Colonist
	selection_color = "#000000"
	spawnpoint_override = "Emsville Spawn"
	alt_titles = list("Miner","Doctor","Nurse","Sushi Chef","Hydroponics Technician","Warehouse Worker","Librarian","Surgeon","Bartender","Nightclub Owner")
	is_whitelisted = 0

/datum/job/Emsville_Marshall
	title = "Emsville Marshall"
	total_positions = 4
	spawn_positions = 4
	outfit_type = /decl/hierarchy/outfit/job/marshall
	selection_color = "#000000"
	access = list(532)
	spawnpoint_override = "Emsville Spawn Marshall"
	is_whitelisted = 0
