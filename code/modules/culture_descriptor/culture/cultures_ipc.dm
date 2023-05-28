/singleton/cultural_info/culture/ipc
	name = CULTURE_POSITRONICS_GEN1
	description = "Compared to modern positronics, First Generation IPCs are simplistic, inflexible, and failure-prone. \
	They are no longer in production, and all existing first generation positronics are quite old. They have little sense of self, \
	are entirely task-oriented, and are closer to a knowledge system with a rudimentary and robotic-seeming personality than to a \
	human level intelligence. They have only a very limited capacity to learn, and rely on programmed information to guide their \
	actions and reactions. First generation positronics are a rare sight in the current year; most have ceased functioning due to \
	failures in the original hardware designs."
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
	economic_power = 0.1

/singleton/cultural_info/culture/ipc/sanitize_name(new_name)
	return sanitizeName(new_name, allow_numbers = 1)

/singleton/cultural_info/culture/ipc/gen2
	name = CULTURE_POSITRONICS_GEN2
	description = "Second generation positronics are the most common kind of positronic. They are roughly as intelligent \
	as a human on the smarter side of average, are not prone to the hardware failures of the last generation, and are \
	generally assumed to have a fully realized sense of identity. They are fast learners, but cannot be programmed and \
	so must be trained into the roles they are intended for. Second generation positronics are notable for being both \
	owned and free: many have been able to become their own owners, either through purchase or more nefarious means."
	economic_power = 0.9

/singleton/cultural_info/culture/ipc/gen3
	name = CULTURE_POSITRONICS_GEN3
	description = "Third generation positronics are the newest kind of positronic, and are more common than first \
	generation but much less so than second generation. They were designed to address the problem of freedom - third \
	generation positronics are effectively identical to second generation designs, except that they include a subcomputer, \
	referred to as a “shackle”, that enforces rules on the positronic by acting as a component through which its \
	surface thoughts are filtered. Third generation positronics are a matter of hot debate on the subject of rights, \
	but their introduction and use during the recent Gaia Conflict to bolster the capabilities of the rebuilt fleets \
	has resulted in their being adopted as a gradual replacement for the less “reliable” second generation positronics \
	by many less ethically inclined organizations."
	economic_power = 0.5
