/obj/overmap/projectile
	name = "projectile"
	icon_state = "projectile"

	scannable = TRUE
	requires_contact = TRUE
	sensor_visibility = 50

	var/obj/structure/missile/actual_missile = null

	/// Is the missile moving on the overmap?
	var/moving = FALSE

	/// Will the missile be marked as a dangerous one on sensors?
	var/dangerous = FALSE

	/// Should this missile consider entering visitable sites?
	var/should_enter_zs = FALSE

/obj/overmap/projectile/Initialize()
	. = ..()
	make_movable()

/obj/overmap/projectile/Destroy()
	actual_missile = null
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/overmap/projectile/proc/set_missile(obj/structure/missile/missile)
	actual_missile = missile

/obj/overmap/projectile/proc/set_dangerous(is_dangerous)
	dangerous = is_dangerous

/obj/overmap/projectile/proc/set_moving(is_moving)
	moving = is_moving

/obj/overmap/projectile/proc/set_enter_zs(enter_zs)
	should_enter_zs = enter_zs

/obj/overmap/projectile/get_scan_data(mob/user)
	. = ..()
	if (user.skill_check(SKILL_WEAPONS, SKILL_TRAINED))
		. += "<br>Additional information:<br>[get_additional_info()]"

/obj/overmap/projectile/proc/get_additional_info()
	if (actual_missile)
		return actual_missile.get_additional_info()
	return "N/A"

/obj/overmap/projectile/Process()
	if (QDELETED(actual_missile))
		qdel_self()
		return
	// Whether overmap movement occurs is controlled by the missile itself
	if (!moving)
		return ..()

	if (check_enter())
		qdel_self()
		return

	// let equipment alter speed/course
	for (var/slot in actual_missile?.equipment)
		if (QDELETED(actual_missile))
			return
		var/obj/item/missile_equipment/part = actual_missile.equipment[slot]
		if (part)
			part.do_overmap_work(src)
	..()

// Checks if the missile should enter the z level of an overmap object
/obj/overmap/projectile/proc/check_enter()
	if (!should_enter_zs)
		return FALSE

	var/list/potential_levels
	var/turf/overmap_turf = get_turf(src)
	for (var/obj/overmap/visitable/overmap_site in overmap_turf)
		if (!LAZYLEN(overmap_site.map_z))
			continue

		LAZYINITLIST(potential_levels)
		potential_levels[overmap_site] = 0

		// Missile equipment "votes" on what to enter
		for (var/slot in actual_missile.equipment)
			var/obj/item/missile_equipment/part = actual_missile.equipment[slot]
			if (part)
				if (part.should_enter(overmap_site))
					potential_levels[overmap_site]++

	// Nothing to enter
	if (!LAZYLEN(potential_levels))
		return FALSE

	var/total_votes = 0
	for (var/option in potential_levels)
		total_votes += potential_levels[option]

	if (total_votes) // Enter the thing with most "votes"
		var/obj/overmap/visitable/winner = pick(potential_levels)
		for (var/overmap_site in potential_levels)
			if (potential_levels[overmap_site] > potential_levels[winner])
				winner = overmap_site
		actual_missile.enter_level(pick(winner.map_z))
		return TRUE
	return FALSE

/obj/overmap/projectile/on_update_icon()
	..()
	icon_state = dangerous ? "projectile_danger" : "projectile"
