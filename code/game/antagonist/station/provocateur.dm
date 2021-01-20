GLOBAL_DATUM_INIT(provocateurs, /datum/antagonist/provocateur, new)

/datum/antagonist/provocateur
	id = MODE_MISC_AGITATOR
	role_text = "Deuteragonist"
	role_text_plural = "Deuteragonists"
	antaghud_indicator = "hud_traitor"
	flags = ANTAG_RANDOM_EXCEPTED
	antag_text = "This role means you should feel free to pursue your goals even if they conflict with the station, but you aren't an antagonist and shouldn't act like one. Try to be reasonable and avoid killing or blowing things up!"
	welcome_text = "You are a character in a side story!"
	blacklisted_jobs = list()
	skill_setter = null
	min_player_age = 0

/datum/antagonist/provocateur/New()
	antag_text = "This role means you should feel free to pursue your goals even if they conflict with the [station_name()], but you aren't an antagonist and shouldn't act like one. Try to be reasonable and avoid killing or blowing things up!"
	..()
