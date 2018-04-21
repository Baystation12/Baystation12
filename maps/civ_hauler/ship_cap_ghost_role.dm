
/obj/effect/landmark/ship_captain_ghost_spawn
	name = "Ship Cap Ghost Spawn"

/obj/effect/landmark/ship_captain_ghost_spawn/ex_act()
	. = ..()
	qdel(src)

/decl/hierarchy/outfit/npc_ship_captain
	name = "NPC - Ship Captain"
	hierarchy_type = /decl/hierarchy/outfit

	uniform = /obj/item/clothing/under/color/grey
	suit = /obj/item/clothing/suit/storage/vest/tactical
	l_ear = /obj/item/device/radio/headset
	shoes = /obj/item/clothing/shoes/black

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/civilian
	pda_slot = slot_l_store
	pda_type = /obj/item/device/pda

	belt = /obj/item/weapon/gun/projectile/m6d_magnum
	r_pocket = /obj/item/ammo_magazine/m127_saphe

	flags = 0

/datum/ghost_role/ship_captain

	mob_to_spawn = /mob/living/carbon/human
	objects_spawn_on = list(/obj/effect/landmark/ship_captain_ghost_spawn)
	always_spawnable = 0
	var/decl/hierarchy/outfit/outfit_to_use = new /decl/hierarchy/outfit/npc_ship_captain

/datum/ghost_role/ship_captain/post_spawn(var/ghost,var/obj/chosen_spawn,var/mob/living/carbon/human/created_mob)
	qdel(chosen_spawn)
	outfit_to_use.equip(created_mob)
