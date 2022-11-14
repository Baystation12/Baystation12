/singleton/skill/electrical
	name = "Electrical Engineering"
	save_key = "electrical"
	default_max = SKILL_ADEPT
	difficulty = SKILL_AVERAGE
	desc = {"\
		This skill describes your knowledge of electronics and the underlying physics. A \
		low level of this skill implies you know how to lay out wiring and configure \
		powernets, a high level of this skill is required for working complex electronic \
		devices such as circuits or bots.\
	"}
	levels = list(
		/singleton/skill_level/none = {"\
			You know that electrical wires are dangerous and getting shocked is bad; you \
			can see and report electrical malfunctions such as broken wires or malfunctioning \
			APCs. You can change a light bulb, and you know how to replace a battery or \
			charge up the equipment you normally use.\
			<br>- Every time you open the hacking panel, wires are randomized.\
			<br>- Every time you pulse a wire, there is a chance you pulse a different one.\
			<br>- Every time you cut a wire, there is a chance you cut/mend extra ones.\
			<br>- You can misconnect remote signalling devices.\
		"},
		/singleton/skill_level/basic = {"\
			You can do basic wiring; you can lay cable for solars or the engine. You can \
			repair broken wiring and build simple electrical equipment like light fixtures \
			or APCs. You know the basics of circuits and understand how to protect yourself \
			from electrical shock. You can probably hack a vending machine.\
			<br>- Every time you open the hacking panel, some wires might be duplicated.\
		"},
		/singleton/skill_level/adept = {"\
			You can repair and build electrical equipment and do so on a regular basis. You \
			can troubleshoot an electrical system and monitor the installation power grid. \
			You can probably hack an airlock.\
			<br>- You can safely hack machines.\
		"},
		/singleton/skill_level/expert = {"\
			You can repair, build, and diagnose any electrical devices with ease. You know \
			your way around APCs, SMES units, and monitoring software, and take apart or hack \
			most objects.\
			<br>- You can safely place remote signaling devices.\
			<br>- You can examine one or two wires on the hacking panel.\
		"},
		/singleton/skill_level/professional = {"\
			You are an electrical engineer or the equivalent. You can design, upgrade, and \
			modify electrical equipment and you are good at maximizing the efficiency of \
			your power network. You can hack anything on the installation you can deal \
			with power outages and electrical problems easily and efficiently.\
			<br>- You can examine most wires on the hacking panel.\
		"}
	)
