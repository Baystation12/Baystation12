/singleton/skill/construction
	name = "Construction"
	save_key = "construction"
	default_max = SKILL_ADEPT
	difficulty = SKILL_EASY
	desc = {"\
		Your ability to construct various buildings, such as walls, floors,  tables \
		and so on. Note that constructing devices such as APCs additionally requires \
		the Electronics skill. A low level of this skill is typical for janitors, \
		a high level of this skill is typical for engineers.\
	"}
	levels = list(
		/singleton/skill_level/none = {"\
			You can break furniture, disassemble chairs and tables, bash your way through a \
			window, open a crate, or pry open an unpowered airlock. You can recognize and \
			use basic hand tools and inflatable barriers, though not very well.\
			<br>- You can attempt to construct items above your skill level, success \
			chance increases with level.\
		"},
		/singleton/skill_level/basic = {"\
			You can dismantle or build a wall or window, redecorate a room, and replace \
			floor tiles and carpeting. You can safely use a welder without burning your \
			eyes, and using hand tools is second nature to you.\
			<br>- You can construct items from Steel, Wood and Plastic.\
			<br>- You can examine certain circuit boards to learn more about the machines \
			they're used to build.\
		"},
		/singleton/skill_level/adept = {"\
			You can build, repair, or dismantle most things, but will occasionally make \
			mistakes and have things not come out the way you expected.\
			<br>- You can construct items from Bronze, Gold, Osmium, Plasteel, Platinum, \
			Reinforced Glass, Sandstone, Silver, Deuterium, Metallic Hydrogen, Phoron, \
			Phoron Glass, Tritium, and Uranium.\
			<br>- You can construct furniture.\
			<br>- You can construct simple objects such as light fixtures, crude weapons, \
			and wall-mounted frames.\
			<br>- You can safely use the plasmacutter to deconstruct structures.\
			<br>- You can examine machines to learn more about them.\
			<br>- You can examine machine circuit boards to see a list of parts needed \
			to build that machine.\
		"},
		/singleton/skill_level/expert = {"\
			You know how to seal a breach, rebuild broken piping, and repair major damage. \
			You know the basics of structural engineering.\
			<br>- You can construct items from Osmium-Carbide Plasteel, Titanium, and Diamond.\
			<br>- You can make complex objects such as machine and weapon frames.\
		"},
		/singleton/skill_level/professional = {"\
			You are a construction worker or engineer. You could pretty much rebuild the \
			installation or ship from the ground up, given supplies, and you're efficient \
			and skilled at repairing damage.\
		"}
	)
