/datum/job/submap
	title = "Survivor"
	supervisors = "your conscience"
	account_allowed = FALSE
	latejoin_at_spawnpoints = TRUE
	announced = FALSE
	create_record = FALSE
	total_positions = 4
	outfit_type = /singleton/hierarchy/outfit/job/assistant
	hud_icon = "hudblank"
	available_by_default = FALSE
	allowed_ranks = null
	allowed_branches = null
	give_psionic_implant_on_join = FALSE

	skill_points = 11
	min_skill = list(
		SKILL_HAULING = SKILL_TRAINED,
		SKILL_EVA = SKILL_TRAINED,
		SKILL_CONSTRUCTION = SKILL_BASIC,
		SKILL_ELECTRICAL = SKILL_BASIC,
		SKILL_MEDICAL = SKILL_BASIC,
		SKILL_WEAPONS = SKILL_BASIC,
		SKILL_COMBAT = SKILL_BASIC,
	)

	max_skill = list(
		SKILL_PILOT = SKILL_MAX,
		SKILL_COMBAT = SKILL_MAX,
		SKILL_WEAPONS = SKILL_MAX,
		SKILL_FORENSICS = SKILL_MAX,
		SKILL_CONSTRUCTION = SKILL_MAX,
		SKILL_ELECTRICAL = SKILL_MAX,
		SKILL_ATMOS = SKILL_MAX,
		SKILL_ENGINES = SKILL_MAX,
		SKILL_DEVICES = SKILL_MAX,
		SKILL_SCIENCE = SKILL_MAX,
		SKILL_MEDICAL = SKILL_MAX,
		SKILL_ANATOMY = SKILL_MAX,
		SKILL_CHEMISTRY = SKILL_MAX
	)

	var/info = "You have survived a terrible disaster. Make the best of things that you can."
	var/rank
	var/branch
	var/list/spawnpoints
	var/datum/submap/owner
	var/list/blacklisted_species = RESTRICTED_SPECIES
	var/list/whitelisted_species = UNRESTRICTED_SPECIES

/datum/job/submap/New(datum/submap/_owner, abstract_job = FALSE)
	if(!abstract_job)
		spawnpoints = list()
		owner = _owner
		..()

/datum/job/submap/is_species_allowed(datum/species/S)
	if(LAZYLEN(whitelisted_species) && !(S.name in whitelisted_species))
		return FALSE
	if(S.name in blacklisted_species)
		return FALSE
	if(owner && owner.archetype)
		if(LAZYLEN(owner.archetype.whitelisted_species) && !(S.name in owner.archetype.whitelisted_species))
			return FALSE
		if(S.name in owner.archetype.blacklisted_species)
			return FALSE
	return TRUE

/datum/job/submap/is_restricted(datum/preferences/prefs, feedback)
	var/datum/species/S = all_species[prefs.species]
	if(LAZYACCESS(minimum_character_age, S.get_bodytype()) && (prefs.age < minimum_character_age[S.get_bodytype()]))
		to_chat(feedback, SPAN_CLASS("boldannounce", "Not old enough. Minimum character age is [minimum_character_age[S.get_bodytype()]]."))
		return TRUE
	if(LAZYLEN(whitelisted_species) && !(prefs.species in whitelisted_species))
		to_chat(feedback, SPAN_CLASS("boldannounce", "Your current species, [prefs.species], is not permitted as [title] on \a [owner.archetype.descriptor]."))
		return TRUE
	if(prefs.species in blacklisted_species)
		to_chat(feedback, SPAN_CLASS("boldannounce", "Your current species, [prefs.species], is not permitted as [title] on \a [owner.archetype.descriptor]."))
		return TRUE
	if(owner && owner.archetype)
		if(LAZYLEN(owner.archetype.whitelisted_species) && !(prefs.species in owner.archetype.whitelisted_species))
			to_chat(feedback, SPAN_CLASS("boldannounce", "Your current species, [prefs.species], is not permitted on \a [owner.archetype.descriptor]."))
			return TRUE
		if(prefs.species in owner.archetype.blacklisted_species)
			to_chat(feedback, SPAN_CLASS("boldannounce", "Your current species, [prefs.species], is not permitted on \a [owner.archetype.descriptor]."))
			return TRUE
	return FALSE

/datum/job/submap/check_is_active(mob/M)
	. = (..() && M.faction == owner.name)
