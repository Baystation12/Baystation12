// Automatically arms the missile upon reaching the map edge if it isn't already active
/obj/item/missile_equipment/autoarm
	name = "automatic missile activator"
	desc = "A system that automatically arms missiles."

/obj/item/missile_equipment/autoarm/on_touch_map_edge(var/obj/effect/overmap/projectile/P)
	var/obj/structure/missile/M = loc
	if(!istype(M))
		return

	if(!M.active)
		M.activate()
