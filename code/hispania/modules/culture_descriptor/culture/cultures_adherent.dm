/decl/cultural_info/culture/adherent
	name = CULTURE_ADHERENT
	description = "La Vigilia es una asociacion relativamente flexible de maquinas-servidores , construida por una cultura ahora \
	extinta. Estan dedicados a la memoria de sus creadores muertos hace mucho tiempo, destruidos por \"El Grito\", una llamarada \
	solar que borro la gran mayoria de los registros de los creadores y altero muchos sistemas de sensores y memoria, dejando a \
	los Adherent confundidos y desorientados durante siglos. Ahora en contacto con la humanidad, la Vigilia esta tentativamente \
	incursionando en un lugar en la cultura galactica."
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
