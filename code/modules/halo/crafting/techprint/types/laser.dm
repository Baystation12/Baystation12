
/datum/techprint/laser
	name = "Directed Energy Beams"
	desc = "The technology to create and manipulate high power laser beams."
	tech_req_all = list(/datum/techprint/energy)
	ticks_max = 300

/datum/techprint/splaser
	name = "M6 Grindell/Galilean Nonlinear Rifle"
	desc = "One of the most devastating anti-tank weapons in the UNSC arsenal."
	tech_req_all = list(/datum/techprint/laser)
	design_unlocks = list(/datum/research_design/splaser)
	ticks_max = 300

/datum/techprint/railgun
	name = "Asymmetric Recoilless Carbine-920"
	desc = "Designed to penetrate armour with projectiles transmitted using magnetic accelerator technology."
	tech_req_all = list(/datum/techprint/laser)
	design_unlocks = list(/datum/research_design/railgun)
	ticks_max = 200
