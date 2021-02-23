/datum/job/submap/rawl_pilot
	title = "Jhoge"
	total_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/rawl/pilot
	supervisors = "the whiners back at the outpost"
	info = "The boys are tired of synthmeat and protein drinks, they demand game.  \
	Good excuse to take your 'homely' ship out. Catch meat dead or alive,  \
	maybe find some fuel along the way. \
	If questioned, your crew works alone. Better, don't act questionable. Dohruk doesn't need publicity."
	whitelisted_species = list(SPECIES_UNATHI)
	is_semi_antagonist = TRUE
	min_skill = list(
		SKILL_HAULING = SKILL_BASIC,
		SKILL_EVA = SKILL_ADEPT,
		SKILL_PILOT = SKILL_EXPERT,
		SKILL_COMBAT = SKILL_ADEPT,
		SKILL_WEAPONS = SKILL_ADEPT,
		SKILL_COOKING = SKILL_BASIC
	)

	max_skill = list(
		SKILL_BUREAUCRACY = SKILL_MAX,
		SKILL_FINANCE = SKILL_MAX,
		SKILL_EVA = SKILL_MAX,
		SKILL_PILOT = SKILL_MAX,
		SKILL_HAULING = SKILL_MAX,
		SKILL_COMPUTER = SKILL_ADEPT,
		SKILL_BOTANY = SKILL_MAX,
		SKILL_COOKING = SKILL_MAX,
		SKILL_COMBAT = SKILL_MAX,
		SKILL_WEAPONS = SKILL_MAX,
		SKILL_FORENSICS = SKILL_ADEPT,
		SKILL_CONSTRUCTION = SKILL_EXPERT,
		SKILL_ELECTRICAL = SKILL_ADEPT,
		SKILL_ATMOS = SKILL_ADEPT,
		SKILL_ENGINES = SKILL_ADEPT,
		SKILL_DEVICES = SKILL_ADEPT,
		SKILL_SCIENCE = SKILL_MAX,
		SKILL_MEDICAL = SKILL_ADEPT,
		SKILL_ANATOMY = SKILL_ADEPT,
		SKILL_CHEMISTRY = SKILL_ADEPT
	)
	skill_points = 18


/datum/job/submap/rawl_tech
	title = "Stoker"
	total_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/rawl/tech
	supervisors = "the whiners back at the outpost"
	info = "The boys are tired of synthmeat and protein drinks, they demand game.  \
	Good excuse to take your 'homely' ship out. Catch meat dead or alive,  \
	maybe salvage some spare parts along the way. \
	If questioned, your crew works alone. Better, don't act questionable. Dohruk doesn't need publicity."
	whitelisted_species = list(SPECIES_UNATHI,SPECIES_YEOSA)
	is_semi_antagonist = TRUE
	min_skill = list(
		SKILL_CONSTRUCTION = SKILL_EXPERT,
		SKILL_ATMOS = SKILL_BASIC,
		SKILL_ELECTRICAL = SKILL_ADEPT,
		SKILL_ENGINES = SKILL_BASIC,
		SKILL_COMPUTER = SKILL_BASIC,
		SKILL_DEVICES = SKILL_BASIC,
		SKILL_HAULING = SKILL_BASIC,
		SKILL_EVA = SKILL_ADEPT,
		SKILL_COMBAT = SKILL_BASIC,
		SKILL_WEAPONS = SKILL_BASIC,
		SKILL_PILOT = SKILL_BASIC,
		SKILL_COOKING = SKILL_BASIC
	)

	max_skill = list(
		SKILL_BUREAUCRACY = SKILL_MAX,
		SKILL_FINANCE = SKILL_MAX,
		SKILL_EVA = SKILL_MAX,
		SKILL_PILOT = SKILL_MAX,
		SKILL_HAULING = SKILL_MAX,
		SKILL_COMPUTER = SKILL_EXPERT,
		SKILL_BOTANY = SKILL_MAX,
		SKILL_COOKING = SKILL_MAX,
		SKILL_COMBAT = SKILL_MAX,
		SKILL_WEAPONS = SKILL_MAX,
		SKILL_FORENSICS = SKILL_ADEPT,
		SKILL_CONSTRUCTION = SKILL_MAX,
		SKILL_ELECTRICAL = SKILL_MAX,
		SKILL_ATMOS = SKILL_EXPERT,
		SKILL_ENGINES = SKILL_EXPERT,
		SKILL_DEVICES = SKILL_MAX,
		SKILL_SCIENCE = SKILL_MAX,
		SKILL_MEDICAL = SKILL_ADEPT,
		SKILL_ANATOMY = SKILL_ADEPT,
		SKILL_CHEMISTRY = SKILL_ADEPT
	)

	skill_points = 16

