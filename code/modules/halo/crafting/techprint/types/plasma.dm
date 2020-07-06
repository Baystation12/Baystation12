
/datum/techprint/plasmadet
	name = "Plasma Detonation"
	desc = "Controlled explosive release of high pressure superheated plasma."
	ticks_max = 55
	required_objs = list(/obj/item/plasma_core = "plasma core")
	tech_req_all = list(\
		/datum/techprint/kemocite)
	tech_req_one = list(\
		/datum/techprint/plasmanade,\
		/datum/techprint/plasmacharge)

/datum/techprint/plasma_generation
	name = "Plasma Generation"
	desc = "Generation methods to consistently produce superheated plasma."
	required_reagents = list(/datum/reagent/toxin/phoron = 100)
	required_objs = list(/obj/item/plasma_core = "plasma core")
	tech_req_one = list(/datum/techprint/plasmarifle, /datum/techprint/plasmapistol)
	tech_req_all = list(/datum/techprint/plasmanade)
	ticks_max = 100

/datum/techprint/plasma_storage
	name = "Plasma Storage"
	desc = "Suspension fields to safely store superheated plasma for long periods of time."
	tech_req_one = list(/datum/techprint/plasmarifle, /datum/techprint/plasmapistol)
	required_objs = list(/obj/item/plasma_core = "plasma core")
	ticks_max = 100

/datum/techprint/plasma_channeling
	name = "Plasma Channelling"
	desc = "Magnetic field manipulation to shape and direct plasma bursts."
	tech_req_one = list(/datum/techprint/plasmarifle, /datum/techprint/plasmapistol)
	required_objs = list(/obj/item/plasma_core = "plasma core")
	ticks_max = 100
