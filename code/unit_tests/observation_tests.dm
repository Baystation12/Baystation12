/proc/is_listening_to_movement(var/atom/movable/listening_to, var/listener)
	return moved_event.is_listening(listening_to, listener)

datum/unit_test/observation
	name = "OBSERVATION template"
	async = 0

datum/unit_test/observation/moved_observer_shall_register_on_follow
	name = "OBSERVATION: Moved - Observer Shall Register on Follow"

datum/unit_test/observation/moved_observer_shall_register_on_follow/start_test()
	var/turf/T = locate(20,20,1)
	var/mob/living/carbon/human/H = new(T)
	var/mob/dead/observer/O = new(T)

	O.ManualFollow(H)
	if(is_listening_to_movement(H, O))
		pass("The observer is now following the mob.")
	else
		fail("The observer is not following the mob.")

	qdel(H)
	qdel(O)
	return 1

datum/unit_test/observation/moved_observer_shall_unregister_on_nofollow
	name = "OBSERVATION: Moved - Observer Shall Unregister on NoFollow"

datum/unit_test/observation/moved_observer_shall_unregister_on_nofollow/start_test()
	var/turf/T = locate(20,20,1)
	var/mob/living/carbon/human/H = new(T)
	var/mob/dead/observer/O = new(T)

	O.ManualFollow(H)
	O.stop_following()
	if(!is_listening_to_movement(H, O))
		pass("The observer is no longer following the mob.")
	else
		fail("The observer is still following the mob.")

	qdel(H)
	qdel(O)
	return 1

datum/unit_test/observation/moved_shall_not_register_on_enter_without_listeners
	name = "OBSERVATION: Moved - Shall Not Register on Enter Without Listeners"

datum/unit_test/observation/moved_shall_not_register_on_enter_without_listeners/start_test()
	var/turf/T = locate(20,20,1)
	var/mob/living/carbon/human/H = new(T)
	var/obj/structure/closet/C = new(T)

	H.forceMove(C)
	if(!is_listening_to_movement(C, H))
		pass("The mob did not register to the closet's moved event.")
	else
		fail("The mob has registered to the closet's moved event.")

	qdel(C)
	qdel(H)
	return 1

datum/unit_test/observation/moved_shall_registers_recursively_on_new_listener
	name = "OBSERVATION: Moved - Shall Register Recursively on New Listener"

datum/unit_test/observation/moved_shall_registers_recursively_on_new_listener/start_test()
	var/turf/T = locate(20,20,1)
	var/mob/living/carbon/human/H = new(T)
	var/obj/structure/closet/C = new(T)
	var/mob/dead/observer/O = new(T)

	H.forceMove(C)
	O.ManualFollow(H)
	var/listening_to_closet = is_listening_to_movement(C, H)
	var/listening_to_human = is_listening_to_movement(H, O)
	if(listening_to_closet && listening_to_human)
		pass("Recursive moved registration succesful.")
	else
		fail("Recursive moved registration failed. Human listening to closet: [listening_to_closet] - Observer listening to human: [listening_to_human]")

	qdel(C)
	qdel(H)
	qdel(O)
	return 1

datum/unit_test/observation/moved_shall_registers_recursively_with_existing_listener
	name = "OBSERVATION: Moved - Shall Register Recursively with Existing Listener"

datum/unit_test/observation/moved_shall_registers_recursively_with_existing_listener/start_test()
	var/turf/T = locate(20,20,1)
	var/mob/living/carbon/human/H = new(T)
	var/obj/structure/closet/C = new(T)
	var/mob/dead/observer/O = new(T)

	O.ManualFollow(H)
	H.forceMove(C)
	var/listening_to_closet = is_listening_to_movement(C, H)
	var/listening_to_human = is_listening_to_movement(H, O)
	if(listening_to_closet && listening_to_human)
		pass("Recursive moved registration succesful.")
	else
		fail("Recursive moved registration failed. Human listening to closet: [listening_to_closet] - Observer listening to human: [listening_to_human]")

	qdel(C)
	qdel(H)
	qdel(O)

	return 1
