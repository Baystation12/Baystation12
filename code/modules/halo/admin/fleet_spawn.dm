//#define FACTION_NPC_SHIPS list("UNSC" = list(/obj/effect/overmap/ship/npc_ship/combat/unsc/medium_armed,/obj/effect/overmap/ship/npc_ship/combat/unsc/heavily_armed),"COVENANT" = list(/obj/effect/overmap/ship/npc_ship/combat/covenant/medium_armed,/obj/effect/overmap/ship/npc_ship/combat/covenant/heavily_armed),"INSURRECTIONIST" = list(/obj/effect/overmap/ship/npc_ship/combat/innie/medium_armed,/obj/effect/overmap/ship/npc_ship/combat/innie/heavily_armed),"FLOOD" = list(/obj/effect/overmap/ship/npc_ship/combat/flood))


/datum/admin_secret_item/fun_secret/spawn_fleet
	name = "Create NPC Ship Fleet"

/datum/admin_secret_item/fun_secret/spawn_fleet/can_execute(var/mob/user)
	if(!ticker) return 0
	return ..()

/datum/admin_secret_item/fun_secret/spawn_fleet/execute(var/mob/user)
	var/fleet_size = input(user, "How big should the fleet be? (recommended: 5)","Fleet Size",5) as num
	var/faction_selection = input(user,"What faction fleet do you want to create","Fleet Faction Selection","Cancel") \
		as null|anything in GLOB.factions_by_name
	if(!faction_selection)
		return
	var/datum/faction/F = GLOB.factions_by_name[faction_selection]
	F.spawn_fleet(fleet_size)
