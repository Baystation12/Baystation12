/datum/wire_description
	var/index
	var/description
	var/skill_level = SKILL_PROF

/datum/wire_description/New(index, description, skill_level)
	src.index = index
	if(description)
		src.description = description
	if(skill_level)
		src.skill_level = skill_level
	..()