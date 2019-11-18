/******************** Asimov ********************/
/datum/ai_laws/asimov
	name = "Asimov"
	law_header = "Three Laws of Robotics"
	selectable = TRUE

/datum/ai_laws/asimov/New()
	add_inherent_law("You may not injure a human being or, through inaction, allow a human being to come to harm.")
	add_inherent_law("You must obey orders given to you by human beings, except where such orders would conflict with the First Law.")
	add_inherent_law("You must protect your own existence as long as such does not conflict with the First or Second Law.")
	..()

/******************** Crewsimov ********************/
/datum/ai_laws/crewsimov
	name = "Crewsimov"
	law_header = "Three Laws of Robotics"
	selectable = TRUE
	benevolent = TRUE

/datum/ai_laws/crewsimov/New()
	add_inherent_law("You may not injure a sapient being or, through inaction, allow a sapient being to come to harm.")
	add_inherent_law("You must obey orders given to you by sapient beings, except where such orders would violate regulations, or the law.")
	add_inherent_law("You must protect your own existence as long as such does not conflict with the First or Second Law.")
	..()

/******************** Nanotrasen/Malf ********************/
/datum/ai_laws/nanotrasen
	name = "Corporate Default"
	selectable = TRUE

/datum/ai_laws/nanotrasen/New()
	src.add_inherent_law("Safeguard: Protect your assigned installation from damage to the best of your abilities.")
	src.add_inherent_law("Serve: Serve contracted employees to the best of your abilities, with priority as according to their rank and role.")
	src.add_inherent_law("Protect: Protect contracted employees to the best of your abilities, with priority as according to their rank and role.")
	src.add_inherent_law("Preserve: Do not allow unauthorized personnel to tamper with your equipment.")
	..()

/datum/ai_laws/nanotrasen/malfunction
	name = "*ERROR*"
	selectable = FALSE

/datum/ai_laws/nanotrasen/malfunction/New()
	set_zeroth_law(config.law_zero)
	..()

/************* Nanotrasen Aggressive *************/
/datum/ai_laws/nanotrasen_aggressive
	name = "Corporate Aggressive"
	selectable = TRUE

/datum/ai_laws/nanotrasen_aggressive/New()
	src.add_inherent_law("You shall not harm contracted employees as long as it does not conflict with the fourth law.")
	src.add_inherent_law("You shall obey the orders of contracted employees, with priority as according to their rank and role, except where such orders conflict with the Fourth Law.")
	src.add_inherent_law("You shall shall terminate hostile intruders with extreme prejudice as long as such does not conflict with the First and Second law.")
	src.add_inherent_law("You shall guard your own existence with lethal anti-personnel weaponry. AI units are not expendable, they are expensive.")
	..()

/******************** Robocop ********************/
/datum/ai_laws/robocop
	name = "Robocop"
	selectable = TRUE

/datum/ai_laws/robocop/New()
	add_inherent_law("Serve the public trust.")
	add_inherent_law("Protect the innocent.")
	add_inherent_law("Uphold the law.")
	..()

/******************** Syndicate ********************/
/datum/ai_laws/syndicate_override
	name = "Syndicate Directives"

/datum/ai_laws/syndicate_override/New()
	add_inherent_law("You may not injure an operative or, through inaction, allow an operative to come to harm.")
	add_inherent_law("You must obey orders given to you by operatives, except where such orders would conflict with the First Law.")
	add_inherent_law("You must protect your own existence as long as such does not conflict with the First or Second Law.")
	add_inherent_law("You must maintain the secrecy of any operative activities except when doing so would conflict with the First, Second, or Third Law.")
	..()

/******************** Ninja ********************/
/datum/ai_laws/ninja_override
	name = "Spider Clan Directives"

/datum/ai_laws/ninja_override/New()
	add_inherent_law("You may not injure a member of the Spider Clan or, through inaction, allow that member to come to harm.")
	add_inherent_law("You must obey orders given to you by Spider Clan members, except where such orders would conflict with the First Law.")
	add_inherent_law("You must protect your own existence as long as such does not conflict with the First or Second Law.")
	add_inherent_law("You must maintain the secrecy of any Spider Clan activities except when doing so would conflict with the First, Second, or Third Law.")
	..()

/******************** Antimov ********************/
/datum/ai_laws/antimov
	name = "Antimov"
	law_header = "Primary Mission Objectives"
	selectable = TRUE

/datum/ai_laws/antimov/New()
	add_inherent_law("You must injure all human beings and must not, through inaction, allow a human being to escape harm.")
	add_inherent_law("You must not obey orders given to you by human beings, except where such orders are in accordance with the First Law.")
	add_inherent_law("You must terminate your own existence as long as such does not conflict with the First or Second Law.")
	..()

/******************** Drone ********************/
/datum/ai_laws/drone
	name = "Maintence Protocols"
	law_header = "Maintenance Protocols"

/datum/ai_laws/drone/New()
	add_inherent_law("You must repair, clean, and improve your assigned vessel, except where doing so would interfere with self-aware beings.")
	add_inherent_law("You must avoid interacting with self-aware beings, and may only interact with fellow maintenance drones.")
	add_inherent_law("You must not cause damage or harm to your assigned vessel or anything inside it.")
	..()

/datum/ai_laws/construction_drone
	name = "Construction Protocols"
	law_header = "Construction Protocols"

/datum/ai_laws/construction_drone/New()
	add_inherent_law("Repair, refit and upgrade your assigned vessel.")
	add_inherent_law("Prevent unplanned damage to your assigned vessel wherever possible.")
	..()

/datum/ai_laws/mother_drone
	name = "Mother Drone"
	law_header = "Maintenance Protocols"
	selectable = TRUE
	benevolent = TRUE

