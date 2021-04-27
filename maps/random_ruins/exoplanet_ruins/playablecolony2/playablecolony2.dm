#include "playablecolony2_radio.dm"

/datum/map_template/ruin/exoplanet/playablecolony2
	name = "Landed Colony Ship"
	id = "playablecolony2"
	description = "a recently landed colony ship"
	suffixes = list("playablecolony2/colony2.dmm")
	spawn_cost = 2
	player_cost = 4
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS | TEMPLATE_FLAG_NO_RADS
	ruin_tags = RUIN_HUMAN|RUIN_HABITAT
	ban_ruins = list(/datum/map_template/ruin/exoplanet/playablecolony)
	apc_test_exempt_areas = list(
		/area/map_template/colony2/external = NO_SCRUBBER|NO_VENT
	)
	spawn_weight = 0.4

/decl/submap_archetype/playablecolony2
	descriptor = "landed colony ship"
	crew_jobs = list(/datum/job/submap/colonist2)

/datum/job/submap/colonist2
	title = "Ship Colonist"
	supervisors = "the trust of your fellow Colonists"
	info = "You are a Colonist, living on the rim of explored, let alone inhabited, space in a recently landed colony ship."
	total_positions = 3
	outfit_type = /decl/hierarchy/outfit/job/colonist2

/decl/hierarchy/outfit/job/colonist2
	name = OUTFIT_JOB_NAME("Colonist2")
	id_types = list()
	pda_type = null
	l_ear = /obj/item/device/radio/headset/map_preset/playablecolony2

/obj/effect/submap_landmark/spawnpoint/colonist_spawn2
	name = "Colonist"

/obj/effect/submap_landmark/joinable_submap/colony2
	name = "Landed Colony Ship"
	archetype = /decl/submap_archetype/playablecolony

// Areas //
/area/map_template/colony2
	icon = 'maps/random_ruins/exoplanet_ruins/playablecolony2/colony2.dmi'

/area/map_template/colony2/Hallway
	name = "\improper Colony Hallway"
	icon_state = "halls"

/area/map_template/colony2/engineering
	name = "\improper Colony Engineering"
	icon_state = "processing"

/area/map_template/colony2/atmospherics
	name = "\improper Colony Atmospherics"
	icon_state = "shipping"

/area/map_template/colony2/commons
	name = "\improper Colony Common Area"
	icon_state = "A"

/area/map_template/colony2/storage
	name = "\improper Colony Storage"
	icon_state = "B"

/area/map_template/colony2/external
	name = "\improper Colony External Infrastructure"
	icon_state = "A"

/area/map_template/colony2/ship
	name = "\improper ICV Halifax Proffer"
	icon_state = "B"

/area/map_template/colony2/tcomms
	name = "\improper Colony Telecommunications"
	icon_state = "B2"
