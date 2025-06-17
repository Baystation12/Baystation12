#define WEBHOOK_SUBMAP_LOADED_SKRELL "webhook_submap_skrell"

#include "skrellscoutship_areas.dm"
#include "skrellscoutship_shuttles.dm"
#include "skrellscoutship_radio.dm"
#include "skrellscoutship_machines.dm"

/datum/map_template/ruin/away_site/skrellscoutship
	name = "Skrellian Scout Ship"
	id = "awaysite_skrell_scout"
	description = "A Skrellian SDTF scouting vessel."
	suffixes = list("skrellscoutship/skrellscoutship_revamp.dmm")
	spawn_cost = 0.5
	player_cost = 4
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/skrellscoutship, /datum/shuttle/autodock/overmap/skrellscoutshuttle)
	apc_test_exempt_areas = list(
		/area/ship/skrellscoutship/externalwing/port = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/ship/skrellscoutship/externalwing/starboard = NO_SCRUBBER|NO_VENT|NO_APC
	)
	spawn_weight = 0.67

/obj/overmap/visitable/sector/skrellscoutspace
	name = "Empty Sector"
	desc = "Slight traces of a cloaking device are present. Unable to determine exact location."
	icon_state = "event"
	hide_from_reports = TRUE
	sensor_visibility = 10

/obj/submap_landmark/joinable_submap/skrellscoutship
	name = "Xilvuxix"
	archetype = /singleton/submap_archetype/skrellscoutship

/obj/submap_landmark/spawnpoint/skrellscoutship
	name = "Qrri-Zuumqix"
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/submap_landmark/spawnpoint/skrellscoutship/leader
	name = "Qrri-Vuxix"

/singleton/webhook/submap_loaded/skrell
	id = WEBHOOK_SUBMAP_LOADED_SKRELL

/singleton/submap_archetype/skrellscoutship
	descriptor = "Skrellian Scout Ship"
	map = "Xilvuxix"
	crew_jobs = list(
		/datum/job/submap/skrellscoutship_crew,
		/datum/job/submap/skrellscoutship_crew/leader
	)
	call_webhook = WEBHOOK_SUBMAP_LOADED_SKRELL

//Loadout

/obj/item/card/id/skrellscoutship
	color = COLOR_GRAY40
	detail_color = "#7331c4"
	access = list(access_skrellscoutship)

/datum/job/submap/skrellscoutship_crew/leader
	title = "Qrri-Vuxix"
	supervisors = "your SDTF"
	total_positions = 1
	outfit_type = /singleton/hierarchy/outfit/job/skrellscoutship
	info = "Your vessel is scouting through unknown space, working to map out any potential dangers, as well as potential allies."
	is_semi_antagonist = TRUE
	min_skill = list( // 24 points
		SKILL_EVA = SKILL_TRAINED, // 2 points
		SKILL_PILOT = SKILL_TRAINED, // 4 points
		SKILL_HAULING = SKILL_TRAINED, // 2 points
		SKILL_COMBAT = SKILL_TRAINED, // 6 points
		SKILL_WEAPONS = SKILL_TRAINED, // 6 points
		SKILL_MEDICAL = SKILL_BASIC // 4 points
	)

/datum/job/submap/skrellscoutship_crew
	title = "Qrri-Zuumqix"
	supervisors = "your Qrri-Vuxix"
	total_positions = 5
	whitelisted_species = list("Skrell")
	outfit_type = /singleton/hierarchy/outfit/job/skrellscoutship
	info = "Your vessel is scouting through unknown space, working to map out any potential dangers, as well as potential allies."
	branch = /datum/mil_branch/skrell_fleet
	rank = /datum/mil_rank/skrell_fleet
	allowed_branches = list(/datum/mil_branch/skrell_fleet)
	allowed_ranks = list(/datum/mil_rank/skrell_fleet)
	skill_points = 30
	is_semi_antagonist = TRUE
	min_skill = list( // 20 points
		SKILL_EVA = SKILL_TRAINED, // 2 points
		SKILL_HAULING = SKILL_TRAINED, // 2 points
		SKILL_COMBAT = SKILL_TRAINED, // 6 points
		SKILL_WEAPONS = SKILL_TRAINED, // 6 points
		SKILL_MEDICAL = SKILL_BASIC // 4 points
	)

