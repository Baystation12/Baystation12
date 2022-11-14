/singleton/skill/bureaucracy
	name = "Bureaucracy"
	save_key = "bureaucracy"
	default_max = SKILL_MAX
	difficulty = SKILL_EASY
	desc = {"\
		Your ability to write and complete paperwork, navigate complex organiztions, \
		and understand laws and regulations.\
	"}
	levels = list(
		/singleton/skill_level/none = {"\
			You can usually fill out basic paperwork, if with a few errors. You have a vague \
			understanding of the law, gleaned mostly from the news and personal experience.\
		"},
		/singleton/skill_level/basic = {"\
			You are familiar with the paperwork needed to do your job, and can navigate it well. \
			You have some understanding of the law as it applies to you and those around you.\
		"},
		/singleton/skill_level/adept = {"\
			You can navigate most paperwork thrown at you, even if you are unfamiliar with it. \
			You have a good working understanding of the law and any regulations or procedures \
			relevant to you.\
		"},
		/singleton/skill_level/expert = {"\
			With your experience, you can easily create paperwork for any eventuality, and \
			write reports which are clear and understandable. You have an excellent knowledge \
			of the law, possibly including formal legal training.\
		"},
		/singleton/skill_level/professional = {"\
			You can make paperwork dance to your bidding, and navigate the most byzantine \
			bureaucratic structures with ease and familiarity. Your reports are works of \
			literature. Your knowledge of the law is both broad and intimate, and you may \
			be certified to practice law.\
		"}
	)
