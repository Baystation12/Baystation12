// Destroys missiles that are traveling on the overmap
/obj/item/missile_equipment/payload/antimissile
	name = "PREDATOR missile disabler system"
	desc = "An advanced concotion of technology intended to detect and detonate in close proximity of another projectile in order to disable it."
	icon_state = "antimissile"

	cooldown = 3

/*
	notice that this doesn't destroy missiles that aren't moving on the overmap.
	if it isn't moving on the overmap, it's moving on a z level.
	since missiles move along z levels at max speed, there's no point in going into the z level to chase the missile.
	so this just waits patiently until it's moving again, then gets it (if it goes back out)
*/
/obj/item/missile_equipment/payload/antimissile/do_overmap_work(var/obj/effect/overmap/projectile/P)
	if(!..())
		return

	var/turf/T = get_turf(P)
	for(var/obj/effect/overmap/projectile/O in T)
		if(O == P)
			continue

		// got em
		if(O.moving)
			qdel(O.actual_missile)
			qdel(P.actual_missile)

// Small explosion when triggered
/obj/item/missile_equipment/payload/antimissile/on_trigger(var/atom/triggerer)
	explosion(get_turf(src), 0, 0, 2, 2)
	
	..()