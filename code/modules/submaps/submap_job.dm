/datum/job/submap
	title = "Survivor"
	supervisors = "your conscience"
	account_allowed = FALSE
	latejoin_at_spawnpoints = TRUE
	announced = FALSE
	create_record = FALSE
	total_positions = 4
	outfit_type = /decl/hierarchy/outfit/job/assistant
	hud_icon = "hudblank"
	available_by_default = FALSE
	allowed_ranks = null
	allowed_branches = null
	skill_points = 25
	give_psionic_implant_on_join = FALSE
	max_skill = list(   SKILL_BUREAUCRACY = SKILL_MAX,
	                    SKILL_FINANCE = SKILL_MAX,
	                    SKILL_EVA = SKILL_MAX,
	                    SKILL_MECH = SKILL_MAX,
	                    SKILL_PILOT = SKILL_MAX,
	                    SKILL_HAULING = SKILL_MAX,
	                    SKILL_COMPUTER = SKILL_MAX,
	                    SKILL_BOTANY = SKILL_MAX,
	                    SKILL_COOKING = SKILL_MAX,
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
	                    SKILL_CHEMISTRY = SKILL_MAX)

	var/info = "You have survived a terrible disaster. Make the best of things that you can."
	var/rank
	var/branch
	var/list/spawnpoints
	var/datum/submap/owner
	var/list/blacklisted_species = RESTRICTED_SPECIES
	var/list/whitelisted_species = UNRESTRICTED_SPECIES

/datum/job/submap/New(var/datum/submap/_owner, var/abstract_job = FALSE)
	if(!abstract_job)
		spawnpoints = list()
		owner = _owner
		..()

/datum/job/submap/is_species_allowed(var/datum/species/S)
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

/datum/job/submap/is_restricted(var/datum/preferences/prefs, var/feedback)
	var/datum/species/S = all_species[prefs.species]
	if(LAZYACCESS(minimum_character_age, S.get_bodytype()) && (prefs.age < minimum_character_age[S.get_bodytype()]))
		to_chat(feedback, "<span class='boldannounce'>Not old enough. Minimum character age is [minimum_character_age[S.get_bodytype()]].</span>")
		return TRUE
	if(LAZYLEN(whitelisted_species) && !(prefs.species in whitelisted_species))
		to_chat(feedback, "<span class='boldannounce'>Your current species, [prefs.species], is not permitted as [title] on \a [owner.archetype.descriptor].</span>")
		return TRUE
	if(prefs.species in blacklisted_species)
		to_chat(feedback, "<span class='boldannounce'>Your current species, [prefs.species], is not permitted as [title] on \a [owner.archetype.descriptor].</span>")
		return TRUE
	if(owner && owner.archetype)
		if(LAZYLEN(owner.archetype.whitelisted_species) && !(prefs.species in owner.archetype.whitelisted_species))
			to_chat(feedback, "<span class='boldannounce'>Your current species, [prefs.species], is not permitted on \a [owner.archetype.descriptor].</span>")
			return TRUE
		if(prefs.species in owner.archetype.blacklisted_species)
			to_chat(feedback, "<span class='boldannounce'>Your current species, [prefs.species], is not permitted on \a [owner.archetype.descriptor].</span>")
			return TRUE
	return FALSE

/datum/job/submap/check_is_active(var/mob/M)
	. = (..() && M.faction == owner.name)