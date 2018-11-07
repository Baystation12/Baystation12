
GLOBAL_LIST_INIT(sanshyuum_virtues, world.file2list('code/modules/halo/species_items/sanshyuum_virtues.txt'))
GLOBAL_LIST_INIT(sanshyuum_titles, world.file2list('code/modules/halo/species_items/sanshyuum_titles.txt'))

/datum/species/sanshyuum
	name = "San'Shyuum"
	name_plural = "San'Shyuum"
	blurb = "A wrinkly, genetically deteriorating species that functions as the religious leader caste of the Covenant"
	flesh_color = "#4A4A64"
	blood_color = "#4A4A64"
	icobase = 'code/modules/halo/icons/species/r_sanshyuum.dmi' //The DMI needed modification to fit the usual format (see other species' dmis)
	deform = 'code/modules/halo/icons/species/r_sanshyuum.dmi'
	icon_template = 'code/modules/halo/icons/species/r_elite_template.dmi'
	default_language = "Sangheili"
	language = "Sangheili"
	total_health = 150		//weaker than a human
	slowdown = 2			//slight slowdown

/datum/species/sanshyuum/get_random_name(var/gender)
	var/newname = "[pick(GLOB.sanshyuum_titles)] of [pick(GLOB.sanshyuum_virtues)]"
	return newname
