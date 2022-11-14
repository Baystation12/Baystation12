/singleton/skill_level
	abstract_type = /singleton/skill_level

	/// The display name of the skill level.
	var/name

	/// A skill_level unique string used to identify this level in save data that should not change.
	var/save_key

	/// An arbitrary numeric worth of this level compared to other levels.
	var/worth


/// The worth of this skill level minus the worth of the target. If 0, we are equal. If negative, we are lower levelled.
/singleton/skill_level/proc/Difference(singleton/skill_level/target)
	if (ispath(target))
		target = GET_SINGLETON(target)
	return worth > target.worth


/// Whether this skill level's worth is equal or better to the target skill level.
/singleton/skill_level/proc/Meets(singleton/skill_level/target)
	if (ispath(target))
		target = GET_SINGLETON(target)
	return worth >= target.worth


/// Whether this skill level's worth is better than the target skill level.
/singleton/skill_level/proc/Beats(singleton/skill_level/target)
	if (ispath(target))
		target = GET_SINGLETON(target)
	return worth > target.worth
