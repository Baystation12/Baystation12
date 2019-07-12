GLOBAL_LIST_EMPTY(all_factions)
GLOBAL_LIST_EMPTY(factions_by_name)
GLOBAL_LIST_EMPTY(factions_by_type)

GLOBAL_DATUM_INIT(UNSC, /datum/faction/unsc, new /datum/faction/unsc())
GLOBAL_DATUM_INIT(COVENANT, /datum/faction/covenant, new /datum/faction/covenant())
GLOBAL_DATUM_INIT(INSURRECTION, /datum/faction/insurrection, new /datum/faction/insurrection())
GLOBAL_DATUM_INIT(HUMAN_CIV, /datum/faction/human_civ, new /datum/faction/human_civ())
/*
/hook/startup/proc/generate_factions()
	if(!GLOB.all_factions.len)
		for(var/faction_type in typesof(/datum/faction) - /datum/faction)
			var/datum/faction/F = new faction_type()
			GLOB.all_factions.Add(F)
			GLOB.factions_by_name[F.name] = F
	return 1
*/
/datum/faction
	var/name = "Unknown faction"
	var/points = 0
	var/list/all_objectives = list()
	var/list/assigned_minds = list()
	var/list/living_minds = list()
	var/max_points = 0
	var/ignore_players_dead = 0
	var/obj/effect/overmap/flagship
	var/obj/effect/overmap/base
	var/list/enemy_factions = list()
	var/list/active_quests = list()
	var/list/complete_quests = list()
	var/datum/job/commander_job		//this needs to be set in the gamemode code
	var/has_flagship = 0
	var/flagship_slipspaced = 0
	var/has_base = 0
	var/base_desc
	var/destroyed_reason = null

/datum/faction/New()
	. = ..()
	GLOB.all_factions.Add(src)
	GLOB.factions_by_name[src.name] = src
	GLOB.factions_by_type[src.type] = src

/datum/faction/proc/players_alive()
	return living_minds.len

/datum/faction/proc/get_flagship()
	return flagship

/*/datum/faction/proc/find_flagship()
	for(var/obj/effect/overmap/ship in world)
		if(ship.faction != src.name)
			continue
		if(ship.flagship)
			flagship = ship
			break*/

/datum/faction/proc/get_base()
	return base

/*/datum/faction/proc/find_base()
	for(var/obj/effect/overmap/sector in world)
		if(sector.faction != src.name)
			continue
		if(sector.base)
			base = sector
			break*/

/datum/faction/proc/get_commander(var/datum/mind/check_mind)
	if(commander_job)
		for(var/mind in commander_job.assigned_players)
			return mind

/datum/faction/proc/get_objective_delivery_areas()
	return list()



/* Covenant */

/datum/faction/covenant
	name = "Covenant"
	var/list/objective_types = list()
	enemy_factions = list("UNSC","Insurrection")

/datum/faction/covenant/get_commander(var/datum/mind/check_mind)
	. = ..()

	if(!. && check_mind.assigned_role == "Sangheili - Shipmaster")
		return check_mind



/* UNSC */

/datum/faction/unsc
	name = "UNSC"
	enemy_factions = list("Covenant","Insurrection")

/datum/faction/unsc/get_commander(var/datum/mind/check_mind)
	. = ..()

	if(!. && check_mind.assigned_role == "UNSC Bertels Commanding Officer")
		return check_mind



/* Insurrection */

/datum/faction/insurrection
	name = "Insurrection"
	enemy_factions = list("UNSC","Covenant")

/datum/faction/insurrection/get_commander(var/datum/mind/check_mind)
	. = ..()

	if(!. && check_mind.assigned_role == "Insurrectionist Commander")
		return check_mind

/datum/faction/human_civ
	name = "Human Colony"
