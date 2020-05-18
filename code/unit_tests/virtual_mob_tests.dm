#ifdef UNIT_TEST

/datum/unit_test/virtual
	name = "VIRTUAL - Template"
	template = /datum/unit_test/virtual

/datum/unit_test/virtual/helper
	name = "VIRTUAL - Template Helper"
	template = /datum/unit_test/virtual/helper

	var/helper_proc
	var/list/expected_mobs

	var/mob/mob_one
	var/mob/mob_two
	var/mob/mob_three

/datum/unit_test/virtual/helper/start_test()
	standard_setup()

	var/list/actual_mobs = call(helper_proc)(mob_one)
	var/list/missing_mobs = expected_mobs - actual_mobs
	var/list/excessive_mobs= actual_mobs - expected_mobs

	if(missing_mobs.len || excessive_mobs.len)
		fail("[helper_proc] did not return the expected mobs. Expected [english_list(expected_mobs)], was [english_list(actual_mobs)]")
		log_debug(mob_one.virtual_mob.sight)
		log_debug(mob_one.virtual_mob.see_invisible)
		log_debug(mob_one.virtual_mob.see_in_dark)
	else
		pass("[helper_proc] returned the expected mobs.")

	expected_mobs = null
	standard_cleanup()
	return TRUE

/datum/unit_test/virtual/helper/check_hearers_in_range
	name = "VIRTUAL - Helper Test - Check Hearers In Range"
	helper_proc = /proc/hearers_in_range
/datum/unit_test/virtual/helper/check_hearers_in_range/standard_setup()
	..()
	expected_mobs = list(mob_one, mob_two, mob_three)

/datum/unit_test/virtual/helper/check_hearers_in_range_with_mob_inside_storage
	name = "VIRTUAL - Helper Test - Check Hearers In Range - With Mob Inside Storage"
	helper_proc = /proc/hearers_in_range
	var/obj/storage
/datum/unit_test/virtual/helper/check_hearers_in_range_with_mob_inside_storage/standard_setup()
	..()
	storage = new(mob_one.loc)
	mob_one.forceMove(storage)
	expected_mobs = list(mob_one, mob_two, mob_three)
/datum/unit_test/virtual/helper/check_hearers_in_range_with_mob_inside_storage/Destroy()
	QDEL_NULL(storage)
	. = ..()

/datum/unit_test/virtual/helper/check_viewers_in_range
	name = "VIRTUAL - Helper Test - Check Viewers In Range"
	helper_proc = /proc/viewers_in_range
/datum/unit_test/virtual/helper/check_viewers_in_range/standard_setup()
	..()
	expected_mobs = list(mob_one, mob_two, mob_three)

/datum/unit_test/virtual/helper/check_all_hearers
	name = "VIRTUAL - Helper Test - Check All Hearers"
	helper_proc = /proc/all_hearers
/datum/unit_test/virtual/helper/check_all_hearers/standard_setup()
	..()
	expected_mobs = list(mob_one, mob_two)

/datum/unit_test/virtual/helper/check_all_viewers
	name = "VIRTUAL - Helper Test - Check All Viewers"
	helper_proc = /proc/all_viewers
/datum/unit_test/virtual/helper/check_all_viewers/standard_setup()
	..()
	expected_mobs = list(mob_one, mob_two)

/datum/unit_test/virtual/helper/check_mobs_in_viewing_range
	name = "VIRTUAL - Helper Test - Check Mobs In Viewing Range"
	helper_proc = /proc/hosts_in_view_range
/datum/unit_test/virtual/helper/check_mobs_in_viewing_range/standard_setup()
	..()
	expected_mobs = list(mob_one, mob_two)

/datum/unit_test/virtual/helper/check_hosts_in_view_range_with_mob_inside_object
	name = "VIRTUAL - Helper Test - Check Hosts in View Range - With Mob Inside Object"
	helper_proc = /proc/hosts_in_view_range
	var/obj/storage
/datum/unit_test/virtual/helper/check_hosts_in_view_range_with_mob_inside_object/standard_setup()
	..()
	storage = new(mob_one.loc)
	mob_one.forceMove(storage)
	expected_mobs = list(mob_one, mob_two)
/datum/unit_test/virtual/helper/check_hosts_in_view_range_with_mob_inside_object/Destroy()
	QDEL_NULL(storage)
	. = ..()

/datum/unit_test/virtual/helper/proc/standard_setup()
	mob_one   = get_named_instance(/mob/fake_mob, get_turf(locate(/obj/effect/landmark/virtual_spawn/one)),   "Test Mob 1")
	mob_two   = get_named_instance(/mob/fake_mob, get_turf(locate(/obj/effect/landmark/virtual_spawn/two)),   "Test Mob 2")
	mob_three = get_named_instance(/mob/fake_mob, get_turf(locate(/obj/effect/landmark/virtual_spawn/three)), "Test Mob 3")

/datum/unit_test/virtual/helper/proc/standard_cleanup()
	QDEL_NULL(mob_one)
	QDEL_NULL(mob_two)
	QDEL_NULL(mob_three)

/obj/effect/landmark/virtual_spawn/one
/obj/effect/landmark/virtual_spawn/two
/obj/effect/landmark/virtual_spawn/three

#endif
