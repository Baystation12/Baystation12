GLOBAL_LIST_EMPTY(mining_asteroid_spawns)

/datum/spawnpoint/mining_asteroid
	display_name =  "Mining Asteroid Spawn"
	restrict_job = list("Outer Colonist")

/datum/spawnpoint/mining_asteroid/New()
	..()
	turfs = GLOB.mining_asteroid_spawns

/obj/effect/landmark/start/mining_asteroid
	name = "Mining Asteroid Spawn"

/obj/effect/landmark/start/mining_asteroid/New()
	..()
	GLOB.mining_asteroid_spawns += loc


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



/datum/job/Outer_Colonist
	title = "Outer Colonist"
	total_positions = 10
	spawn_positions = 10
	outfit_type = /decl/hierarchy/outfit/job/Outer_Colonist
	selection_color = "#000000"
	spawnpoint_override = "Mining Asteroid Spawn"
	alt_titles = list("Miner","Doctor","Nurse","Warehouse Worker","Sushi Cook","Surgeon","Bartender")
	is_whitelisted = 0