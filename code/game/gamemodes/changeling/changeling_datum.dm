/// New changelings will pick randomly from this list when forming their "code name" to communicate over hive chat.
GLOBAL_LIST_INIT(possible_changeling_IDs, list("Alpha", "Beta", "Gamma", "Delta", "Epsilon", "Zeta", "Eta", "Theta", "Iota", "Kappa", "Lambda", "Mu", "Nu", "Xi", "Omicron", "Pi", "Rho", "Sigma", "Tau", "Upsilon", "Phi", "Chi", "Psi", "Omega"))

/// Stores changeling powers, chemicals, absorbed DNA, and hivemind ID.
/datum/changeling
	/// A list of all "absorbed DNA" datums we have - these includeactual DNA datums, name, species name, and languages.
	var/list/datum/absorbed_dna/absorbed_dna = list()
	/// A list of the languages we've absorbed from others. We can speak and understand these languages fluently.
	var/list/absorbed_languages = list()
	/// The total number of people we've absorbed.
	var/absorbed_count = 0
	/// If TRUE, we're currently absorbing another person.
	var/is_absorbing = FALSE

	/// Chemicals are used to fuel changeling powers. This var tracks how many we currently have.
	var/chem_charges = 20
	/// This many chemicals will be added every life tick to what we currently have.
	var/chem_recharge_rate = 0.5
	/// The max chemicals we can store at a time.
	var/chem_storage = 50

	/// When using sting powers, they have a range of this many tiles.
	var/sting_range = 1

	/// Not actually clone loss, this is used to represent a cooldown period on using abilities.
	var/genetic_damage = 0
	/// Genetic points are our resources for buying new abilities and upgrades.
	var/genetic_points = 25
	/// A list of the power datums we've purchased.
	var/purchased_powers = list()

	/// This is a string used when talking over changeling hivemind, instead of the person's current identity.
	var/changelingID = "Changeling"
	/// If we're mimicking someone else's voice, this value tracks that name and uses it when we speak.
	var/mimicing = ""

	/// The mind that owns this changeling datum.
	var/datum/mind/owner_mind

/datum/changeling/Destroy()
	purchased_powers = null
	absorbed_languages.Cut()
	absorbed_dna.Cut()
	. = ..()

/datum/changeling/New()
	..()
	if(LAZYLEN(GLOB.possible_changeling_IDs))
		changelingID = pick(GLOB.possible_changeling_IDs)
		GLOB.possible_changeling_IDs -= changelingID
		changelingID = "[changelingID]"
	else
		changelingID = "[rand(1,999)]"


/// Provides the per-tick regeneration for chemicals and genetic damage.
/datum/changeling/proc/regenerate()
	chem_charges = min(max(0, chem_charges + chem_recharge_rate), chem_storage)
	genetic_damage = max(0, genetic_damage -1 )


/// Fetches the absorbed_dna datum from a provided name.
/datum/changeling/proc/get_DNA(dna_owner)
	for(var/datum/absorbed_dna/DNA in absorbed_dna)
		if(dna_owner == DNA.name)
			return DNA


/// Adds a new absorb_dna datum into our stored DNA. Chomp.
/datum/changeling/proc/absorb_DNA(datum/absorbed_dna/snacc)
	for(var/language in snacc.languages)
		absorbed_languages |= language

	update_languages(absorbed_languages)

	absorbed_dna += snacc


/// Updates our parent mob's knowledge of languages based on what we've absorbed.
/datum/changeling/proc/update_languages(new_languages)
	owner_mind.current.languages = list()
	for(var/language in new_languages)
		owner_mind.current.languages += language

	// This isn't strictly necessary, but just to be safe...
	owner_mind.current.add_language(LANGUAGE_CHANGELING_GLOBAL)


/// Transforms the current mob of this mind to match the DNA of the provided absorbed_dna datum.
/datum/changeling/proc/do_transform(datum/mind/M, datum/absorbed_dna/chosen_dna)
	M.current.visible_message(
		SPAN_WARNING("\The [M.current] transforms!"),
		SPAN_WARNING("We transform.")
	)

	M.current.dna = chosen_dna.dna
	M.current.real_name = chosen_dna.name
	M.current.flavor_text = ""

	if (ishuman(M.current))
		var/mob/living/carbon/human/H = M.current
		var/newSpecies = chosen_dna.speciesName
		H.set_species(newSpecies,1)
		H.b_type = chosen_dna.dna.b_type
		H.sync_organ_dna()

	domutcheck(M.current, null)
	M.current.UpdateAppearance()
