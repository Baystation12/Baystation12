
/datum/techprint/forerunner_nanites
	name = "Foreunner Nanite Analysis"
	desc = "????"
	hidden = TRUE
	required_reagents = list(/datum/reagent/nanites = 100)

/datum/techprint/armour_nanites
	name = "Repair Nanites"
	desc = "Will gradually restore chest armour to an undamaged state."
	tech_req_all = list(/datum/techprint/forerunner_nanites)
	ticks_max = 110

/datum/techprint/flood_tox
	name = "Flood Toxin Analysis"
	desc = "????"
	hidden = TRUE
	required_reagents = list(/datum/reagent/floodinfectiontoxin = 10)
