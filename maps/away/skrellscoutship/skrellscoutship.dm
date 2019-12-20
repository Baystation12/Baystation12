#define WEBHOOK_SUBMAP_LOADED_SKRELL "webhook_submap_skrell"

#include "skrellscoutship_areas.dm"
#include "skrellscoutship_shuttles.dm"

/datum/map_template/ruin/away_site/skrellscoutship
	name = "Skrellian Scout Ship"
	id = "awaysite_skrell_scout"
	description = "A Skrellian SDTF scouting vessel."
	suffixes = list("skrellscoutship/skrellscoutship-1.dmm", "skrellscoutship/skrellscoutship-2.dmm")
	cost = 0.5
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/skrellscoutship, /datum/shuttle/autodock/overmap/skrellscoutshuttle)
	apc_test_exempt_areas = list(
		/area/ship/skrellscoutshuttle =                NO_SCRUBBER,
		/area/ship/skrellscoutship/crew/toilets =      NO_SCRUBBER|NO_VENT,
		/area/ship/skrellscoutship/maintenance/power = NO_SCRUBBER,
		/area/ship/skrellscoutship/solars =            NO_SCRUBBER|NO_VENT|NO_APC
	)

/obj/effect/overmap/visitable/sector/skrellscoutspace
	name = "Empty Sector"
	desc = "Slight traces of a cloaking device are present. Unable to determine exact location."
	in_space = 1
	icon_state = "event"
	hide_from_reports = TRUE

/obj/effect/submap_landmark/joinable_submap/skrellscoutship
	name = "Xilvuxix"
	archetype = /decl/submap_archetype/skrellscoutship

/obj/effect/submap_landmark/spawnpoint/skrellscoutship
	name = "Qrri-Zuumqix"
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/submap_landmark/spawnpoint/skrellscoutship/leader
	name = "Qrri-Vuxix"

/decl/webhook/submap_loaded/skrell
	id = WEBHOOK_SUBMAP_LOADED_SKRELL

/decl/submap_archetype/skrellscoutship
	descriptor = "Skrellian Scout Ship"
	map = "Xilvuxix"
	crew_jobs = list(
		/datum/job/submap/skrellscoutship_crew,
		/datum/job/submap/skrellscoutship_crew/leader
	)
	call_webhook = WEBHOOK_SUBMAP_LOADED_SKRELL

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
	is_semi_antagonist = TRUE
	min_skill = list(SKILL_EVA = SKILL_ADEPT,
					SKILL_HAULING = SKILL_ADEPT,
					SKILL_COMBAT = SKILL_ADEPT,
					SKILL_WEAPONS = SKILL_ADEPT,
					SKILL_MEDICAL = SKILL_BASIC)

/datum/job/submap/skrellscoutship_crew/leader
	title = "Qrri-Vuxix"
	supervisors = "your SDTF"
	total_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/skrellscoutship
	info = "Your vessel is scouting through unknown space, working to map out any potential dangers, as well as potential allies."
	is_semi_antagonist = TRUE
	min_skill = list(SKILL_EVA = SKILL_ADEPT,
					SKILL_PILOT = SKILL_ADEPT,
					SKILL_HAULING = SKILL_ADEPT,
					SKILL_COMBAT = SKILL_ADEPT,
					SKILL_WEAPONS = SKILL_ADEPT,
					SKILL_MEDICAL = SKILL_BASIC)

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
			"Mero'tol-Ketish",
			"Goxo'i-Ketish"
		),
		"Raskinta-Katish" = list(
			"Me'kerr-Ketish",
			"Qi'kerr-Ketish",
			"Me'xoal-Ketish"
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

/obj/item/clothing/under/skrelljumpsuit
	name = "black bodysuit"
	desc = "A sleek, skin-tight bodysuit designed to not wick moisture away from the body. The inner stitching appears to contain something written in Skrellian."
	icon_state = "skrell_suit"
	item_state = "skrell_suit"
	worn_state = "skrell_suit"

/decl/hierarchy/outfit/job/skrellscoutship
	name = "Xilvuxix Crew"
	uniform = /obj/item/clothing/under/skrelljumpsuit
	shoes = /obj/item/clothing/shoes/dutyboots
	gloves = /obj/item/clothing/gloves/thick/swat/skrell
	pda_type = /obj/item/modular_computer/pda
	pda_slot = slot_l_store
	l_ear = /obj/item/device/radio/headset/skrellian
	id_type = /obj/item/weapon/card/id/skrellscoutship
	l_pocket = /obj/item/clothing/accessory/badge/tags/skrell

/obj/item/weapon/stock_parts/circuitboard/telecomms/allinone/skrellscoutship
	build_path = /obj/machinery/telecomms/allinone/skrellscoutship

/obj/machinery/telecomms/allinone/skrellscoutship
	listening_freqs = list(SKRELL_FREQ)
	channel_color = COMMS_COLOR_SKRELL
	channel_name = "Recon"
	circuitboard = /obj/item/weapon/stock_parts/circuitboard/telecomms/allinone/skrellscoutship

/obj/item/device/radio/headset/skrellian
	name = "recon headset"
	icon_state = "srv_headset"
	ks1type = /obj/item/device/encryptionkey/skrellian

/obj/item/device/radio/headset/skrellian/Initialize()
	. = ..()
	set_frequency(SKRELL_FREQ)	//Not going to be random or just set to the common frequency, but can be set later.

/obj/item/device/encryptionkey/skrellian
	name = "recon radio encryption key"
	icon_state = "medsci_cypherkey"
	channels = list("Recon" = 1)

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

/obj/machinery/power/apc/skrell
	req_access = list(access_skrellscoutship)

/obj/machinery/alarm/skrell
	req_access = list(access_skrellscoutship)
	target_temperature = T0C+40

/obj/machinery/alarm/skrell/Initialize()
	. = ..()
	TLV["pressure"] =		list(ONE_ATMOSPHERE*0.80,ONE_ATMOSPHERE*0.90,ONE_ATMOSPHERE*1.30,ONE_ATMOSPHERE*1.40) /* kpa */
	TLV["temperature"] =	list(T0C-26, T0C, T0C+80, T0C+90) // K

/obj/machinery/power/smes/buildable/preset/skrell
	uncreated_component_parts = list(
		/obj/item/weapon/stock_parts/smes_coil/super_io = 2,
		/obj/item/weapon/stock_parts/smes_coil/super_capacity = 2)
	_input_maxed = TRUE
	_output_maxed = TRUE
	_input_on = TRUE
	_output_on = TRUE
	_fully_charged = TRUE

/obj/machinery/vending/medical/skrell
	req_access = list(access_skrellscoutship)

#undef WEBHOOK_SUBMAP_LOADED_SKRELL