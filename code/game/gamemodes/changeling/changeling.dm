/datum/game_mode/changeling
	name = "Changeling"
	round_description = "There are alien changelings onboard. Do not let the changelings succeed!"
	extended_round_description = "Life always finds a way. However, life can sometimes take a more disturbing route. \
		Humanity's extensive knowledge of xeno-biological specimens has made them confident and arrogant. Yet \
		something slipped past their eyes. Something dangerous. Something alive. Most frightening of all, \
		however, is that this something is someone. An unknown alien specimen has incorporated itself into \
		the crew. Its unique biology allows it to manipulate its own or anyone else's DNA. \
		With the ability to copy faces, voices, animals, but also change the chemical make up of your own body, \
		its existence is a threat to not only your personal safety but the lives of everyone on board. \
		No one knows where it came from. No one knows who it is or what it wants. One thing is for \
		certain though... there is never just one of them. Good luck."
	config_tag = "changeling"
	required_players = 2
	required_enemies = 1
	end_on_antag_death = 0
	antag_scaling_coeff = 10
	antag_tags = list(MODE_CHANGELING)
