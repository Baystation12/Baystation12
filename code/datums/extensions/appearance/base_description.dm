/datum/extension/base_desc
	base_type = /datum/extension/base_desc
	expected_type = /atom
	var/base_desc

/datum/extension/base_desc/New(holder, base_desc)
	..()
	src.base_desc = base_desc