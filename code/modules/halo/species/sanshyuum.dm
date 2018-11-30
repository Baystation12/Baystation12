
GLOBAL_LIST_INIT(sanshyuum_virtues, world.file2list('code/modules/halo/species_items/sanshyuum_virtues.txt'))
GLOBAL_LIST_INIT(sanshyuum_titles, world.file2list('code/modules/halo/species_items/sanshyuum_titles.txt'))

/datum/species/sanshyuum
	name = "San'Shyuum"
	name_plural = "San'Shyuum"
	blurb = "San'Shyuum (Latin Perfidia vermis, meaning \"Worms of Treachery\"), also \
		known as Prophets by humanity, are a species who are the leadership caste within the \
		Covenant. Prophets to exert complete control over religious and political \
		affairs.  Although physically frail compared to other Covenant species, they wield \
		near absolute power over the Covenant. They have a strong religious importance \
		throughout the Covenant Hierarchy."
	flesh_color = "#4A4A64"
	blood_color = "#4A4A64"
	icobase = 'code/modules/halo/icons/species/r_sanshyuum.dmi' //The DMI needed modification to fit the usual format (see other species' dmis)
	deform = 'code/modules/halo/icons/species/r_sanshyuum.dmi'
	icon_template = 'code/modules/halo/icons/species/sanshyuum_template.dmi'
	default_language = "Sangheili"
	language = "Sangheili"
	secondary_langs = list("Janjur Qomi")
	num_alternate_languages = 1
	total_health = 150		//weaker than a human
	slowdown = 2			//slight slowdown
	equipment_slowdown_multiplier = 2

/datum/species/sanshyuum/get_random_name(var/gender)
	var/newname = "[pick(GLOB.sanshyuum_titles)] of [pick(GLOB.sanshyuum_virtues)]"
	return newname
