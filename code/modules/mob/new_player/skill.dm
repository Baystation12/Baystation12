var/const/SKILL_NONE = 0
var/const/SKILL_BASIC = 1
var/const/SKILL_ADEPT = 2
var/const/SKILL_EXPERT = 3

// Specific skill typepaths that won't show up on the skills panel.
// This is used to hide the category subtypes, without having to use special variable.
var/list/hidden_skill_types = list(\
	/datum/skill,\
	/datum/skill/secondary,\
	/datum/skill/security,\
	/datum/skill/engineering,\
	/datum/skill/research,\
	/datum/skill/medical\
	)


proc/setup_skills()
	if(SKILLS == null)
		SKILLS = list()
		for(var/T in (typesof(/datum/skill)-hidden_skill_types))
			var/datum/skill/S = new T
			if(S.ID != "none")
				if(!SKILLS.Find(S.field))
					SKILLS[S.field] = list()
				var/list/L = SKILLS[S.field]
				L += S

mob/living/carbon/human/proc/GetSkillClass(points)
	return CalculateSkillClass(points, age)

proc/show_skill_window(var/mob/user, var/mob/living/carbon/human/M)
	if(!istype(M)) return
	if(SKILLS == null)
		setup_skills()

	if(!M.skills || M.skills.len == 0)
		to_chat(user, "There are no skills to display.")
		return

	var/HTML = "<body>"
	HTML += "<b>Select your Skills</b><br>"
	HTML += "Current skill level: <b>[M.GetSkillClass(M.used_skillpoints)]</b> ([M.used_skillpoints])<br>"
	HTML += "<table>"
	for(var/V in SKILLS)
		HTML += "<tr><th colspan = 5><b>[V]</b>"
		HTML += "</th></tr>"
		for(var/datum/skill/S in SKILLS[V])
			var/level = M.skills[S.ID]
			HTML += "<tr style='text-align:left;'>"
			HTML += "<th>[S.name]</th>"
			HTML += "<th><font color=[(level == SKILL_NONE) ? "red" : "black"]>\[Untrained\]</font></th>"
			// secondary skills don't have an amateur level
			if(S.secondary)
				HTML += "<th></th>"
			else
				HTML += "<th><font color=[(level == SKILL_BASIC) ? "red" : "black"]>\[Amateur\]</font></th>"
			HTML += "<th><font color=[(level == SKILL_ADEPT) ? "red" : "black"]>\[Trained\]</font></th>"
			HTML += "<th><font color=[(level == SKILL_EXPERT) ? "red" : "black"]>\[Professional\]</font></th>"
			HTML += "</tr>"
	HTML += "</table>"

	user << browse(null, "window=preferences")
	user << browse(HTML, "window=show_skills;size=600x800")
	return

mob/living/carbon/human/verb/show_skills()
	set category = "IC"
	set name = "Show Own Skills"

	show_skill_window(src, src)


/datum/skill
    var/ID = "none"					// ID of this skill.
    var/name = "None" 				// Name of the skill. This is what the player sees.
    var/desc = "Placeholder skill" 	// Generic description of this skill.
    var/field = "Unset" 			// Category under which this skill will be listed.
    var/secondary = FALSE 			// Whether the skill is secondary. Secondary skills are cheaper and lack the Amateur level.

   	// Specific descriptions for specific skill levels.
    var/desc_unskilled = "Unskilled Descripton"
    var/desc_amateur = "Amateur Description"
    var/desc_trained = "Trained Description"
    var/desc_professional = "Expert Description"

/datum/skill/secondary
	field = "Secondary"
	secondary = TRUE

/datum/skill/security
	field = "Security"

/datum/skill/engineering
	field = "Engineering"

/datum/skill/research
	field = "Research"

/datum/skill/medical
	field = "Medical"

var/global/list/SKILLS = null

// ONLY SKILL DEFINITIONS BELOW THIS LINE
// Category: Secondary

