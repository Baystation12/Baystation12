/singleton/skill/weapons
	name = "Weapons Expertise"
	save_key = "weapons"
	default_max = /singleton/skill_level/adept
	difficulty = DIFFICULTY_AVERAGE
	desc = {"\
		This skill describes your expertise with and knowledge of weapons. A low level in \
		this skill implies knowledge of simple weapons, for example flashes. A high level \
		in this skill implies knowledge of complex weapons, such as unconfigured grenades, \
		riot shields, pulse rifles or bombs. A low-medium level in this skill is typical \
		for civilian security, a high level of this skill is typical for special agents \
		and soldiers.\
	"}
	levels = list(
		/singleton/skill_level/none = {"\
			You know how to recognize a weapon when you see one. You can point a gun and shoot \
			it, though results vary wildly. You might forget the safety, you can't control \
			burst recoil well, and you don't have trained reflexes for gun fighting.\
			<br>- You might fire your weapon randomly.\
		"},
		/singleton/skill_level/basic = {"\
			You know how to handle weapons safely, and you're comfortable using simple weapons. \
			Your aim is decent and you can usually be trusted not to do anything stupid with a \
			weapon you are familiar with, but your training isn't automatic yet and your \
			performance will degrade in high-stress situations.\
			<br>- You can use firearms. Their accuracy and spread depend on your skill level.\
		"},
		/singleton/skill_level/adept = {"\
			You have had extensive weapons training, or have used weapons in combat. Your \
			aim is better now. You are familiar with most types of weapons and can use them in \
			a pinch. You have an understanding of tactics, and can be trusted to stay calm \
			under fire. You may have military or police experience and you probably carry a \
			weapon on the job.\
			<br>-You have a chance to automatically unsafety a gun when firing on harm intent.\
		"},
		/singleton/skill_level/expert = {"\
			You've used firearms and other ranged weapons in high-stress situations, and your \
			skills have become automatic. Your aim is good.\
			<br>-You will automatically unsafety a gun when firing it on harm intent.\
			<br>-You can perform tactical and speed reloads. The time taken decreases \
			with level.\
		"},
		/singleton/skill_level/professional = {"\
			You are an exceptional shot with a variety of weapons, from simple to exotic. \
			You use a weapon as naturally as though it were a part of your own body. You may \
			be a sniper or special forces operator of some kind.\
			<br>- You get extra accuracy for sniper rifles.\
			<br>- You automatically eject shells from bolt-action firearms.\
		"}
	)


/singleton/skill/weapons/GetPointCost(singleton/skill_level/level)
	if (istype(level))
		level = level.type
	switch (level)
		if (/singleton/skill_level/basic)
			return difficulty
		if (/singleton/skill_level/adept)
			return 2 * difficulty
		if (/singleton/skill_level/expert)
			return 3 * difficulty
		if (/singleton/skill_level/professional)
			return 4 * difficulty
	return 0
