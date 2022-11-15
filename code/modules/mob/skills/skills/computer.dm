/singleton/skill/computer
	name = "Information Technology"
	save_key = "computer"
	default_max = /singleton/skill_level/professional
	difficulty = DIFFICULTY_EASY
	desc = {"\
		Describes your understanding of computers, software and communication. Not a \
		requirement for using computers, but definitely helps. Used in telecommunications \
		and programming of computers and AIs.\
	"}
	levels = list(
		/singleton/skill_level/none = {"\
			You know how to use the computers and communication devices that you grew up with. \
			You can use a computer console, a handheld or wall-mounted radio, and your headset, \
			as well as your PDA. You know what an AI is, but you may see them as either "people \
			made of silicon" or "only machines"; you know they have to obey their laws, but \
			you don't know much about how or why they work.\
		"},
		/singleton/skill_level/basic = {"\
			You know the basics of programming, but you're not very good at it and couldn't do \
			it professionally. You have a pretty good idea of what makes AIs tick. You understand \
			how information is stored in a computer, and you can fix simple computer problems. \
			You're computer-literate, but you still make mistakes. If you tried to subvert the \
			AI, you might make mistakes in wording your new laws.\
			<br>- The antagonist access decryption program has a chance to avoid tripping alarms \
			and working more effectively. This increases with level.\
		"},
		/singleton/skill_level/adept = {"\
			At this level, you're probably working with computers on a daily basis. You understand \
			and can repair the telecommunications network. Your understanding of AI programming and \
			psychology lets you fix problems with the AIs or cyborgs - or create problems, if you \
			so desire. You can program computers and AIs and change their laws effectively.\
			<br>- You can fully operate the Network Monitor, E-mail Administration, and AI \
			Management Programs.\
		"},
		/singleton/skill_level/expert = {"\
			You have years of experience with computer networks, AI systems, telecommunications, \
			and sysadmin tasks. You know the systems used on a daily basis intimately, and can \
			diagnose complex problems.\
			<br>- The antagonist dos program gives extra fake attacking nodes to the system log.\
			<br>- You can use the command line on modular computers (type "man" for a list).\
		"},
		/singleton/skill_level/professional = {"\
			People are probably starting to wonder whether you might be a computer yourself. \
			Computer code is your first language; you relate to AIs as easily as (probably \
			more easily than) organics. You could build a telecommunications network from \
			the ground up.\
		"}
	)
