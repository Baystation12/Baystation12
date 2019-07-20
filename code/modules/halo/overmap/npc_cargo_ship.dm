
/obj/effect/overmap/ship/npc_ship/cargo
	name = "Cargo Ship"
	desc = "A ship specialised to carry cargo."

	ship_datums = list(/datum/npc_ship/ccv_sbs)

	available_ship_requests = newlist(/datum/npc_ship_request/halt,/datum/npc_ship_request/cargo_call)

/obj/effect/overmap/ship/npc_ship/ship_targetedby_defenses()
	target_loc = pick(GLOB.overmap_tiles_uncontrolled)
	for(var/datum/npc_ship_request/cargo_call/c in available_ship_requests)
		c.set_cargo_call_status(null,src)
