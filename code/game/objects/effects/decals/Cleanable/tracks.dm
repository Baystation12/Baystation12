// Stolen en masse from N3X15 of /vg/station with much gratitude.

// The idea is to have 4 bits for coming and 4 for going.
#define TRACKS_COMING_NORTH 1
#define TRACKS_COMING_SOUTH 2
#define TRACKS_COMING_EAST  4
#define TRACKS_COMING_WEST  8
#define TRACKS_GOING_NORTH  16
#define TRACKS_GOING_SOUTH  32
#define TRACKS_GOING_EAST   64
#define TRACKS_GOING_WEST   128

// 5 seconds
#define TRACKS_CRUSTIFY_TIME   50

// color-dir-dry
var/global/list/image/fluidtrack_cache=list()

/datum/fluidtrack
	var/direction=0
	var/basecolor=COLOR_BLOOD_HUMAN
	var/wet=0
	var/fresh=1
	var/crusty=0
	var/image/overlay

/datum/fluidtrack/New(_direction,_color,_wet)
	src.direction=_direction
	src.basecolor=_color
	src.wet=_wet

/obj/decal/cleanable/blood/tracks/reveal_blood()
	if(!fluorescent)
		for (var/dir in setdirs)
			var/datum/fluidtrack/track = setdirs["[dir]"]
			if (track)
				track.basecolor = COLOR_LUMINOL
		..()

// Footprints, tire trails...
/obj/decal/cleanable/blood/tracks
	amount = 0
	random_icon_states = null
	icon = 'icons/effects/fluidtracks.dmi'
	cleanable_scent = null

	/// Bitflag. All directions, both incoming and outgoing, that this track decal has prints traveling in. See `setdirs` for a definition of each flag.
	var/dirs = EMPTY_BITFIELD
	/// String. Icon state used for incoming tracks during `update_icon()`.
	var/coming_state="blood1"
	/// String. Icon state used for outgoing tracks during `update_icon()`.
	var/going_state="blood2"

	/**
	 * List (`"number"` -> instances of `/datum/fluidtrack`). Map of directional bit flags to attached fluidtrack isntances.
	 *
	 * Indexes are stringified bitflags of the four main cardinal directions, duplicated once. The first set is
	 *   incoming footsteps, and the second outgoing.
	 *
	 * Quick reference of each bitflag:
	 * ```dm
	 * INCOMING_NORTH = 1
	 * INCOMING_SOUTH = 2
	 * INCOMING_EAST = 4
	 * INCOMING_WEST = 8
	 * OUTGOING_NORTH = 16
	 * OUTGOING_SOUTH = 32
	 * OUTGOING_EAST = 64
	 * OUTGOING_WEST = 128
	 * ```
	 */
	var/list/setdirs=list(
		"1" = null,
		"2" = null,
		"4" = null,
		"8" = null,
		"16" = null,
		"32" = null,
		"64" = null,
		"128" = null
	)

/**
 * Add tracks to an existing trail.
 *
 * @param DNA bloodDNA to add to collection.
 * @param comingdir Direction tracks come from, or 0.
 * @param goingdir Direction tracks are going to (or 0).
 * @param bloodcolor Color of the blood when wet.
 */
