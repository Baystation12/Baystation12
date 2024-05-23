/datum/gear/passport/tajara
	display_name = "(Tajara) passport"
	path = /obj/item/passport/xeno/tajara
	whitelisted = list(SPECIES_TAJARA)
	flags = 0
	sort_category = "Xenowear"
	custom_setup_proc = TYPE_PROC_REF(/obj/item/passport, set_info)
	cost = 0

/datum/gear/gloves/dress/modified
	display_name = "modified gloves, dress"
	path = /obj/item/clothing/gloves/color/white/modified
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_TAJARA, SPECIES_UNATHI, SPECIES_YEOSA)
