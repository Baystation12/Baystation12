/singleton/skill
	abstract_type = /singleton/skill

	/// The display name of this skill.
	var/name

	/// A skill-unique string used to identify this skill in save data that should not change.
	var/key

	/// Unless permitted at a higher level by a job, the max level this skill can be taken at.
	var/default_max

	/// Adjusts the outcome of the default GetPointCost behavior for this skill.
	var/difficulty

	var/const/DIFFICULTY_EASY = 1
	var/const/DIFFICULTY_AVERAGE = 2
	var/const/DIFFICULTY_HARD = 4

	/// A (/singleton/skill = /singleton/skill_level) map that must be met before this skill may be taken.
	var/list/prerequisites

	/// The description for this skill overall.
	var/desc

	/// The skill category this skill belongs to.
	var/singleton/skill_category/category

	/// A (/singleton/skill_level = {"level description"}) map of levels this skill has available.
	var/list/levels


/singleton/skill/proc/GetPointCost(singleton/skill_level/level)
	if (istype(level))
		level = level.type
	switch (level)
		if (/singleton/skill_level/basic, /singleton/skill_level/adept)
			return difficulty
		if (/singleton/skill_level/expert, /singleton/skill_level/professional)
			return 2 * difficulty
	return 0
