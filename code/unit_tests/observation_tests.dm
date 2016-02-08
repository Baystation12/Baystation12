/proc/is_listening_to_movement(var/atom/movable/listening_to, var/listener)
	return moved_event.is_listening(listening_to, listener)

datum/unit_test/observation
	name = "OBSERVATION template"
	async = 0
	var/list/received_moves

datum/unit_test/observation/start_test()
	if(!received_moves)
		received_moves = list()
	received_moves.Cut()

datum/unit_test/observation/proc/receive_move(var/atom/movable/am, var/old_loc, var/new_loc)
	received_moves[++received_moves.len] =  list(am, old_loc, new_loc)

datum/unit_test/observation/proc/dump_received_moves()
	for(var/entry in received_moves)
		var/list/l = entry
		log_unit_test("[l[1]] - [l[2]] - [l[3]]")

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

datum/unit_test/observation/moved_shall_only_trigger_for_recursive_drop
	name = "OBSERVATION: Moved - Shall Only Trigger Once For Recursive Drop"

datum/unit_test/observation/moved_shall_only_trigger_for_recursive_drop/start_test()
	..()
	var/turf/T = locate(20,20,1)
	var/obj/mecha/mech = new(T)
	var/obj/item/weapon/wrench/held_item = new(T)
	var/mob/living/carbon/human/dummy/held_mob = new(T)
	var/mob/living/carbon/human/dummy/holding_mob = new(T)

	held_mob.real_name = "Held Mob"
	held_mob.name = "Held Mob"
	held_mob.mob_size = MOB_SMALL
	held_mob.put_in_active_hand(held_item)
	held_mob.get_scooped(holding_mob)

	holding_mob.real_name = "Holding Mob"
	holding_mob.name = "Holding Mob"
	holding_mob.forceMove(mech)

	mech.occupant = holding_mob

	moved_event.register(held_item, src, /datum/unit_test/observation/proc/receive_move)
	holding_mob.drop_from_inventory(held_item)

	if(received_moves.len != 1)
		fail("Expected 1 raised moved event, were [received_moves.len].")
		dump_received_moves()
		return 1

	var/list/event = received_moves[1]
	if(event[1] != held_item || event[2] != held_mob || event[3] != mech)
		fail("Unepected move event received. Expected [held_item], was [event[1]]. Expected [held_mob], was [event[2]]. Expected [mech], was [event[3]]")
	else if(!(held_item in mech.dropped_items))
		fail("Expected \the [held_item] to be in the mechs' dropped item list")
	else
		pass("One one moved event with expected arguments raised.")

	qdel(mech)
	qdel(held_item)
	qdel(held_mob)
	qdel(holding_mob)

	return 1

