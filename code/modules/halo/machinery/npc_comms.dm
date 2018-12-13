#define COMMS_REQUESTS list("halt")

/obj/machinery/overmap_weapon_console/npc_comms_console
	name = "Local Comms Console"
	desc = "A console used to communicate with local vessels if other channels are unavailable."
	icon = 'code/modules/halo/machinery/npc_comms.dmi'
	icon_state = "base"
	anchored = 1
	density = 1
	fired_projectile = /obj/item/projectile/overmap/npc_comms_projectile

	var/authority_level = 0 //How much authority this console broadcasts, scaling from Civilian, to innie, to unsc to ONI.

/obj/item/projectile/overmap/npc_comms_projectile
	invisibility = 101
	hitscan = 1
	var/authority_level = 0

/obj/item/projectile/overmap/npc_comms_projectile/New(var/obj/spawner)
	. = ..()
	var/obj/machinery/overmap_weapon_console/npc_comms_console/console = spawner
	if(istype(console))
		authority_level = console.authority_level

/obj/item/projectile/overmap/npc_comms_projectile/on_impact(var/atom/impacted)
	var/mob/user = firer
	var/obj/effect/overmap/ship/npc_ship/ship = impacted
	if(isnull(user) || !istype(user) || !istype(ship))
		qdel(src)
		return
	var/list/requestable_actions = ship.get_requestable_actions(authority_level)
	if(requestable_actions.len ==0)
		to_chat(user,"<span class = 'notice'>Your comms console doesn't have enough authority to request anything!</span>")
		return
	var/user_input = input(firer,"Request what action?","Action Requests","Cancel") in requestable_actions + list("Cancel")
	if(user_input == "Cancel")
		return
	ship.parse_action_request(user_input,firer,authority_level)

/obj/machinery/overmap_weapon_console/npc_comms_console/oni
	authority_level = AUTHORITY_LEVEL_ONI

/obj/machinery/overmap_weapon_console/npc_comms_console/unsc
	authority_level = AUTHORITY_LEVEL_UNSC

/obj/machinery/overmap_weapon_console/npc_comms_console/innie
	authority_level = AUTHORITY_LEVEL_INNIE
