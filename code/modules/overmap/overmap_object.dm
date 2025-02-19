#define SANITIZE_SPEED(speed) SIGN(speed) * clamp(abs(speed), 0, max_speed)
/obj/overmap
	name = "map object"
	icon = 'icons/obj/overmap.dmi'
	icon_state = "object"
	color = "#fffffe"

	var/scannable					// If set to TRUE will show up on ship sensors for detailed scans, and will ping when detected by scanners.

	var/unknown_id					// A unique identifier used when this entity is scanned. Assigned in Initialize().

	var/requires_contact = FALSE	// Whether or not the effect must be identified by ship sensors before being seen.
	var/instant_contact  = FALSE	// Do we instantly identify ourselves to any ship in sensors range?
	var/sensor_visibility = 20		// How much it increases identification process each scan.

	var/list/known_ships = list()	//List of ships known at roundstart - put types here.

	/// The list of scans that can be performed on this overmap effect. See /datum/sector_scan for more info.
	var/list/scans = list()
	///Used for generating unique keys for the associated list 'scans'
	var/next_id = 0

	// Basic movement is supported, but things like acceleration are handled in subtypes (ships)
	/// If true, this object will be scheduled for movement processing
	var/movable = FALSE
	/// Current speed of the object, as turfs/ticks
	var/list/speed = list(0, 0)
	/// Sub-tile position of the object, as a fraction of distance from center
	/// For example, 0.33 = 1/3 tile
	var/list/position = list(0, 0)
	/// Halts movement processing entirely (admin freezes and similar)
	var/halted = FALSE
	/// If true, the object is deleted on hitting the map edge. This takes precedence over wraparound
	var/delete_on_edge = FALSE
	/// Should the object wrap to the other side of the map when it hits the map edge?
	var/wraparound = TRUE
	/// The "speed of light" for this object. Any faster than 1 turf/SSobj tick will get janky.
	var/max_speed = 1 / (1 SECOND)
	/// Objects traveling slower than this are considered at rest
	var/min_speed = 1 / (5 MINUTES)

	/// Whether to randomize sub-tile start position
	var/randomize_start_pos = TRUE

	var/image/heading_overlay = null

//Overlay of how this object should look on other skyboxes
/obj/overmap/proc/get_skybox_representation()
	return

/obj/overmap/proc/get_scan_data(mob/user)
	var/temp_data = list()
	for(var/id in scans)
		var/datum/sector_scan/scan = scans[id]
		if (!scan.required_skill || user.skill_check(scan.required_skill, scan.required_skill_level))
			temp_data += scan.description
		else if (scan.low_skill_description)
			temp_data += scan.low_skill_description

	return temp_data

/obj/overmap/Initialize()
	. = ..()
	min_speed = round(min_speed, GLOB.overmap_move_resolution)
	max_speed = round(max_speed, GLOB.overmap_move_resolution)
	add_scan_data("base_scan", desc)

	if(!GLOB.using_map.use_overmap)
		return INITIALIZE_HINT_QDEL

	if(scannable)
		unknown_id = "[pick(GLOB.phonetic_alphabet)]-[random_id(/obj/overmap, 100, 999)]"

	if(requires_contact)
		invisibility = INVISIBILITY_OVERMAP // Effects that require identification have their images cast to the client via sensors.

	if(movable)
		START_PROCESSING(SSobj, src)
		heading_overlay = overlay_image(icon = icon, icon_state = "heading_indicator", flags = RESET_COLOR)
		heading_overlay.filters = filter(type="drop_shadow", color = color + "F0", size = 2, offset = 1,x = 0, y = 0)

	if (randomize_start_pos)
		position[1] = round((rand() - 0.5) / 2.5, GLOB.overmap_move_resolution)
		position[2] = round((rand() - 0.5) / 2.5, GLOB.overmap_move_resolution)
	update_icon()

/obj/overmap/Destroy()
	if(movable)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/overmap/Process()
	process_movement()

/obj/overmap/proc/make_movable()
	if (movable)
		return FALSE

	movable = TRUE
	if (isnull(heading_overlay))
		heading_overlay = overlay_image(icon = icon, icon_state = "heading_indicator", flags = RESET_COLOR)
		heading_overlay.filters = filter(type="drop_shadow", color = color + "F0", size = 2, offset = 1,x = 0, y = 0)

	START_PROCESSING(SSobj, src)

/obj/overmap/proc/make_stationary()
	if (!movable)
		return FALSE
	speed[1] = 0
	speed[2] = 0
	movable = FALSE
	STOP_PROCESSING(SSobj, src)

/obj/overmap/proc/adjust_speed(n_x, n_y)
	n_x = SANITIZE_SPEED(n_x)
	n_y = SANITIZE_SPEED(n_y)

	if(abs(speed[1] + n_x) < min_speed)
		speed[1] = 0
	else
		speed[1] = SANITIZE_SPEED((speed[1] + n_x)/(1 + speed[1]*n_x/(max_speed ** 2)))

	if(abs(speed[2] + n_y) < min_speed)
		speed[2] = 0
	else
		speed[2] = SANITIZE_SPEED((speed[2] + n_y)/(1 + speed[2]*n_y/(max_speed ** 2)))

	update_icon()

/obj/overmap/proc/get_speed()
	return round(sqrt(speed[1] ** 2 + speed[2] ** 2), GLOB.overmap_move_resolution)

