#include "slavers_base_areas.dm"
#include "../mining/mining_areas.dm"

/obj/effect/overmap/sector/slavers_base
	name = "large asteroid"
	desc = "Sensor array is reading an artificial structure inside the asteroid."
	icon_state = "object"
	known = 0

	generic_waypoints = list(
		"nav_slavers_base_1",
		"nav_slavers_base_2",
		"nav_slavers_base_3",
		"nav_slavers_base_4",
		"nav_slavers_base_5",
		"nav_slavers_base_6",
		"nav_slavers_base_antag"
	)

/datum/map_template/ruin/away_site/slavers
	name = "Slavers' Base"
	id = "awaysite_slavers"
	description = "Asteroid with slavers base inside."
	suffixes = list("slavers/slavers_base.dmm")
	cost = 1

/obj/effect/shuttle_landmark/nav_slavers_base/nav1
	name = "Slavers Base Navpoint #1"
	landmark_tag = "nav_slavers_base_1"

/obj/effect/shuttle_landmark/nav_slavers_base/nav2
	name = "Slavers Base Navpoint #2"
	landmark_tag = "nav_slavers_base_2"

/obj/effect/shuttle_landmark/nav_slavers_base/nav3
	name = "Slavers Base Navpoint #3"
	landmark_tag = "nav_slavers_base_3"

/obj/effect/shuttle_landmark/nav_slavers_base/nav4
	name = "Slavers Base Navpoint #4"
	landmark_tag = "nav_slavers_base_4"

/obj/effect/shuttle_landmark/nav_slavers_base/nav5
	name = "Slavers Base Navpoint #5"
	landmark_tag = "nav_slavers_base_5"

/obj/effect/shuttle_landmark/nav_slavers_base/nav6
	name = "Slavers Base Navpoint #6"
	landmark_tag = "nav_slavers_base_6"

/obj/effect/shuttle_landmark/nav_slavers_base/nav7
	name = "Slavers Base Navpoint #7"
	landmark_tag = "nav_slavers_base_antag"

/obj/structure/slavers_base/mattress
	name = "dirty mattress"
	desc = "Dirty, smelling mattress, covered with body fluids. You wouldn't want to touch this."
	icon = 'maps/away/slavers/slavers_base_sprites.dmi'
	icon_state = "dirty_mattress"
	anchored = 0

/obj/effect/landmark/corpse/slavers_base/slaver1
	name = "Slaver"
	corpseuniform = /obj/item/clothing/suit/johnny_coat
	corpseshoes = /obj/item/clothing/shoes/black
	corpseglasses = /obj/item/clothing/glasses/sunglasses

/obj/effect/landmark/corpse/slavers_base/slaver2
	name = "Slaver"
	corpseuniform = /obj/item/clothing/under/grayson
	corpseshoes = /obj/item/clothing/shoes/blue

/obj/effect/landmark/corpse/slavers_base/slaver3
	name = "Slaver"
	corpseuniform = /obj/item/clothing/under/pirate
	corpseshoes = /obj/item/clothing/shoes/brown

/obj/effect/landmark/corpse/slavers_base/slaver4
	name = "Slaver"
	corpseuniform = /obj/item/clothing/under/psyche
	corpseshoes = /obj/item/clothing/shoes/brown

/obj/effect/landmark/corpse/slavers_base/slaver5
	name = "Slaver"
	corpseuniform = /obj/item/clothing/under/sterile
	corpseshoes = /obj/item/clothing/shoes/orange
	corpsemask = /obj/item/clothing/mask/surgical

/obj/effect/landmark/corpse/slavers_base/slaver6
	name = "Slaver"
	corpseuniform = /obj/item/clothing/under/frontier
	corpseshoes = /obj/item/clothing/shoes/orange

/obj/effect/landmark/corpse/slavers_base/slave
	name = "Slave"
	corpseuniform = /obj/item/clothing/under/color/orange
	corpseshoes = /obj/item/clothing/shoes/tactical

/mob/living/simple_animal/hostile/abolition_extremist
	name = "abolition extremist"
	desc = "Vigiliant fighter against slavery."
	icon = 'maps/away/slavers/slavers_base_sprites.dmi'
	icon_state = "extremist"
	icon_living = "extremist"
	icon_dead = "extremist_dead"
	speak_chance = 0
	turns_per_move = 5
	response_help = "pushes"
	response_disarm = "shoves"
	response_harm = "hits"
	speed = 4
	stop_automated_movement_when_pulled = 0
	maxHealth = 100
	health = 100
	harm_intent_damage = 5
	melee_damage_lower = 30
	melee_damage_upper = 30
	unsuitable_atoms_damage = 15
	var/corpse = /obj/effect/landmark/mobcorpse/abolitionist
	var/weapon = /obj/item/weapon/gun/energy/laser
	projectilesound = 'sound/weapons/laser.ogg'
	ranged = 1
	rapid = 1
	projectiletype = /obj/item/projectile/beam
	faction = "extremist abolitionists"

/mob/living/simple_animal/hostile/abolition_extremist/death(gibbed, deathmessage, show_dead_message)
	. = ..(gibbed, deathmessage, show_dead_message)
	if(corpse)
		new corpse(loc)
	if(weapon)
		new weapon(loc)
	qdel(src)

/obj/effect/landmark/mobcorpse/abolitionist
	name = "abolitionist"
	corpseuniform = /obj/item/clothing/under/abol_uniform
	corpseshoes = /obj/item/clothing/shoes/jackboots
	corpsehelmet = /obj/item/clothing/head/helmet/merc

/obj/item/clothing/under/abol_uniform
	name = "abolitionist combat suit"
	desc = "Lightly armored suit worn by abolition extremists during raids. It has green patches on the right sleeve and the chest. There is big green \"A\" on the back."
	icon = 'maps/away/slavers/slavers_base_sprites.dmi'
	icon_state = "abol_suit"
	item_icons = list(slot_w_uniform_str = 'maps/away/slavers/slavers_base_sprites.dmi')
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	armor = list(melee = 30, bullet = 25, laser = 10, energy = 10, bomb = 5, bio = 0, rad = 0)

