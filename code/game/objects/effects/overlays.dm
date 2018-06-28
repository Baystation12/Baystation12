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

/obj/effect/overlay/temp
	icon_state = "nothing"
	anchored = 1
	layer = 5
	mouse_opacity = 0
	var/duration = 10 //in deciseconds
	var/randomdir = TRUE
	var/timerid

/obj/effect/overlay/temp/New()
	..()
	if(randomdir)
		dir = (pick(NORTH, SOUTH, EAST, WEST))
	flick("[icon_state]", src)

	QDEL_IN(src, duration)

/obj/effect/overlay/temp/ex_act()
	return

/obj/effect/overlay/temp/dir_setting
	randomdir = FALSE

/obj/effect/overlay/temp/dir_setting/New(loc, set_dir)
	if(set_dir)
		dir = set_dir
	..()


/obj/effect/overlay/temp/kinetic_blast
	name = "kinetic explosion"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "kinetic_blast"
	layer = 5
	duration = 4

/obj/effect/overlay/temp/explosion
	name = "explosion"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "explosion"
	pixel_x = -32
	pixel_y = -32
	duration = 8

/obj/effect/overlay/temp/explosion/fast
	icon_state = "explosionfast"
	duration = 4