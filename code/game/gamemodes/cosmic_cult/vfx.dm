/obj/cosmic_cult/vfx
	anchored = TRUE
	unacidable = TRUE
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	density = FALSE
	var/duration = 20

/obj/cosmic_cult/vfx/Initialize()
	. = ..()
	QDEL_IN(src, duration)

/obj/cosmic_cult/vfx/on_update_icon()
	ClearOverlays()
	AddOverlays(list(
		overlay_image(icon, icon_state),
		emissive_appearance(icon, icon_state)
	))

/obj/cosmic_cult/light_fx
	icon = 'icons/coscult/vfx-light-2.5.dmi'
	icon_state = ""
	plane = LIGHTING_PLANE
	layer = ABOVE_LIGHTING_LAYER
	blend_mode = BLEND_ADD
	invisibility = INVISIBILITY_LIGHTING
	color = "#42a4ae"
	alpha = 0
	pixel_x = -64
	pixel_y = -64 - 8
	var/time_in
	var/time_out

/obj/cosmic_cult/light_fx/Initialize()
	. = ..()
	animate(src, alpha = 255, time = time_in)
	animate(alpha = 0, time = time_out)
	QDEL_IN(src, time_in + time_out)
