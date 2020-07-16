
/datum/techprint/compression
	name = "Matter Compression I"
	desc = "Storing matter more compactly and efficiently."
	required_materials = list("plasteel" = 10)
	required_reagents = list(/datum/reagent/carbon = 10, /datum/reagent/acid/hydrochloric = 10)
	ticks_max = 60
	design_unlocks = list(\
		/datum/research_design/basic_matter_bin,\
		/datum/research_design/adv_drill,\
		/datum/research_design/plastique)

/datum/techprint/compression_two
	name = "Matter Compression II"
	desc = "Storing matter more compactly and efficiently."
	tech_req_all = list(/datum/techprint/compression)
	required_materials = list("plasteel" = 20)
	required_reagents = list(/datum/reagent/carbon = 20, /datum/reagent/acid/hydrochloric = 20)
	ticks_max = 120
	design_unlocks = list(\
		/datum/research_design/adv_matter_bin,\
		/datum/research_design/diamonddrill,\
		/datum/research_design/implant_explosive)

/datum/techprint/compression_three
	name = "Matter Compression III"
	desc = "Storing matter more compactly and efficiently."
	tech_req_all = list(/datum/techprint/compression_two)
	required_materials = list("plasteel" = 30, "osmium-carbide plasteel" = 5)
	required_reagents = list(/datum/reagent/carbon = 30, /datum/reagent/acid/hydrochloric = 30)
	ticks_max = 300
	design_unlocks = list(\
		/datum/research_design/super_matter_bin,\
		/datum/research_design/jackhammer,\
		/datum/research_design/implant_compressed)
