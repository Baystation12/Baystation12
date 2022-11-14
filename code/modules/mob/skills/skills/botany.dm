/singleton/skill/botany
	name = "Botany"
	save_key = "botany"
	default_max = SKILL_MAX
	difficulty = SKILL_EASY
	desc = "Describes how good a character is at growing and maintaining plants."
	levels = list(
		/singleton/skill_level/none = {"\
			You know next to nothing about plants. While you can attempt to plant, weed, or \
			harvest, you are just as likely to kill the plant instead.\
		"},
		/singleton/skill_level/basic = {"\
			You've done some gardening. You can water, weed, fertilize, plant, and harvest, \
			and you can recognize and deal with pests. You may be a hobby gardener.\
			<br>- You can safely plant and weed normal plants.\
			<br>- You can tell weeds and pests apart from each other.\
		"},
		/singleton/skill_level/adept = {"\
			You are proficient at botany, and can grow plants for food or oxygen production. \
			Your plants will generally survive and prosper. You know the basics of \
			manipulating plant genes.\
			<br>- You can safely plant and weed exotic plants.\
			<br>- You can operate xenoflora machines. The sample's degradation decreases \
			with skill level.\
		"},
		/singleton/skill_level/expert = {"\
			You're a botanist or farmer, capable of running a facility's hydroponics farms \
			or doing botanical research. You are adept at creating custom hybrids and \
			modified strains.\
		"},
		/singleton/skill_level/professional = {"\
			You're a specialized botanist. You can care for even the most exotic, fragile, \
			or dangerous plants. You can use gene manipulation machinery with precision, \
			and are often able to avoid the degradation of samples.\
		"}
	)
