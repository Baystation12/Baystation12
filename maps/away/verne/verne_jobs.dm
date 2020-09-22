/datum/job/submap/CTI_pilot
	title = "CTI Pilot"
	total_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/verne/pilot
	supervisors = "the CTI Professor in Command of the Verne"
	info = "You are an employee on the SRV Verne, as it carries the students of the prestigious Ceti Technical Institute conducting research \
	in the depths of space. Your job on the Survey team is simple; pilot the SRV Verne and the SRV Venerable Catfish; protect the students; and assist in their studies. Your Survey team has awoken \
 	to find the Verne running at low capacity, under-staffed, with much of the automated life support systems doing the heavy lifting."
	whitelisted_species = list(SPECIES_HUMAN,SPECIES_IPC,SPECIES_SPACER,SPECIES_GRAVWORLDER,SPECIES_VATGROWN,SPECIES_BOOSTER,SPECIES_TRITONIAN)
	required_language = LANGUAGE_HUMAN_EURO
	min_skill = list(
		SKILL_EVA     = SKILL_BASIC,
		SKILL_WEAPONS = SKILL_ADEPT,
		SKILL_PILOT   = SKILL_ADEPT,
	)

	max_skill = list(
		SKILL_PILOT   = SKILL_MAX,
		SKILL_SCIENCE = SKILL_MAX,
	)
	skill_points = 20//skills copied from Torch pilot + gun

/datum/job/submap/CTI_engineer
	title = "CTI Engineer"
	total_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/verne/engineer
	supervisors = "the CTI Professor in Command of the Verne"
	info = "You are an employee on the SRV Verne, as it carries the students of the prestigious Ceti Technical Institute conducting research \
 	in the depths of space. Your job on the Survey team is simple: Handle engineering work on the SRV Verne and the SRV Venerable Catfish, protect the students, and assist in their studies. Your Survey team has awoken \
	to find the Verne running at low capacity, under-staffed, with much of the automated life support systems doing the heavy lifting."
	whitelisted_species = list(SPECIES_HUMAN,SPECIES_IPC,SPECIES_SPACER,SPECIES_GRAVWORLDER,SPECIES_VATGROWN,SPECIES_BOOSTER,SPECIES_TRITONIAN)
	required_language = LANGUAGE_HUMAN_EURO
	min_skill = list(
		SKILL_COMPUTER     = SKILL_BASIC,
		SKILL_EVA          = SKILL_BASIC,
		SKILL_CONSTRUCTION = SKILL_ADEPT,
		SKILL_ELECTRICAL   = SKILL_BASIC,
		SKILL_ATMOS        = SKILL_BASIC,
		SKILL_ENGINES      = SKILL_BASIC,
	)

	max_skill = list(
		SKILL_CONSTRUCTION = SKILL_MAX,
		SKILL_ELECTRICAL   = SKILL_MAX,
		SKILL_ATMOS        = SKILL_MAX,
		SKILL_ENGINES      = SKILL_MAX,
	)
	skill_points = 20//skills copied from torch eng

/datum/job/submap/CTI_Undergraduate_Xenoscience_Researcher
	title = "CTI Undergraduate Xenoscience Researcher"
	supervisors = "the CTI Professor in Command of the Verne"
	total_positions = 2
	outfit_type = /decl/hierarchy/outfit/job/verne/researcher
	info = "You are an undergraduate xenoscience researcher on the SRV Verne, alongside the rest of your class of the prestigious Ceti Technical Institute conducting research \
	in the depths of space. A survey team will be accompanying you, on hand to assist your studies on the exoplanets in this system. Your team has awoken \
	to find the Verne running at low capacity, under-staffed, with much of the automated life support systems doing the heavy lifting."
	whitelisted_species = list(SPECIES_HUMAN,SPECIES_SPACER,SPECIES_GRAVWORLDER,SPECIES_VATGROWN,SPECIES_BOOSTER,SPECIES_TRITONIAN)
	required_language = LANGUAGE_HUMAN_EURO
	min_skill = list(
		SKILL_BUREAUCRACY = SKILL_BASIC,
		SKILL_COMPUTER    = SKILL_BASIC,
		SKILL_DEVICES     = SKILL_BASIC,
		SKILL_SCIENCE     = SKILL_ADEPT,
	)

	max_skill = list(
		SKILL_ANATOMY = SKILL_MAX,
		SKILL_DEVICES = SKILL_MAX,
		SKILL_SCIENCE = SKILL_MAX,
	)
	skill_points = 20//skills copied from Torch sci

#define VERNE_OUTFIT_JOB_NAME(job_name) ("CTI Research Vessel - Job - " + job_name)
/decl/hierarchy/outfit/job/verne
	hierarchy_type = /decl/hierarchy/outfit/job/verne
	pda_type = null
	pda_slot = null
	id_types = list(/obj/item/weapon/card/id/verne)
	l_ear = /obj/item/device/radio/headset

/decl/hierarchy/outfit/job/verne/pilot
	name = VERNE_OUTFIT_JOB_NAME("Pilot")
	uniform = /obj/item/clothing/under/suit_jacket/navy
	shoes = /obj/item/clothing/shoes/dress/caretakershoes
	belt = /obj/item/weapon/storage/belt/holster/general
	r_pocket = /obj/item/weapon/gun/energy/gun/small
	l_pocket = /obj/item/weapon/crowbar/prybar

/decl/hierarchy/outfit/job/verne/engineer
	name = VERNE_OUTFIT_JOB_NAME("Engineer")
	uniform = /obj/item/clothing/under/rank/engineer
	shoes = /obj/item/clothing/shoes/workboots
	belt = /obj/item/weapon/storage/belt/utility/full
	r_pocket = /obj/item/device/radio
	l_pocket = /obj/item/weapon/crowbar/prybar

/decl/hierarchy/outfit/job/verne/engineer/New()
	..()
	backpack_overrides[/decl/backpack_outfit/backpack] = /obj/item/weapon/storage/backpack/industrial
	backpack_overrides[/decl/backpack_outfit/satchel] = /obj/item/weapon/storage/backpack/satchel/eng
	backpack_overrides[/decl/backpack_outfit/messenger_bag] = /obj/item/weapon/storage/backpack/messenger/engi

/decl/hierarchy/outfit/job/verne/researcher
	name = VERNE_OUTFIT_JOB_NAME("Undergraduate Xenoscience Researcher")
	uniform = /obj/item/clothing/under/rank/psych/turtleneck
	suit = /obj/item/clothing/suit/storage/toggle/hoodie/cti
	shoes = /obj/item/clothing/shoes/black

/obj/effect/submap_landmark/spawnpoint/CTI_pilot
	name = "CTI Pilot"

/obj/effect/submap_landmark/spawnpoint/CTI_engineer
	name = "CTI Engineer"

/obj/effect/submap_landmark/spawnpoint/CTI_Undergraduate_Xenoscience_Researcher
	name = "CTI Undergraduate Xenoscience Researcher"

#undef VERNE_OUTFIT_JOB_NAME
