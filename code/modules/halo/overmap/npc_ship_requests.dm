
#define BASE_CARGO_STAY_TIME 10 MINUTES
#define BASE_CARGO_DEPART_TIME 2 MINUTES

/datum/npc_ship_request/cargo_call
	request_name = "Trade With"
	request_auth_levels = ALL_AUTHORITY_LEVELS
	request_requires_processing = 1

	var/obj/effect/overmap/ship/npc_ship/our_ship
	var/atom/cargo_call_target
	var/cargo_stay_time = BASE_CARGO_STAY_TIME
	var/warn_depart_time = BASE_CARGO_DEPART_TIME
	var/on_call = 0

	var/time_leave_at = 0
	var/already_warned = 0

/datum/npc_ship_request/cargo_call/proc/set_cargo_call_status(var/atom/call_target,var/obj/effect/overmap/ship/npc_ship/our_ship)//Leave target null to cancel cargo call.
	if(on_call)
		return
	if(isnull(call_target))
		cargo_call_target = null
		our_ship.pick_target_loc()
		return
	cargo_call_target = call_target
	our_ship.target_loc = call_target.loc

/datum/npc_ship_request/cargo_call/do_request(var/obj/effect/overmap/ship/npc_ship/ship_source,var/mob/requester)
	ship_source.radio_message("A trade? Of course. On our way.")
	set_cargo_call_status(map_sectors["[requester.z]"],ship_source)
	time_leave_at = cargo_stay_time

/datum/npc_ship_request/cargo_call/do_request_process(var/obj/effect/overmap/ship/npc_ship/ship_source)
	..()
	if(cargo_call_target)
		if(ship_source.loc == cargo_call_target.loc)
			if(!on_call)
				ship_source.radio_message("Alright, we're here. Dock with us. You have [cargo_stay_time/600] minutes.")
				ship_source.target_loc = null
				time_leave_at = world.time + BASE_CARGO_STAY_TIME
				on_call = 1
			else
				ship_source.target_loc = null
			if(time_leave_at != 0 && !already_warned && world.time > time_leave_at-warn_depart_time)
				ship_source.radio_message("I'll be leaving in [warn_depart_time/600] minutes. Better pack your stuff up.")
				already_warned = 1
			if(time_leave_at != 0 && world.time > time_leave_at)
				ship_source.radio_message("Thanks for the trade! We're leaving now.")
				cargo_call_target = null
				on_call = 0
				already_warned = 0
				ship_source.pick_target_loc()
		else
			ship_source.target_loc = cargo_call_target.loc

			walk(ship_source,get_dir(ship_source,ship_source.target_loc),ship_source.move_delay)
			ship_source.dir = get_dir(ship_source,ship_source.target_loc)

		return 1 //Don't let any normal move-processing happen.


/datum/npc_ship_request/halt
	request_name = "Halt"
	request_auth_levels = list(AUTHORITY_LEVEL_UNSC,AUTHORITY_LEVEL_ONI)
	var/time_leave_at = 0
	var/already_warned = 0

/datum/npc_ship_request/halt/do_request(var/obj/effect/overmap/ship/npc_ship/ship_source,var/mob/requester)
	if(time_leave_at > 0)
		ship_source.radio_message("Woah, Calm down. We're already waiting on someone's behalf.")
		return
	ship_source.target_loc = null
	ship_source.radio_message("Slowing down.. I can only give you [STOP_WAIT_TIME/600] minutes.")
	request_requires_processing = 1
	time_leave_at = world.time + STOP_WAIT_TIME

/datum/npc_ship_request/halt/do_request_process(var/obj/effect/overmap/ship/npc_ship/ship_source)
	if(time_leave_at != 0 && world.time > time_leave_at)
		if(already_warned)
			time_leave_at = 0
			ship_source.pick_target_loc()
			already_warned = 0
			request_requires_processing = 0
			return
		already_warned = 1
		ship_source.radio_message("I need to leave now. I'll give you [STOP_DISEMBARK_TIME/600] minutes to disembark.")
		time_leave_at = world.time + STOP_DISEMBARK_TIME

/datum/npc_ship_request/halt/innie
	request_auth_levels = list(AUTHORITY_LEVEL_INNIE)

/datum/npc_ship_request/halt/unsc
	request_auth_levels = list(AUTHORITY_LEVEL_UNSC,AUTHORITY_LEVEL_ONI)

/datum/npc_ship_request/halt/cov
	request_auth_levels = list(AUTHORITY_LEVEL_COV)

/datum/npc_ship_request/halt_fake
	request_name = "Halt"
	request_auth_levels = list(AUTHORITY_LEVEL_UNSC,AUTHORITY_LEVEL_ONI)

/datum/npc_ship_request/halt_fake/do_request(var/obj/effect/overmap/ship/npc_ship/combat/ship_source,var/mob/requester)
	ship_source.radio_message("Slowing dow- DIE UNSC SCUM! FOR THE URF!", 1)
	for(var/obj/effect/overmap/ship/npc_ship/combat/innie/ship in view(7,src))
		ship.radio_message("FOR THE URF!", 1)
		ship.target = map_sectors["[requester.z]"]
	ship_source.target = map_sectors["[requester.z]"]
	. = ..()

