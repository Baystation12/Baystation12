#include "venera_areas.dm"
#include "venera_radio.dm"

/obj/effect/overmap/visitable/ship/venera
	name = "venera"
	desc = "Sensor array is detecting a vessel with unknown lifeforms on board."
	color = "#1d96f8"
	vessel_mass = 3000 /// Venera is small and fast ship
	max_speed = 1/(2 SECONDS)
	initial_generic_waypoints = list(
		"nav_venera_1",
		"nav_venera_2",
		"nav_venera_3",
		"nav_venera_antag"
	)
	initial_restricted_waypoints = list(
		"Aquila" = list("nav_venera_aquila"),
	)
/obj/effect/overmap/visitable/ship/venera/New(nloc, max_x, max_y)
	name = "SGV Venera"
	..()

/datum/map_template/ruin/away_site/venera
	name = "SGV Venera"
	id = "awaysite_venera"
	description = "SolGov movable medium ship with turned humans."
	suffixes = list("venera/venera.dmm")
	spawn_cost = 0.5
	area_usage_test_exempted_root_areas = list(/area/venera)

/obj/effect/shuttle_landmark/nav_venera/nav1
	name = "SGV Venera Navpoint #1"
	landmark_tag = "nav_venera_1"

/obj/effect/shuttle_landmark/nav_venera/nav2
	name = "SGV Venera Navpoint #2"
	landmark_tag = "nav_venera_2"

/obj/effect/shuttle_landmark/nav_venera/nav3
	name = "SGV Venera Navpoint #3"
	landmark_tag = "nav_venera_3"

/obj/effect/shuttle_landmark/nav_venera/nav4
	name = "SGV Venera Navpoint #4"
	landmark_tag = "nav_venera_antag"
/obj/effect/shuttle_landmark/nav_venera/aquila
	name = "Aquila Dock"
	landmark_tag = "nav_venera_aquila"



////////// Venera Corpses ////////////

/obj/effect/landmark/corpse/venera
	name = "Dead Crewmember"
	corpse_outfits = list(/decl/hierarchy/outfit/job/torch/crew/service/crewman)
/obj/effect/landmark/corpse/venera/security
	name = "Dead Security"
	corpse_outfits = list(/decl/hierarchy/outfit/job/torch/crew/security/maa)
/obj/effect/landmark/corpse/venera/medical
	name = "Dead Medic"
	corpse_outfits = list(/decl/hierarchy/outfit/venera/doctor)
/obj/effect/landmark/corpse/venera/engineer
	name = "Dead Engineer"
	corpse_outfits = list(/decl/hierarchy/outfit/job/torch/crew/engineering/engineer)
/obj/effect/landmark/corpse/venera/captain
	name = "Dead Captain"
	corpse_outfits = list(/decl/hierarchy/outfit/venera/captain)
/obj/effect/landmark/corpse/venera/iccgn
	name = "Dead ICCGN Agent"
	corpse_outfits = list(/decl/hierarchy/outfit/venera/iccgn)

/decl/hierarchy/outfit/venera
	name = OUTFIT_JOB_NAME ("Venera Crew")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/service
/decl/hierarchy/outfit/venera/iccgn
	name = OUTFIT_JOB_NAME ("ICCGN Agent")
	uniform = /obj/item/clothing/under/iccgn/utility
	suit = /obj/item/clothing/suit/armor/bulletproof
	shoes = /obj/item/clothing/shoes/iccgn/utility
	gloves = /obj/item/clothing/gloves/iccgn/duty
	head = /obj/item/clothing/head/helmet/ballistic
	back = /obj/item/storage/backpack/dufflebag/syndie
/decl/hierarchy/outfit/venera/doctor
	name = OUTFIT_JOB_NAME ("Venera Doctor")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/medical
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	shoes = /obj/item/clothing/shoes/dutyboots
	gloves = /obj/item/clothing/gloves/latex
	head = /obj/item/clothing/head/beret/solgov/expedition/medical
	back = /obj/item/storage/backpack/satchel/med
	l_ear = /obj/item/device/radio/headset/map_preset/venera
/decl/hierarchy/outfit/venera/captain
	name = OUTFIT_JOB_NAME ("Venera Captain")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/officer/command
	suit = /obj/item/clothing/suit/storage/solgov/dress/expedition/command/capt
	shoes = /obj/item/clothing/shoes/dress
	gloves = /obj/item/clothing/gloves/thick/duty/solgov/cmd
	head = /obj/item/clothing/head/solgov/service/expedition/captain
	back = /obj/item/storage/backpack/satchel/com
	l_ear = /obj/item/device/radio/headset/map_preset/venera



///////////// Venera Snacks ////////////

/obj/item/reagent_containers/food/snacks/meatsteak/toxin
	name = "meat steak"
	desc = "A piece of spicy meat."
	icon_state = "meatstake"
	trash = /obj/item/trash/plate
	filling_color = "#7a3d11"
	center_of_mass = "x=16;y=13"
	bitesize = 40
/obj/item/reagent_containers/food/snacks/meatsteak/toxin/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 5)
	reagents.add_reagent(/datum/reagent/sodiumchloride, 1)
	reagents.add_reagent(/datum/reagent/blackpepper, 1)
	reagents.add_reagent(/datum/reagent/chloralhydrate, 10)
	reagents.add_reagent(/datum/reagent/toxin/cyanide, 10)

/////////// Venera Mobs ///////////

/obj/item/natural_weapon/meatbits/strong
	force = 35
	sharp = TRUE
	edge = TRUE
	attack_cooldown = 1 SECONDS
	attack_verb = list("mauled", "slashed")

/mob/living/simple_animal/hostile/meat/abomination/strong
	name = "strong abomination"
	desc = "A monstrously huge wall of flesh, it looks like you took who knows how many humans and put them together, this one looks very dangerously..."
	icon = 'icons/mob/simple_animal/nightmaremonsters.dmi'
	icon_state = "abomination"
	icon_living = "abomination"
	icon_dead = "abomination_dead"
	speak_emote = list("трясётся")
	turns_per_move = 5
	see_in_dark = 20
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "pokes"
	maxHealth = 320
	health = 320
	natural_weapon = /obj/item/natural_weapon/meatbits/strong
	heat_damage_per_tick = 20
	cold_damage_per_tick = 0
	faction = "meat"
	pass_flags = PASS_FLAG_TABLE
	move_to_delay = 3
	speed = 0.5
	bleed_colour = "#5c0606"
	break_stuff_probability = 50
	pry_time = 1 SECONDS
	pry_desc = "clawing"
	min_gas = null
	max_gas = null
	minbodytemp = 0
	resistance = 15
	natural_armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_SMALL
		)
