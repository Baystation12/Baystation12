
/datum/techprint/thickness_patch
	name = "Synthfibre Patch"
	desc = "An armour upgrade increasing armour thickness."
	design_unlocks = list(/datum/research_design/armour_fibre)
	required_materials = list("plasteel" = 10)
	tech_req_all = list(/datum/techprint/compression)

/datum/techprint/diamond_patch
	name = "Diamond Weave Patch"
	desc = "An armour upgrade providing minor resistance to melee and brute force weaponry."
	design_unlocks = list(/datum/research_design/armour_diamond)
	required_materials = list("diamond" = 1)
	tech_req_all = list(/datum/techprint/compression_two)

/datum/techprint/nanolam_patch
	name = "Armour Nanolaminate Patch"
	desc = "An armour upgrade providing minor all round resistance and thickness increase."
	design_unlocks = list(/datum/research_design/armour_nanolaminate)
	required_materials = list("nanolaminate" = 5)
	tech_req_all = list(/datum/techprint/nanolaminate, /datum/techprint/compression_three)
	ticks_max = 250