/datum/npc_ship_request/halt_fake_flood
	request_name = "Halt"
	request_auth_levels = ALL_AUTHORITY_LEVELS

/datum/npc_ship_request/halt_fake_flood/do_request(var/obj/effect/overmap/ship/npc_ship/combat/ship_source,var/mob/requester)
	for(var/obj/effect/overmap/ship/npc_ship/combat/flood/ship in view(7,src))
		ship.target = map_sectors["[requester.z]"]
	ship_source.target = map_sectors["[requester.z]"]
	. = ..()

/datum/npc_ship_request/fire_on_target
	request_name = "Fire On Target"
	request_auth_levels = list()

/datum/npc_ship_request/fire_on_target/do_request(var/obj/effect/overmap/ship/npc_ship/combat/ship_source,var/mob/requester)
	var/user_input = input(requester,"Input target name","Target Selection")
	if(isnull(user_input))
		return
	for(var/obj/object in view(7,src) + view(7,map_sectors["[requester.z]"]))
		if(object.name == "[user_input]")
			ship_source.target = object
			ship_source.radio_message("Located object. Firing.")
			return

	ship_source.radio_message("We can't find any nearby object with that name. Ensure name accuracy.")
	if(ship_source.target)
		ship_source.radio_message("Disengaging from current target.")
		ship_source.target = null

/datum/npc_ship_request/fire_on_target/unsc
	request_auth_levels = list(AUTHORITY_LEVEL_UNSC, AUTHORITY_LEVEL_ONI)

/datum/npc_ship_request/fire_on_target/innie
	request_auth_levels = list(AUTHORITY_LEVEL_INNIE)

/datum/npc_ship_request/fire_on_target/cov
	request_auth_levels = list(AUTHORITY_LEVEL_COV)

/datum/npc_ship_request/player_controlled
	request_requires_processing = 1

/datum/npc_ship_request/player_controlled/do_request_process(var/obj/effect/overmap/ship/npc_ship/ship_source)
	if(ship_source.hull > initial(ship_source.hull)/4) //Slowly reduce the hull over time to eventually start the lose_to_space processing
		ship_source.hull--
	return 1

#undef BASE_CARGO_STAY_TIME


/datum/npc_ship_request/control_fleet
	request_name = "Assume Fleet Control"
	request_auth_levels = list()

/datum/npc_ship_request/control_fleet/do_request(var/obj/effect/overmap/ship/npc_ship/ship_source,var/mob/requester)
	var/obj/effect/overmap/ship/origin_ship = map_sectors["[requester.z]"]
	if(!origin_ship || !istype(origin_ship))
		return
	ship_source.our_fleet.assign_leader(origin_ship)

/datum/npc_ship_request/add_to_fleet
	request_name = "Add To Fleet"
	request_auth_levels = list()

/datum/npc_ship_request/add_to_fleet/do_request(var/obj/effect/overmap/ship/npc_ship/ship_source,var/mob/requester)
	var/obj/effect/overmap/ship/origin_ship = map_sectors["[requester.z]"]
	if(!origin_ship || !istype(origin_ship) || !origin_ship.our_fleet)
		return
	origin_ship.our_fleet.add_tofleet(ship_source)

/datum/npc_ship_request/give_control
	request_name = "Give Fleet Control"
	request_auth_levels = list()

/datum/npc_ship_request/give_control/do_request(var/obj/effect/overmap/ship/npc_ship/ship_source,var/mob/requester)
	var/obj/effect/overmap/ship/origin_ship = map_sectors["[requester.z]"]
	if(!origin_ship || !istype(origin_ship) || !origin_ship.our_fleet)
		return
	ship_source.our_fleet = origin_ship.our_fleet
	origin_ship.our_fleet = new /datum/npc_fleet (origin_ship)
	ship_source.our_fleet.assign_leader(ship_source)

/datum/npc_ship_request/control_fleet/unsc
	request_auth_levels = list(AUTHORITY_LEVEL_UNSC, AUTHORITY_LEVEL_ONI)

/datum/npc_ship_request/control_fleet/innie
	request_auth_levels = list(AUTHORITY_LEVEL_INNIE)

/datum/npc_ship_request/control_fleet/cov
	request_auth_levels = list(AUTHORITY_LEVEL_COV)

/datum/npc_ship_request/add_to_fleet/unsc
	request_auth_levels = list(AUTHORITY_LEVEL_UNSC, AUTHORITY_LEVEL_ONI)

/datum/npc_ship_request/add_to_fleet/innie
	request_auth_levels = list(AUTHORITY_LEVEL_INNIE)

/datum/npc_ship_request/add_to_fleet/cov
	request_auth_levels = list(AUTHORITY_LEVEL_COV)

/datum/npc_ship_request/give_control/unsc
	request_auth_levels = list(AUTHORITY_LEVEL_UNSC, AUTHORITY_LEVEL_ONI)

/datum/npc_ship_request/give_control/innie
	request_auth_levels = list(AUTHORITY_LEVEL_INNIE)

/datum/npc_ship_request/give_control/cov
	request_auth_levels = list(AUTHORITY_LEVEL_COV)