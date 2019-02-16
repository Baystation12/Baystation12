/datum/map/overmap_example
	name = "Bearcat"
	full_name = "Bearcat"
	path = "overmap_example"

	station_name  = "FTV Bearcat"
	station_short = "Bearcat"

	dock_name     = "FTS Capitalist's Rest"
	boss_name     = "FTU Merchant Navy"
	boss_short    = "Merchant Admiral"
	company_name  = "Legit Cargo Ltd."
	company_short = "LC"
	overmap_event_areas = 11

	default_law_type = /datum/ai_laws/corporate

	evac_controller_type = /datum/evacuation_controller/lifepods
	lobby_icon = 'maps/overmap_example/overmap_example_lobby.dmi'
	lobby_screens = list("spess","aesthetic")

	allowed_spawns = list("Cryogenic Storage")
	default_spawn = "Cryogenic Storage"
	use_overmap = 1
	num_exoplanets = 3
	welcome_sound = 'sound/effects/cowboysting.ogg'

	emergency_shuttle_leaving_dock = "Attention all hands: the escape pods have been launched, maintaining burn for %ETA%."

	emergency_shuttle_called_message = "Attention all hands: emergency evacuation procedures are now in effect. Escape pods will launch in %ETA%"
	emergency_shuttle_called_sound = sound('sound/AI/torch/abandonship.ogg', volume = 45)

	emergency_shuttle_recall_message = "Attention all hands: emergency evacuation sequence aborted. Return to normal operating conditions."

	starting_money = 5000
	department_money = 0
	salary_modifier = 0.2

/datum/map/overmap_example/map_info(victim)
	to_chat(victim, "Welcome aboard the TRCV Sandros, a Colony Vessel with the purpose of colonizing a new planetary body in undiscovered space. Something strange happened though... <br>The Vessel is staffed by a mixture of Civilian and TRDF Personnel.<br> This area of space is uncharged, and away from TRDF territories. The likelihood of encountering any civilized humans in this part of space is null, and no known governments or species hold these systems.")

/datum/map/overmap_example/setup_map()
	..()
	SStrade.traders += new /datum/trader/xeno_shop
	SStrade.traders += new /datum/trader/medical
	SStrade.traders += new /datum/trader/mining