/datum/skill/secondary/management
    ID = "management"
    name = "Command"
    desc = "Your ability to manage and commandeer other crew members."
    desc_unskilled = "You know a little about management, but you have a lot of flaws and little experience. You are likely to micromanage, lose track of people, or generally muck things up. Handling a major crisis is probably beyond your ability."
    desc_trained = "You're a good commander. You know how to coordinate the efforts of a large group of people effectively. You'll still be thrown off in a crisis, but you'll probably get through it."
    desc_professional = "You're an excellent commander. In addition to just doing your job, you know how to inspire love, loyalty or fear, and you handle crises smoothly and efficiently."

/datum/skill/secondary/EVA
    ID = "EVA"
    name = "Extra-vehicular activity"
    desc = "This skill describes your skill and knowledge of space-suits and working in vacuum."
    desc_unskilled = "You have basic safety training common to people who work in space: You know how to put on and seal your internals, and you can probably struggle into a space suit if you really need to, though you'll be clumsy at it. You're still prone to mistakes that may leave you trying to breathe vacuum."
    desc_trained = "You can comfortably use a space suit and do so regularly in the course of your work. Checking your internals is second nature to you, and you don't panic in an emergency."
    desc_professional = "You can use all kinds of space suits, including specialized versions. You can use a jet pack to navigate and are just as much at home in a vacuum as in atmosphere. You probably do your job almost entirely EVA."

/datum/skill/secondary/law
    ID = "law"
    name = "Legal"
    desc = "Your knowledge of law and procedures. This includes SolGov law, Corporate Regulations, SOP, or other law systems. A low level in this skill is typical of law enforcement, high is typical of people in command of a station or vessel."
    desc_unskilled = "You know most of what's legal and illegal in your everyday life and work, though you're fuzzy on the finer points of the law, especially if it doesn't apply to your own daily experience."
    desc_trained = "You know and understand the law in a practical sense. You know the punishments for crimes and you can read and understand a legal document easily. You may be in Security or Command."
    desc_professional = "You have a law degree or the equivalent amount of knowledge. You can draw up legal contracts, interpret the minutiae of the law, settle disagreements, and argue a case in court."

/datum/skill/secondary/botany
	ID = "botany"
	name = "Botany"
	desc = "Describes how good a character is at growing and maintaining plants."
	desc_unskilled = "You've done some gardening. You can water, weed, fertilize, plant, and harvest, and you can recognize and deal with pests. You may be a hobby gardener."
	desc_trained = "You're a botanist or farmer, growing crops on large scales or doing botanical research. You know the basics of manipulating plant genes."
	desc_professional = "You're a specialized botanist. You can care for even the most exotic, fragile, or dangerous plants, and you can create custom hybrids and modified strains."

/datum/skill/secondary/cooking
	ID = "cooking"
	name = "Cooking"
	desc = "Describes a character's skill at preparing meals and other consumable goods. This includes mixing alcoholic beverages."
	desc_unskilled = "You can make simple meals and do the cooking for your family. Things like spaghetti, grilled cheese, or simple mixed drinks are your usual fare."
	desc_trained = "You can cook professionally, keeping an entire crew fed easily. Your food is tasty and you don't have a problem with tricky or complicated dishes. You can be depended on to make just about any commonly-served drink."
	desc_professional = "Not only are you good at cooking and mixing drinks, but you can manage a kitchen staff and cater for special events. You can safely prepare exotic foods and drinks that would be poisonous if prepared incorrectly."

// Category: Security

/datum/skill/security/combat
	ID = "combat"
	name = "Close Combat"
	desc = "This skill describes your training in hand-to-hand combat or melee weapon usage. While expertise in this area is rare in the era of firearms, experts still exist among athletes."
	desc_unskilled = "You can throw a punch or a kick, but it'll knock you off-balance. You're inexperienced and have probably never been in a serious hand-to-hand fight. In a fight, you might panic and run, grab whatever's nearby and blindly strike out with it, or (if the other guy is just as much of a beginner as you are) make a fool out of yourself."
	desc_amateur = "You either have some experience with fistfights, or you have some training in a martial art. You can handle yourself if you really have to, and if you're a security officer, can handle a stun baton at least well enough to get the handcuffs onto a criminal."
	desc_trained = "You're good at hand-to-hand combat. You've trained explicitly in a martial art or as a close combatant as part of a military or police unit. You can use weaponry competently and you can think strategically and quickly in a melee. You're in good shape and you spend time training."
	desc_professional = "You specialize in hand-to-hand combat. You're well-trained in a practical martial art, and in good shape. You spend a lot of time practicing. You can take on just about anyone, use just about any weapon, and usually come out on top. You may be a professional athlete or special forces member."

