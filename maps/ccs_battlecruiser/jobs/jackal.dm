
/datum/job/opredflag_cov/jackal
	title = "Kig-Yar"
	supervisors = "the Elites"
	selection_color = "#9900ff"
	outfit_type = /decl/hierarchy/outfit/kigyar
	whitelisted_species = list(/datum/species/kig_yar)
	spawn_positions = -1
	total_positions = -1

/datum/job/opredflag_cov/jackal/equip(var/mob/living/carbon/human/H, var/alt_title, var/datum/mil_branch/branch)
	. = ..()

	//check if we have been assigned this role and arent just previewing the equipment
	if(H.mind && H.mind.assigned_role == src.title)
		var/client/C = get_client(H)
		if(C)
			C.verbs += /client/proc/list_destinations
			C.verbs += /client/proc/pick_destinations
			C.verbs += /client/proc/direct_destinations

/datum/job/opredflag_cov/skirmisher
	title = "T-Vaoan Skirmisher"
	supervisors = "the Elites"
	selection_color = "#9900ff"
	outfit_type = /decl/hierarchy/outfit/skirmisher_minor
	whitelisted_species = list(/datum/species/kig_yar_skirmisher)
	spawn_positions = -1
	track_players = 1

/datum/job/opredflag_cov/skirmisher/major
	title = "T-Vaoan Skirmisher Major"
	outfit_type = /decl/hierarchy/outfit/skirmisher_major

/datum/job/opredflag_cov/skirmisher/murmillo
	title = "T-Vaoan Skirmisher Murmillo"
	outfit_type = /decl/hierarchy/outfit/skirmisher_murmillo

/datum/job/opredflag_cov/skirmisher/commando
	title = "T-Vaoan Skirmisher Commando"
	outfit_type = /decl/hierarchy/outfit/skirmisher_commando

/datum/job/opredflag_cov/skirmisher/champion
	title = "T-Vaoan Skirmisher Champion"
	outfit_type = /decl/hierarchy/outfit/skirmisher_champion
