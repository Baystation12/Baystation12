/proc/cosmic_cult_siphon_vfx(atom/target, client/viewer, duration = 1 SECOND)
	if (!viewer)
		return

	var/image/vfx = image('icons/coscult/ability-siphon.dmi', target, "vfx")
	vfx.pixel_y = 26
	vfx.transform = matrix().Scale(0.65, 0.65)
	vfx.plane = EFFECTS_ABOVE_LIGHTING_PLANE
	vfx.layer = ABOVE_LIGHTING_LAYER
	vfx.appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_TRANSFORM
	viewer.images += vfx
	addtimer(new Callback(GLOBAL_PROC, GLOBAL_PROC_REF(cosmic_cult_remove_client_image), viewer, vfx), duration)
	usr.playsound_local(null, 'sound/coscult/ability-siphon.ogg', 75, FALSE)

/proc/cosmic_cult_remove_client_image(client/viewer, image/I)
	if (viewer)
		viewer.images -= I

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

/obj/cosmic_cult/vfx/ability_shift
	icon = 'icons/coscult/ability-shift.dmi'
	icon_state = "vfx"
	pixel_x = -8
	pixel_y = -8

/obj/cosmic_cult/light_fx/ability_shift
	time_in = 10
	time_out = 10

/proc/cosmic_cult_shift_vfx(atom/target)
	new /obj/cosmic_cult/vfx/ability_shift(target.loc)
	new /obj/cosmic_cult/light_fx/ability_shift(target.loc)

/proc/cosmic_cult_sink_out(atom/atom, duration = 1 SECOND)
	playsound(atom.loc, 'sound/coscult/ability-shift-out.ogg', 75, FALSE)
	atom.appearance_flags |= KEEP_TOGETHER
	atom.filters += filter(type = "alpha", icon = icon('icons/effects/effects.dmi', "white"), name = "cosmic_cult_sink")
	var/mask = atom.filters["cosmic_cult_sink"]
	animate(atom, pixel_y = atom.pixel_y - world.icon_size, time = duration, easing = EASE_IN | CUBIC_EASING, flags = ANIMATION_PARALLEL)
	animate(mask, y = world.icon_size, time = duration, easing = EASE_IN | CUBIC_EASING, flags = ANIMATION_PARALLEL)

/proc/cosmic_cult_sink_in(atom/atom, duration = 1 SECOND)
	set waitfor = 0

	var/mask = atom.filters["cosmic_cult_sink"]
	playsound(atom.loc, 'sound/coscult/ability-shift-in.ogg', 75, FALSE)
	animate(mask, y = 0, time = duration, easing = EASE_OUT | CUBIC_EASING, flags = ANIMATION_PARALLEL)
	animate(atom, pixel_y = atom.pixel_y + world.icon_size, time = duration, easing = EASE_OUT | CUBIC_EASING, flags = ANIMATION_PARALLEL)

	sleep(duration)

	atom.filters -= mask
	atom.appearance_flags &= ~KEEP_TOGETHER

/obj/cosmic_cult/vfx/ability_shunt
	icon = 'icons/coscult/ability-shunt.dmi'
	icon_state = "vfx"
	pixel_x = -16
	pixel_y = -16
	duration = 15
	layer = ABOVE_HUMAN_LAYER

/obj/cosmic_cult/light_fx/ability_shunt
	time_in = 8
	time_out = 8

/proc/cosmic_cult_shunt_vfx(atom/target)
	playsound(target.loc, 'sound/coscult/ability-shunt.ogg', 75, FALSE)
	new /obj/cosmic_cult/vfx/ability_shunt(target.loc)
	new /obj/cosmic_cult/light_fx/ability_shunt(target.loc)
