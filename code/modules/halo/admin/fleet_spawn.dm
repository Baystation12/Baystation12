#define FACTION_NPC_SHIPS list("UNSC" = list(/obj/effect/overmap/ship/npc_ship/combat/unsc/medium_armed,/obj/effect/overmap/ship/npc_ship/combat/unsc/heavily_armed),"COVENANT" = list(/obj/effect/overmap/ship/npc_ship/combat/covenant/medium_armed,/obj/effect/overmap/ship/npc_ship/combat/covenant/heavily_armed),"INSURRECTIONIST" = list(/obj/effect/overmap/ship/npc_ship/combat/innie/medium_armed,/obj/effect/overmap/ship/npc_ship/combat/innie/heavily_armed),"FLOOD" = list(/obj/effect/overmap/ship/npc_ship/combat/flood))


/datum/admin_secret_item/fun_secret/spawn_fleet
	name = "Create NPC Ship Fleet"

/datum/admin_secret_item/fun_secret/spawn_fleet/can_execute(var/mob/user)
	if(!ticker) return 0
	return ..()

/datum/admin_secret_item/fun_secret/spawn_fleet/execute(var/mob/user)
	to_chat(user,"Ensure you are on the system map and are at the location you would like the fleet spawned. before executing this command.")
	var/do_continue = input(user,"Continue?","Continue?","No") in list("Yes","No")
	if(do_continue == "No")
		return
	var/list/options_assoc = FACTION_NPC_SHIPS
	var/list/options = list()
	for(var/option in options_assoc)
		options += option
	var/fleet_size = input(user, "How big should the fleet be?","Fleet Size Input",1) as num
	var/faction_selection = input(user,"What faction fleet do you want to create","Fleet Faction Selection","Cancel") in options + list("Cancel")
	if(faction_selection == "Cancel")
		return
	var/list/shiptypes_pickfrom = options_assoc[faction_selection]
	if(shiptypes_pickfrom.len == 0)
		to_chat(user,"There are no ships available for that faction. Report to developers, this should not appear.")
		return
	var/datum/npc_fleet/fleet_main
	for(var/i = 0,i < fleet_size,i++)
		var/spawntype = pick(shiptypes_pickfrom)
		var/obj/effect/overmap/ship/spawned = new spawntype (user.loc)
		if(isnull(fleet_main))
			fleet_main = spawned.our_fleet
		else
			fleet_main.add_tofleet(spawned)

#undef FACTION_NPC_SHIPS