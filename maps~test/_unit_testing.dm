#ifdef UNIT_TEST

#include "say_tests.dmm"

var/list/test_landmarks

/obj/effect/landmark/test/New()
	if(!test_landmarks)
		test_landmarks = new()
	var/list/name_list = test_landmarks[type]
	if(!name_list)
		name_list = new()
		test_landmarks[type] = name_list
	name_list[name] = src

/obj/effect/landmark/test/say_mark

/area/say_test
	name = "Say Test Area"
	icon_state = ""

#endif
