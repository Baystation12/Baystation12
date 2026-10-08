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
