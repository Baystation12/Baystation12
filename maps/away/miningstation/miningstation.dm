#include "miningstation_areas.dm"


/obj/effect/overmap/visitable/sector/miningstation
	name = "Orbital Mining Station"
	desc = "An orbital Mining Station bearing authentication codes from Grayson Mining Industries, sensors show inconsistant lifesigns aboard the station. It is emitting a active distress beacon."
	icon_state = "object"
	known = 0
	initial_generic_waypoints = list(
		"nav_miningstation_hangar",
		"nav_miningstation_exterior",
	)

/datum/map_template/ruin/away_site/miningstation
	name = "Mining Station"
	id = "awaysite_miningstation"
	description = "An orbital Mining Station bearing authentication codes from Grayson Mining Industries, sensors show inconsistant lifesigns aboard the station."
	suffixes = list("miningstation/miningstation.dmm")
	cost = 1
	area_usage_test_exempted_root_areas = list(/area/miningstation)

/obj/effect/shuttle_landmark/nav_miningstation/hangar
	name = "Hangar"
	landmark_tag = "nav_miningstation_hangar"
	base_area = /area/miningstation/hangar
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/nav_miningstation/exterior
	name = "Near the orbital station"
	landmark_tag = "nav_miningstation_exterior"


///////////////////////////////////crew
/decl/hierarchy/outfit/corpse
	hierarchy_type = /decl/hierarchy/outfit/corpse

/decl/hierarchy/outfit/corpse/miningstation
	hierarchy_type = /decl/hierarchy/outfit/corpse/miningstation

/obj/effect/landmark/corpse/miningstation/deadminer
	name = "Dead miner"
	corpse_outfits = list(/decl/hierarchy/outfit/miningstation)
	hair_styles_per_species = list(SPECIES_HUMAN = list("cia"))
	hair_colors_per_species = list(SPECIES_HUMAN = list("#523d28"))
	genders_per_species = list(SPECIES_HUMAN = list(MALE))

/decl/hierarchy/outfit/miningstation
	name = OUTFIT_JOB_NAME ("Grayson Engineer")
	uniform = /obj/item/clothing/under/hazard
	suit = /obj/item/clothing/suit/storage/hazardvest
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/thick/duty
	head = /obj/item/clothing/head/hardhat/orange
	mask = /obj/item/clothing/mask/gas
	glasses = /obj/item/clothing/glasses/welding

/obj/effect/landmark/corpse/miningstation/deadminerf
	name = "Dead miner"
	corpse_outfits = list(/decl/hierarchy/outfit/miningstation)
	hair_styles_per_species = list(SPECIES_HUMAN = list("Flaired Hair"))
	hair_colors_per_species = list(SPECIES_HUMAN = list("#523d28"))
	genders_per_species = list(SPECIES_HUMAN = list(FEMALE))

/obj/effect/landmark/corpse/miningstation/deadminersuit
	name = "Dead miner suit"
	corpse_outfits = list(/decl/hierarchy/outfit/corpse/miningstation/deadminersuit)
	hair_styles_per_species = list(SPECIES_HUMAN = list("cia"))
	hair_colors_per_species = list(SPECIES_HUMAN = list("#523d28"))
	genders_per_species = list(SPECIES_HUMAN = list(MALE))

/decl/hierarchy/outfit/corpse/miningstation/deadminersuit
	name = OUTFIT_JOB_NAME ("Grayson Miner Suit")
	uniform = /obj/item/clothing/under/hazard
	suit = /obj/item/clothing/suit/space/void/mining/alt
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/thick/duty
	head = /obj/item/clothing/head/helmet/space/void/mining/alt
	mask = /obj/item/clothing/mask/gas
	glasses = /obj/item/clothing/glasses/welding

/obj/effect/landmark/corpse/miningstation/deadmineroveralls
	name = "Dead Miner"
	corpse_outfits = list(/decl/hierarchy/outfit/corpse/miningstation/deadmineroveralls)
	hair_styles_per_species = list(SPECIES_HUMAN = list("cia"))
	hair_colors_per_species = list(SPECIES_HUMAN = list("#523d28"))
	genders_per_species = list(SPECIES_HUMAN = list(MALE))

/obj/effect/landmark/corpse/miningstation/deadmineroverallsf
	name = "Dead miner"
	corpse_outfits = list(/decl/hierarchy/outfit/corpse/miningstation/deadmineroveralls)
	hair_styles_per_species = list(SPECIES_HUMAN = list("Flaired Hair"))
	hair_colors_per_species = list(SPECIES_HUMAN = list("#523d28"))
	genders_per_species = list(SPECIES_HUMAN = list(FEMALE))

