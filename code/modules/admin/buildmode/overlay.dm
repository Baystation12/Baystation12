/datum/buildmode_overlay
	var/list/images = list()
	var/mob/user
	var/datum/build_mode/buildmode
	var/shown
	var/size

/datum/buildmode_overlay/New(mob/user, buildmode, icon_state)
	src.user = user
	src.buildmode = buildmode
	size = user.client.view
	if (!icon_state)
		icon_state = ""
	for (var/x = -size to size step 1)
		for (var/y = -size to size step 1)
			var/image/I = new('icons/turf/overlays.dmi', user, icon_state)
			I.appearance_flags = KEEP_APART|RESET_COLOR|RESET_ALPHA|RESET_TRANSFORM|NO_CLIENT_COLOR|KEEP_APART
			I.plane = EFFECTS_ABOVE_LIGHTING_PLANE
			I.pixel_x = x * 32
			I.pixel_y = y * 32
			images += I
	. = ..()

/datum/buildmode_overlay/Destroy()
	Hide()
	images = null
	buildmode = null
	user = null
	. = ..()

/datum/buildmode_overlay/proc/Show()
	if (shown || QDELETED(user?.client))
		return
	user.client.images += images
	shown = TRUE

/datum/buildmode_overlay/proc/Hide()
	if (!shown || QDELETED(user?.client))
		return
	user.client.images -= images
	shown = FALSE

/datum/buildmode_overlay/proc/TimerEvent()
	if (!shown || QDELETED(buildmode) || QDELETED(user?.client))
		return
	var/i = 1
	for (var/x = -size to size step 1)
		for (var/y = -size to size step 1)
			var/image/I = images[i++]
			var/turf/T = locate(user.x + x, user.y + y, user.z)
			if (T)
				I.alpha = 255
				ImmediateInvokeAsync(buildmode, /datum/build_mode/.proc/UpdateOverlay, I, T)
			else
				I.alpha = 0
