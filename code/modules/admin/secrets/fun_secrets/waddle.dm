/datum/admin_secret_item/fun_secret/waddle
	name = "Toggle Waddling"
	var/waddling = FALSE

/datum/admin_secret_item/fun_secret/waddle/do_execute(mob/user)
	waddling = !waddling
	if(waddling)
		GLOB.moved_event.register_global(src, src::waddle())
	else
		GLOB.moved_event.unregister_global(src, src::waddle())

/datum/admin_secret_item/fun_secret/waddle/proc/waddle(atom/movable/AM)
	var/mob/living/L = AM
	if(!istype(L) || L.incapacitated() || L.lying)
		return
	animate(L, pixel_z = 4, time = 0)
	animate(
		pixel_z = 0,
		transform = matrix().Update(rotation = pick(-12, 0, 12)),
		time = 2
	)
	animate(pixel_z = 0, transform = matrix(), time = 0)
