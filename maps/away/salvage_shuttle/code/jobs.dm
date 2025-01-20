/datum/job/submap/independent_salvager
	title = "Independent Salvager"
	total_positions = 2
	outfit_type = /singleton/hierarchy/outfit/job/independent_salvager
	supervisors = "your fellow crew"
	info = "You're an independent salvager on board the ISV Crab. \
	Fly through the sector, salvaging what materials and valuables you can find. \
	You're a travelling merchant at heart. Make friends and trade your spoils to turn a profit!"
	whitelisted_species = list(
		SPECIES_HUMAN,
		SPECIES_IPC,
		SPECIES_SPACER,
		SPECIES_GRAVWORLDER,
		SPECIES_VATGROWN,
		SPECIES_TRITONIAN,
		SPECIES_MULE
	)
	min_skill = list(
		SKILL_HAULING = SKILL_TRAINED,
		SKILL_MECH = SKILL_MAX,
		SKILL_PILOT = SKILL_BASIC,
		SKILL_EVA = SKILL_EXPERIENCED,
		SKILL_CONSTRUCTION = SKILL_TRAINED,
		SKILL_ELECTRICAL = SKILL_BASIC,
		SKILL_ATMOS = SKILL_BASIC,
		SKILL_MEDICAL = SKILL_BASIC,
		SKILL_ENGINES = SKILL_BASIC,
	)

	skill_points = 15

/singleton/hierarchy/outfit/job/independent_salvager
	name = "Independent Salvager"
	l_ear = null
	uniform = /obj/item/clothing/under/color/brown/salvage
	r_pocket = /obj/item/device/radio/map_preset/salvage_shuttle
	l_pocket = null
	shoes = /obj/item/clothing/shoes/workboots
	gloves = /obj/item/clothing/gloves/thick
	id_types = null
	pda_type = null

/obj/submap_landmark/spawnpoint/independent_salvager
	name = "Independent Salvager"
