/singleton/skill/pilot
	name = "Piloting"
	save_key = "pilot"
	default_max = SKILL_ADEPT
	difficulty = SKILL_AVERAGE
	desc = {"\
		Describes your experience and understanding of piloting spacecraft, from \
		small and short-range pods to corvette sized vessels.\
	"}
	levels = list(
		/singleton/skill_level/none = {"\
			You know what a spacecraft is, and you might have an abstract understanding of \
			the differences between various ships. If your department is involved in the \
			use of spacecraft, you know roughly what their capabilities are. You might be \
			able to fly a spacecraft in a videogame. If you were to take the Helm of a \
			smaller vessel, you might be able to move it with proper guidance.\
			<br>- Travel time between tranisition decreases with level.\
			<br>- You can fly ships but their movement might be randomized.\
			<br>- The speed of your ship hitting carps will increase with level.\
		"},
		/singleton/skill_level/basic = {"\
			You can pilot a small, short-range craft safely, but larger ships are out of \
			your area of expertise. You are by no means an expert, and probably don't have \
			much training. Skills of this level are typical for deck crew.\
			<br>- You can operate small shuttlecraft without error.\
			<br>- You can completely avoid meteors on slow speed while using tiny \
			shuttlecrafts such as the GUP.\
		"},
		/singleton/skill_level/adept = {"\
			You are a trained pilot, and can safely operate anything from a small craft to \
			a corvette. You can spend extended periods of time piloting a spacecraft, and \
			you're versed in the abilities of different ships, and what makes them function. \
			You can do basic maintenance on smaller vessels, and perform most basic maneuvers. \
			You can use armed spacecraft. You can make basic calculations relating to piloting. \
			Skills of this level are typical for newer pilots. You have probably received \
			formal piloting training.\
			<br>- You can operate large ships without error.\
			<br>- You can mostly avoid meteors on slow speed using any shuttlecrafts.\
		"},
		/singleton/skill_level/expert = {"\
			You are an experienced pilot, and can safely take the helm of many types of craft. \
			You could probably live in a spacecraft, and you're very well versed in essentially \
			everything related to space-faring vessels. Not only can you fly a ship, but you can \
			perform difficult maneuvers, and make most calculations related to piloting a \
			spacecraft. You can maintain a ship. Skills of this level are typical for very \
			experienced pilots. You have received formal piloting training.\
			<br>- You can somewhat avoid meteors on normal speed while using tiny shuttlecrafts.\
		"},
		/singleton/skill_level/professional = {"\
			Not only are you an exceptional pilot, but you have mastered peripheral functions \
			such as stellar navigation and bluespace jump plotting. You have experience performing \
			complex maneuvers, managing squadrons of small craft, and operating in hostile environments.\
			<br>- You can mostly avoid meteors on normal speed using any shuttlecrafts.\
			<br>- Less meteors will hit the ship while passing through meteor fields.\
		"}
	)
