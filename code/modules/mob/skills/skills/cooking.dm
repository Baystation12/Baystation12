/singleton/skill/cooking
	name = "Cooking"
	save_key = "cooking"
	default_max = /singleton/skill_level/professional
	difficulty = DIFFICULTY_EASY
	desc = {"\
		Describes a character's skill at preparing meals and other consumable goods. \
		This includes mixing alcoholic beverages.\
	"}
	levels = list(
		/singleton/skill_level/none = {"\
			You barely know anything about cooking, and stick to vending machines when \
			you can. The microwave is a device of black magic to you, and you avoid it \
			when possible.
		"},
		/singleton/skill_level/basic = {"\
			You can make simple meals and do the cooking for your family. Things like \
			spaghetti, grilled cheese, or simple mixed drinks are your usual fare.\
		"},
		/singleton/skill_level/adept = {"\
			You can make most meals while following instructions, and they generally \
			turn out well. You have some experience with hosting, catering, and/or \
			bartending.\
			<br>- You can fully operate the drink dispensers.\
		"},
		/singleton/skill_level/expert = {"\
			You can cook professionally, keeping an entire crew fed easily. Your food is \
			tasty and you don't have a problem with tricky or complicated dishes. You \
			can be depended on to make just about any commonly-served drink.\
		"},
		/singleton/skill_level/professional = {"\
			Not only are you good at cooking and mixing drinks, but you can manage a \
			kitchen staff and cater for special events. You can safely prepare exotic \
			foods and drinks that would be poisonous if prepared incorrectly.\
		"}
	)
