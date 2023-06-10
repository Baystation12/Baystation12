/datum/bubble_effect
	var/center_x
	var/center_y
	var/z
	var/radius
	var/soft_radius
	var/delta
	var/list/seen
	var/list/cache


/datum/bubble_effect/Destroy()
	LAZYCLEARLIST(seen)
	LAZYCLEARLIST(cache)
	return ..()


/datum/bubble_effect/New(center_x, center_y, z, initial_radius, delta, datum/bubble_effect/parent)
	src.center_x = center_x
	src.center_y = center_y
	src.z = z
	soft_radius = initial_radius
	src.delta = delta
	if (istype(parent))
		if (!parent.cache)
			parent.cache = list()
			cache = parent.cache
			seen = parent.seen
	else
		seen = list()


/datum/bubble_effect/proc/Tick()
	soft_radius += delta
	var/new_radius = round(soft_radius, 1)
	if (new_radius == radius)
		return radius
	radius = new_radius
	var/list/coords
	if (cache && length(cache))
		coords = cache["[radius]"]
	if (!coords)
		coords = get_circle_coordinates(radius, center_x, center_y) - seen
		if (cache)
			cache["[radius]"] = coords
	seen += coords
	var/maxx = world.maxx
	var/maxy = world.maxy
	for (var/entry in coords)
		var/x = entry & 0xFFF
		var/y = SHIFTR(entry, 12)
		if (x < 1 || x > maxx)
			continue
		if (y < 1 || y > maxy)
			continue
		var/turf/turf = locate(x, y, z)
		if (!turf)
			continue
		if (TurfEffect(turf))
			return radius
	return radius


/datum/bubble_effect/proc/TurfEffect(turf/turf)
	return
