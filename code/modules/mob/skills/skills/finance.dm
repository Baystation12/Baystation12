/singleton/skill/finance
	name = "Finance"
	save_key = "finance"
	default_max = /singleton/skill_level/professional
	difficulty = DIFFICULTY_EASY
	desc = "Your ability to manage money and investments."
	levels = list(
		/singleton/skill_level/none = {"\
			Your understanding of money starts and ends with personal finance. \
			While you are able to perform basic transactions, you get lost in \
			the details, and can find yourself ripped off on occasion.\
			<br>- You get some starting money. Its amount increases with level.\
			<br>- You can use the verb "Appraise" to see the value of different objects.\
		"},
		/singleton/skill_level/basic = {"\
			You have some limited understanding of financial transactions, and \
			will generally be able to keep accurate records. You have little experience \
			with investment, and managing large sums of money will likely go poorly for you.\
		"},
		/singleton/skill_level/adept = {"\
			You are good at managing accounts, keeping records, and arranging transactions. \
			You have some familiarity with mortgages, insurance, stocks, and bonds, but may \
			be stumped when facing more complicated financial devices.\
		"},
		/singleton/skill_level/expert = {"\
			With your experience, you are familiar with any financial entities you may run \
			across, and are a shrewd judge of value. More often than not, investments you \
			make will pan out well.\
		"},
		/singleton/skill_level/professional = {"\
			You have an excellent knowledge of finance, will often make brilliant \
			investments, and have an instinctive feel for interstellar economics. \
			Financial instruments are weapons in your hands. You likely have professional \
			experience in the finance industry.\
		"}
	)