/obj/overmap/proc/is_moving()
	return ((abs(speed[1]) >= min_speed) || (abs(speed[2]) >= min_speed))

/obj/overmap/proc/get_heading()
	var/res = 0
	if(abs(speed[1]) >= min_speed)
		if(speed[1] > 0)
			res |= EAST
		else
			res |= WEST
	if(abs(speed[2]) >= min_speed)
		if(speed[2] > 0)
			res |= NORTH
		else
			res |= SOUTH
	return res

/obj/overmap/proc/get_heading_angle()
	var/res = 0
	if (is_moving())
		res = (round(Atan2(speed[1], -speed[2])) + 450)%360
	return res

///Perform any movement, as applicable
/obj/overmap/proc/process_movement()
	if (halted || !is_moving())
		return

	var/list/deltas = list(0, 0)
	for(var/i = 1 to 2)
		if(abs(speed[i]) >= min_speed)
			// Speed is turfs/second, so multiply by the time passed since the last time SSobj fired
			position[i] += speed[i] * (world.time - SSobj.last_fire)
			if(position[i] < 0)
				deltas[i] = ceil(position[i])
			else if(position[i] > 0)
				deltas[i] = floor(position[i])

			if(deltas[i] != 0)
				position[i] -= deltas[i]
				// carry spillover movement to the next turf
				position[i] += (deltas[i] > 0) ? -1 : 1

	dir = get_heading()
	update_icon()
	var/new_x = x + deltas[1]
	var/new_y = y + deltas[2]
	var/turf/newloc = locate(new_x, new_y, z)
	if(newloc && loc != newloc)
		Move(newloc)

		if(istype(newloc, /turf/unsimulated/map/edge))
			if (delete_on_edge)
				qdel(src)
			else if (wraparound)
				handle_wraparound(new_x, new_y)
			else
				// we're not being deleted, and we're not wrapping around, so just stop where we are
				speed[1] = 0
				speed[2] = 0
				for(var/i = 1 to 2)
					if(deltas[i] != 0)
						position[i] -= (deltas[i] > 0) ? -1 : 1
						position[i] += deltas[i]
						position[i] = clamp(position[i], -1, 1)

/obj/overmap/proc/handle_wraparound(nx, ny)
	var/low_edge = 2
	var/high_edge = GLOB.using_map.overmap_size - 1

	if((dir & WEST) && (nx == 1))
		nx = high_edge
	else if((dir & EAST) && (nx == GLOB.using_map.overmap_size))
		nx = low_edge

	if((dir & SOUTH) && (ny == 1))
		ny = high_edge
	else if((dir & NORTH) && (ny == GLOB.using_map.overmap_size))
		ny = low_edge

	var/turf/T = locate(nx,ny,z)
	if(T)
		forceMove(T)

/obj/overmap/visitable/ship/proc/halt()
	halted = TRUE

/obj/overmap/visitable/ship/proc/unhalt()
	halted = FALSE

/obj/overmap/Crossed(obj/overmap/visitable/other)
	if(istype(other))
		for(var/obj/overmap/visitable/O in loc)
			SSskybox.rebuild_skyboxes(O.map_z)

/obj/overmap/Uncrossed(obj/overmap/visitable/other)
	if(istype(other))
		SSskybox.rebuild_skyboxes(other.map_z)
		for(var/obj/overmap/visitable/O in loc)
			SSskybox.rebuild_skyboxes(O.map_z)

/obj/overmap/on_update_icon()
	pixel_x = position[1] * (world.icon_size/2)
	pixel_y = position[2] * (world.icon_size/2)
	filters = filter(type="drop_shadow", color = color + "F0", size = 2, offset = 1,x = 0, y = 0)

	ClearOverlays()
	if (is_moving())
		AddOverlays(heading_overlay)

/**
 * Runs any relevant code needed for updating anything connected to known overmap effects, such as helms.
 */
/obj/overmap/proc/update_known_connections(notify = FALSE)
	return

/obj/overmap/proc/add_scan_data(id, description, low_skill_description, required_skill, required_skill_level)

	var/datum/sector_scan/new_scan = new()
	//If id isn't specified, generate unique-ish one
	if(!id)
		id = "scan_data_[next_id++]"

	if (scans[id])
		log_debug("Tried to add a scan with an id that already exists: [id]")
		return FALSE

	new_scan.id = id
	new_scan.description = description
	new_scan.low_skill_description = low_skill_description
	new_scan.required_skill = required_skill
	new_scan.required_skill_level = required_skill_level

	scans[id] = new_scan

	return TRUE

/obj/overmap/proc/remove_scan_data(id)
	if(!scans[id])
		return FALSE

	var/datum/scan = scans[id]
	scans -= id
	qdel(scan)

	return TRUE

/datum/sector_scan
	/// The id of the scan. Used for referencing the scan in the linked overmap effect's 'scans' list.
	var/id = "Sector Scan"
	/// The description of the scan. This is what will be shown to the player when they scan the sector.
	var/description = "A scan of the sector."
	/// The description of the scan if the player doesn't have the required skill to see the normal description.
	var/low_skill_description = "A scan of the sector. You can't make out much."
	/// The skill required to see the normal description.
	var/required_skill = SKILL_SCIENCE
	/// The level of the skill required to see the normal description.
	var/required_skill_level = SKILL_TRAINED

#undef SANITIZE_SPEED
