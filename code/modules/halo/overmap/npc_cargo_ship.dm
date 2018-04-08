#define BASE_CARGO_STAY_TIME 10 MINUTES
#define BASE_CARGO_DEPART_TIME 2 MINUTES

/obj/effect/overmap/ship/npc_ship/cargo
	name = "Cargo Ship"
	desc = "A ship specialised to carry cargo."

	var/atom/cargo_call_target
	var/cargo_stay_time = BASE_CARGO_STAY_TIME
	var/warn_depart_time = BASE_CARGO_DEPART_TIME
	var/on_call = 0

/obj/effect/overmap/ship/npc_ship/cargo/proc/set_cargo_call_status(var/atom/call_target)//Leave target null to cancel cargo call.
	if(on_call)
		return
	if(isnull(call_target))
		cargo_call_target = null
		pick_target_loc()
		return
	cargo_call_target = call_target
	target_loc = call_target.loc

/obj/effect/overmap/ship/npc_ship/cargo/process()
	..()
	if(cargo_call_target)
		if(on_call)
			target_loc = null
			return
		if(loc == cargo_call_target.loc)
			GLOB.global_headset.autosay("Alright, we're here. Dock with us. You have [cargo_stay_time/600] minutes.","[name]","System")
			target_loc = null
			on_call = 1
			spawn(cargo_stay_time-warn_depart_time)
				GLOB.global_headset.autosay("I'll be leaving in [warn_depart_time/600] minutes. Better pack your stuff up.","[name]","System")
			spawn(cargo_stay_time)
				GLOB.global_headset.autosay("Thanks for the trade! We're leaving now.","[name]","System")
				cargo_call_target = null
				on_call = 0
				pick_target_loc()
		else
			target_loc = cargo_call_target.loc

/obj/effect/overmap/ship/npc_ship/cargo/get_requestable_actions(var/authority_level)
	. = ..()
	if(authority_level >= AUTHORITY_LEVEL_CIV)
		. += "Trade with"

/obj/effect/overmap/ship/npc_ship/cargo/parse_action_request(var/request,var/mob/requester)
	if(request == "Trade with")
		to_chat(requester,"<span class = 'comradio'>[name] A trade? Of course. On our way.</span>")
		set_cargo_call_status(map_sectors["[requester.z]"])

#undef BASE_CARGO_STAY_TIME