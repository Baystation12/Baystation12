/obj/cosmic_cult/vfx/monument_icon
	icon = 'icons/coscult/cosmic-actions.dmi'
	icon_state = "vfx"
	plane = EFFECTS_ABOVE_LIGHTING_PLANE
	layer = ABOVE_LIGHTING_LAYER
	duration = 5 SECONDS

/proc/cosmic_cult_monument_influence_icon(atom/target, datum/power/cosmic_cult/influence)
	var/obj/cosmic_cult/vfx/effect = new /obj/cosmic_cult/vfx/monument_icon(target.loc)

	effect.icon_state = influence.ability_icon_state
	effect.pixel_y += 0.95 * world.icon_size
	effect.transform = matrix().Scale(0.1)
	effect.alpha = 0

	animate(effect, time = 2 SECONDS, flags = ANIMATION_PARALLEL)
	animate(pixel_y = effect.pixel_y + 0.5 * world.icon_size, time = 2 SECONDS, easing = QUAD_EASING)

	animate(effect, time = 0.65 SECONDS, flags = ANIMATION_PARALLEL)
	animate(transform = matrix(), time = 1.55 SECONDS, easing = ELASTIC_EASING | EASE_IN | EASE_OUT)

	animate(effect, time = 1.5 SECONDS, flags = ANIMATION_PARALLEL)
	animate(alpha = 255, time = 0.75 SECONDS)
	animate(alpha = 0, time = 0.75 SECONDS, easing = EASE_OUT | SINE_EASING)