/datum/skill/security/weapons
	ID = "weapons"
	name = "Weapons Expertise"
	desc = "This skill describes your expertise with and knowledge of weapons. A low level in this skill implies knowledge of simple weapons, for example flashes. A high level in this skill implies knowledge of complex weapons, such as unconfigured grenades, riot shields, pulse rifles or bombs. A low-medium level in this skill is typical for security officers, a high level of this skill is typical for special agents and soldiers."
	desc_unskilled = "You know how to recognize a weapon when you see one. You can probably use pepper spray or a flash, though you might fumble and turn them on yourself by mistake. You're likely to shoot yourself in the foot or forget to take the safety off. Your lack of training may make you more dangerous to your allies than your enemies."
	desc_amateur = "You know how to handle weapons safely, and you're comfortable using simple weapons. Your aim is decent and you can be trusted not to do anything stupid with a weapon, but your training isn't automatic yet and your performance will degrade in high-stress situations."
	desc_trained = "You've used firearms and other ranged weapons in a high-stress situation, and your skills have become automatic. You spend time practicing at the firing range. Your aim is good. You can maintain and repair your weaponry. You may have military or police experience and you probably carry a weapon on the job."
	desc_professional = "You are an exceptional shot with a variety of weapons, from simple to exotic. You can depend on hitting not just your target, but a specific part of your target, such as shooting someone in the leg. You use a weapon as naturally as though it were a part of your own body. You may be a professional marksman of some kind. You probably know a good deal about tactics, and you may have designed or modified your own weaponry."

/datum/skill/security/forensics
	ID = "forensics"
	name = "Forensics"
	desc = "Describes your skill at performing forensic examinations and identifying vital evidence. Does not cover analytical abilities, and as such isn't the only indicator for your investigation skill. Note that in order to perform autopsy, the surgery skill is also required."
	desc_unskilled = "You know that detectives solve crimes. You may have some idea that it's bad to contaminate a crime scene, but you're not too clear on the details."
	desc_amateur = "You know how to avoid contaminating a crime scene. You know how to use the tools of the trade (scanner, computer database, and so forth), and you can conduct an interview with a witness or a suspect."
	desc_trained = "You're a police officer, pathologist, or detective. You can secure a crime scene, gather evidence, interview witnesses, and put two and two together to get an arrest. If you're trained in anatomy, you can perform an autopsy."
	desc_professional = "You specialize in criminal investigations. Your ability to gather and analyze evidence has been honed through intensive schooling, years of practice, or most likely both. You can organize a manhunt or draw a criminal into a trap, and though you're behind the scenes and may never even see the criminal, your skills make the difference between an unsolved crime and a convicted criminal."

// Category: Engineering

/datum/skill/engineering/construction
    ID = "construction"
    name = "Construction"
    desc = "Your ability to construct various buildings, such as walls, floors, tables and so on. Note that constructing devices such as APCs additionally requires the Electronics skill. A low level of this skill is typical for janitors, a high level of this skill is typical for engineers."
    desc_unskilled = "You can move furniture, assemble or disassemble chairs and tables (sometimes they even stay assembled), bash your way through a window, open a crate, or pry open an unpowered airlock. You can recognize and use basic hand tools and inflatable barriers, though not very well."
    desc_amateur = "You can dismantle or build a wall or window, build furniture, redecorate a room, and replace floor tiles and carpeting. You can safely use a welder without burning your eyes, and using hand tools is second nature to you."
    desc_trained = "You know how to seal a breach, rebuild broken piping, and repair major damage. You know the basics of structural engineering."
    desc_professional = "You are a construction worker or engineer. You could pretty much rebuild the station from the ground up, given supplies, and you're efficient and skilled at repairing damage."

