/datum/gear_tweak/proc/get_random()
	return get_default()

/datum/gear_tweak/color/get_random()
	return valid_colors ? pick(valid_colors) : rgb(rand(200) + 55, rand(200) + 55, rand(200) + 55)
