
/datum/techprint/ma5p
	name = "MA5P Plasma ICWS"
	desc = "The next generation iteration of the Infantry Combat Weapon System firing superheated plasma."
	design_unlocks = list(/datum/research_design/plasma_rifle, /datum/research_design/plasma_rifle_mag)
	required_reagents = list(/datum/reagent/toxin/phoron = 10)
	ticks_max = 135
	tech_req_all = list(\
		/datum/techprint/plasma_generation,\
		/datum/techprint/plasma_storage,\
		/datum/techprint/plasma_channeling)

/datum/techprint/m414
	name = "M414 Plasma DMR"
	desc = "The next generation iteration of the Designated Marksman Rifle firing superheated plasma."
	design_unlocks = list(/datum/research_design/plasma_marksman, /datum/research_design/plasma_marksman_mag)
	required_reagents = list(/datum/reagent/toxin/phoron = 10)
	ticks_max = 135
	tech_req_all = list(\
		/datum/techprint/plasma_generation,\
		/datum/techprint/plasma_storage,\
		/datum/techprint/plasma_channeling)

/datum/techprint/railgun
	name = "Asymmetric Recoilless Carbine-920"
	desc = "Designed to penetrate armour with projectiles transmitted using magnetic accelerator technology."
	tech_req_all = list(/datum/techprint/lasers_two, /datum/techprint/electromagnetism)
	design_unlocks = list(/datum/research_design/railgun)
	ticks_max = 200

/datum/techprint/splaser
	name = "M6 Grindell/Galilean Nonlinear Rifle"
	desc = "One of the most devastating anti-tank weapons in the UNSC arsenal."
	tech_req_all = list(/datum/techprint/lasers_three)
	design_unlocks = list(/datum/research_design/splaser)
	ticks_max = 300
