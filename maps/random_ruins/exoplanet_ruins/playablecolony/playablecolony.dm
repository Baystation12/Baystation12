/datum/map_template/ruin/exoplanet/playablecolony
	name = "established colony"
	id = "playablecolony"
	description = "a fully functional colony on the frontier of settled space"
	suffixes = list("playablecolony/colony.dmm")
	cost = 2
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS | TEMPLATE_FLAG_NO_RADS
	ruin_tags = RUIN_HUMAN|RUIN_HABITAT
	apc_test_exempt_areas = list(
		/area/map_template/colony/mineralprocessing = NO_SCRUBBER|NO_VENT
	)

/decl/submap_archetype/playablecolony
	descriptor = "established colony"
	crew_jobs = list(/datum/job/submap/colonist)

/datum/job/submap/colonist
	title = "Colonist"
	info = "You are a Colonist, living on the rim of explored, let alone inhabited, space in a reconstructed shelter made from the very ship that took you here."
	total_positions = 6
	outfit_type = /decl/hierarchy/outfit/job/colonist

/decl/hierarchy/outfit/job/colonist
	name = OUTFIT_JOB_NAME("Colonist")
	id_type = null
	pda_type = null

/obj/effect/submap_landmark/spawnpoint/colonist_spawn
	name = "Colonist"

/obj/effect/submap_landmark/joinable_submap/colony
	name = "Established Colony"
	archetype = /decl/submap_archetype/playablecolony

// Areas //
/area/map_template/colony
	name = "\improper Colony Hallways"
	icon_state = "halls"
	icon = 'maps/random_ruins/exoplanet_ruins/playablecolony/colony.dmi'

/area/map_template/colony/engineering
	name = "\improper Colony Engineering"
	icon_state = "processing"

/area/map_template/colony/atmospherics
	name = "\improper Colony Atmospherics"
	icon_state = "shipping"

/area/map_template/colony/bathroom
	name = "\improper Colony Lavatory"
	icon_state = "shower"

/area/map_template/colony/commons
	name = "\improper Colony Common Area"
	icon_state = "A"

/area/map_template/colony/messhall
	name = "\improper Colony Mess Hall"
	icon_state = "B"

/area/map_template/colony/tcomms
	name = "\improper Colony Secure Storage"
	icon_state = "C"

/area/map_template/colony/jail
	name = "\improper Colony Jail"
	icon_state = "D"

/area/map_template/colony/armory
	name = "\improper Colony Armory"
	icon_state = "F"

/area/map_template/colony/hydroponics
	name = "\improper Colony Hydroponics Bay"
	icon_state = "X"

/area/map_template/colony/airlock
	name = "\improper Colony Primary External Airlock"
	icon_state = "airlock"

/area/map_template/colony/medbay
	name = "\improper Colony Hospital"
	icon_state = "D"

/area/map_template/colony/surgery
	name = "\improper Colony Operating Theatre"
	icon_state = "F"

/area/map_template/colony/mineralprocessing
	name = "\improper Colony Mining Bay"
	icon_state = "A"

/area/map_template/colony/command
	name = "\improper Colony Operations Center"
	icon_state = "B"

/area/map_template/colony/dorms
	name = "\improper Colony Dormitories"
	icon_state = "C"
