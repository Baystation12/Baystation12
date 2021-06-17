
/var/list/gender_datums = list()

/hook/startup/proc/populate_gender_datum_list()
	for(var/type in subtypesof(/datum/gender))
		var/datum/gender/G = new type
		gender_datums[G.key] = G
		if(!G.formal_term)
			G.formal_term = G.key
	return 1

/datum/gender
	var/key
	var/formal_term

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

	He   = "It"
	he   = "it"
	His  = "Its"
	his  = "its"
	him  = "it"
	has  = "has"
	is   = "is"
	does = "does"
	self = "itself"
