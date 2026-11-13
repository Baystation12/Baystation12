#define SHOCKWAVE_GROWTH 0.675
#define SHOCKWAVE_SEGMENTS 12

/obj/cosmic_cult/vfx/shockwave
	plane = SHOCKWAVE_EFFECT_PLANE
	appearance_flags = NO_CLIENT_COLOR
	z_flags = ZMM_IGNORE
	duration = 2 SECONDS

	var/radius = 9.8
	var/edge_width = 1.5
	var/width = 1.5
	var/strength = 1
	var/steps = 6

	var/list/obj/cosmic_cult/shockwave_layer/layers

/obj/cosmic_cult/vfx/shockwave/Initialize()
	. = ..()

	layers = list()
	add_layer("neutral", 1, 0, 1)

	var/level = 0
	for (var/i = 0 to steps - 1)
		var/next = smoothstep(0, edge_width, edge_width * (i + 1) / steps) ** 2
		add_layer("direction", 2, edge_width * (i + 0.5) / steps, 1 - (1 - next) / (1 - level))
		level = next

	var/remaining = 1
	for (var/i = 0 to steps - 1)
		var/next = (1 - smoothstep(width, width + edge_width, width + edge_width * (i + 1) / steps)) ** 2
		add_layer("neutral", 3, width + edge_width * (i + 0.5) / steps, 1 - next / remaining)
		remaining = next

	var/fader = add_layer("neutral", 4, 0, 1 - strength)
	animate(fader, alpha = 255 * (1 - 0.4 * strength), time = 0.6 * duration, flags = ANIMATION_PARALLEL)
	animate(alpha = 255, time = 0.4 * duration, easing = EASE_OUT | QUAD_EASING)

/obj/cosmic_cult/vfx/shockwave/Destroy()
	clear_vis_contents()
	QDEL_NULL_LIST(layers)
	return ..()

/obj/cosmic_cult/vfx/shockwave/proc/smoothstep(a, b, x)
	var/t = clamp((x - a) / (b - a), 0, 1)
	return t * t * (3 - 2 * t)

/obj/cosmic_cult/vfx/shockwave/proc/out_cubic(x)
	return 1 - (1 - x) ** 3

/obj/cosmic_cult/vfx/shockwave/proc/radius_at(t)
	return radius * out_cubic(SHOCKWAVE_GROWTH * t) / out_cubic(SHOCKWAVE_GROWTH)

/obj/cosmic_cult/vfx/shockwave/proc/time_at(r)
	return (1 - (1 - r / radius * out_cubic(SHOCKWAVE_GROWTH)) ** (1 / 3)) / SHOCKWAVE_GROWTH

/obj/cosmic_cult/vfx/shockwave/proc/add_layer(state, layer, inset, alpha)
	if (inset >= radius)
		return
	var/obj/cosmic_cult/shockwave_layer/disk = new(state, layer, alpha)
	layers += disk
	add_vis_contents(disk)

	var/tile_scale = world.icon_size / 128
	var/previous = time_at(inset)
	var/started = FALSE
	if (previous > 0)
		animate(disk, time = previous * duration)
		started = TRUE
	for (var/i = 1 to SHOCKWAVE_SEGMENTS)
		var/t = (i / SHOCKWAVE_SEGMENTS) ** 2
		if (t <= previous)
			continue
		var/matrix/scale = matrix().Scale((radius_at(t) - inset) * tile_scale)
		if (started)
			animate(transform = scale, time = (t - previous) * duration)
		else
			animate(disk, transform = scale, time = (t - previous) * duration)
			started = TRUE
		previous = t
	return disk


/obj/cosmic_cult/shockwave_layer
	icon = 'icons/coscult/shockwave.dmi'
	plane = SHOCKWAVE_EFFECT_PLANE
	appearance_flags = NO_CLIENT_COLOR
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	pixel_x = -112
	pixel_y = -112
	transform = matrix(0, 0, 0, 0, 0, 0)

/obj/cosmic_cult/shockwave_layer/New(state, layer, alpha)
	..()
	src.icon_state = state
	src.layer = layer
	src.alpha = 255 * alpha

/proc/cosmic_cult_shockwave_vfx(target)
	new /obj/cosmic_cult/vfx/shockwave(get_turf(target))

#undef SHOCKWAVE_GROWTH
#undef SHOCKWAVE_SEGMENTS
