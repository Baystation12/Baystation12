/*
//meme machine is working on sprites for these... have a human sprite now need a spartan 2 sprite
/datum/techprint/spi_armour_one
	name = "Semi-Powered Infiltration Armour I"
	desc = "Next generation stealth armour with the cost saving benefit of reduced protectiveness."
	tech_req_all = list(\
		/datum/techprint/armour_compact_two,\
		/datum/techprint/passive_camo)
	ticks_max = 200

/datum/techprint/spi_armour_two
	name = "Semi-Powered Infiltration Armour II"
	desc = "Greater protection is added without sacrificing stealth via a liquid nanocrystal layer and plasma ablative patches."
	tech_req_all = list(\
		/datum/techprint/spi_armour_one,\
		/datum/techprint/ablative_patch,\
		/datum/techprint/liquid_nanocrystal)
	ticks_max = 250
*/

/*
//superseded by other techprints
/datum/techprint/liquid_nanocrystal
	name = "Liquid nanocrystals"
	desc = "Improved carbon nanotubing for stronger, lighter materials."
	required_materials = list("steel" = 10, "glass" = 10)
	required_reagents = list(/datum/reagent/carbon = 50)
	ticks_max = 75
	tech_rech_all = list(/datum/techprint/compression_three)
*/