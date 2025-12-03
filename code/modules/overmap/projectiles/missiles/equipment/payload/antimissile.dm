// Destroys missiles that are traveling on the overmap
/obj/item/missile_equipment/payload/antimissile
	name = "PREDATOR missile disabler system"
	desc = "An advanced concotion of technology intended to detect and detonate in close proximity of another projectile in order to disable it."
	icon_state = "antimissile"
	missile_name_override = "countermeasure missile"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_ENGINEERING = 3)
	matter = list(MATERIAL_ALUMINIUM = 4000, MATERIAL_GOLD = 500, MATERIAL_PHORON = 2000)
	enters_zs = FALSE
	cooldown = 3

/*
	notice that this doesn't destroy missiles that aren't moving on the overmap.
	if it isn't moving on the overmap, it's moving on a z level.
	since missiles move along z levels at max speed, there's no point in going into the z level to chase the missile.
	so this just waits patiently until it's moving again, then gets it (if it goes back out)
*/
/obj/item/missile_equipment/payload/antimissile/do_overmap_work(obj/overmap/projectile/overmap_missile)
	if (!..())
		return
	var/turf/overmap_turf = get_turf(overmap_missile)
	var/obj/structure/missile/actual_missile = overmap_missile.actual_missile
	var/target = actual_missile?.get_target()
	for (var/obj/overmap/projectile/other_missile in overmap_turf)
		if (other_missile == overmap_missile)
			continue
		// got em
		if (other_missile.moving && other_missile == target)
			qdel(other_missile)
			qdel(overmap_missile)

// Small explosion when triggered
/obj/item/missile_equipment/payload/antimissile/on_trigger(armed, atom/triggerer)
	if (armed)
		explosion(loc, 3, shaped = get_dir(src, triggerer), turf_breaker = FALSE)
	..()
