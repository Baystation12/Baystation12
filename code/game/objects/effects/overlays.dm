/obj/effect/overlay
	name = "overlay"
	unacidable = TRUE
	var/i_attached //Added for possible image attachments to objects. For hallucinations and the like.

/obj/effect/overlay/beam
	name="beam"
	icon='icons/effects/beam.dmi'
	icon_state= "b_beam"
	var/tmp/atom/BeamSource

/obj/effect/overlay/beam/New()
	..()
	spawn(10)
		qdel(src)

/obj/effect/overlay/palmtree_r
	name = "Palm tree"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "palm1"
	density = TRUE
	layer = ABOVE_HUMAN_LAYER
	anchored = TRUE

/obj/effect/overlay/palmtree_l
	name = "Palm tree"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "palm2"
	density = TRUE
	layer = ABOVE_HUMAN_LAYER
	anchored = TRUE

/obj/effect/overlay/coconut
	name = "Coconuts"
	icon = 'icons/misc/beach.dmi'
	icon_state = "coconuts"

/obj/effect/overlay/bluespacify
	name = "Bluespace"
	icon = 'icons/turf/space.dmi'
	icon_state = "bluespacify"
	layer = SUPERMATTER_WALL_LAYER

/obj/effect/overlay/wallrot
	name = "wallrot"
	desc = "Ick..."
	icon = 'icons/effects/wallrot.dmi'
	anchored = TRUE
	density = TRUE
	layer = ABOVE_TILE_LAYER
	mouse_opacity = 0

/obj/effect/overlay/wallrot/New()
	..()
	pixel_x += rand(-10, 10)
	pixel_y += rand(-10, 10)


/// Effect overlays that should automatically delete themselves after a set time.
/obj/effect/overlay/self_deleting
	/// The amount of time in deciseconds before the effect deletes itself. Can be defined in the object's definition or via `New()`.
	var/delete_time


/obj/effect/overlay/self_deleting/emppulse
	name = "emp pulse"
	icon = 'icons/effects/effects.dmi'
	icon_state = "emppulse"
	anchored = TRUE
	delete_time = 2 SECONDS


/obj/effect/overlay/self_deleting/Initialize(mapload, _delete_time)
	. = ..()
	if (_delete_time)
		delete_time = _delete_time
	if (delete_time <= 0)
		log_debug(append_admin_tools("A self deleting overlay ([src]) was spawned with a negative or zero delete time ([delete_time]) and was instantly deleted.", location = get_turf(src)))
		return INITIALIZE_HINT_QDEL
	addtimer(CALLBACK(src, .proc/self_delete), delete_time)


/obj/effect/overlay/self_deleting/proc/self_delete()
	qdel(src)