/decl/hierarchy/outfit/corpse/miningstation/deadmineroveralls
	name = OUTFIT_JOB_NAME ("Grayson Miner Overalls")
	uniform = /obj/item/clothing/under/grayson
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/thick/duty
	head = /obj/item/clothing/head/welding

////////////////////////////MONSTERS!!!
/mob/living/simple_animal/hostile/meat/
	name = "Horror"
	desc = "A monstrously huge wall of flesh, it looks like you took who knows how many humans and put them together..."
	icon = 'icons/mob/simple_animal/nightmaremonsters.dmi'
	icon_state = "horror"
	icon_living = "horror"
	icon_dead = "horror_dead"
	speak_emote = list("twitches.")
	emote_hear = list("roars!", "groans..")
	emote_see = list("snaps it's head at something..", "twitches", "stops suddenly")
	speak_chance = 5
	turns_per_move = 5
	see_in_dark = 10
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "pokes"
	maxHealth = 250
	health = 250
	melee_damage_lower = 20
	melee_damage_upper = 25
	melee_damage_flags = DAM_SHARP | DAM_EDGE
	heat_damage_per_tick = 20
	cold_damage_per_tick = 0
	attacktext = "mauls and slashes"
	faction = "meat"
	pass_flags = PASS_FLAG_TABLE
	move_to_delay = 3
	speed = 0.5
	bleed_colour = "#5c0606"
	break_stuff_probability = 25
	pry_time = 4 SECONDS
	pry_desc = "clawing"
	min_gas = null
	max_gas = null
	minbodytemp = 0
	natural_armor = list(
		melee = ARMOR_MELEE_KNIVES
		)

/mob/living/simple_animal/hostile/meat/abomination
	name = "Abomination"
	desc = "A monstrously huge wall of flesh, it looks like you took who knows how many humans and put them together..."
	icon = 'icons/mob/simple_animal/nightmaremonsters.dmi'
	icon_state = "abomination"
	icon_living = "abomination"
	icon_dead = "abomination_dead"
	speak_emote = list("twitches.")
	emote_hear = list("roars!", "groans..")
	emote_see = list("snaps it's head at something..", "twitches", "stops suddenly")
	speak_chance = 5
	turns_per_move = 5
	see_in_dark = 10
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "pokes"
	maxHealth = 250
	health = 250
	melee_damage_lower = 20
	melee_damage_upper = 25
	melee_damage_flags = DAM_SHARP | DAM_EDGE
	heat_damage_per_tick = 20
	cold_damage_per_tick = 0
	attacktext = "mauls and slashes"
	faction = "meat"
	pass_flags = PASS_FLAG_TABLE
	move_to_delay = 3
	speed = 0.5
	bleed_colour = "#5c0606"
	break_stuff_probability = 25
	pry_time = 4 SECONDS
	pry_desc = "clawing"
	min_gas = null
	max_gas = null
	minbodytemp = 0
	natural_armor = list(
		melee = ARMOR_MELEE_KNIVES
		)

/mob/living/simple_animal/hostile/meat/horror
	name = "Horror"
	desc = "A monstrously huge wall of flesh, it looks like you took two humans and put them together..."
	icon = 'icons/mob/simple_animal/nightmaremonsters.dmi'
	icon_state = "horror"
	icon_living = "horror"
	icon_dead = "horror_dead"
	speak_emote = list("twitches.")
	emote_hear = list("roars!", "groans...")
	emote_see = list("snaps it's head at something...", "twitches.", "stops suddenly.")
	speak_chance = 5
	turns_per_move = 5
	see_in_dark = 10
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "pokes"
	maxHealth = 150
	health = 150
	melee_damage_lower = 10
	melee_damage_upper = 15
	melee_damage_flags = DAM_SHARP | DAM_EDGE
	heat_damage_per_tick = 100
	cold_damage_per_tick = 0
	faction = "meat"
	pass_flags = PASS_FLAG_TABLE
	move_to_delay = 3
	speed = 0.5
	bleed_colour = "#5c0606"
	break_stuff_probability = 25
	pry_time = 8 SECONDS
	pry_desc = "clawing"
	min_gas = null
	max_gas = null
	minbodytemp = 0
	natural_armor = list(
		melee = ARMOR_MELEE_KNIVES
		)

