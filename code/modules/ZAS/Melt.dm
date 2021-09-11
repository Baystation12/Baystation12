///Used for removing atoms from zone melt lists completely. Needs to be a datum proc because it is used in Destroy()
/datum/proc/DisableMelting()

/atom/DisableMelting()
	for(var/zone/Z in tracking_zones)
		Z.remove_meltable(src)


/atom/var/material/material

/atom/var/list/tracking_zones = list()


///Returns TRUE if the atom is meltable, and FALSE if it isn't
/atom/proc/is_meltable()

/turf/simulated/wall/is_meltable()
	if (material && !(material.flags & MATERIAL_UNMELTABLE) && material.melting_point)
		return TRUE
	return FALSE

/turf/simulated/floor/is_meltable()
	if (flooring && flooring.damage_temperature)
		return TRUE
	return FALSE

/obj/structure/is_meltable()
	if (material && !(material.flags & MATERIAL_UNMELTABLE) && material.melting_point)
		return TRUE
	return FALSE

/obj/machinery/door/is_meltable()
	if (material && !(material.flags & MATERIAL_UNMELTABLE) && material.melting_point)
		return TRUE
	return FALSE

/obj/machinery/light/is_meltable()
	if (lightbulb && !(lightbulb.status == LIGHT_BROKEN) && lightbulb.material && !(lightbulb.material.flags & MATERIAL_UNMELTABLE) && lightbulb.material.melting_point)
		return TRUE
	return FALSE


///Returns the melting temperature of an atom. Call only if is_meltable() passed
/atom/proc/get_melting_temperature()
	log_debug(append_admin_tools("\The [src] called get_melting_temperature() but the atom has no override defined!", null, get_turf(src)))

/obj/get_melting_temperature()
	return material.melting_point

/turf/simulated/floor/get_melting_temperature()
	return flooring.damage_temperature

/turf/simulated/wall/get_melting_temperature()
	return material.melting_point

/obj/structure/window/get_melting_temperature()
	if (reinf_material)
		return material.melting_point + 0.25*reinf_material.melting_point
	return material.melting_point

/obj/machinery/door/get_melting_temperature()
	return material.melting_point

/obj/machinery/light/get_melting_temperature()
	return lightbulb.material.melting_point


///Called when the temperature is higher than the melting point, generally used for damage
/atom/proc/do_melt(damage)
	log_debug(append_admin_tools("\The [src] called do_melt() but the atom has no override defined!", null, get_turf(src)))

/obj/structure/do_melt(damage)
	take_damage(damage)

/turf/simulated/wall/do_melt(damage)
	take_damage(damage)

/turf/simulated/floor/do_melt(damage)
	if (prob(min(5, damage)))
		make_plating()
	else if (!burnt && prob(min(95, damage * 5)))
		burn_tile(damage)

/obj/machinery/door/do_melt(damage)
	if (health <= 0)
		deconstruct()
		return
	take_damage(damage)

/obj/machinery/door/unpowered/simple/do_melt(damage)
	take_damage(damage)

/obj/structure/bed/do_melt(damage)
	if (prob(min(95, damage * 10)))
		dismantle()
		qdel(src)

/obj/machinery/light/do_melt(damage)
	if (prob(min(95, damage * 10)))
		broken()

/obj/structure/firedoor_assembly/do_melt(damage)
	if (prob(min(95, damage)))
		deconstruct()


///Checks surrounding zones and updates them accordingly
/atom/proc/check_tracking_zones()

/turf/simulated/check_tracking_zones()

	var/list/todo = list()
	var/list/tzones = tracking_zones.Copy()

	for(var/turf/simulated/SimT in CardinalTurfs(FALSE))
		todo |= SimT.zone
	if (zone)
		todo |= zone

	for(var/zone/Z in tzones)
		for(var/zone/TZ in todo)
			if (Z == TZ)
				tzones -= Z
				todo -= TZ

	for(var/zone/Z in tzones)
		Z.remove_meltable(src)

	for(var/zone/Z in todo)
		Z.add_meltable(src)

/obj/check_tracking_zones()

	if (!istype(loc, /turf))
		DisableMelting()
		return

	var/list/todo = list()
	var/list/tzones = tracking_zones.Copy()
	var/turf/simulated/T = loc

	if (istype(T))
		if (T.zone)
			todo |= T.zone
	for(var/turf/simulated/SimT in T.CardinalTurfs(FALSE))
		todo |= SimT.zone

	for(var/zone/Z in tzones)
		for(var/zone/TZ in todo)
			if (Z == TZ)
				tzones -= Z
				todo -= TZ

	for(var/zone/Z in tzones)
		Z.remove_meltable(src)

	for(var/zone/Z in todo)
		Z.add_meltable(src)


/mob/Entered(atom/movable/am, atom/old_loc)
	if (am.is_meltable())
		am.DisableMelting()
	. = ..()

/obj/Entered(atom/movable/am, atom/old_loc)
	if (am.is_meltable())
		am.DisableMelting()
	. = ..()

/turf/Entered(atom/movable/am, atom/old_loc)
	if (am.is_meltable())
		am.check_tracking_zones()
	. = ..()


/turf/simulated/New()
	if (istext(material) && !istype(material))
		material = SSmaterials.get_material_by_name(material)
	if ((GAME_STATE > RUNLEVEL_LOBBY) && is_meltable())
		check_tracking_zones()
	..()

/obj/New()
	if (istext(material) && !istype(material))
		material = SSmaterials.get_material_by_name(material)
	if ((GAME_STATE > RUNLEVEL_LOBBY) && is_meltable())
		check_tracking_zones()
	..()
