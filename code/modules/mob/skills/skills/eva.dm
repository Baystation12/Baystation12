/singleton/skill/eva
	name = "Extra-vehicular activity"
	save_key = "eva"
	default_max = /singleton/skill_level/professional
	difficulty = DIFFICULTY_EASY
	desc = "This skill describes your skill and knowledge of space-suits and working in vacuum."
	levels = list(
		/singleton/skill_level/none = {"\
			You have basic safety training common to people who work in space: \
			You know how to put on and seal your internals, and you can probably struggle \
			into a space suit if you really need to, though you'll be clumsy at it. \
			You're still prone to mistakes that may leave you trying to breathe vacuum.\
			<br>- You can remove hardsuits. Its speed increases with level.\
			<br>- You will always get floored when you enter gravity area from space. This \
			chance decreases with level.\
			<br>- You are likely to slip. This chance decreases with level.\
		"},
		/singleton/skill_level/basic = {"\
			You have had thorough basic training in EVA operations, and are unlikely to \
			make novice mistakes. However, you have little experience working in vacuum.\
		"},
		/singleton/skill_level/adept = {"\
			You can comfortably use a space suit and do so regularly in the course of your work. \
			Checking your internals is second nature to you, and you don't panic in an emergency.\
			<br>- You can fully operate jetpacks.\
		"},
		/singleton/skill_level/expert = {"\
			You can use all kinds of space suits, including specialized versions. \
			Your years of experience in EVA keep you from being disoriented in space, and you \
			have experience using a jetpack to move around.\
			<br>- You cannot slip anymore.\
		"},
		/singleton/skill_level/professional = {"\
			You are just as much at home in a vacuum as in atmosphere. You probably do your \
			job almost entirely EVA.\
			<br>- You cannot get floored anymore.\
			<br>- You get bonus speed in zero-G.\
		"}
	)
