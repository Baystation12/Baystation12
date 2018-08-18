/decl/cultural_info/culture/generic
	name = CULTURE_OTHER
	description = "You are from one of the many small, relatively unknown cultures scattered across the galaxy."

/decl/cultural_info/culture/human
	name = CULTURE_HUMAN
	description = "You are from one of various planetary cultures of humankind."
	language = LANGUAGE_SOL_COMMON
	secondary_langs = list(LANGUAGE_GALCOM)

/decl/cultural_info/culture/human/vatgrown
	name = CULTURE_HUMAN_VATGROWN
	description = "You were grown in a vat, either as clone or as a gene-adapt, and your outlook diverges from baseline humanity accordingly."
	language = LANGUAGE_GALCOM
	secondary_langs = list(LANGUAGE_SOL_COMMON)

/decl/cultural_info/culture/human/vatgrown/sanitize_name(name)
	return sanitizeName(name, allow_numbers=TRUE)

/decl/cultural_info/culture/human/vatgrown/get_random_name(gender)
	// #defines so it's easier to read what's actually being generated
	#define LTR ascii2text(rand(65,90)) // A-Z
	#define NUM ascii2text(rand(48,57)) // 0-9
	#define NAME capitalize(pick(gender == FEMALE ? GLOB.first_names_female : GLOB.first_names_male))
	switch(rand(1,4))
		if(1) return NAME
		if(2) return "[LTR][LTR]-[NAME]"
		if(3) return "[NAME]-[NUM][NUM][NUM]"
		if(4) return "[LTR][LTR]-[NUM][NUM][NUM]"
	. = 1 // Never executed, works around http://www.byond.com/forum/?post=2072419
	#undef LTR
	#undef NUM
	#undef NAME
