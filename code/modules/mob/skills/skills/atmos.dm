/singleton/skill/atmos
	name = "Atmospherics"
	save_key = "atmos"
	default_max = SKILL_ADEPT
	difficulty = SKILL_AVERAGE
	desc = "Describes your knowledge of piping, air distribution and gas dynamics."
	levels = list(
		/singleton/skill_level/none = {"\
			You know that the air monitors flash orange when the air is bad and red when \
			it's deadly. You know that a flashing fire door means danger on the other side. \
			You know that some gases are poisonous, that pressure has to be kept in a safe \
			range, and that most creatures need oxygen to live. You can use a fire extinguisher \
			or deploy an inflatable barrier.\
			<br>- RPD may give out random pipes, chance decreases with levels.\
			<br>- You cannot recompress pipes with the RPD.\
		"},
		/singleton/skill_level/basic = {"\
			You know how to read an air monitor, how to use an air pump, how to analyze the \
			atmosphere in a space, and how to help seal a breach. You can lay piping and work \
			with gas tanks and canisters. If you work with the engine, you can set up the \
			cooling system. You can use a fire extinguisher easily and place inflatable barriers \
			so that they allow convenient access and airtight breach containment.\
			<br>- You can recompress pipes with the RPD.\
		"},
		/singleton/skill_level/adept = {"\
			You can run the atmospherics system. You know how to monitor the air quality across \
			the installation detect problems, and fix them. You're trained in dealing with fires, \
			breaches, and gas leaks, and may have exosuit or fire gear training.\
			<br>- You can use the RPD safely.\
		"},
		/singleton/skill_level/expert = {"\
			Your atmospherics experience lets you find, diagnose, and fix breaches efficiently. \
			You can manage complex atmospherics systems without fear of making mistakes, and are \
			proficient with all monitoring and pumping equipment at your disposal.\
			<br>- You can dispense a larger selection of pipes from the RPD.\
		"},
		/singleton/skill_level/professional = {"\
			You are an atmospherics specialist. You monitor, modify, and optimize the installation \
			atmospherics system, and you can quickly and easily deal with emergencies. You can \
			modify atmospherics systems to do pretty much whatever you want them to. You can easily \
			handle a fire or breach, and are proficient at securing an area and rescuing civilians, \
			but you're equally likely to have simply prevented it from happening in the first place.\
		"}
	)