/datum/job/submap/skrellscoutship_crew/equip(mob/living/carbon/human/H, alt_title, datum/mil_branch/branch, datum/mil_rank/grade)
	. = ..(H, alt_title, branch, grade)	//passing through arguments
	//Limited to subcastes that make sense on the vessel. No need for ground-forces on such a ship.
	var/skrellscoutcastes = list(
		"Malish-Katish" = list(
			"Mero'ta-Ketish",
			"Toglo'i-Ketish",
			"Keloa-Ketish"
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
		var/obj/item/card/id/C = H.wear_id
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

/singleton/hierarchy/outfit/job/skrellscoutship
	name = "Xilvuxix Crew"
	uniform = /obj/item/clothing/under/skrelljumpsuit
	shoes = /obj/item/clothing/shoes/dutyboots
	gloves = /obj/item/clothing/gloves/thick/swat/skrell
	pda_type = /obj/item/modular_computer/pda
	pda_slot = slot_l_store
	l_ear = /obj/item/device/radio/headset/map_preset/skrellscoutship
	id_types = list(/obj/item/card/id/skrellscoutship)
	l_pocket = /obj/item/clothing/accessory/badge/tags/skrell


/obj/item/reagent_containers/food/condiment/psilocybin
	starting_reagents = list(/datum/reagent/drugs/psilocybin = 50)


/obj/item/reagent_containers/food/condiment/mindbreaker
	starting_reagents = list(/datum/reagent/drugs/mindbreaker = 50)


/obj/item/reagent_containers/food/condiment/hextro
	starting_reagents = list(/datum/reagent/drugs/hextro = 50)


/datum/mil_branch/skrell_fleet
	name = "Skrellian Defense Task Force"
	name_short = "SDTF"
	email_domain = "sdtf.qb"

	rank_types = list(/datum/mil_rank/skrell_fleet)
	spawn_rank_types = list(/datum/mil_rank/skrell_fleet)

/datum/mil_rank/skrell_fleet
	name = "NULL"

/obj/machinery/power/smes/buildable/preset/skrell
	uncreated_component_parts = list(
		/obj/item/stock_parts/smes_coil/advanced = 2
	)
	_input_maxed = TRUE
	_output_maxed = TRUE
	_input_on = TRUE
	_output_on = TRUE
	_fully_charged = TRUE

/obj/machinery/power/apc/debug/skrell
	cell_type = /obj/item/cell/infinite
	req_access = list(access_skrellscoutship)

#undef WEBHOOK_SUBMAP_LOADED_SKRELL

//Skrell Security Belt
/obj/item/storage/belt/holster/skrell
	name = "skrellian holster belt"
	desc = "Can hold security gear like handcuffs and flashes. This one has a convenient holster."
	icon_state = "securitybelt"
	item_state = "security"
	storage_slots = 8
	overlay_flags = BELT_OVERLAY_ITEMS|BELT_OVERLAY_HOLSTER
	contents_allowed = list(
		/obj/item/crowbar,
		/obj/item/grenade,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/handcuffs,
		/obj/item/device/flash,
		/obj/item/clothing/glasses,
		/obj/item/ammo_casing/shotgun,
		/obj/item/ammo_magazine,
		/obj/item/reagent_containers/food/snacks/donut,
		/obj/item/melee/baton,
		/obj/item/melee/telebaton,
		/obj/item/flame/lighter,
		/obj/item/device/flashlight,
		/obj/item/modular_computer/pda,
		/obj/item/device/radio/headset,
		/obj/item/device/hailer,
		/obj/item/device/megaphone,
		/obj/item/melee,
		/obj/item/taperoll,
		/obj/item/device/holowarrant,
		/obj/item/magnetic_ammo,
		/obj/item/device/binoculars,
		/obj/item/clothing/gloves,
		/obj/item/gun/energy/gun/skrell
		)