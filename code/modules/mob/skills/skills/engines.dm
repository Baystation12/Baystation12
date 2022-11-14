/singleton/skill/engines
	name = "Engines"
	save_key = "engines"
	default_max = SKILL_ADEPT
	difficulty = SKILL_HARD
	desc = {"\
		Describes your knowledge of the various engine types common on space stations, such as \
		the PACMAN, singularity, supermatter or RUST engine.\
	"}
	levels = list(
		/singleton/skill_level/none = {"\
			You know that \"delamination\" is a bad thing and that you should stay away from the \
			singularity. You know the engine provides power, but you're unclear on the specifics. \
			If you were to try to set up the engine, you would need someone to talk you through \
			every detail - and even then, you'd probably make deadly mistakes.\
			<br>- You can read the SM monitor readings with 40% error. This decreases with level.\
		"},
		/singleton/skill_level/basic = {"\
			You know the basic theoretical principles of engine operation. You can try to set up \
			the engine by yourself, but you are likely to need some assistance and supervision, \
			otherwise you are likely to make mistakes. You are fully capable of running a \
			PACMAN-type generator.\
		"},
		/singleton/skill_level/adept = {"\
			You can set up the engine, and you probably won't botch it up too badly. You know how \
			to protect yourself from radiation in the engine room. You can read the engine \
			monitors and keep the engine going. An engine malfunction may stump you, but you can \
			probably work out how to fix it - let's just hope you do so quickly enough to prevent \
			serious damage.\
			<br>- You can fully read the SM monitor readings.\
		"},
		/singleton/skill_level/expert = {"\
			You have years of experience with engines, and can set them up quickly and reliably. \
			You're familiar with engine types other than the one you work with.\
			<br>- You can examine the SM directly for its integrity.\
		"},
		/singleton/skill_level/professional = {"\
			Your engine is your baby and you know every minute detail of its workings. You can \
			optimize the engine and you probably have your own favorite custom setup. You could \
			build an engine from the ground up. When things go wrong, you know exactly what has \
			happened and how to fix the problem. You can safely handle singularities and \
			supermatter.\
			<br>- You can examine the SM directly for an approximate number of its EER.\
		"}
	)
