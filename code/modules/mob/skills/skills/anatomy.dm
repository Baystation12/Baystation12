/singleton/skill/anatomy
	name = "Anatomy"
	save_key = "anatomy"
	default_max = SKILL_ADEPT
	difficulty = SKILL_HARD
	desc = {"\
		Gives you a detailed insight of the human body. A high skill in this is required \
		to perform surgery. This skill may also help in examining alien biology.\
	"}
	levels = list(
		/singleton/skill_level/none = {"\
			You know what organs, bones, and such are, and you know roughly where they are. \
			You know that someone who's badly hurt or sick may need surgery.\
		"},
		/singleton/skill_level/basic = {"\
			You've taken an anatomy class and you've spent at least some time poking around \
			inside actual people. You know where everything is, more or less. You could \
			assist in surgery, if you have the required medical skills. If you have the \
			forensics knowledge, you could perform an autopsy. If you really had to, you \
			could probably perform basic surgery such as an appendectomy, but you're not yet \
			a qualified surgeon and you really shouldn't - not unless it's an emergency. If \
			you're a xenobiologist, you know how to take out slime cores.\
		"},
		/singleton/skill_level/adept = {"\
			You have some training in anatomy. Diagnosing broken bones, damaged ligaments, \
			shrapnel wounds, and other trauma is straightforward for you. You can splint \
			limbs with a good chance of success, operate a defibrillator competently, and \
			perform CPR well. Surgery is still outside your training.\
			<br>- You can do surgery (requires Trained Medicine skill too) but you are very \
			likely to fail at every step. Its speed increases with level.\
			<br>- You can perform cybernethics procedures if you have Trained Complex \
			Devices skill.\
		"},
		/singleton/skill_level/expert = {"\
			You're a surgical resident, or an experienced medical doctor. You can put \
			together broken bones, fix a damaged lung, patch up a liver, or remove an \
			appendix without problems. But tricky surgeries, with an unstable patient or \
			delicate manipulation of vital organs like the heart and brain, are at the edge \
			of your ability, and you prefer to leave them to specialized surgeons. You \
			can recognize when someone's anatomy is noticeably unusual. You're trained \
			in working with several species, but you're probably better at surgery on \
			your own species.\
			<br>- You can do all surgery steps safely, if you have Experienced \
			Medicine skill too.\
		"},
		/singleton/skill_level/professional = {"\
			You are an experienced surgeon. You can handle anything that gets rolled, pushed, \
			or dragged into the OR, and you can keep a patient alive and stable even if \
			there's no one to assist you. You can handle severe trauma cases or multiple \
			organ failure, repair brain damage, and perform heart surgery. By now, you've \
			probably specialized in one field, where you may have made new contributions to \
			surgical technique. You can detect even small variations in the anatomy of a \
			patient - even a changeling probably wouldn't slip by your notice, provided \
			you could get one on the operating table.\
			<br>- The penalty from operating on improper operating surfaces is reduced.\
		"}
	)
