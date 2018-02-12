#include "yacht_areas.dm"

/obj/effect/overmap/ship/yacht
	name = "private yacht"
	desc = "Sensor array is detecting a small vessel with unknown lifeforms on board"
	color = "#FFC966"
	vessel_mass = 30
	default_delay = 35 SECONDS
	speed_mod = 10 SECONDS
	generic_waypoints = list(
		"nav_yacht_1",
		"nav_yacht_2",
		"nav_yacht_3",
		"nav_yacht_antag"
	)

/obj/effect/overmap/ship/yacht/New(nloc, max_x, max_y)
	name = "IPV [pick("Razorshark", "Aurora", "Lighting", "Pequod", "Anansi")], \a [name]"
	..()

/datum/map_template/ruin/away_site/yacht
	name = "Yacht"
	id = "awaysite_yach"
	description = "Tiny movable ship with spiders."
	suffixes = list("yacht/yacht.dmm")
	cost = 0.5

/obj/effect/shuttle_landmark/nav_yacht/nav1
	name = "Small Yacht Navpoint #1"
	landmark_tag = "nav_yacht_1"

/obj/effect/shuttle_landmark/nav_yacht/nav2
	name = "Small Yacht Navpoint #2"
	landmark_tag = "nav_yacht_2"

/obj/effect/shuttle_landmark/nav_yacht/nav3
	name = "Small Yacht Navpoint #3"
	landmark_tag = "nav_yacht_3"

/obj/effect/shuttle_landmark/nav_yacht/nav4
	name = "Small Yacht Navpoint #4"
	landmark_tag = "nav_yacht_antag"

/obj/effect/awayjob/yacht
	desc = "Clicking on this will turn you into this ship's captain."
	name = "yacht captain"

/obj/effect/awayjob/yacht/prepare(var/mob/living/carbon/human/H)
	var/list/valid_species = list(SPECIES_UNATHI,SPECIES_TAJARA,SPECIES_SKRELL,SPECIES_HUMAN,SPECIES_VOX)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/tan(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/box(H), slot_in_backpack)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel/leather(H), slot_back)
	H.change_appearance(APPEARANCE_ALL, H.loc, H, valid_species, state = GLOB.z_state)
	to_chat(H, "<i>You wake up at the controls of a small vessle. Who knows what kind of incompetence led you to fall asleep at the wheel. In fact you don't quite remember how you got here in the first place.")
	to_chat(H, "<b> You are playing an off-station role. Use your surroundings to your advantage, and create good roleplay. You may shred the papers scattered about, in order to create your own version of the events. REMEMBER: Server rules still apply.")
	to_chat(H, "<span class='warning'>You hear creepy skittering around the hull of your ship.</span>")