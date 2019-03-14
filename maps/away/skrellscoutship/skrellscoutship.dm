#include "skrellscoutship_areas.dm"
#include "skrellscoutship_shuttles.dm"

/datum/map_template/ruin/away_site/skrellscoutship
	name = "Skrellian Scout Ship"
	id = "awaysite_skrell_scout"
	description = "A Skrellian SDTF scouting vessel."
	suffixes = list("skrellscoutship/skrellscoutship-1.dmm", "skrellscoutship/skrellscoutship-2.dmm")
	cost = 0.5
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/skrellscoutship, /datum/shuttle/autodock/overmap/skrellscoutshuttle)
	
/obj/effect/overmap/sector/skrellscoutspace
	name = "Empty Sector"
	desc = "Slight traces of a cloaking device are present. Unable to determine exact location."
	in_space = 1
	icon_state = "event"

/obj/effect/submap_landmark/joinable_submap/skrellscoutship
	name = "Xilvuxix"
	archetype = /decl/submap_archetype/skrellscoutship
	
/obj/effect/submap_landmark/spawnpoint/skrellscoutship
	name = "Qrri-Zuumqix"
	
/obj/effect/submap_landmark/spawnpoint/skrellscoutship/leader
	name = "Qrri-Vuxix"

/decl/submap_archetype/skrellscoutship
	descriptor = "Skrellian Scout Ship"
	map = "Xilvuxix"
	crew_jobs = list(
		/datum/job/submap/skrellscoutship_crew,
		/datum/job/submap/skrellscoutship_crew/leader
	)
	
//Access + Loadout	

/var/const/access_skrellscoutship = "ACCESS_SKRELLSCOUT"

/datum/access/skrellscoutship
	id = access_skrellscoutship
	desc = "SSV Crewman"
	region = ACCESS_REGION_NONE

/obj/item/weapon/card/id/skrellscoutship
	color = COLOR_GRAY40
	detail_color = "#7331c4"
	access = list(access_skrellscoutship)
	
/datum/job/submap/skrellscoutship_crew
	title = "Qrri-Zuumqix"
	supervisors = "your Qrri-Vuxix"
	total_positions = 5
	whitelisted_species = list("Skrell")
	outfit_type = /decl/hierarchy/outfit/job/skrellscoutship
	info = "Your vessel is scouting through unknown space, working to map out any potential dangers, as well as potential allies."
	branch = /datum/mil_branch/skrell_fleet
	rank = /datum/mil_rank/skrell_fleet
	allowed_branches = list(/datum/mil_branch/skrell_fleet)
	allowed_ranks = list(/datum/mil_rank/skrell_fleet)
	skill_points = 30

/datum/job/submap/skrellscoutship_crew/leader
	title = "Qrri-Vuxix"
	supervisors = "your SDTF"
	total_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/skrellscoutship
	info = "Your vessel is scouting through unknown space, working to map out any potential dangers, as well as potential allies."
	
/datum/job/submap/skrellscoutship_crew/equip(var/mob/living/carbon/human/H, var/alt_title, var/datum/mil_branch/branch, var/datum/mil_rank/grade)
	. = ..(H, alt_title, branch, grade)	//passing through arguments
	//Limited to subcastes that make sense on the vessel. No need for ground-forces or R&D on such a ship.
	var/skrellscoutcastes = list(
		"Malish-Katish" = list(
			"Mero'ta-Ketish", 
			"Toglo'i-Ketish"
		),
		"Kanin-Katish" = list(
			"Xiqarr-Ketish", 
			"Mero'tol-Ketish"
		),
		"Raskinta-Katish" = list(
			"Me'kerr-Ketish", 
			"Qi'kerr-Ketish"
		)
	)
		
	var/skrellcaste = input(H, "What is your Skrell's Caste?", "SDTF Rank") as null|anything in skrellscoutcastes
	if(skrellcaste)
		var/skrellsubcaste = input(H, "What is your Skrell's Subcaste?", "SDTF Rank") as null|anything in skrellscoutcastes[skrellcaste]
		var/obj/item/weapon/card/id/C = H.wear_id
		if(istype(C))
			C.assignment = skrellsubcaste
	
/obj/item/clothing/gloves/thick/swat/skrell
	name = "black gloves"
	desc = "A pair of black, reinforced gloves. The tag on the inner stitching appears to be written in some form of Skrellian."

/decl/hierarchy/outfit/job/skrellscoutship
	name = "Xilvuxix Crew"
	uniform = /obj/item/clothing/under/color/black
	shoes = /obj/item/clothing/shoes/dutyboots
	gloves = /obj/item/clothing/gloves/thick/swat/skrell
	pda_type = /obj/item/modular_computer/pda
	pda_slot = slot_l_store
	l_ear = /obj/item/device/radio/headset/skrellian
	id_type = /obj/item/weapon/card/id/skrellscoutship
	l_pocket = /obj/item/clothing/accessory/badge/tags/skrell

/obj/item/weapon/circuitboard/telecomms/allinone/skrellscoutship
	build_path = /obj/machinery/telecomms/allinone/skrellscoutship

/obj/machinery/telecomms/allinone/skrellscoutship
	listening_freqs = list(SKRELL_FREQ)
	channel_color = "#7331c4"
	channel_name = "Recon"
	circuitboard = /obj/item/weapon/circuitboard/telecomms/allinone/skrellscoutship
	
/obj/item/device/radio/headset/skrellian
	name = "recon headset"
	icon_state = "srv_headset"
	ks1type = /obj/item/device/encryptionkey/skrellian
	
/obj/item/device/radio/headset/skrellian/Initialize()
	..()
	set_frequency(SKRELL_FREQ)	//Not going to be random or just set to the common frequency, but can be set later.
	
/obj/item/device/encryptionkey/skrellian
	name = "recon radio encryption key"
	icon_state = "medsci_cypherkey"
	channels = list("Skrell" = 1)

/obj/item/weapon/reagent_containers/food/condiment/psilocybin
	label_text = "Psilocybin"
	starting_reagents = list(/datum/reagent/psilocybin = 50)


/obj/item/weapon/reagent_containers/food/condiment/mindbreaker
	label_text = "Mindbreaker"
	starting_reagents = list(/datum/reagent/mindbreaker = 50)


/obj/item/weapon/reagent_containers/food/condiment/space_drugs
	label_text = "Ambrosia"
	starting_reagents = list(/datum/reagent/space_drugs = 50)
	
	
/datum/mil_branch/skrell_fleet
	name = "Skrellian Defense Task Force"
	name_short = "SDTF"
	email_domain = "sdtf.qb"
	
	rank_types = list(/datum/mil_rank/skrell_fleet)
	spawn_rank_types = list(/datum/mil_rank/skrell_fleet)
		
/datum/mil_rank/skrell_fleet
	name = "NULL"
	