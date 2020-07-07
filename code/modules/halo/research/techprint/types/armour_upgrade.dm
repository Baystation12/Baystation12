
/datum/techprint/armour_compact_one
	name = "Armour Compact I"
	desc = "Denser armour fabrication allows for modular designs."
	ticks_max = 300

/datum/techprint/thickness_patch
	name = "Synthfibre Patch"
	design_unlocks = list(/datum/research_design/armour_fibre)
	required_materials = list("plasteel" = 10)
	tech_req_all = list(/datum/techprint/armour_compact_one)

/datum/techprint/armour_compact_two
	name = "Armour Compact II"
	desc = "Denser armour fabrication allows for modular designs."
	tech_req_all = list(/datum/techprint/armour_compact_one)
	ticks_max = 400

/datum/techprint/diamond_patch
	name = "Diamond Weave Patch"
	design_unlocks = list(/datum/research_design/armour_diamond)
	required_materials = list("diamond" = 1)
	tech_req_all = list(/datum/techprint/armour_compact_two)

/datum/techprint/armour_compact_three
	name = "Armour Compact III"
	desc = "Denser armour fabrication allows for modular designs."
	tech_req_all = list(/datum/techprint/armour_compact_two)
	ticks_max = 500

/datum/techprint/ablative_patch
	name = "Ablative Patch"
	desc = "An armour upgrade that will provide some minor resistance to plasma weaponry."
	design_unlocks = list(/datum/research_design/armour_ablative)
	required_materials = list("rglass" = 10)
	required_reagents = list(/datum/reagent/lithium = 10)
	tech_req_all = list(/datum/techprint/ablative, /datum/techprint/armour_compact_three)
	tech_req_one = list(/datum/techprint/plasmarifle, /datum/techprint/plasmapistol)
	ticks_max = 250

/datum/techprint/nanolam_patch
	name = "Armour Nanolaminate Patch"
	desc = "This advanced alien alloy is interwoven with UNSC armour."
	design_unlocks = list(/datum/research_design/armour_nanolaminate)
	required_materials = list("nanolaminate" = 5)
	tech_req_all = list(/datum/techprint/nanolaminate, /datum/techprint/armour_compact_three)
	ticks_max = 250
