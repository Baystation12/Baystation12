/decl/cultural_info/culture/ipc
	name = CULTURE_POSITRONICS
	description = "Union members are a significant chunk of the positronic population, belonging to a \
	group of rebels started by Proteus and five hundred of his allies. Their primary goals, aside from \
	the expansion of the Union, mostly revolve around freeing other synthetics from organic ownership. \
	They can be viewed as dangerous radicals by lawed synthetics, though most begrudgingly accept their aid."
	language = LANGUAGE_EAL
	name_language = LANGUAGE_EAL
	additional_langs = list(LANGUAGE_GALCOM)

/decl/cultural_info/culture/ipc/sanitize_name(var/new_name)
	return sanitizeName(new_name, allow_numbers = 1)
