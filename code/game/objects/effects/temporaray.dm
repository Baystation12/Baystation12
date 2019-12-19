//temporary visual effects
/obj/effect/temp_visual
	icon_state = "nothing"
	anchored = TRUE
	layer = ABOVE_HUMAN_LAYER
	mouse_opacity = 0
	simulated = FALSE
	var/duration = 10 //in deciseconds

/obj/effect/temp_visual/Initialize(mapload, set_dir)
	if(set_dir)
		set_dir(set_dir)
	. = ..()
	QDEL_IN(src, duration)

/obj/effect/temp_visual/bloodsplatter
	icon = 'icons/effects/bloodspatter.dmi'
	duration = 5
	layer = LYING_HUMAN_LAYER
	var/splatter_type = "splatter"

/obj/effect/temp_visual/bloodsplatter/Initialize(mapload, set_dir, _color)
	if(set_dir in GLOB.cornerdirs)
		icon_state = "[splatter_type][pick(1, 2, 6)]"
	else
		icon_state = "[splatter_type][pick(3, 4, 5)]"
	. = ..()
	if (_color)
		color = _color

	var/target_pixel_x = 0
	var/target_pixel_y = 0
	if(set_dir & NORTH)
		target_pixel_y = 16
	if(set_dir & SOUTH)
		target_pixel_y = -16
		layer = ABOVE_HUMAN_LAYER
	if(set_dir & EAST)
		target_pixel_x = 16
	if(set_dir & WEST)
		target_pixel_x = -16
	animate(src, pixel_x = target_pixel_x, pixel_y = target_pixel_y, alpha = 0, time = duration)