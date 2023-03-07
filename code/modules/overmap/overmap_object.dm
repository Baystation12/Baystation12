/obj/effect/overmap
	name = "map object"
	icon = 'icons/obj/overmap.dmi'
	icon_state = "object"
	color = "#fffffe"

	var/scannable					// If set to TRUE will show up on ship sensors for detailed scans, and will ping when detected by scanners.

	var/unknown_id					// A unique identifier used when this entity is scanned. Assigned in Initialize().

	var/requires_contact = FALSE	// Whether or not the effect must be identified by ship sensors before being seen.
	var/instant_contact  = FALSE	// Do we instantly identify ourselves to any ship in sensors range?
	var/sensor_visibility = 10		// How likely it is to increase identification process each scan.

	var/list/known_ships = list()	 //List of ships known at roundstart - put types here.

//Overlay of how this object should look on other skyboxes
/obj/effect/overmap/proc/get_skybox_representation()
	return

/obj/effect/overmap/proc/get_scan_data(mob/user)
	return desc

/obj/effect/overmap/Initialize()
	. = ..()
	if(!GLOB.using_map.use_overmap)
		return INITIALIZE_HINT_QDEL

	if(scannable)
		unknown_id = "[pick(GLOB.phonetic_alphabet)]-[random_id(/obj/effect/overmap, 100, 999)]"

	if(requires_contact)
		invisibility = INVISIBILITY_OVERMAP // Effects that require identification have their images cast to the client via sensors.

	update_icon()

/obj/effect/overmap/Crossed(obj/effect/overmap/visitable/other)
	if(istype(other))
		for(var/obj/effect/overmap/visitable/O in loc)
			SSskybox.rebuild_skyboxes(O.map_z)

/obj/effect/overmap/Uncrossed(obj/effect/overmap/visitable/other)
	if(istype(other))
		SSskybox.rebuild_skyboxes(other.map_z)
		for(var/obj/effect/overmap/visitable/O in loc)
			SSskybox.rebuild_skyboxes(O.map_z)

/obj/effect/overmap/on_update_icon()
	filters = filter(type="drop_shadow", color = color + "F0", size = 2, offset = 1,x = 0, y = 0)


/**
 * Flags the effect as `known` and runs relevant update procs. Intended for admin event usage.
 */
/obj/effect/overmap/visitable/proc/make_known(notify = FALSE)
	if (!(sector_flags & OVERMAP_SECTOR_KNOWN))
		sector_flags = OVERMAP_SECTOR_KNOWN
		update_known_connections(notify)


/**
 * Runs any relevant code needed for updating anything connected to known overmap effects, such as helms.
 */
/obj/effect/overmap/proc/update_known_connections(notify = FALSE)
	return
