/datum/fake_client

/mob/fake_mob
	var/datum/fake_client/fake_client

/mob/fake_mob/Destroy()
	QDEL_NULL(fake_client)
	. = ..()

/mob/fake_mob/get_client()
	if(!fake_client)
		fake_client = new()
	return fake_client


/obj/unit_test_light
	w_class = 1

/obj/unit_test_medium
	w_class = 3

/obj/unit_test_heavy
	w_class = 5

/obj/random/unit_test/spawn_choices()
	return list(/obj/unit_test_light, /obj/unit_test_heavy, /obj/unit_test_medium)


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
