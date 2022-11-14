/singleton/skill
	abstract_type = /singleton/skill

	/// The display name of this skill.
	var/name

	/// A skill-unique string used to identify this skill in save data that should not change.
	var/key

	/// Unless permitted at a higher level by a job, the max level this skill can be taken at.
	var/default_max

	/// Adjusts the expense differences between levels for this skill.
	var/difficulty

	/// Other skill paths that must be taken to be able to take this skill.
	var/list/prerequisites

	/// The description for this skill overall.
	var/desc

	/// The skill category this skill belongs to.
	var/singleton/skill_category/category

	/// A (/singleton/skill_level) list of the levels this skill may have.
	var/list/levels = list(
		/singleton/skill_level/none,
		/singleton/skill_level/basic,
		/singleton/skill_level/adept,
		/singleton/skill_level/expert,
		/singleton/skill_level/professional
	)


/singleton/skill/proc/GetPointCost(singleton/skill_level/level)
	if (istype(level))
		level = level.type
	switch (level)
		if (/singleton/skill_level/basic, /singleton/skill_level/adept)
			return difficulty
		if (/singleton/skill_level/expert, /singleton/skill_level/professional)
			return 2 * difficulty
	return 0
