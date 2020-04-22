
GLOBAL_LIST_INIT(sanshyuum_virtues, world.file2list('code/modules/halo/covenant/species/sanshyuum/sanshyuum_virtues.txt'))
GLOBAL_LIST_INIT(sanshyuum_titles, world.file2list('code/modules/halo/covenant/species/sanshyuum/sanshyuum_titles.txt'))

/datum/species/sanshyuum
	name = "San Shyuum"
	name_plural = "San Shyuum"
	blurb = "San Shyuum (Latin Perfidia vermis, meaning \"Worms of Treachery\"), also \
		known as Prophets by humanity, are a species who are the leadership caste within the \
		Covenant. Prophets to exert complete control over religious and political \
		affairs.  Although physically frail compared to other Covenant species, they wield \
		near absolute power over the Covenant. They have a strong religious importance \
		throughout the Covenant Hierarchy."
	flesh_color = "#4A4A64"
	icobase = 'code/modules/halo/covenant/species/sanshyuum/r_sanshyuum.dmi' //The DMI needed modification to fit the usual format (see other species' dmis)
	deform = 'code/modules/halo/covenant/species/sanshyuum/r_sanshyuum.dmi'
	icon_template = 'code/modules/halo/covenant/species/sanshyuum/sanshyuum_template.dmi'
	default_language = "Sangheili"
	language = "Sangheili"
	additional_langs = list("Janjur Qomi","Galactic Common")
	spawn_flags = SPECIES_CAN_JOIN
	item_icon_offsets = list(list(0,2),list(0,2),null,list(0,2),null,null,null,list(0,2),null)
	total_health = 200		//weaker than a human
	brute_mod = 1.2
	slowdown = 0.5			//slight slowdown
	equipment_slowdown_multiplier = 2
	default_faction = "Covenant"

/datum/species/sanshyuum/get_random_name(var/gender)
	var/newname = "[pick(GLOB.sanshyuum_titles)] of [pick(GLOB.sanshyuum_virtues)]"
	return newname

/mob/living/carbon/human/covenant/sanshyuum/New(var/new_loc)
	. = ..(new_loc,"San Shyuum")
