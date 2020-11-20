#include "spybox_areas.dm"

/obj/effect/overmap/visitable/sector/spybox
	name = "strange signal"
	icon_state = "meteor4"
	desc = "Scans are picking up an unknown signal bouncing off the asteroids in this cluster."
	known = 0
	in_space = 1
	initial_generic_waypoints = list(
		"nav_spybox_1",
		"nav_spybox_2",
		"nav_spybox_3"
	)

/datum/map_template/ruin/away_site/spybox
	name = "Observation Post"
	id = "awaysite_spybox"
	description = "A pirate's observation post hidden within an asteroid field"
	suffixes = list("spybox/spybox-1.dmm")
	cost = 0.5
	area_usage_test_exempted_root_areas = list(/area/spybox)

//site specific mobs

/mob/living/simple_animal/hostile/syndicate/melee/space/spybox
	name = "Pirate Butcher"
	speed = 6
	speak = list("Die!", "For the Marauders!", "Your mistake!", "Run while you can!", "I love when loot comes to us!", "Eat this!", "Another kill!")
	speak_chance = 50
	emote_hear = list("laughs", "grumbles", "breathes loudly", "mumbles", "speaks into a radio")
	emote_see = list("shuffles", "checks their weapon", "stomps their feet", "thumps their helmet")
	turns_per_move = 5
	wander = 1
	corpse = /obj/effect/landmark/corpse/spybox/melee

/mob/living/simple_animal/hostile/syndicate/ranged/space/spybox
	name = "Pirate Marksman"
	speed = 3
	speak = list("Die!", "For the Marauders!", "Your mistake!", "Run while you can!", "I love when loot comes to us!", "Eat this!", "Another kill!")
	speak_chance = 50
	emote_hear = list("laughs", "grumbles", "breathes loudly", "mumbles", "speaks into a radio")
	emote_see = list("shuffles", "checks their weapon", "stomps their feet", "thumps their helmet", "reloads")
	turns_per_move = 3
	wander = 1
	corpse = /obj/effect/landmark/corpse/spybox/gun

/obj/effect/landmark/corpse/spybox/melee
	name = "Pirate Butcher"
	corpse_outfits = list(/decl/hierarchy/outfit/spybox)

/obj/effect/landmark/corpse/spybox/gun
	name = "Pirate Marksman"
	corpse_outfits = list(/decl/hierarchy/outfit/spybox)

/decl/hierarchy/outfit/spybox
	name = "Observation Post Marauder"
	uniform = /obj/item/clothing/under/syndicate
	shoes = /obj/item/clothing/shoes/combat
	suit = /obj/item/clothing/suit/space/void/merc
	mask = /obj/item/clothing/mask/gas/syndicate
	head = /obj/item/clothing/head/helmet/space/void/merc
	l_pocket = /obj/item/weapon/tank/emergency/oxygen
	back = /obj/item/weapon/tank/jetpack/oxygen

	id_slot = slot_wear_id
	id_types = list(/obj/item/weapon/card/id/spybox)
	id_pda_assignment = "Marauder"



//site-specific object stuff

/var/const/access_spybox = "ACCESS_SPYBOX"
/datum/access/spybox
	id = access_spybox
	desc = "Observation Post Access"
	region = ACCESS_REGION_NONE

/obj/item/weapon/card/id/spybox
	access = list(access_spybox)

/obj/machinery/alarm/spybox
	req_access = list(access_spybox)

/obj/machinery/power/apc/spybox
	req_access = list(access_spybox)
	cell_type = /obj/item/weapon/cell/hyper

/obj/item/weapon/disk/spydata
	name = "encrypted data disk"
	desc = "A data disk locked behind several layers of encryptions. Whatever is inside this must be very valuable.."
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk0"
	item_state = "card-id"
	w_class = ITEM_SIZE_SMALL