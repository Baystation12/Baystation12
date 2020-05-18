#define UPDATE_BUFFER 25 // 2.5 seconds

// CHUNK
//
// A 16x16 grid of the map with a list of turfs that can be seen, are visible and are dimmed.
// Allows the Eye to stream these chunks and know what it can and cannot see.

/datum/obfuscation
	var/icon = 'icons/effects/cameravis.dmi'
	var/icon_state = "black"
	var/list/obfuscation_images = list()
	var/static/icon/obfuscation_underlay
	// There is an exploit were clients can memory-edit their local version of the static images, allowing them to see everything. This is a minor attempt to make that more difficult.

/datum/obfuscation/Destroy()
	obfuscation_images.Cut()
	. = ..()

/datum/obfuscation/proc/has_obfuscation(var/turf/T)
	return !isnull(obfuscation_images[T])

/datum/obfuscation/proc/get_obfuscation(var/turf/T)
	var/image/obfuscation = obfuscation_images[T]
	if(!obfuscation)
		obfuscation = image(icon, T, icon_state)
		obfuscation.layer = OBFUSCATION_LAYER
		if(!obfuscation_underlay)
			// Creating a new icon of a fairly common icon state, adding some random color to prevent address searching, and hoping being static kills memory locality
			var/turf/floor = /turf/simulated/floor/tiled
			obfuscation_underlay = icon(initial(floor.icon), initial(floor.icon_state))
			obfuscation_underlay.Blend(rgb(rand(0,255),rand(0,255),rand(0,255)))
		obfuscation.underlays += obfuscation_underlay
		obfuscation_images[T] = obfuscation
	return obfuscation

/datum/chunk
	var/datum/visualnet/visualnet
	var/list/obscuredTurfs = list()
	var/list/visibleTurfs = list()
	var/list/obscured = list()
	var/list/turfs = list()
	var/list/seenby = list()
	var/list/sources = list()
	var/dirty = FALSE
	var/updating = FALSE
	var/x = 0
	var/y = 0
	var/z = 0
	var/datum/obfuscation/obfuscation = new()

// Create a new chunk, since the chunks are made as they are needed.
/datum/chunk/New(var/datum/visualnet/visualnet, x, y, z)
	..()
	src.visualnet = visualnet
	// 0xf = 15
	x &= ~0xf
	y &= ~0xf

	src.x = x
	src.y = y
	src.z = z

	for(var/turf/t in range(10, locate(x + 8, y + 8, z)))
		if(t.x >= x && t.y >= y && t.x < x + 16 && t.y < y + 16)
			turfs[t] = t

	add_sources(visualnet.sources)
	acquire_visible_turfs(visibleTurfs)

	// Removes turf that isn't in turfs.
	visibleTurfs &= turfs
	obscuredTurfs = turfs - visibleTurfs

	for(var/turf in obscuredTurfs)
		var/turf/t = turf
		obscured += obfuscation.get_obfuscation(t)

/datum/chunk/Destroy()
	visualnet = null
	. = ..()

/datum/chunk/proc/add_sources(var/list/sources)
	var/turf/center = locate(x + 8, y + 8, z)
	for(var/entry in sources)
		var/atom/A = entry
		if(get_dist(get_turf(A), center) > 16)
			continue
		add_source(A)

/datum/chunk/proc/add_source(var/atom/source)
	if(source in sources)
		return FALSE
	sources += source
	visibility_changed()
	return TRUE

/datum/chunk/proc/remove_source(var/atom/source)
	if(sources.Remove(source))
		visibility_changed()
		return TRUE
	return FALSE

// The visual net is responsible for adding/removing eyes.
/datum/chunk/proc/add_eye(mob/observer/eye/eye)
	seenby += eye
	eye.visibleChunks += src
	if(eye.owner && eye.owner.client)
		eye.owner.client.images += obscured

/datum/chunk/proc/remove_eye(mob/observer/eye/eye)
	seenby -= eye
	eye.visibleChunks -= src
	if(eye.owner && eye.owner.client)
		eye.owner.client.images -= obscured

// Updates the chunk, makes sure that it doesn't update too much. If the chunk isn't being watched it will
// instead be flagged to update the next time an AI Eye moves near it.

/datum/chunk/proc/visibility_changed(var/update_now = FALSE)
	if(update_now)
		update()
		return

	if(updating)
		return

	if(seenby.len)
		updating = TRUE
		spawn(UPDATE_BUFFER) // Batch large changes, such as many doors opening or closing at once
			if(updating)     // Check if we're still updating, a forced update may have occured.
				update()
	else
		dirty = TRUE // If this chunk is seen by noone, simply mark it as dirty and do nothing

// The actual updating.

/datum/chunk/proc/update()
	var/list/newVisibleTurfs = new()
	acquire_visible_turfs(newVisibleTurfs)

	// Removes turf that isn't in turfs.
	newVisibleTurfs &= turfs

	var/list/visAdded = newVisibleTurfs - visibleTurfs
	var/list/visRemoved = visibleTurfs - newVisibleTurfs

	visibleTurfs = newVisibleTurfs
	obscuredTurfs = turfs - newVisibleTurfs

	for(var/turf in visAdded)
		var/turf/t = turf
		if(obfuscation.has_obfuscation(t))
			var/image/obfuscation_image = obfuscation.get_obfuscation(t)
			obscured -= obfuscation_image
			for(var/eye in seenby)
				var/mob/observer/eye/m = eye
				if(m && m.owner && m.owner.client)
					m.owner.client.images -= obfuscation_image

	for(var/turf in visRemoved)
		var/turf/t = turf
		if(obscuredTurfs[t])
			var/image/obfuscation_image = obfuscation.get_obfuscation(t)
			obscured += obfuscation_image
			for(var/eye in seenby)
				var/mob/observer/eye/m = eye
				if(m && m.owner && m.owner.client)
					m.owner.client.images += obfuscation_image

	dirty = FALSE
	updating = FALSE

/datum/chunk/proc/acquire_visible_turfs(var/list/visible)
	return

/proc/seen_turfs_in_range(var/source, var/range)
	var/turf/pos = get_turf(source)
	if(pos)
		. = hear(range, pos)
	else
		. = list()

#undef UPDATE_BUFFER
