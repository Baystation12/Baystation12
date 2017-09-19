/obj/effect/overlay
	name = "overlay"
	unacidable = 1
	var/i_attached//Added for possible image attachments to objects. For hallucinations and the like.

/obj/effect/overlay/beam//Not actually a projectile, just an effect.
	name="beam"
	icon='icons/effects/beam.dmi'
	icon_state= "b_beam"
	var/tmp/atom/BeamSource
	New()
		..()
		spawn(10) qdel(src)

/obj/effect/overlay/palmtree_r
	name = "Palm tree"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "palm1"
	density = 1
	plane = ABOVE_HUMAN_PLANE
	layer = ABOVE_HUMAN_LAYER
	anchored = 1

/obj/effect/overlay/palmtree_l
	name = "Palm tree"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "palm2"
	density = 1
	plane = ABOVE_HUMAN_PLANE
	layer = ABOVE_HUMAN_LAYER
	anchored = 1

/obj/effect/overlay/coconut
	name = "Coconuts"
	icon = 'icons/misc/beach.dmi'
	icon_state = "coconuts"

/obj/effect/overlay/bluespacify
	name = "Bluespace"
	icon = 'icons/turf/space.dmi'
	icon_state = "bluespacify"
	plane = EFFECTS_ABOVE_LIGHTING_PLANE
	layer = SUPERMATTER_WALL_LAYER

/obj/effect/overlay/wallrot
	name = "wallrot"
	desc = "Ick..."
	icon = 'icons/effects/wallrot.dmi'
	anchored = 1
	density = 1
	plane = ABOVE_TURF_PLANE
	layer = ABOVE_TILE_LAYER
	mouse_opacity = 0

/obj/effect/overlay/wallrot/New()
	..()
	pixel_x += rand(-10, 10)
	pixel_y += rand(-10, 10)

/obj/effect/overlay/cult/cultwall
	name = "Corrupting glow"
	desc = "You find yourself carrying an overwhelming urge to report the observability of this overlay to the bug tracker. Mention a \"cultwall\"."
	icon = 'icons/effects/effects.dmi'
	icon_state = "cultwall"
	plane = ABOVE_TURF_PLANE
	layer = ABOVE_TILE_LAYER
	mouse_opacity = 0
/obj/effect/overlay/cult/wallspawn/New()
	..()
	spawn(1)
	qdel(src)

/obj/effect/overlay/cult/cultfloor
	icon = 'icons/effects/effects.dmi'
	desc = "You find yourself carrying an overwhelming urge to report the observability of this overlay to the bug tracker. Mention a \"cultfloor\"."
	icon_state = "cultfloor"
	plane = ABOVE_TURF_PLANE
	layer = ABOVE_TILE_LAYER
	mouse_opacity = 0

/obj/effect/overlay/cult/floorspawn/New()
	..()
	spawn(1)
	qdel(src)