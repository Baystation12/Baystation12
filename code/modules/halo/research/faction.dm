
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
		//
		/*
		/datum/techprint/kemocite,
		/datum/techprint/duridium,
		/datum/techprint/corundum,
		*/
		//
		/datum/techprint/data,
		/datum/techprint/processing,
		//
		/datum/techprint/miniaturisation,
		/datum/techprint/energy,
		/datum/techprint/compression,
		/datum/techprint/lasers,
		/datum/techprint/sensors)

	base_designs = list(\
		/datum/research_design/drive,
		/datum/research_design/drive_micro
		/datum/research_design/processor,
		/datum/research_design/processor_small,
		/datum/research_design/portable_drive,
		//
		/datum/research_design/recharger,
		/datum/research_design/cell_charger,
		//
		/datum/research_design/implanter,
		/datum/research_design/implant_adrenaline,
		/datum/research_design/implant_chem,
		//
		/datum/research_design/language_learner_english,
		/datum/research_design/implant_english)
