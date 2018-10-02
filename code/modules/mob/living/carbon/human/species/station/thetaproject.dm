//Should add in Theta Project Race
/mob/living/carbon/human/theta/New(var/new_loc)
	..(new_loc,"theta")

//Theta's will be all around slightly worse then an Orion as they are knockoffs of the Orion Project.
/datum/species/theta
	name = "Theta"
	name_plural = "Theta Subject"
	spawn_flags = SPECIES_IS_RESTRICTED
	total_health = 210 //Slightly more health then a normal human
	metabolism_mod = 1.35 //Slightly faster metabolism
	darksight = 3 //Slightly better night vision!
	slowdown = -1 //Increased move speed

	//Spartan 1's have a bit better temperature tolerance
	siemens_coefficient = 0.9 //Better insulated against temp changes
	heat_discomfort_level = 355 //Normal human is 315
	cold_discomfort_level = 255 // Normal human is 285
	//Buff to temperature damage levels (5% per level)
	heat_level_1 = 380 //~107C
	heat_level_2 = 420 //147C
	heat_level_3 = 1050 //777C
	cold_level_1 = 247 //-26C
	cold_level_2 = 190 //-83C
	cold_level_3 = 114 //-159C
	blood_volume = 580 // Normal Human has 560