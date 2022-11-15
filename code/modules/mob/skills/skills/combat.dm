/singleton/skill/combat
	name = "Close Combat"
	save_key = "combat"
	default_max = /singleton/skill_level/adept
	difficulty = DIFFICULTY_AVERAGE
	desc = {"\
		This skill describes your training in hand-to-hand combat or melee weapon \
		usage. While expertise in this area is rare in the era of firearms, \
		experts still exist among athletes.\
	"}
	levels = list(
		/singleton/skill_level/none = {"\
			You can throw a punch or a kick, but it'll knock you off-balance. You're \
			inexperienced and have probably never been in a serious hand-to-hand fight. \
			In a fight, you might panic and run, grab whatever's nearby and blindly \
			strike out with it, or (if the other guy is just as much of a beginner as \
			you are) make a fool out of yourself.\
			<br>- You can disarm, grab, and hit. Their success chance depends on the \
			fighters' skill difference.\
			<br>- The chance of falling over when tackled is reduced with level.\
		"},
		/singleton/skill_level/basic = {"\
			You either have some experience with fistfights, or you have some \
			training in a martial art. You can handle yourself if you really have to, \
			and if you're a security officer, can handle a stun baton at least well \
			enough to get the handcuffs onto a criminal.\
		"},
		/singleton/skill_level/adept = {"\
			You have had close-combat training, and can easily defeat unskilled opponents. \
			Close combat may not be your specialty, and you don't engage in it more than \
			needed, but you know how to handle yourself in a fight.\
			<br>- You can parry with weapons. This increases with level.\
			<br>- You can do grab maneuvers (pinning, dislocating).\
			<br>- You can grab targets when leaping at them and not fall over, if your \
			species is able to do so.\
		"},
		/singleton/skill_level/expert = {"\
			You're good at hand-to-hand combat. You've trained explicitly in a martial art \
			or as a close combatant as part of a military or police unit. You can use \
			weaponry competently and you can think strategically and quickly in a melee. \
			You're in good shape and you spend time training.\
		"},
		/singleton/skill_level/professional = {"\
			You specialize in hand-to-hand combat. You're well-trained in a practical \
			martial art, and in good shape. You spend a lot of time practicing. You can take \
			on just about anyone, use just about any weapon, and usually come out on top. \
			You may be a professional athlete or special forces member.\
		"}
	)


/singleton/skill/combat/GetPointCost(singleton/skill_level/level)
	if (istype(level))
		level = level.type
	switch (level)
		if (/singleton/skill_level/basic)
			return difficulty
		if (/singleton/skill_level/adept, /singleton/skill_level/expert)
			return 2 * difficulty
		if (/singleton/skill_level/professional)
			return 4 * difficulty
	return 0