/datum/skill/engineering/electrical
    ID = "electrical"
    name = "Electrical Engineering"
    desc = "This skill describes your knowledge of electronics and the underlying physics. A low level of this skill implies you know how to lay out wiring and configure powernets, a high level of this skill is required for working complex electronic devices such as circuits or bots."
    desc_unskilled = "You know that electrical wires are dangerous and getting shocked is bad; you can see and report electrical malfunctions such as broken wires or malfunctioning APCs. You can change a light bulb, and you know how to replace a battery or charge up the equipment you normally use."
    desc_amateur = "You can do basic wiring; you can lay cable for solars or the engine. You can repair broken wiring and build simple electrical equipment like light fixtures or APCs. You know the basics of circuits and understand how to protect yourself from electrical shock. You can probably hack a vending machine."
    desc_trained = "You can repair and build electrical equipment and do so on a regular basis. You can troubleshoot an electrical system and monitor the station power grid. You can probably hack an airlock."
    desc_professional = "You are an electrical engineer or the equivalent. You can design, upgrade, and modify electrical equipment and you are good at maximizing the efficiency of your power network. You can hack anything on the station; you can deal with power outages and electrical problems easily and efficiently."

/datum/skill/engineering/atmos
    ID = "atmos"
    name = "Atmospherics"
    desc = "Describes your knowledge of piping, air distribution and gas dynamics."
    desc_unskilled = "You know that the air monitors flash orange when the air is bad and red when it's deadly. You know that a flashing fire door means danger on the other side. You know that some gases are poisonous, that pressure has to be kept in a safe range, and that most creatures need oxygen to live. You can use a fire extinguisher or deploy an inflatable barrier."
    desc_amateur = "You know how to read an air monitor, how to use an air pump, how to analyze the atmosphere in a space, and how to help seal a breach. You can lay piping and work with gas tanks and canisters. If you work with the engine, you can set up the cooling system. You can use a fire extinguisher easily and place inflatable barriers so that they allow convenient access and airtight breach containment."
    desc_trained = "You can run the Atmospherics system. You know how to monitor the air quality across the station, detect problems, and fix them. You're trained in dealing with fires, breaches, and gas leaks, and may have exosuit or fire gear training."
    desc_professional = "You are an atmospherics specialist. You monitor, modify, and optimize the station's atmospherics system, and you can quickly and easily deal with emergencies. You can modify atmospherics systems to do pretty much whatever you want them to. You can easily handle a fire or breach, and are proficient at securing an area and rescuing civilians, but you're equally likely to have simply prevented it from happening in the first place."

/datum/skill/engineering/engines
	ID = "engines"
	name = "Engines"
	desc = "Describes your knowledge of the various engine types common on space stations, such as the singularity, supermatter or RUST engine."
	desc_unskilled = "You know that \"delamination\" is a bad thing and that you should stay away from the singularity. You know the engine provides power, but you're unclear on the specifics. If you were to try to set up the engine, you would need someone to talk you through every detail--and even then, you'd probably make deadly mistakes."
	desc_amateur = "You know the basic theoretical principles of engine operation. You can try to set up the engine by yourself, but you are likely to need some assistance and supervision, otherwise you are likely to make mistakes."
	desc_trained = "You can set up the engine, and you probably won't botch it up too badly. You know how to protect yourself from radiation in the engine room. You can read the engine monitors and keep the engine going. You're familiar with engine types other than the one you work with. An engine malfunction may stump you, but you can probably work out how to fix it... let's just hope you do so quickly enough to prevent serious damage."
	desc_professional = "Your engine is your baby and you know every minute detail of its workings. You can optimize the engine and you probably have your own favorite custom setup. You could build an engine from the ground up. When things go wrong, you know exactly what has happened and how to fix the problem. You can safely handle singularities and supermatter."

