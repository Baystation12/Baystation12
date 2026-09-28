/obj/cosmic_cult/vfx/shockwave
	plane = SHOCKWAVE_EFFECT_PLANE
	appearance_flags = NO_CLIENT_COLOR
	pixel_x = -112
	pixel_y = -112
	z_flags = ZMM_IGNORE
	icon = 'icons/coscult/shockwave.dmi'
	icon_state = "ring"
	duration = 2 SECONDS

	var/icon_size = 256
	var/radius = 7
	var/strength = 1

/obj/cosmic_cult/vfx/shockwave/proc/get_color_matrix(strength)
	var/neutral = (1 - strength) * 0.5
	return list(
		strength, 0, 0, 0,
		0, strength, 0, 0,
		0, 0, 1, 0,
		0, 0, 0, 1,
		neutral, neutral, 0, 0
	)

/obj/cosmic_cult/vfx/shockwave/Initialize()
	. = ..()

	var/icon_radius = icon_size / 2
	SetTransform(scale = 0)
	color = get_color_matrix(strength)
	animate(src, transform = matrix().Scale(radius * world.icon_size / icon_radius), time = duration, easing = EASE_OUT | CUBIC_EASING, flags = ANIMATION_PARALLEL)
	animate(src, color = get_color_matrix(0), time = duration, flags = ANIMATION_PARALLEL)

/proc/cosmic_cult_shockwave_vfx(atom/target)
	new /obj/cosmic_cult/vfx/shockwave(get_turf(target))
