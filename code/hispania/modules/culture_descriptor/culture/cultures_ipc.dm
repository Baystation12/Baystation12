/decl/cultural_info/culture/ipc
	name = CULTURE_POSITRONICS
	description = "Los miembros de la union son una parte importante de la poblacion positronica, pertenecientes a un grupo de rebeldes iniciado por Proteus y \
	quinientos de sus aliados. Sus objetivos principales, ademas de la expansion de la Union, giran principalmente en torno a liberar a otros sinteticos de la \
	propiedad organica. Los sinteticos legales pueden verlos como radicales peligrosos, aunque la mayoria acepta su ayuda."
	language = LANGUAGE_EAL
	secondary_langs = list(
		LANGUAGE_HUMAN_EURO,
		LANGUAGE_HUMAN_CHINESE,
		LANGUAGE_HUMAN_ARABIC,
		LANGUAGE_HUMAN_INDIAN,
		LANGUAGE_HUMAN_IBERIAN,
		LANGUAGE_HUMAN_RUSSIAN,
		LANGUAGE_SPACER,
		LANGUAGE_SIGN
	)

/decl/cultural_info/culture/ipc/sanitize_name(var/new_name)
	return sanitizeName(new_name, allow_numbers = 1)