/datum/skill/engineering/mech
    ID = "mech"
    name = "Heavy Machinery Operation"
    desc = "Describes your experience and understanding of operating heavy machinery, which includes mechs and other large exosuits. Used in piloting mechs."
    desc_unskilled = "You know what a mech is, and if you see one you can recognize which type it is. If your department uses exosuits, you know roughly what their capabilities are. If you were to get into one, you'd have about fifty-fifty odds of getting it moving in the direction you wanted it to go."
    desc_amateur = "You can drive an exosuit safely, but you specialize in only one type of mech that your department regularly uses. You're not an expert and you fumble the controls sometimes, but you're going where you want to go and you're pretty sure you know what those buttons do. If you're a miner, you can set up a mining drill safely; if you have the electrical skills, you probably know how to operate a shield generator and set up a laser emitter."
    desc_trained = "You are very comfortable using the type of exosuit you're most familiar with. You may spend entire shifts piloting one, and you're familiar with its functions. You can do basic maintenance. You can use most types of exosuits, unless they're very exotic or specialized. If you're an electrician or engineer, you can set up a shield generator solo. Miners at this level can place and use mining drills with high efficiency."
    desc_professional = "You can use any type of mech comfortably and automatically. To you, a mech is more like a second skin than a vehicle. You can maintain, repair, and probably build exosuits. You can maintain, repair, and modify drills and shield generators."

/datum/skill/engineering/pilot
    ID = "pilot"
    name = "Piloting"
    desc = "Describes your experience and understanding of piloting spacecraft, from small and short-range pods to even corvette sized craft."
    desc_unskilled = "You know what a spacecraft is, and you might have a rough understanding of the differences between different craft. If your department is involved in the use of spacecraft, you know roughly what their capabilities are. You might be able to fly a spacecraft in a videogame. If you were to take the Helm of a smaller craft, you might be able to move it with proper guidance."
    desc_amateur = "You can pilot a small, short-range craft safely, but larger ships are out of your area of expertise. You are by no means an expert, and probably don't have much formal training. Skills of this level are typical for deck crew."
    desc_trained = "You are a trained pilot, and can safely pilot anything from a small craft to a corvette. You can spend extended periods of time piloting a spacecraft, and you're versed in the abilities of different ships, and what makes them function. You can do basic maintenance on smaller vessels, and perform most basic maneuvers. You can use armed spacecraft. You can make basic calculations relating to piloting. Skills of this level are typical for newer pilots. You have probably recieved formal piloting training."
    desc_professional = "You are an experienced pilot, and can safety take the Helm of many types of craft. You could probably live in a spacecraft, and you're very well versed in essentially everything related to space-faring vessels. Not only can you fly a ship, but you can perform difficult maneuvers, and make certain calculations relating to flying some vessels. You can maintain a ship. Skills of this level are typical for very experienced pilots. You have recieved formal piloting training."

// Category: Research

/datum/skill/research/devices
    ID = "devices"
    name = "Complex Devices"
    desc = "Describes the ability to assemble complex devices, such as computers, circuits, printers, robots or gas tank assemblies (bombs). Note that if a device requires electronics or programming, those skills are also required in addition to this skill."
    desc_unskilled = "You know how to use the technology that was present in whatever society you grew up in. You know how to tell when something is malfunctioning, but you have to call tech support to get it fixed."
    desc_amateur = "You use and repair high-tech equipment in the course of your daily work. You can fix simple problems, and you know how to use a circuit printer or autolathe. You can build simple robots such as cleanbots and medibots. If you have the relevant medical or electronic knowledge, you can repair a prosthesis or artificial organ; if not, these devices are beyond you."
    desc_trained = "You can build or repair an exosuit or cyborg chassis, use a protolathe and destructive analyzer, and build prosthetic limbs. You can safely transfer an MMI or posibrain into a cyborg chassis."
    desc_professional = "You are an inventor, researcher, or anomalist. You can design, build, and modify equipment that most people don't even know exists. You are at home in the lab and the workshop and you've never met a gadget you couldn't take apart, put back together, and replicate."

