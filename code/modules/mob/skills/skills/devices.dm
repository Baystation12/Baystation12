/singleton/skill/devices
	name = "Complex Devices"
	save_key = "devices"
	default_max = /singleton/skill_level/adept
	difficulty = DIFFICULTY_AVERAGE
	desc = {"\
		Describes the ability to assemble complex devices, such as computers, circuits, \
		printers, robots or gas tank assemblies (bombs). Note that if a device requires \
		electronics or programming, those skills are also required in addition to this skill.\
	"}
	levels = list(
		/singleton/skill_level/none = {"\
			You know how to use the technology that was present in whatever society you grew \
			up in. You know how to tell when something is malfunctioning, but you have to \
			call tech support to get it fixed.\
		"},
		/singleton/skill_level/basic = {"\
			You use and repair high-tech equipment in the course of your daily work. You \
			can fix simple problems, and you know how to use a circuit printer or autolathe. \
			You can build simple robots such as cleanbots and medibots.\
		"},
		/singleton/skill_level/adept = {"\
			You can build or repair an exosuit or cyborg chassis, use a protolathe and \
			destructive analyzer, and build prosthetic limbs. You can safely transfer \
			an MMI or posibrain into a cyborg chassis.\
			<br>- You can attach robotic limbs. Its speed increases with level.\
			<br>- You can perform cybernetics procedures if you have Trained Anatomy skill.\
		"},
		/singleton/skill_level/expert = {"\
			You have years of experience building or reverse-engineering complex devices. \
			Your use of the lathes and destructive analyzers is efficient and methodical. \
			You can design contraptions to order, and likely sell those designs at a profit.\
		"},
		/singleton/skill_level/professional = {"\
			You are an inventor or researcher. You can design, build, and modify equipment \
			that most people don't even know exists. You are at home in the lab and the \
			workshop and you've never met a gadget you couldn't take apart, put back \
			together, and replicate.\
		"}
	)
