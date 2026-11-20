/obj/cosmic_cult/vfx/monument_projectile
	icon = 'icons/coscult/monument-vfx-alt.dmi'
	icon_state = "vfx"
	plane = EFFECTS_ABOVE_LIGHTING_PLANE
	layer = ABOVE_ABOVE_LIGHTING_LAYER

/proc/cosmic_cult_monument_projectile(atom/origin, atom/target)
	var/obj/cosmic_cult/vfx/effect = new /obj/cosmic_cult/vfx/monument_projectile(origin.loc)

	var/turf/source = get_turf(origin)
	var/turf/dest = get_turf(target)
	var/dx = dest.x - source.x
	var/dy = dest.y - source.y - 1.55

	var/angle = arctan(dx, dy)
	var/sweep = angle + 90
	effect.pixel_y += 1.55 * world.icon_size
	effect.transform = matrix().Scale(0.1)

	animate(effect, time = 0.5 SECONDS, flags = ANIMATION_PARALLEL)
	animate(pixel_x = effect.pixel_x + dx * world.icon_size, pixel_y = effect.pixel_y + dy * world.icon_size, time = 1 SECOND, easing = EASE_IN | CUBIC_EASING)

	animate(effect, transform = matrix().Scale(1), time = 1 SECOND, easing = EASE_OUT | CIRCULAR_EASING, flags = ANIMATION_PARALLEL)
	animate(transform = matrix().Scale(0.611).Turn(-sweep * 0.286), time = 0.35 SECONDS)
	animate(transform = matrix().Scale(0.5).Turn(-sweep * 0.564), time = 0.1 SECONDS)
	animate(transform = matrix().Scale(0.617).Turn(-sweep), time = 0.05 SECONDS)
	animate(transform = matrix().Scale(1.25).Turn(-sweep), time = 0.45 SECONDS, easing = EASE_OUT | SINE_EASING)

	animate(effect, time = 1.5 SECONDS, flags = ANIMATION_PARALLEL)
	animate(alpha = 0, time = 0.5 SECONDS, easing = EASE_OUT | SINE_EASING)
