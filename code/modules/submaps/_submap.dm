/datum/submap
	var/name
	var/decl/submap_archetype/archetype
	var/list/jobs
	var/associated_z
	var/datum/antag_skill_setter/skill_setter = /datum/antag_skill_setter/station/offstation

/datum/submap/New(var/existing_z)
	SSmapping.submaps[src] = TRUE
	associated_z = existing_z
	if(ispath(skill_setter))
		skill_setter = new skill_setter

/datum/submap/Destroy()
	SSmapping.submaps -= src
	. = ..()

/datum/submap/proc/setup_submap(var/decl/submap_archetype/_archetype)

	if(!istype(_archetype))
		to_chat(world.log, "Submap error - [name] - null or invalid archetype supplied ([_archetype]).")
		qdel(src)
		return

	// Not much point doing this when it has presumably been done already.
	if(_archetype == archetype)
		to_chat(world.log, "Submap error - [name] - submap already set up.")
		return

	archetype = _archetype
	to_chat(world.log, "Starting submap setup - n'[name]', a'[archetype]', z'[associated_z]'")

	// Instantiate our job list.
	jobs = list()
	for(var/crew_job in archetype.crew_jobs)
		var/datum/job/submap/job = new crew_job(src, archetype.crew_jobs[crew_job])
		if(!job.whitelisted_species)
			job.whitelisted_species = archetype.whitelisted_species
		if(!job.blacklisted_species)
			job.blacklisted_species = archetype.blacklisted_species
		jobs[job.title] = job

	// Either find or build our map.
	if(!associated_z)
		// Load a map + overmap object from archetype map file.
		if(archetype.map && SSmapping.map_templates[archetype.map])
			var/datum/map_template/template = SSmapping.map_templates[archetype.map]
			if (template.loaded && !(template.template_flags & TEMPLATE_FLAG_ALLOW_DUPLICATES))
				to_chat(world.log, "Submap ([template.name]) tried to place duplicate of existing non-duplicate template.")
				qdel(src)
				return
			var/turf/new_z_centre = template.load_new_z()
			if(!istype(new_z_centre))
				to_chat(world.log, "Failed to place submap ([template.name])")
				qdel(src)
				return
			to_chat(world.log, "Submap '[template.name]' placed on zlevel [new_z_centre.z].")
			log_and_message_admins("Submap ([template.name]) has been placed on a new zlevel.", location=new_z_centre)
			associated_z = new_z_centre.z

	if(!associated_z)
		to_chat(world.log, "Submap error - [name]/[archetype ? archetype.descriptor : "NO ARCHETYPE"] could not find an associated z-level for spawnpoint placement.")
		qdel(src)
		return

	var/obj/effect/overmap/cell = map_sectors["[associated_z]"]
	if(istype(cell))
		sync_cell(cell)

	// Add the spawn points to the appropriate job list.
	var/added_spawnpoint
	for(var/check_z in GetConnectedZlevels(associated_z))
		for(var/thing in block(locate(1, 1, check_z), locate(world.maxx, world.maxy, check_z)))
			for(var/obj/effect/submap_landmark/spawnpoint/landmark in thing)
				var/datum/job/submap/job = jobs[landmark.name]
				if(istype(job))
					job.spawnpoints += landmark
					added_spawnpoint = TRUE

	if(!added_spawnpoint)
		to_chat(world.log, "Submap error - [name]/[archetype ? archetype.descriptor : "NO ARCHETYPE"] has no job spawn points.")
		qdel(src)
		return

/datum/submap/proc/sync_cell(var/obj/effect/overmap/cell)
	name = cell.name

/datum/submap/proc/available()
	return TRUE
