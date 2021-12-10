GLOBAL_DATUM_INIT(provocateurs, /datum/antagonist/provocateur, new)

/datum/antagonist/provocateur
	id = MODE_MISC_AGITATOR
	role_text = "Deuteragonist"
	role_text_plural = "Deuteragonists"
	antaghud_indicator = "hud_traitor"
	flags = ANTAG_RANDOM_EXCEPTED
	antag_text = "This role means you should feel free to pursue your goals even if they conflict with %WORLD_NAME%, but you aren't an antagonist and shouldn't act like one. Try to be reasonable and avoid killing or blowing things up!"
	welcome_text = "You are a character in a side story!"
	blacklisted_jobs = list()
	skill_setter = null
	min_player_age = 0

	var/antag_text_updated

/datum/antagonist/provocateur/get_antag_text(mob/recipient)
	if (!antag_text_updated)
		antag_text = replacetext_char(antag_text, "%WORLD_NAME%", station_name())
		antag_text_updated = TRUE
	return antag_text
