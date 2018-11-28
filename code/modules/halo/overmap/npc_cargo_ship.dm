#define BASE_CARGO_STAY_TIME 10 MINUTES
#define BASE_CARGO_DEPART_TIME 2 MINUTES

/obj/effect/overmap/ship/npc_ship/cargo
	name = "Cargo Ship"
	desc = "A ship specialised to carry cargo."

	ship_datums = list(/datum/npc_ship/ccv_sbs)

	available_ship_requests = newlist(/datum/npc_ship_request/halt,/datum/npc_ship_request/cargo_call)

/obj/effect/overmap/ship/npc_ship/cargo/get_requestable_actions(var/authority_level)
	. = ..()

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
	to_world("<span class = 'radio'>\[System\] [ship_source.name]: \"A trade? Of course. On our way.\"</span>")
	set_cargo_call_status(map_sectors["[requester.z]"],ship_source)
	time_leave_at = cargo_stay_time

/datum/npc_ship_request/cargo_call/do_request_process(var/obj/effect/overmap/ship/npc_ship/ship_source)
	..()
	if(cargo_call_target)
		if(on_call)
			ship_source.target_loc = null
			return 1
		if(ship_source.loc == cargo_call_target.loc)
			to_world("<span class = 'radio'>\[System\] [ship_source.name]: \"Alright, we're here. Dock with us. You have [cargo_stay_time/600] minutes.\"</span>")
			ship_source.target_loc = null
			on_call = 1
			if(time_leave_at != 0 && !already_warned && world.time > time_leave_at-warn_depart_time)
				to_world("<span class = 'radio'>\[System\] [ship_source.name]: \"I'll be leaving in [warn_depart_time/600] minutes. Better pack your stuff up.\"</span>")
			if(time_leave_at != 0 && world.time > time_leave_at)
				to_world("<span class = 'radio'>\[System\] [ship_source.name]: \"Thanks for the trade! We're leaving now.\"</span>")
				cargo_call_target = null
				on_call = 0
				ship_source.pick_target_loc()
		else
			ship_source.target_loc = cargo_call_target.loc

		walk(ship_source,get_dir(ship_source,ship_source.target_loc),ship_source.move_delay)
		ship_source.dir = get_dir(ship_source,ship_source.target_loc)

		return 1 //Don't let any normal move-processing happen.

#undef BASE_CARGO_STAY_TIME