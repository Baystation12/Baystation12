GLOBAL_LIST_EMPTY(all_factions)
GLOBAL_LIST_EMPTY(factions_by_name)

/hook/startup/proc/generate_factions()
	if(!GLOB.all_factions.len)
		for(var/faction_type in typesof(/datum/faction) - /datum/faction)
			var/datum/faction/F = new faction_type()
			GLOB.all_factions.Add(F)
			GLOB.factions_by_name[F.name] = F
	return 1

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

/datum/faction/proc/players_alive()
	return living_minds.len

/datum/faction/proc/get_flagship()
	if(!flagship)
		for(var/obj/effect/overmap/ship in world)
			if(ship.faction != src.name)
				continue
			if(ship.flagship)
				flagship = ship
				break
	return flagship

/datum/faction/proc/get_base()
	if(!base)
		for(var/obj/effect/overmap/sector in world)
			if(sector.faction != src.name)
				continue
			if(sector.base)
				base = sector
				break
	return base

/datum/faction/covenant
	name = "Covenant"
	var/list/objective_types = list()
	enemy_factions = list("UNSC","Insurrection")

/datum/faction/unsc
	name = "UNSC"
	enemy_factions = list("Covenant","Insurrection")

/datum/faction/insurrection
	name = "Insurrection"
	enemy_factions = list("UNSC","Covenant")

/datum/faction/human_civ
	name = "Human Colony"
