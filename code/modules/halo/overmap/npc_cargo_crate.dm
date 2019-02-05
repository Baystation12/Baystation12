/obj/structure/closet/npc_cargo_closet

/obj/structure/closet/npc_cargo_closet/Initialize()
	.=..()
	var/obj/effect/overmap/ship/npc_ship/our_ship = map_sectors["[z]"]
	if(!istype(our_ship))
		return
	our_ship.cargo_containers += src
