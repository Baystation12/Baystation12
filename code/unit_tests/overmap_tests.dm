/datum/unit_test/overmap_test
	template = /datum/unit_test/overmap_test

/datum/unit_test/overmap_test/New()
	name = "OVERMAP: " + name

// 513 no longer allows no color or white as a filter color, hence this test
/datum/unit_test/overmap_test/shall_have_non_white_color
	name = "Shall have non-white color"

/datum/unit_test/overmap_test/shall_have_non_white_color/start_test()
	var/list/invalid_overmap_types = list()
	for(var/omt in subtypesof(/obj/effect/overmap))
		var/obj/overmap = omt
		var/color = initial(overmap.color)
		if(!color || color == COLOR_WHITE)
			invalid_overmap_types += omt

	if(invalid_overmap_types.len)
		fail("Following /obj/effect/overmap types types have invalid colors: [english_list(invalid_overmap_types)]")
	else
		pass("All /obj/effect/overmap types have a valid color")

	return TRUE
