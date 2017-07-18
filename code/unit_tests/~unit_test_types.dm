/obj/effect/landmark/test/safe_turf
	name = "safe_turf" // At creation, landmark tags are set to: "landmark*[name]"
	desc = "A safe turf should be an as large block as possible of livable, passable turfs, preferably at least 3x3 with the marked turf as the center"

/obj/effect/landmark/test/space_turf
	name = "space_turf"
	desc = "A space turf should be an as large block as possible of space, preferably at least 3x3 with the marked turf as the center"

#ifdef UNIT_TEST

/datum/fake_client

/mob/fake_mob
	var/datum/fake_client/fake_client

/mob/fake_mob/Destroy()
	qdel_null(fake_client)
	. = ..()

/mob/fake_mob/get_client()
	if(!fake_client)
		fake_client = new()
	return fake_client

/area/test_area/powered_non_dynamic_lighting
	name = "\improper Test Area - Powered - Non-Dynamic Lighting"
	icon_state = "green"
	requires_power = 0
	dynamic_lighting = 0

/area/test_area/requires_power_non_dynamic_lighting
	name = "\improper Test Area - Requires Power - Non-Dynamic Lighting"
	icon_state = "red"
	requires_power = 1
	dynamic_lighting = 0

/area/test_area/powered_dynamic_lighting
	name = "\improper Test Area - Powered - Dynamic Lighting"
	icon_state = "yellow"
	requires_power = 0
	dynamic_lighting = 1

/area/test_area/requires_power_dynamic_lighting
	name = "\improper Test Area - Requires Power - Dynamic Lighting"
	icon_state = "purple"
	requires_power = 1
	dynamic_lighting = 1

#endif
