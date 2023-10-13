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

	var/list/known_ships = list()	 //List of ships known at roundstart - put types here.

	/// The list of scans that can be performed on this overmap effect. See /datum/sector_scan for more info.
	var/list/scans = list()
	///Used for generating unique keys for the associated list 'scans'
	var/next_id = 0

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
	add_scan_data("base_scan", desc)

	if(!GLOB.using_map.use_overmap)
		return INITIALIZE_HINT_QDEL

	if(scannable)
		unknown_id = "[pick(GLOB.phonetic_alphabet)]-[random_id(/obj/overmap, 100, 999)]"

	if(requires_contact)
		invisibility = INVISIBILITY_OVERMAP // Effects that require identification have their images cast to the client via sensors.

	update_icon()

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
	filters = filter(type="drop_shadow", color = color + "F0", size = 2, offset = 1,x = 0, y = 0)


/**
 * Flags the effect as `known` and runs relevant update procs. Intended for admin event usage.
 */
/obj/overmap/visitable/proc/make_known(notify = FALSE)
	if (!HAS_FLAGS(sector_flags, OVERMAP_SECTOR_KNOWN))
		sector_flags = OVERMAP_SECTOR_KNOWN
		update_known_connections(notify)


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