/obj/decal/cleanable/blood/tracks/proc/AddTracks(list/DNA, comingdir, goingdir, bloodcolor=COLOR_BLOOD_HUMAN)
	var/updated=0
	// Shift our goingdir 4 spaces to the left so it's in the GOING bitblock.
	var/realgoing = SHIFTL(goingdir, 4)

	// Current bit
	var/b=0

	// When tracks will start to dry out
	var/t=world.time + TRACKS_CRUSTIFY_TIME

	var/datum/fluidtrack/track

	// Process 4 bits
	for(var/bi=0;bi<4;bi++)
		b = SHIFTL(1, bi)
		// COMING BIT
		// If setting
		if(comingdir&b)
			// If not wet or not set
			if(dirs&b)
				track = setdirs["[b]"]
				if (track && track.wet == t && track.basecolor == bloodcolor)
					continue
				// Remove existing stack entry
				qdel(track)
			track = new /datum/fluidtrack(b, bloodcolor, t)
			setdirs["[b]"] = track
			updated=1

		// GOING BIT (shift up 4)
		b = SHIFTL(b, 4)
		if(realgoing&b)
			// If not wet or not set
			if(dirs&b)
				track = setdirs["[b]"]
				if (track && track.wet == t && track.basecolor == bloodcolor)
					continue
				// Remove existing stack entry
				qdel(track)
			track = new /datum/fluidtrack(b, bloodcolor, t)
			setdirs["[b]"] = track
			updated=1

	dirs |= comingdir|realgoing
	if(islist(blood_DNA))
		blood_DNA |= DNA.Copy()
	if(updated)
		update_icon()

/obj/decal/cleanable/blood/tracks/on_update_icon()
	ClearOverlays()
	color = "#ffffff"
	var/truedir=0

	// Update ONLY the overlays that have changed.
	for (var/dir in setdirs)
		var/datum/fluidtrack/track = setdirs["[dir]"]
		if (!track)
			continue
		var/state=coming_state
		truedir=track.direction
		if(truedir&240) // Check if we're in the GOING block
			state=going_state
			truedir = SHIFTR(truedir, 4)

		if(track.overlay)
			track.overlay=null
		var/image/I = image(icon, icon_state=state, dir=num2dir(truedir))
		I.color = track.basecolor

		track.fresh=0
		track.overlay=I
		AddOverlays(I)

/obj/decal/cleanable/blood/tracks/footprints
	name = "wet footprints"
	dryname = "dried footprints"
	desc = "They look like still wet tracks left by footwear."
	drydesc = "They look like dried tracks left by footwear."
	coming_state = "human1"
	going_state  = "human2"

/obj/decal/cleanable/blood/tracks/footprints/reversed
	coming_state = "human2"
	going_state = "human1"

/obj/decal/cleanable/blood/tracks/footprints/reversed/AddTracks(list/DNA, comingdir, goingdir, bloodcolor=COLOR_BLOOD_HUMAN)
	comingdir = reverse_direction(comingdir)
	goingdir = reverse_direction(goingdir)
	..(DNA, comingdir, goingdir, bloodcolor)

/obj/decal/cleanable/blood/tracks/snake
	name = "wet tracks"
	dryname = "dried tracks"
	desc = "They look like still wet tracks left by a giant snake."
	drydesc = "They look like dried tracks left by a giant snake."
	coming_state = "snake1"
	going_state  = "snake2"

/obj/decal/cleanable/blood/tracks/paw
	name = "wet tracks"
	dryname = "dried tracks"
	desc = "They look like still wet tracks left by a mammal."
	drydesc = "They look like dried tracks left by a mammal."
	coming_state = "paw1"
	going_state  = "paw2"

/obj/decal/cleanable/blood/tracks/claw
	name = "wet tracks"
	dryname = "dried tracks"
	desc = "They look like still wet tracks left by a reptile."
	drydesc = "They look like dried tracks left by a reptile."
	coming_state = "claw1"
	going_state  = "claw2"

/obj/decal/cleanable/blood/tracks/wheels
	name = "wet tracks"
	dryname = "dried tracks"
	desc = "They look like still wet tracks left by wheels."
	drydesc = "They look like dried tracks left by wheels."
	coming_state = "wheels"
	going_state  = ""
	gender = PLURAL

/obj/decal/cleanable/blood/tracks/body
	name = "wet trails"
	dryname = "dried trails"
	desc = "A still-wet trail left by someone crawling."
	drydesc = "A dried trail left by someone crawling."
	coming_state = "trail1"
	going_state  = "trail2"
