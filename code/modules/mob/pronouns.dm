/datum/pronouns
	var/key
	var/formal_term
	/// what pronouns this includes, used only for multiple pronouns
	var/list/types = null

	var/He   = "They"
	var/he   = "they"
	var/His  = "Their"
	var/his  = "their"
	var/him  = "them"
	var/has  = "have"
	var/is   = "are"
	var/does = "do"
	var/self = "themselves"
	var/s    = ""
	var/es   = ""

/datum/pronouns/they_them
	key  = PRONOUNS_THEY_THEM
	formal_term = "They/Them"

/datum/pronouns/he_him
	key  = PRONOUNS_HE_HIM
	formal_term = "He/Him"

	He   = "He"
	he   = "he"
	His  = "His"
	his  = "his"
	him  = "him"
	has  = "has"
	is   = "is"
	does = "does"
	self = "himself"
	s    = "s"
	es   = "es"

/datum/pronouns/he_they
	key  = PRONOUNS_HE_THEY
	formal_term = "He/They"
	types = list(PRONOUNS_HE_HIM, PRONOUNS_THEY_THEM)

/datum/pronouns/she_her
	key  = PRONOUNS_SHE_HER
	formal_term = "She/Her"

	He   = "She"
	he   = "she"
	His  = "Her"
	his  = "her"
	him  = "her"
	has  = "has"
	is   = "is"
	does = "does"
	self = "herself"
	s    = "s"
	es   = "es"

/datum/pronouns/she_they
	key  = PRONOUNS_SHE_THEY
	formal_term = "She/They"
	types = list(PRONOUNS_SHE_HER, PRONOUNS_THEY_THEM)

/datum/pronouns/it_its
	key = PRONOUNS_IT_ITS
	formal_term = "It/Its"

	He   = "It"
	he   = "it"
	His  = "Its"
	his  = "its"
	him  = "it"
	has  = "has"
	is   = "is"
	does = "does"
	self = "itself"
	s    = "s"
	es   = "es"


/datum/pronouns_manager
	var/static/list/datum/pronouns/instances = list()
	var/static/list/datum/pronouns/by_key = list()


/datum/pronouns_manager/New()
	instances.Cut()
	by_key.Cut()
	for (var/datum/pronouns/pronouns as anything in subtypesof(/datum/pronouns))
		pronouns = new pronouns
		instances += pronouns
		by_key[pronouns.key] = pronouns


GLOBAL_DATUM_INIT(pronouns, /datum/pronouns_manager, new)
