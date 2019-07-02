// Automatically arms the missile upon reaching the map edge if it isn't already active
/obj/item/missile_equipment/autoarm
	name = "automatic missile activator"
	desc = "A system that automatically arms missiles."

/obj/item/missile_equipment/autoarm/on_touch_map_edge(var/obj/effect/overmap/projectile/P)
	if(!in_missile.active)
		in_missile.activate()
