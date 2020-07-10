
/datum/faction
	var/list/base_techprints = list()
	var/list/base_designs = list()

/datum/faction/proc/get_base_techprints()
	return base_techprints.Copy()

/datum/faction/proc/get_base_designs()
	return base_designs

/datum/faction/unsc
	base_techprints = list(\
		/datum/techprint/unknown,
		//,
		/datum/techprint/data,
		/datum/techprint/processing,
		//,
		/datum/techprint/biology,
		/datum/techprint/miniaturisation,
		/datum/techprint/energy,
		/datum/techprint/compression,
		/datum/techprint/lasers,
		/datum/techprint/sensors)

	base_designs = list(\
		/datum/research_design/circuit/recharger,
		/datum/research_design/circuit/cell_charger,
		/datum/research_design/circuit/cell_charger,
		/datum/research_design/circuit/cell_charger,
		/datum/research_design/circuit/cell_charger,
		/datum/research_design/circuit/cell_charger,
		//,
		/datum/research_design/implanter,
		//,
		/datum/research_design/language_learner_english,
		/datum/research_design/implant_english)