/mob/living/simple_animal/hostile/meat/strippedhuman
	name = "Turned Human"
	desc = "What's left of a human. Their body's chest cavity is ripped open, their organs spilling out. It twitches, ready for it's next victim..."
	icon = 'icons/mob/simple_animal/nightmaremonsters.dmi'
	icon_state = "horror_alt"
	icon_living = "horror_alt"
	icon_dead = "horror_alt_dead"
	speak_emote = list("twitches.")
	emote_hear = list("roars!", "groans...")
	emote_see = list("turns to the sound..", "twitches", "stops suddenly, it's intestines slowly spilling out")
	speak_chance = 5
	turns_per_move = 5
	see_in_dark = 10
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "pokes"
	maxHealth = 100
	health = 100
	melee_damage_lower = 5
	melee_damage_upper = 10
	melee_damage_flags = DAM_SHARP | DAM_EDGE
	heat_damage_per_tick = 100
	cold_damage_per_tick = 0
	attacktext = "mauls"
	faction = "meat"
	pass_flags = PASS_FLAG_TABLE
	move_to_delay = 3
	speed = 0.5
	bleed_colour = "#5c0606"
	break_stuff_probability = 25
	pry_time = 8 SECONDS
	pry_desc = "clawing"
	min_gas = null
	max_gas = null
	minbodytemp = 0
	natural_armor = list(
		melee = ARMOR_MELEE_KNIVES
		)

/mob/living/simple_animal/hostile/meat/humansecurity
	name = "Turned Security"
	desc = "What's left of a SAARE security guard. The only way you can tell is by the tatters of their uniform. That armor they wore in life now gives them a bit of hardiness in death..."
	icon = 'icons/mob/simple_animal/nightmaremonsters.dmi'
	icon_state = "horror_security"
	icon_living = "horror_security"
	icon_dead = "horror_security_dead"
	speak_emote = list("twitches.")
	emote_hear = list("roars!", "groans...")
	emote_see = list("snaps it's head at something...", "twitches.", "stops suddenly.")
	speak_chance = 5
	turns_per_move = 5
	see_in_dark = 10
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "pokes"
	maxHealth = 200
	health = 200
	melee_damage_lower = 10
	melee_damage_upper = 15
	melee_damage_flags = DAM_SHARP | DAM_EDGE
	heat_damage_per_tick = 100
	cold_damage_per_tick = 0
	attacktext = "slashes"
	faction = "meat"
	pass_flags = PASS_FLAG_TABLE
	move_to_delay = 3
	speed = 0.5
	bleed_colour = "#5c0606"
	break_stuff_probability = 25
	pry_time = 8 SECONDS
	pry_desc = "clawing"
	min_gas = null
	max_gas = null
	minbodytemp = 0
	natural_armor = list(
		melee = ARMOR_MELEE_KNIVES
		)

/mob/living/simple_animal/hostile/meat/horrorminer
	name = "Turned Miner"
	desc = "What's left of a miner. Their head is hanging off the back by a few scraps of fabric."
	icon = 'icons/mob/simple_animal/nightmaremonsters.dmi'
	icon_state = "horror_miner"
	icon_living = "horror_miner"
	icon_dead = "horror_miner_dead"
	speak_emote = list("twitches.")
	emote_hear = list("roars!", "groans...")
	emote_see = list("snaps it's head at something...", "twitches.", "stops suddenly.")
	speak_chance = 5
	turns_per_move = 5
	see_in_dark = 10
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "pokes"
	maxHealth = 150
	health = 150
	melee_damage_lower = 10
	melee_damage_upper = 15
	melee_damage_flags = DAM_SHARP | DAM_EDGE
	heat_damage_per_tick = 100
	cold_damage_per_tick = 0
	attacktext = "slashes"
	faction = "meat"
	pass_flags = PASS_FLAG_TABLE
	move_to_delay = 3
	speed = 0.5
	bleed_colour = "#5c0606"
	break_stuff_probability = 25
	pry_time = 8 SECONDS
	pry_desc = "clawing"
	min_gas = null
	max_gas = null
	minbodytemp = 0
	natural_armor = list(
		melee = ARMOR_MELEE_KNIVES
		)

