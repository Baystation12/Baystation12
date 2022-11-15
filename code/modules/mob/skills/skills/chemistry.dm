/singleton/skill/chemistry
	name = "Chemistry"
	save_key = "chemistry"
	default_max = /singleton/skill_level/adept
	difficulty = DIFFICULTY_HARD
	desc = {"\
		Experience with mixing chemicals, and an understanding of what the effect will \
		be. This doesn't cover an understanding of the effect of chemicals on the human \
		body, as such the medical skill is also required for medical chemists.\
	"}
	levels = list(
		/singleton/skill_level/none = {"\
			You know that chemists work with chemicals; you know that they can make medicine \
			or poison or useful chemicals. You probably know what an element is and have a \
			vague idea of what a chemical reaction is from some chemistry class back during \
			your school days.\
		"},
		/singleton/skill_level/basic = {"\
			You can make basic chemicals or medication--things like space cleaner or \
			anti-toxin. You have some training in safety and you might not blow up \
			the lab.\
			<br>- You can safely use the industrial grinder but lose some ingredients. \
			Its amount decreases with skill level.\
		"},
		/singleton/skill_level/adept = {"\
			You can accurately measure out reagents, grind powders, and perform chemical \
			reactions. You may still lose some product on occasion, but are unlikely to \
			endanger yourself or those around you.<br>- You can fully operate the chem \
			dispenser.\
		"},
		/singleton/skill_level/expert = {"\
			You work as a chemist, or else you are a doctor with training in chemistry. \
			If you are a research chemist, you can create most useful chemicals; if you \
			are a pharmacist, you can make most medications. At this stage, you're \
			working mostly by-the-book. You can weaponize your chemicals by making \
			grenades, smoke bombs, and similar devices.\
			<br>- You can examine held containers for scannable reagents.\
		"},
		/singleton/skill_level/professional = {"\
			You specialized in chemistry or pharmaceuticals; you are either a medical \
			researcher or professional chemist. You can create custom mixes and make \
			even the trickiest of medications easily. You understand how your \
			pharmaceuticals interact with the bodies of your patients. You are probably \
			the originator of at least one new chemical innovation.\
			<br>- You can examine held containers for all reagents.\
		"}
	)
