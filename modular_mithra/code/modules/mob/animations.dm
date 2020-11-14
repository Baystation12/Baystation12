/atom/movable/proc/do_pickup_animation(atom/target, atom/old_loc)
	set waitfor = FALSE
	if (QDELETED(src))
		return
	if (QDELETED(target))
		return
	if (QDELETED(old_loc))
		return

	var/turf/old_turf = get_turf(old_loc)
	var/image/I = image(icon = src, loc = old_turf)
	I.plane = DEFAULT_PLANE ////might cause issues later on.
	I.layer = ABOVE_HUMAN_LAYER
	I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	if (istype(target,/mob))
		I.dir = target.dir

	if (istype(old_loc,/obj/item/weapon/storage))
		I.pixel_x += old_loc.pixel_x
		I.pixel_y += old_loc.pixel_y

	var/list/viewing = list()
	for (var/mob/M in viewers(target))
		if (M.client)
			viewing |= M.client
	flick_overlay(I, viewing, 7)

	var/matrix/M = new
	M.Turn(pick(30, -30))

	animate(I, transform = M, time = 1)
	sleep(1)
	animate(I, transform = matrix(), time = 1)
	sleep(1)

	var/to_x = (target.x - old_turf.x) * 32
	var/to_y = (target.y - old_turf.y) * 32

	animate(I, pixel_x = to_x, pixel_y = to_y, time = 3, transform = matrix() * 0, easing = CUBIC_EASING)
	sleep(3)

/atom/movable/proc/do_putdown_animation(atom/target, mob/user)
	if (QDELETED(src))
		return
	if (QDELETED(target))
		return
	if (QDELETED(user))
		return
	var/old_invisibility = invisibility // I don't know, it may be used.
	invisibility = 100
	var/turf/old_turf = get_turf(user)
	if (QDELETED(old_turf))
		return
	var/image/I = image(icon = src, loc = old_turf, layer = layer + 0.1)
	I.plane = DEFAULT_PLANE //might cause issues later on.
	I.layer = ABOVE_HUMAN_LAYER
	I.transform = matrix() * 0
	I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	I.pixel_x = 0
	I.pixel_y = 0
	if (istype(target,/mob))
		I.dir = target.dir

	var/list/viewing = list()
	for (var/mob/M in viewers(target))
		if (M.client)
			viewing |= M.client
	flick_overlay(I, viewing, 4)

	var/to_x = (target.x - old_turf.x) * 32 + pixel_x
	var/to_y = (target.y - old_turf.y) * 32 + pixel_y
	var/old_x = pixel_x
	var/old_y = pixel_y
	pixel_x = 0
	pixel_y = 0

	animate(I, pixel_x = to_x, pixel_y = to_y, time = 3, transform = matrix(), easing = CUBIC_EASING)
	sleep(3)
	if (QDELETED(src))
		return
	invisibility = old_invisibility
	pixel_x = old_x
	pixel_y = old_y