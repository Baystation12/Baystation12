/singleton/skill/science
	save_key = "science"
	name = "Science"
	save_key = "devices"
	default_max = SKILL_ADEPT
	difficulty = SKILL_AVERAGE
	desc = "Your experience and knowledge with scientific methods and processes."
	levels = list(
		/singleton/skill_level/none = {"\
			You know what science is and probably have a vague idea of the scientific \
			method from secondary education science classes.\
		"},
		/singleton/skill_level/basic = {"\
			You keep up with scientific discoveries. You know a little about most fields of \
			research. You've learned basic laboratory skills. You may read about science as \
			a hobby; or you may be working in a field related to science and have learned \
			about science that way. You could design a simple experiment.\
			<br>- You can determine the presence of flora, fauna, and an atmosphere when \
			scanning exoplanets.\
		"},
		/singleton/skill_level/adept = {"\
			You are a scientist, perhaps a graduate student or post-graduate researcher. \
			You can design an experiment, analyze your results, publish your data, and \
			integrate what you've learned with the research of other scientists. Your \
			laboratory skills are reliable, and you know how to find information you need when \
			you research a new scientific topic. You can dissect exotic xenofauna without \
			many issues.\
			<br>- You can determine the composition of an atmosphere when scanning exoplanets.\
			<br>- You can determine the number of artificial structures when scanning exoplanets.\
			<br>- You can successfully perform surgery on slimes.\
		"},
		/singleton/skill_level/expert = {"\
			You are a junior researcher. You can formulate your own questions, use the tools \
			at hand to test your hypotheses, and investigate entirely new phenomena. You likely \
			have a track record of success in publishing your conclusions and attracting funding.\
		"},
		/singleton/skill_level/professional = {"\
			You are a professional researcher, and you have made multiple new discoveries in your \
			field. Your experiments are well-designed. You are known as an authority in your \
			specialty and your papers often appear in prestigious journals. You may be coordinating \
			the research efforts of a team of scientists, and likely know how to make your findings \
			appealing to investors.\
		"}
	)
