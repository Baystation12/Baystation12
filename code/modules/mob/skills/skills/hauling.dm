/singleton/skill/hauling
	name = "Athletics"
	save_key = "hauling"
	default_max = /singleton/skill_level/professional
	difficulty = DIFFICULTY_EASY
	desc = "Your ability to perform tasks requiring great strength, dexterity, or endurance."
	levels = list(
		/singleton/skill_level/none = {"\
			You are not used to manual labor, tire easily, and are likely not in great shape. \
			Extended heavy labor may be dangerous for you.\
			<br>- You can pull objects but start to generate Lactate after tiring out. Your \
			strength increases with level.\
			<br>- You can throw objects. Their speed, thrown distance, and force increases \
			with level.\
			<br>- You can sprint, the stamina consumption rate is lowered with each level.\
			<br>- You can leap by clicking on a distant target with grab intent, leap range \
			is increased and chances of falling over are decreased with each level.\
		"},
		/singleton/skill_level/basic = {"\
			You have some familiarity with manual labor, and are in reasonable physical shape. \
			Tasks requiring great dexterity or strength may still elude you.\
			<br>- You can throw "huge" items or normal-sized mobs without getting weakened.\
		"},
		/singleton/skill_level/adept = {"\
			You have sufficient strength and dexterity for more strenuous tasks, and can \
			perform physical labor for longer periods without tiring.\
		"},
		/singleton/skill_level/expert = {"\
			You likely have experience with heavy work in trying physical conditions, and \
			are in excellent shape. You may visit the gym frequently.\
		"},
		/singleton/skill_level/professional = {"\
			You are in excellent shape. You're well-adapted to performing heavy physical \
			labor, and may have requested extra PT.\
		"}
	)