/datum/skill/research/computer
    ID = "computer"
    name = "Information Technology"
    desc = "Describes your understanding of computers, software and communication. Not a requirement for using computers, but definitely helps. Used in telecommunications and programming of computers and AIs."
    desc_unskilled = "You know how to use the computers and communication devices that you grew up with. You can use a computer console, a handheld or wall-mounted radio, and your headset, as well as your PDA. You know what an AI is, but you may see them as either \"people made of silicon\" or \"only machines\"; you know they have to obey their laws, but you don't know much about how or why they work."
    desc_amateur = "You know the basics of programming, but you're not very good at it and couldn't do it professionally. You have a pretty good idea of what makes AIs tick. You understand how information is stored in a computer, and you can fix simple computer problems. You're computer-literate, but you still make mistakes. If you tried to subvert the AI, you might make mistakes in wording your new laws."
    desc_trained = "At this level, you're probably working with computers on a daily basis. You understand and can repair the telecommunications network. Your understanding of AI programming and psychology lets you fix problems with the AIs or cyborgs--or create problems, if you so desire. You can program computers and AIs and change their laws effectively."
    desc_professional = "People are probably starting to wonder whether you might be a computer yourself. Computer code is your first language; you relate to AIs as easily as (probably more easily than) organics. You could build a telecommunications network from the ground up."

/datum/skill/research/science
	ID = "science"
	name = "Science"
	desc = "Your experience and knowledge with scientific methods and processes."
	desc_unskilled = "You know what science is and probably have a vague idea of the scientific method from your high school science classes."
	desc_amateur = "You keep up with scientific discoveries. You know a little about most fields of research. You've learned basic laboratory skills. You may read about science as a hobby; or you may be working in a field related to science and have learned about science that way. You could design a simple experiment."
	desc_trained = "You are a scientist, perhaps a graduate student or post-graduate researcher. You can design an experiment, analyze your results, publish your data, and integrate what you've learned with the research of other scientists. Your laboratory skills are reliable, and you know how to find information you need when you research a new scientific topic."
	desc_professional = "You are a professional researcher, and you have made multiple new discoveries in your field. Your experiments are well-designed. You are known as an authority in your specialty and your papers often appear in prestigious journals. You may be coordinating the research efforts of a team of scientists."

// Category: Medical

/datum/skill/medical/medical
    ID = "medical"
    name = "Medicine"
    desc = "Covers an understanding of the human body and medicine. At a low level, this skill gives a basic understanding of applying common types of medicine, and a rough understanding of medical devices like the health analyzer. At a high level, this skill grants exact knowledge of all the medicine available on the station, as well as the ability to use complex medical devices like the body scanner or mass spectrometer."
    desc_unskilled = "You know basic first aid, such as how to apply a bandage or ointment to an injury. You can use an autoinjector designed for civilian use, probably by reading the directions printed on it. You can tell when someone is badly hurt and needs a doctor; you can see whether someone has a badly broken bone, is having trouble breathing, or is unconscious. You may not be able to tell the difference between unconscious and dead."
    desc_amateur = "You've taken a first-aid training, nursing, or EMT course. You can stop bleeding, do CPR, apply a splint, take someone's pulse, apply trauma and burn treatments, and read a handheld health scanner. You probably know that Dylovene helps poisoning and Dexalin helps people with breathing problems; you can use a syringe or start an IV. You've been briefed on the symptoms of common emergencies like a punctured lung, appendicitis, alcohol poisoning, or broken bones, and though you can't treat them, you know that they need a doctor's attention. You can recognize most emergencies as emergencies and safely stabilize and transport a patient."
    desc_trained = "You are an experienced EMT or experienced nurse, a medical resident, or a doctor. You know how to treat most illnesses and injuries, though exotic illnesses and unusual injuries may still stump you. You have probably begun to specialize in some sub-field of medicine. In emergencies, you can think fast enough to keep your patients alive, and even when you can't treat a patient, you know how to find someone who can. You probably have some skill in genetics, virology, and surgery, if only to the extent of being able to create an antibody, do a cloning scan, or assist a surgeon in the operating room. You can use a full-body scanner, and you know something's off about a patient with an alien parasite or cortical borer."
    desc_professional = "You are an experienced doctor. You've seen almost everything there is to see when it comes to injuries and illness and even when it comes to something you haven't seen, you can apply your wide knowledge base to put together a treatment. In a pinch, you can do just about any medicine-related task, but your specialty, whatever it may be, is where you really shine."

