/singleton/skill/medical
	name = "Medicine"
	save_key = "medical"
	default_max = /singleton/skill_level/adept
	difficulty = DIFFICULTY_HARD
	desc = {"\
		Covers an understanding of the human body and medicine. At a low level, this skill \
		gives a basic understanding of applying common types of medicine, and a rough \
		understanding of medical devices like the health analyzer. At a high level, this skill \
		grants exact knowledge of all the medicine available on the installation, as well as \
		the ability to use complex medical devices like the body scanner or mass spectrometer.\
	"}
	levels = list(
		/singleton/skill_level/none = {"\
			You know first aid, such as how to apply a bandage or ointment to an injury. You \
			can use an autoinjector designed for civilian use, probably by reading the directions \
			printed on it. You can tell when someone is badly hurt and needs a doctor; you can see \
			whether someone has a badly broken bone, is having trouble breathing, or is unconscious. \
			You may have trouble telling the difference between unconscious and dead at distance.\
			<br>- You can use first aid supplies found in kits and pouches, including autoinjectors.\
		"},
		/singleton/skill_level/basic = {"\
			You've taken a nursing or EMT course. You can stop bleeding, do CPR, apply a splint, take \
			someone's pulse, apply trauma and burn treatments, and read a handheld health scanner. You \
			probably know that Dylovene helps poisoning and Dexalin helps people with breathing problems; \
			you can use a syringe or start an IV. You've been briefed on the symptoms of common emergencies \
			like a punctured lung, appendicitis, alcohol poisoning, or broken bones, and though you \
			can't treat them, you know that they need a doctor's attention. You can recognize most \
			emergencies as emergencies and safely stabilize and transport a patient.\
			<br>- You can fully operate Defibrillators, Health Analyzers, IV drips, and Syringes.\
			<br>- You can comprehend most of a Body Scanner's readout.\
		"},
		/singleton/skill_level/adept = {"\
			You are an experienced EMT, an experienced nurse, or a medical resident. You know how \
			to treat most illnesses and injuries, though exotic illnesses and unusual injuries may \
			still stump you. You have probably begun to specialize in some sub-field of medicine. \
			In emergencies, you can think fast enough to keep your patients alive, and even when \
			you can't treat a patient, you know how to find someone who can. You can use a body \
			scanner, and you know something's off about a patient with an alien parasite or \
			cortical borer.\
			<br>- You can fully operate Sleepers and Body Scanners.\
			<br>- You can apply splints without failing.\
			<br>- You can perform simple surgery steps if you have Experienced Anatomy skill.\
		"},
		/singleton/skill_level/expert = {"\
			You are a senior nurse or paramedic, or a practicing doctor. You know how to use \
			all of the medical devices available to treat a patient. Your deep knowledge of \
			the body and medications will let you diagnose and come up with a course of \
			treatment for most ailments. You can perform a full-body scan thoroughly and find \
			important information.\
			<br>- You can perform all surgery steps safely if you have Experienced Anatomy skill.\
		"},
		/singleton/skill_level/professional = {"\
			You are an experienced doctor or an expert nurse or EMT. You've seen almost everything \
			there is to see when it comes to injuries and illness and even when it comes to \
			something you haven't seen, you can apply your wide knowledge base to put together \
			a treatment. In a pinch, you can do just about any medicine-related task, but your \
			specialty, whatever it may be, is where you really shine.\
		"}
	)
