/atom/movable/proc/set_glide_size(glide_size_override = 0, min = 0.9, max = world.icon_size/2)
	if (!glide_size_override || glide_size_override > max)
		glide_size = 0
	else
		glide_size = max(min, glide_size_override)

	for (var/atom/movable/AM in contents)
		AM.set_glide_size(glide_size, min, max)


/proc/step_glide(atom/movable/am, dir, glide_size_override)
	am.set_glide_size(glide_size_override)
	return step(am, dir)
