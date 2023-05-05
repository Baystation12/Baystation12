
GLOBAL_LIST_EMPTY(gender_datums)
/// List (`string`|`/datum/gender` => `/datum/pronouns`). Map of genders to pronouns. Derived from each gender datum's `default_pronouns`. Accepts both string or a gender datum as a key.
GLOBAL_LIST_EMPTY(pronouns_from_gender)

/hook/startup/proc/populate_gender_datum_list()
	for(var/type in subtypesof(/datum/gender))
		var/datum/gender/G = new type
		GLOB.gender_datums[G.key] = G
		if(!G.formal_term)
			G.formal_term = G.key

		var/datum/pronouns/P = GLOB.pronouns.by_key[G.default_pronouns]
		GLOB.pronouns_from_gender[G.key] = P
		GLOB.pronouns_from_gender[G] = P

	return 1

/datum/gender
	var/key
	var/formal_term
	/// String (One of `PRONOUNS_*`). Associated default pronouns used by this gender.
	var/default_pronouns = PRONOUNS_THEY_THEM

	var/He   = "They"
	var/he   = "they"
	var/His  = "Their"
	var/his  = "their"
	var/him  = "them"
	var/has  = "have"
	var/is   = "are"
	var/does = "do"
	var/self = "themselves"

/datum/gender/plural
	key  = PLURAL
	formal_term = "other"

/datum/gender/male
	key  = MALE
	default_pronouns = PRONOUNS_HE_HIM

	He   = "He"
	he   = "he"
	His  = "His"
	his  = "his"
	him  = "him"
	has  = "has"
	is   = "is"
	does = "does"
	self = "himself"

/datum/gender/female
	key  = FEMALE
	default_pronouns = PRONOUNS_SHE_HER

	He   = "She"
	he   = "she"
	His  = "Her"
	his  = "her"
	him  = "her"
	has  = "has"
	is   = "is"
	does = "does"
	self = "herself"

/datum/gender/neuter
	key = NEUTER
	formal_term = "other"
	default_pronouns = PRONOUNS_IT_ITS

	He   = "It"
	he   = "it"
	His  = "Its"
	his  = "its"
	him  = "it"
	has  = "has"
	is   = "is"
	does = "does"
	self = "itself"
