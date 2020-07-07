
/datum/techprint/holo
	name = "Holographic Projectors"
	desc = "Realistic holographic projectors able to fool the naked eye."
	tech_req_all = list(/datum/techprint/sensors)
	required_materials = list("glass" = 20)
	ticks_max = 50
/*
/datum/techprint/holo_suit
	name = "Holographic Suit"
	desc = "Modular design and placement of holographic projectors to quickly and easily change your appearance."
	tech_req_all = list(/datum/techprint/holo)
	ticks_max = 75
*/
/datum/techprint/passive_camo
	name = "Passive Camouflage"
	desc = "Photoreactive panels can fool optical sensors vastly more effectively than conventional camoflage."
	tech_req_all = list(/datum/techprint/holo)
	ticks_max = 125

/datum/techprint/active_camo
	name = "Active Camouflage"
	desc = "Advanced alien technology that employs light bending energy fields for true invisibility."
	tech_req_all = list(/datum/techprint/passive_camo, /datum/techprint/sangheili_bodysuit_specops)
	ticks_max = 200
