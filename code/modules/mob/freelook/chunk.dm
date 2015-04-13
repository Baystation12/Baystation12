#define UPDATE_BUFFER 25 // 2.5 seconds

// CHUNK
//
// A 16x16 grid of the map with a list of turfs that can be seen, are visible and are dimmed.
// Allows the Eye to stream these chunks and know what it can and cannot see.

/datum/obfuscation
	var/icon = 'icons/effects/cameravis.dmi'
	var/icon_state = "black"

/datum/chunk
	var/list/obscuredTurfs = list()
	var/list/visibleTurfs = list()
	var/list/obscured = list()
	var/list/turfs = list()
	var/list/seenby = list()
	var/visible = 0
	var/changed = 0
	var/updating = 0
	var/x = 0
	var/y = 0
	var/z = 0
	var/datum/obfuscation/obfuscation = new()

// Add an eye to the chunk, then update if changed.

/datum/chunk/proc/add(mob/eye/eye)
	if(!eye.owner)
		return
	eye.visibleChunks += src
	if(eye.owner.client)
		eye.owner.client.images += obscured
	visible++
	seenby += eye
	if(changed && !updating)
		update()

// Remove an eye from the chunk, then update if changed.

/datum/chunk/proc/remove(mob/eye/eye)
	if(!eye.owner)
		return
	eye.visibleChunks -= src
	if(eye.owner.client)
		eye.owner.client.images -= obscured
	seenby -= eye
	if(visible > 0)
		visible--

// Called when a chunk has changed. I.E: A wall was deleted.

/datum/chunk/proc/visibilityChanged(turf/loc)
	if(!visibleTurfs[loc])
		return
	hasChanged()

// Updates the chunk, makes sure that it doesn't update too much. If the chunk isn't being watched it will
// instead be flagged to update the next time an AI Eye moves near it.

/datum/chunk/proc/hasChanged(var/update_now = 0)
	if(visible || update_now)
		if(!updating)
			updating = 1
			spawn(UPDATE_BUFFER) // Batch large changes, such as many doors opening or closing at once
				update()
				updating = 0
	else
		changed = 1

// The actual updating.

/datum/chunk/proc/update()

	set background = 1

	var/list/newVisibleTurfs = new()
	acquireVisibleTurfs(newVisibleTurfs)

	// Removes turf that isn't in turfs.
	newVisibleTurfs &= turfs

	var/list/visAdded = newVisibleTurfs - visibleTurfs
	var/list/visRemoved = visibleTurfs - newVisibleTurfs

	visibleTurfs = newVisibleTurfs
	obscuredTurfs = turfs - newVisibleTurfs

	for(var/turf in visAdded)
		var/turf/t = turf
		if(t.obfuscations[obfuscation.type])
			obscured -= t.obfuscations[obfuscation.type]
			for(var/eye in seenby)
				var/mob/eye/m = eye
				if(!m || !m.owner)
					continue
				if(m.owner.client)
					m.owner.client.images -= t.obfuscations[obfuscation.type]

	for(var/turf in visRemoved)
		var/turf/t = turf
		if(obscuredTurfs[t])
			if(!t.obfuscations[obfuscation.type])
				t.obfuscations[obfuscation.type] = image(obfuscation.icon, t, obfuscation.icon_state, OBFUSCATION_LAYER)

			obscured += t.obfuscations[obfuscation.type]
			for(var/eye in seenby)
				var/mob/eye/m = eye
				if(!m || !m.owner)
					seenby -= m
					continue
				if(m.owner.client)
					m.owner.client.images += t.obfuscations[obfuscation.type]

/datum/chunk/proc/acquireVisibleTurfs(var/list/visible)

// Create a new camera chunk, since the chunks are made as they are needed.

/datum/chunk/New(loc, x, y, z)

	// 0xf = 15
	x &= ~0xf
	y &= ~0xf

	src.x = x
	src.y = y
	src.z = z

	for(var/turf/t in range(10, locate(x + 8, y + 8, z)))
		if(t.x >= x && t.y >= y && t.x < x + 16 && t.y < y + 16)
			turfs[t] = t

	acquireVisibleTurfs(visibleTurfs)

	// Removes turf that isn't in turfs.
	visibleTurfs &= turfs

	obscuredTurfs = turfs - visibleTurfs

	for(var/turf in obscuredTurfs)
		var/turf/t = turf
		if(!t.obfuscations[obfuscation.type])
			t.obfuscations[obfuscation.type] = image(obfuscation.icon, t, obfuscation.icon_state, OBFUSCATION_LAYER)
		obscured += t.obfuscations[obfuscation.type]

#undef UPDATE_BUFFER
