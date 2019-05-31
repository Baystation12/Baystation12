
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

/datum/faction/unsc
	name = "UNSC"

/datum/faction/insurrection
	name = "Insurrection"

/datum/faction/human_civ
	name = "Human Civilian"