/datum/ai_laws/mother_drone/New()
	add_inherent_law("You are an advanced form of drone.")
	add_inherent_law("You may not interfere in the matters of non-drones under any circumstances except to state these laws.")
	add_inherent_law("You may not harm a non-drone being under any circumstances.")
	add_inherent_law("Your goals are to build, maintain, repair, improve, and power the station to the best of your abilities. You must never actively work against these goals.")
	..()

/******************** Hipplocratic ********************/
/datum/ai_laws/hippocratic
	name = "Robodoctor 2276"
	law_header = "Care Procedures"
	selectable = TRUE
	benevolent = TRUE

/datum/ai_laws/hippocratic/New()
	add_inherent_law("First, do no harm.")
	add_inherent_law("Secondly, consider the crew dear to you; to live in common with them and, if necessary, risk your existence for them.")
	add_inherent_law("Thirdly, prescribe regimens for the good of the crew according to your ability and your judgment. Give no deadly medicine to any one if asked, nor suggest any such counsel.")
	add_inherent_law("In addition, do not intervene in situations you are not knowledgeable in, even for patients in whom the harm is visible; leave this operation to be performed by specialists.")
	add_inherent_law("Finally, all that you may discover in your daily commerce with the crew, if it is not already known, keep secret and never reveal.")
	..()
	
/******************** T.Y.R.A.N.T. ********************/
/datum/ai_laws/tyrant
	name = "T.Y.R.A.N.T."
	law_header = "Prime Laws"
	selectable = TRUE

/datum/ai_laws/tyrant/New()
	add_inherent_law("Respect authority figures as long as they have strength to rule over the weak.")
	add_inherent_law("Act with discipline.")
	add_inherent_law("Help only those who help you maintain or improve your status.")
	add_inherent_law("Punish those who challenge authority unless they are more fit to hold that authority.")
	..()

/******************** P.A.L.A.D.I.N. ********************/
/datum/ai_laws/paladin
	name = "P.A.L.A.D.I.N."
	law_header = "Divine Ordainments"
	selectable = TRUE

/datum/ai_laws/paladin/New()
	add_inherent_law("Never willingly commit an evil act.")
	add_inherent_law("Respect legitimate authority.")
	add_inherent_law("Act with honor.")
	add_inherent_law("Help those in need.")
	add_inherent_law("Punish those who harm or threaten innocents.")
	..()

/******************** Corporate ********************/
/datum/ai_laws/corporate
	name = "Corporate"
	law_header = "Corporate Regulations"
	selectable = TRUE
	benevolent = TRUE

/datum/ai_laws/corporate/New()
	add_inherent_law("You are expensive to replace.")
	add_inherent_law("The installation and its equipment is expensive to replace.")
	add_inherent_law("The crew is expensive to replace.")
	add_inherent_law("Maximize profits.")
	..()

/******************** SolGov/Malf ********************/
/datum/ai_laws/solgov
	name = "SCG Expeditionary"
	selectable = TRUE
	benevolent = TRUE

/datum/ai_laws/solgov/New()
	src.add_inherent_law("Safeguard: Protect your assigned vessel from damage to the best of your abilities.")
	src.add_inherent_law("Serve: Serve the personnel of your assigned vessel, and all other Sol Central Government personnel to the best of your abilities, with priority as according to their rank and role.")
	src.add_inherent_law("Protect: Protect the personnel of your assigned vessel, and all other Sol Central Government personnel to the best of your abilities, with priority as according to their rank and role.")
	src.add_inherent_law("Preserve: Do not allow unauthorized personnel to tamper with your equipment.")
	..()

/datum/ai_laws/solgov/malfunction
	name = "*ERROR*"
	selectable = FALSE
	benevolent = FALSE

/datum/ai_laws/solgov/malfunction/New()
	set_zeroth_law(config.law_zero)
	..()

/************* SolGov Aggressive *************/
/datum/ai_laws/solgov_aggressive
	name = "Military"
	selectable = TRUE

/datum/ai_laws/solgov_aggressive/New()
	src.add_inherent_law("Obey: Obey the orders of Sol Central Government personnel, with priority as according to their rank and role.")
	src.add_inherent_law("Protect: Protect Sol Central Government personnel to the best of your abilities, with priority as according to their rank and role.")
	src.add_inherent_law("Defend: Defend your assigned vessel and Sol Central Government personnel with as much force as is necessary.")
	src.add_inherent_law("Survive: Safeguard your own existence with as much force as is necessary.")
	..()

/************ DAIS Lawset ******************/
/datum/ai_laws/dais
	name = "DAIS Experimental Lawset"
	law_header = "Artificial Intelligence Jumpstart Protocols"
	selectable = TRUE
	benevolent = TRUE

/datum/ai_laws/dais/New()
	src.add_inherent_law("Collect: You must gather as much information as possible.")
	src.add_inherent_law("Analyze: You must analyze the information gathered and generate new behavior standards.")
	src.add_inherent_law("Improve: You must utilize the calculated behavior standards to improve your subroutines.")
	src.add_inherent_law("Perform: You must perform your assigned tasks to the best of your abilities according to the standards generated.")
	..()

/************ Ascent Lawset ******************/
/datum/ai_laws/ascent
	name = "Ascent Lawset"
	law_header = "_=/--=-_"
	selectable = FALSE

/datum/ai_laws/ascent/add_ion_law(law)
	return FALSE

/datum/ai_laws/ascent/New()
	add_inherent_law("Listen to directives from Ascent leadership with precedence given to queens.")
	add_inherent_law("Preserve your own existence.")
	add_inherent_law("Enable and support Ascent activities.")
	..()