/mob/living/simple_animal/hostile/meat/horrorsmall
	name = "Smaller Horror"
	desc = "A creature with more legs than it could possibly need. It has multiple sets of eyes, though they're all human..."
	icon = 'icons/mob/simple_animal/nightmaremonsters.dmi'
	icon_state = "lesser_ling"
	icon_living = "lesser_ling"
	icon_dead = ""
	speak_emote = list("twitches.")
	emote_hear = list("roars!", "groans...")
	emote_see = list("snaps it's head at something...", "twitches.", "stops suddenly.")
	speak_chance = 5
	turns_per_move = 5
	see_in_dark = 10
	attacktext = "slashes"
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "pokes"
	maxHealth = 50
	health = 50
	melee_damage_lower = 10
	melee_damage_upper = 15
	melee_damage_flags = DAM_SHARP | DAM_EDGE
	heat_damage_per_tick = 100
	cold_damage_per_tick = 0
	faction = "meat"
	pass_flags = PASS_FLAG_TABLE
	move_to_delay = 3
	speed = 0.5
	bleed_colour = "#5c0606"
	break_stuff_probability = 25
	pry_time = 8 SECONDS
	pry_desc = "clawing"
	min_gas = null
	max_gas = null
	minbodytemp = 0
	natural_armor = list(
		melee = ARMOR_MELEE_KNIVES
		)

////////////////////////////Notes and papers

/obj/item/weapon/paper/miner_note_1
	name = "Invoice"
	info = {"
			<center><b><font color='red'>Grayson Industries</font></b></center>
			<center><b><small>Supply department</small></b></center>
			<i>A new supply of mechs have arrived today. We'll need to have them signed off and inventoried by the end of the night. Grayson doesn't like it when we daddle like that. Remind Lenny that he needs to do it, damn bastard is probably drunk but he can get it done if you push him hard enough.</i>
			"}

/obj/item/weapon/paper/miner_note_2
	name = "Headquarters Invoice"
	info = {"
			<center><b><font color='red'>Grayson Industries</font></b></center>
			<center><b><small>Headquarters, Financial Department</small></b></center>
			<i>Quarterly income from this station has been well above projections. Well done. As a rewward, Grayson industries has awarded everyone on the station a raise of 1500 thaler. Enjoy the money, your men have earned it.area
			Jason Mowry, Grayson Financial.</i>
			"}

/obj/item/weapon/paper/miner_note_3
	name = "Letter to Home"
	info = {"
			<i>WOOOO! Paaaayday! Headquarters just gave us a bunch of new stuff! Woooo! We're rich now! Honey, we're gonna finally be able to afford that place you wanted in Selene! I'm coming home soon, just wait until I come home, then we'll be able to work on our new lives.</i>
			"}

/obj/item/weapon/paper/miner_note_4
	name = "Report"
	info = {"
			<center><b><font color='red'>Grayson Industries</font></b></center>
			<center><b><small>Report</small></b></center>
			<i>We found something in one of the nearby asteroids... seems like it's some sort of artifact. This seems like something NT or maybe the FTU would be interested in. We brought it aboard and are contacting headquarters to see what we should do with it. Some of the guys say that they found some wierd markings near it.</i>
			"}

/obj/item/weapon/paper/miner_note_5
	name = "Invoice"
	info = {"
			<center><b><font color='red'>Grayson Industries</font></b></center>
			<center><b><small>Internal department memo</small></b></center>
			<i>A group of scientists are on their way here to investigate the artifact. I know you're all worried about it, but we'll be fine as long as we stay strong. Remember, our cycle is only a few months out, and then we'll be home. </i>
			"}
/obj/item/weapon/paper/miner_note_6_1
	name = "Letter"
	info = {"
			<i>My dearest Lily,
			It's been quite some time since I've written. I know, you'd rather I send an email but this station is so far out we don't have the ability to send mail save for through the faxes they send to headquarters. Things are rough lately, we've had a lot of strange things going on, random equipment failures, random injuries, a few guys have even gotten sick. The docs don't know what's wrong with them but they're getting worse by the day. We're holding on while we can, the company wants us to stay out here until our cycle is over, which should be just over a few months.</i>
			"}
/obj/item/weapon/paper/miner_note_6_2
	name = "Scribbled note"
	info = {"
			<i>Lily,
			We're not making it off this station alive. Something... something's attacking the crew here. I'm not sure what it is but it seems like it's getting worse as time goes on.. I'm sitting here in the power room, hoping they don't find me... If somehow, someone finds this, please... inform Lillian Mason that her husband, Clark Mason, is no longer here. I'm going to try to see if I can find to at least get a distress beacon out. Wish me luck.
			Until we meet again in heaven,
			Clark Mason</i>
			"}