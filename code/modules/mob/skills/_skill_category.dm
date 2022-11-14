/singleton/skill_category
	abstract_type = /singleton/skill_category

	/// The name of this category.
	var/name

	/// The skills that belong to this category, in display order.
	var/list/skills


/singleton/skill_category/New()
	skills = Singletons.GetList(skills)
