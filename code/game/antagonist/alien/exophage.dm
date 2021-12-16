GLOBAL_DATUM_INIT(exophages, /datum/antagonist/exophage, new)

/datum/antagonist/exophage
	id = MODE_EXOPHAGE
	role_text = "\improper Exophage"
	role_text_plural = "\improper Exophages"
	welcome_text = "You are a nightmare, produced by the darkest corners of the galaxy! Spread your kind, kill the humans!"
	landmark_id = "xeno_spawn"

	flags = ANTAG_OVERRIDE_MOB | ANTAG_OVERRIDE_JOB
	mob_path = /mob/living/carbon/alien/exophage

	skill_setter = null