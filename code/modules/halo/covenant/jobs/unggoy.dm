
/datum/job/covenant/unggoy_minor
	title = "Unggoy Minor"
	total_positions = -1
	spawn_positions = -1
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/unggoy
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
	open_slot_on_death = 1
	outfit_type = /decl/hierarchy/outfit/unggoy/major
	whitelisted_species = list(/datum/species/unggoy)

/datum/job/covenant/unggoy_ultra
	title = "Unggoy Ultra"
	total_positions = 2
	spawn_positions = 2
	outfit_type = /decl/hierarchy/outfit/unggoy/ultra
	faction_whitelist = "Covenant"
	whitelisted_species = list(/datum/species/unggoy)

/datum/job/covenant/unggoy_deacon
	title = "Unggoy Deacon"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/unggoy/deacon
	faction_whitelist = "Covenant"
	whitelisted_species = list(/datum/species/unggoy)



/* Not available during standard play */

/datum/job/covenant/unggoy_specops
	title = "Special Operations Unggoy"
	supervisors = "the Elites"
	outfit_type = /decl/hierarchy/outfit/unggoy/specops
	spawn_positions = 0
	total_positions = 0
	faction_whitelist = "Covenant"
