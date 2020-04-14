
/datum/job/covenant/unggoy_minor
	title = "Unggoy"
	total_positions = -1
	spawn_positions = -1
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/unggoy
	access = list(230,250)
	whitelisted_species = list(/datum/species/unggoy)

/datum/job/covenant/unggoy_minor/get_outfit(var/mob/living/carbon/human/H, var/alt_title, var/datum/mil_branch/branch)

	//free upgrade to grunt major if you're covenant whitelisted
	if(whitelist_lookup("Covenant", H))
		return outfit_by_type(/decl/hierarchy/outfit/unggoy/major)

	return ..()

/datum/job/covenant/unggoy_major
	title = "Unggoy Major"
	total_positions = 4
	spawn_positions = 4
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/unggoy/major
	access = list(230,250)
	whitelisted_species = list(/datum/species/unggoy)

/datum/job/covenant/unggoy_ultra
	title = "Unggoy Ultra"
	total_positions = 2
	spawn_positions = 2
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/unggoy/ultra
	access = list(230,250)
	faction_whitelist = "Covenant"
	whitelisted_species = list(/datum/species/unggoy)

/datum/job/covenant/unggoy_deacon
	title = "Unggoy Deacon"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/unggoy/deacon
	access = list(230,250)
	faction_whitelist = "Covenant"
	whitelisted_species = list(/datum/species/unggoy)
