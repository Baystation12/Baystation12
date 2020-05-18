/decl/cultural_info/culture/adherent
	name = CULTURE_ADHERENT
	description = "The Vigil is a relatively loose association of machine-servitors, adherents, built by a now-extinct culture. \
	They are devoted to the memory of their long-dead creators, destroyed by the Scream, a solar flare which wiped out the vast \
	majority of records of the creators and scrambled many sensor systems and minds, leaving the surviving adherents confused \
	and disoriented for hundreds of years following. Now in contact with humanity, the Vigil is tentatively making inroads on \
	a place in the wider galactic culture."
	hidden_from_codex = TRUE
	language = LANGUAGE_ADHERENT
	secondary_langs = list(
		LANGUAGE_HUMAN_EURO,
		LANGUAGE_SPACER
	)

/decl/cultural_info/culture/adherent/get_random_name(var/gender)
	return "[uppertext("[pick(GLOB.full_alphabet)][pick(GLOB.full_alphabet)]-[pick(GLOB.full_alphabet)] [rand(1000,9999)]")]"

/decl/cultural_info/culture/adherent/sanitize_name(name)
	return sanitizeName(name, allow_numbers=TRUE)
