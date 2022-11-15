/singleton/skill/forensics
	name = "Forensics"
	save_key = "forensics"
	default_max = /singleton/skill_level/adept
	difficulty = DIFFICULTY_AVERAGE
	desc = {"\
		Describes your skill at performing forensic examinations and identifying vital evidence. \
		Does not cover analytical abilities, and as such isn't the only indicator for your \
		investigation skill. Note that in order to perform autopsy, the surgery skill is \
		also required.\
	"}
	levels = list(
		/singleton/skill_level/none = {"\
			You know that detectives solve crimes. You may have some idea that it's bad to \
			contaminate a crime scene, but you're not too clear on the details.\
		"},
		/singleton/skill_level/basic = {"\
			You know how to avoid contaminating a crime scene. You know how to bag the \
			evidence without contaminating it unduly.\
		"},
		/singleton/skill_level/adept = {"\
			You are trained in collecting forensic evidence - fibers, fingerprints, the \
			works. You know how autopsies are done, and might've assisted performing one.\
			<br>- You can more easily detect fingerprints.\
			<br>- You no longer contaminate evidence.\
		"},
		/singleton/skill_level/expert = {"\
			You're a pathologist, or detective. You've seen your share of bizarre cases, \
			and spent a lot of time putting pieces of forensic puzzle together, so you're \
			faster now.\
			<br>- You can notice additional details upon examining, such as fibers, \
			partial prints, and gunshot residue.\
		"},
		/singleton/skill_level/professional = {"\
			You're a big name in forensic science. You might be an investigator who cracked \
			a famous case, or you published papers on new methods of forensics. Either way, \
			if there's a forensic trail, you will find it, period.\
			<br>- You can notice traces of wiped off blood.\
		"}
	)


/singleton/skill/forensics/GetPointCost(singleton/skill_level/level)
	if (istype(level))
		level = level.type
	switch (level)
		if (/singleton/skill_level/basic, /singleton/skill_level/adept, /singleton/skill_level/expert)
			return difficulty * 2
		if (/singleton/skill_level/professional)
			return 3 * difficulty
	return 0
