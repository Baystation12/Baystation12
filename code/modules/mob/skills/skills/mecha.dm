/singleton/skill/mecha
	name = "Exosuit Operation"
	save_key = "mecha"
	default_max = SKILL_BASIC
	difficulty = SKILL_AVERAGE
	prerequisites = list(
		/singleton/skill/eva = /singleton/skill_level/adept
	)
	desc = "Allows you to operate exosuits well."
	levels = list(
		/singleton/skill_level/none = {"\
			You are unfamiliar with exosuit controls, and if you attempt to use them you are \
			liable to make mistakes.\
		"},
		/singleton/skill_level/adept = {"\
			You are proficient in exosuit operation and safety, and can use them without penalties.\
		"}
	)
