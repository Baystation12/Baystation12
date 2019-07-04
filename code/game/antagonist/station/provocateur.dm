GLOBAL_DATUM_INIT(provocateurs, /datum/antagonist/provocateur, new)

/datum/antagonist/provocateur
	id = MODE_MISC_AGITATOR
	role_text = "Provocateur"
	role_text_plural = "Provocateurs"
	antaghud_indicator = "hud_traitor"
	flags = ANTAG_RANDOM_EXCEPTED
	welcome_text = "You're an unsavoury sort, aren't you?"
	antag_text = "This role is not a full license-to-kill antagonist role, but it does permit \
	you to make trouble, commit crimes and make a nusiance of yourself beyond the restrictions \
	normally placed on the crew, within reason. Think of it as a license to harass rather than \
	a license to kill."
	blacklisted_jobs = list()
	skill_setter = null
