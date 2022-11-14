/datum/skills_repository
	/// All skills in natural order.
	var/list/singleton/skill/skills = list()
	var/list/skills_by_path = list()
	var/list/skills_by_key = list()

	/// All skill levels in natural order.
	var/list/singleton/skill_level/levels = list()
	var/list/levels_by_path = list()
	var/list/levels_by_key = list()

	/// All skill categories in display order.
	var/list/singleton/skill_category/categories = list(
		/singleton/skill_category/organization,
		/singleton/skill_category/general,
		/singleton/skill_category/engineering,
		/singleton/skill_category/research,
		/singleton/skill_category/medical,
		/singleton/skill_category/security,
		/singleton/skill_category/security
	)
	var/list/categories_by_path = list()


/datum/skills_repository/New()
	skills = Singletons.GetSubtypeList(/singleton/skill)
	for (var/singleton/skill/skill as anything in skills)
		skills_by_path[skill.type] = skill
		skills_by_key[skill.key] = skill
	levels = Singletons.GetSubtypeList(/singleton/skill_level)
	for (var/singleton/skill_level/level as anything in levels)
		levels_by_path[level.type] = level
		levels_by_key[level.key] = level
	categories = Singletons.GetList(categories)
	for (var/singleton/skill_category/category as anything in categories)
		categories_by_path[category.type] = category


GLOBAL_DATUM_INIT(skills, /datum/skills_repository, new)
