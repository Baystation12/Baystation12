
/obj/effect/landmark/faction_defender
	name = "simple mob roundstart defender"
	icon_state = "x"
	var/faction_name

/obj/effect/landmark/faction_defender/Initialize()
	. = ..()
	var/datum/faction/my_faction = GLOB.factions_by_name[faction_name]
	if(my_faction)
		var/to_spawn = pickweight(my_faction.defender_mob_types)
		new to_spawn (src.loc)

/obj/effect/landmark/faction_defender/covenant
	faction_name = "Covenant"

/obj/effect/landmark/faction_defender/unsc
	faction_name = "UNSC"

/obj/effect/landmark/faction_defender/insurrection
	faction_name = "Insurrection"

/obj/effect/landmark/faction_defender/flood
	faction_name = "Flood"