/datum/skill/medical/anatomy
    ID = "anatomy"
    name = "Anatomy"
    desc = "Gives you a detailed insight of the human body. A high skill in this is required to perform surgery. This skill may also help in examining alien biology."
    desc_unskilled = "You know what organs, bones, and such are, and you know roughly where they are. You know that someone who's badly hurt or sick may need surgery."
    desc_amateur = "You've taken an anatomy class and you've spent at least some time poking around inside actual people. You know where everything is, more or less. You could assist in surgery, if you have the required medical skills. If you have the forensics knowledge, you could perform an autopsy. If you really had to, you could probably perform basic surgery such as an appendectomy, but you're not yet a qualified surgeon and you really shouldn't--not unless it's an emergency. If you're a xenobiologist, you know how to take out slime cores."
    desc_trained = "You're a surgical resident, or an experienced medical doctor. You can put together broken bones, fix a damaged lung, patch up a liver, or remove an appendix without problems. But tricky surgeries, with an unstable patient or delicate manipulation of vital organs like the heart and brain, are at the edge of your ability, and you prefer to leave them to specialized surgeons. You can recognize when someone's anatomy is noticeably unusual. You're trained in working with several species, but you're probably better at surgery on your own species."
    desc_professional = "You are an experienced surgeon. You can handle anything that gets rolled, pushed, or dragged into the OR, and you can keep a patient alive and stable even if there's no one to assist you. You can handle severe trauma cases or multiple organ failure, repair brain damage, and perform heart surgery. By now, you've probably specialized in one field, where you may have made new contributions to surgical technique. You can detect even small variations in the anatomy of a patient--even a changeling probably wouldn't slip by your notice, provided you could get one on the operating table."

/datum/skill/medical/virology
    ID = "virology"
    name = "Virology"
    desc = "This skill implies an understanding of microorganisms and their effects on humans."
    desc_unskilled = "You know that diseases are contagious; you've probably heard you should wash your hands to stop their spread. You know that if you're sick, you can go to Medical and get treatment."
    desc_amateur = "You know how viruses work, and you can use the machinery in the virology lab to analyze a virus or create an antibody. You know the principles of quarantine and you know how to keep a virus from spreading. You know that spaceacillin will help the body fight off a virus. However, you're not specialized in virology, and you probably don't have a whole lot of experience in dealing with viruses. If you are a medical doctor, you know how to treat symptoms and keep sick patients stable."
    desc_trained = "You know how to analyze, modify, and cure viruses, and could probably do so even without most of the equipment in the virology lab. You know how to trigger mutations in a virus and how to isolate genes. If you really wanted to, you could create a deadly virus, provided you got lucky with the mutations."
    desc_professional = "You are a specialized virologist - either a medical doctor or a scientific researcher. You may be well-known in the field, having published in prestigious journals; or you may be a mad scientist working away in secret. You know how to use a virus as a tool or a weapon. You can cure any epidemic and if you wanted to, you could start one so deadly and contagious that your targets wouldn't know what hit them."

/datum/skill/medical/chemistry
	ID = "chemistry"
	name = "Chemistry"
	desc = "Experience with mixing chemicals, and an understanding of what the effect will be. This doesn't cover an understanding of the effect of chemicals on the human body, as such the medical skill is also required for medical chemists."
	desc_unskilled = "You know that chemists work with chemicals; you know that they can make medicine or poison or useful chemicals. You probably know what an element is and have a vague idea of what a chemical reaction is from some chemistry class in your high school days."
	desc_amateur = "You can make basic chemicals or medication--things like space cleaner or anti-toxin. You have some training in safety and you won't blow up the lab... probably."
	desc_trained = "You work as a chemist, or else you are a doctor with training in chemistry. If you are a research chemist, you can create most useful chemicals; if you are a pharmacist, you can make most medications. At this stage, you're working mostly by-the-book. You can weaponize your chemicals by making grenades, smoke bombs, and similar devices."
	desc_professional = "You specialized in chemistry or pharmaceuticals; you are either a medical researcher or professional chemist. You can create custom mixes and make even the trickiest of medications easily. You understand how your pharmaceuticals interact with the bodies of your patients. You are probably the originator of at least one new chemical innovation."
