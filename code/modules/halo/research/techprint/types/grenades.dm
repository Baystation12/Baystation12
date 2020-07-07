/*
//superseded by other techs
/datum/techprint/empnade
	name = "EMP grenade"
	desc = "Single use, localised disabling of equipment in an easy-to-use-package."
	design_unlocks = list(/datum/research_design/emp_grenade)
	required_reagents = list(/datum/reagent/uranium = 20, /datum/reagent/silver = 20)
	ticks_max = 55
	tech_req_all = list(/datum/techprint/electromagnetism)

/datum/techprint/antiphotonnade
	name = "Anti-Photon grenade"
	desc = "Single use, localised darkness."
	design_unlocks = list(/datum/research_design/anti_photon_grenade)
	required_reagents = list(/datum/reagent/uranium = 20, /datum/reagent/silver = 20)
	ticks_max = 55
	tech_req_all = list(/datum/techprint/energy)
*/

/datum/techprint/high_yield_frag
	name = "High Yield Fragmentation"
	desc = "For when you really need to shred something."
	design_unlocks = list(/datum/research_design/high_yield_frag)
	required_materials = list("steel" = 50, "plasteel" = 50)
	required_reagents = list(/datum/reagent/copper = 20)
	ticks_max = 55
	tech_req_one = list(\
		/datum/techprint/needler,\
		/datum/techprint/needle_rifle)
