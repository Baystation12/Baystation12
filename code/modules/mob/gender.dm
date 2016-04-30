
// Those are for id_gender stuff (used in species.dm)
#define NORMAL_GENDER 		"Normal"
#define OPPOSITE_GENDER 	"Opposite"
#define NEUTRAL_GENDER 	"Neutral"
#define NONE_GENDER 		"None"

/proc/gender2text(var/value, var/sex = 0)
	if (!value)
		return "Normal"

	if (value in all_sexes_define_list) // genders when value is a gender
		return sex2text(value)
	if (value in all_sexes_text_list)
		return value

	if (value == NORMAL_GENDER && (sex == NEUTER || sex == PLURAL))
		return "None"

	if (value in all_genders_define_list) // id_genders when value is an id_gender
		if (value == OPPOSITE_GENDER && (sex == MALE || sex == FEMALE))
			return "Opposite ([sex == MALE ? "Female":"Male"])"
		return value

	return "N/A"

// sex to gender, requires reference to a second (often the actual) sex
/proc/determinate_gender(var/gender_sex, var/sex)
	if((sex == NEUTER || sex == PLURAL) && (gender_sex == MALE || gender_sex == FEMALE))
		return gender_sex == MALE ? MALE : FEMALE
	if(gender_sex == sex)
		return NORMAL_GENDER
	if(gender_sex == PLURAL)
		return NEUTRAL_GENDER
	if(gender_sex == NEUTER)
		return NONE_GENDER
	return OPPOSITE_GENDER

/proc/pick_gender(var/gender_val, var/sex)
	if (!gender_val || !sex || gender_val == "N/A")
		return NEUTER

	if(gender_val in all_sexes_define_list)
		return gender_val

	switch (gender_val)
		if (NORMAL_GENDER)
			return sex
		if (OPPOSITE_GENDER)
			return sex == MALE ? FEMALE : MALE
		if (NEUTRAL_GENDER)
			return PLURAL

	return NEUTER // also NONE_GENDER


/var/list/gender_datums = list()

/hook/startup/proc/populate_gender_datum_list()
	for(var/type in typesof(/datum/gender))
		var/datum/gender/G = new type
		gender_datums[G.key] = G
	return 1

/datum/gender
	var/key  = "plural"

	var/He   = "They"
	var/he   = "they"
	var/His  = "Their"
	var/his  = "their"
	var/him  = "them"
	var/has  = "have"
	var/is   = "are"
	var/does = "do"

	var/singular = 0 // I hate this, but at least it is still better than fucking around with "key == "pural""

/datum/gender/male
	key  = "male"

	He   = "He"
	he   = "he"
	His  = "His"
	his  = "his"
	him  = "him"
	has  = "has"
	is   = "is"
	does = "does"

	singular = 1

/datum/gender/female
	key  = "female"

	He   = "She"
	he   = "she"
	His  = "Her"
	his  = "her"
	him  = "her"
	has  = "has"
	is   = "is"
	does = "does"

	singular = 1

/datum/gender/neuter
	key = "neuter"

	He   = "It"
	he   = "it"
	His  = "Its"
	his  = "its"
	him  = "it"
	has  = "has"
	is   = "is"
	does = "does"

	singular = 1
