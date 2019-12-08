/datum/extension/base_name
	base_type = /datum/extension/base_name
	expected_type = /atom
	var/base_name

/datum/extension/base_name/New(holder, base_name)
	..()
	src.base_name = base_name