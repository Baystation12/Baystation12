
/* Covenant */

/datum/faction/covenant
	name = "Covenant"
	var/list/objective_types = list()
	enemy_factions = list("UNSC","Insurrection", "Human Colony","Flood")
	commander_titles = list("Sangheili Shipmaster")
	ship_types = list(/obj/effect/overmap/ship/npc_ship/combat/covenant/medium_armed,/obj/effect/overmap/ship/npc_ship/combat/covenant/heavily_armed)
	defender_mob_types = list(/mob/living/simple_animal/hostile/defender_mob/cov/grunt = 3, /mob/living/simple_animal/hostile/defender_mob/cov/kig)
	default_radio_channel = RADIO_COV

/datum/faction/covenant/New()
	. = ..()
	leader_name = "[pick(GLOB.sanshyuum_titles)] of [pick(GLOB.sanshyuum_virtues)]"

/datum/faction/covenant/get_commander(var/datum/mind/check_mind)

	if(!. && check_mind && check_mind.assigned_role == "Sangheili - Shipmaster")
		return check_mind

	. = ..()



/* UNSC */

/datum/faction/unsc
	name = "UNSC"
	contraband_gear = "UNSC"
	enemy_factions = list("Covenant","Insurrection","Flood")
	commander_titles = list("UNSC Bertels Commanding Officer")
	ship_types = list(/obj/effect/overmap/ship/npc_ship/combat/unsc/medium_armed,/obj/effect/overmap/ship/npc_ship/combat/unsc/heavily_armed)
	defender_mob_types = list(/mob/living/simple_animal/hostile/defender_mob/unsc/marine)
	default_radio_channel = RADIO_SQUAD

/datum/faction/unsc/Initialize()
	. = ..()
	leader_name = "[pick("Vice Admiral","Rear Admiral","Admiral","Fleet Admiral")] [leader_name]"
	money_account = create_account("UNSC", 1000000000)		//1 billion credits muahahahaha

/datum/faction/unsc/get_commander(var/datum/mind/check_mind)

	if(!. && check_mind && check_mind.assigned_role == "UNSC Bertels Commanding Officer")
		return check_mind

	. = ..()

/datum/faction/oni
	name = "ONI"
	contraband_gear = "UNSC"
	enemy_factions = list("Covenant","Insurrection","Flood")
	defender_mob_types = list(/mob/living/simple_animal/hostile/defender_mob/unsc/odst)
	default_radio_channel = RADIO_ONI



/* Insurrection */

/datum/faction/insurrection
	name = "Insurrection"
	contraband_gear = "Insurrection"
	enemy_factions = list("UNSC","Covenant","Flood")
	commander_titles = list("Insurrectionist Commander")
	ship_types = list(/obj/effect/overmap/ship/npc_ship/combat/innie/medium_armed,/obj/effect/overmap/ship/npc_ship/combat/innie/heavily_armed)
	defender_mob_types = list(/mob/living/simple_animal/hostile/defender_mob/innie/medium = 3, /mob/living/simple_animal/hostile/defender_mob/innie/heavy)
	default_radio_channel = null

/datum/faction/insurrection/Initialize()
	. = ..()
	money_account = create_account("Geminus Revolutionaries", rand(10,1000))		//little bit of starting cash but not much

/datum/faction/insurrection/proc/get_innie_channel_name()
	if(!default_radio_channel)
		default_radio_channel = pick(GLOB.random_channels)
		GLOB.random_channels -= default_radio_channel

	return default_radio_channel

/datum/faction/insurrection/get_commander(var/datum/mind/check_mind)

	if(!. && check_mind && check_mind.assigned_role == "Insurrectionist Commander")
		return check_mind

	. = ..()



/* Human Civilian */

/datum/faction/human_civ
	name = "Human Colony"
	ship_types = list(/obj/effect/overmap/ship/npc_ship/cargo)



/* Flood */

/datum/faction/flood
	name = "Flood"
	enemy_factions = list("Covenant","Insurrection","Human Colony","UNSC")
	ship_types = list(/obj/effect/overmap/ship/npc_ship/combat/flood)
