
/datum/techprint/ablative
	name = "Ablative materials I"
	desc = "A reflective plastalloy that better disperses energy."
	required_materials = list("glass" = 10, "plastic" = 10, "steel" = 10)

/datum/techprint/fragment
	name = "Fragmenting Materials I"
	desc = "Better understanding of fragmenting metals."
	required_materials = list("steel" = 20, "plasteel" = 20)

/datum/techprint/fragment_two
	name = "Fragmenting Materials II"
	desc = "Better understanding of fragmenting metals."
	required_materials = list("steel" = 50, "plasteel" = 50)
	tech_req_all = list(\
		/datum/techprint/fragment)
	tech_req_one = list(\
		/datum/techprint/needler,\
		/datum/techprint/needle_rifle)

/datum/techprint/energy
	name = "Energetic Materials I"
	desc = "Better understanding of high energy matter."
	required_materials = list("glass" = 30)
	required_objs = list(/obj/item/stack/cable_coil = "Cable coil")
	required_reagents = list(/datum/reagent/toxin/phoron = 10, /datum/reagent/phosphorus = 10, /datum/reagent/radium = 10)
	ticks_max = 300

/datum/techprint/electromagnetism
	name = "Electro-magnetic Fields I"
	desc = "Weaponised electromagnetic fields for targetted disabling of equipment."
	required_reagents = list(/datum/reagent/silver = 20)
	ticks_max = 75
	tech_req_all = list(\
		/datum/techprint/energy)
/*
/datum/techprint/cryptomine
	name = "Mine for crypto"
	desc = "Spend a few processor cycles being useless."
	ticks_max = 20
*/
/datum/techprint/liquid_nanocrystal
	name = "Liquid nanocrystals"
	desc = "Improved carbon nanotubing for stronger, lighter materials."
	required_materials = list("steel" = 50)
	required_reagents = list(/datum/reagent/mercury = 50)
	ticks_max = 100

/*
there's actually no way to obtain /datum/reagent/toxin/plasticide except for some random mushroom lol
*/