/datum/job/submap/rawl_medic
	title = "Bonesetter"
	total_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/rawl/medic
	supervisors = "the whiners back at the outpost"
	info = "The boys are tired of synthmeat and protein drinks, they demand game.  \
	Good excuse to take your 'homely' ship out. Catch meat dead or alive,  \
	maybe find some actual medical supplies along the way. \
	If questioned, your crew works alone. Better, don't act questionable. Dohruk doesn't need publicity."
	whitelisted_species = list(SPECIES_UNATHI)
	is_semi_antagonist = TRUE
	min_skill = list(
		SKILL_HAULING = SKILL_BASIC,
		SKILL_EVA = SKILL_ADEPT,
		SKILL_COMBAT = SKILL_BASIC,
		SKILL_WEAPONS = SKILL_BASIC,
		SKILL_MEDICAL = SKILL_EXPERT,
		SKILL_ANATOMY = SKILL_EXPERT,
		SKILL_PILOT = SKILL_BASIC,
		SKILL_COOKING = SKILL_EXPERT
	)

	max_skill = list(
		SKILL_BUREAUCRACY = SKILL_MAX,
		SKILL_FINANCE = SKILL_MAX,
		SKILL_EVA = SKILL_MAX,
		SKILL_PILOT = SKILL_ADEPT,
		SKILL_HAULING = SKILL_MAX,
		SKILL_COMPUTER = SKILL_ADEPT,
		SKILL_BOTANY = SKILL_MAX,
		SKILL_COOKING = SKILL_MAX,
		SKILL_COMBAT = SKILL_MAX,
		SKILL_WEAPONS = SKILL_MAX,
		SKILL_FORENSICS = SKILL_ADEPT,
		SKILL_CONSTRUCTION = SKILL_ADEPT,
		SKILL_ELECTRICAL = SKILL_ADEPT,
		SKILL_ATMOS = SKILL_ADEPT,
		SKILL_ENGINES = SKILL_ADEPT,
		SKILL_DEVICES = SKILL_ADEPT,
		SKILL_SCIENCE = SKILL_MAX,
		SKILL_MEDICAL = SKILL_MAX,
		SKILL_ANATOMY = SKILL_MAX,
		SKILL_CHEMISTRY = SKILL_MAX
	)

	skill_points = 16

/obj/effect/submap_landmark/spawnpoint/rawl_pilot
	name = "Jhoge"
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/submap_landmark/spawnpoint/rawl_tech
	name = "Stoker"
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/submap_landmark/spawnpoint/rawl_medic
	name = "Bonesetter"
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/decl/hierarchy/outfit/job/rawl/
	name = "Poacher"
	l_ear = null
	r_ear = null
	uniform = /obj/item/clothing/under/savage_hunter
	suit = /obj/item/clothing/suit/unathi/robe
	l_pocket = /obj/item/device/radio/
	r_pocket = /obj/item/weapon/crowbar/prybar
	shoes = /obj/item/clothing/shoes/jackboots/unathi
	gloves = null
	belt = null
	hierarchy_type = /decl/hierarchy/outfit/job/rawl
	id_types = list(/obj/item/weapon/card/id/rawl)
	pda_type = null
	pda_slot = null


/decl/hierarchy/outfit/job/rawl/pilot
	name = "Jhoge"

/decl/hierarchy/outfit/job/rawl/tech
	name = "Stoker"
	shoes = /obj/item/clothing/shoes/workboots/toeless

/decl/hierarchy/outfit/job/rawl/medic
	name = "Bonesetter"