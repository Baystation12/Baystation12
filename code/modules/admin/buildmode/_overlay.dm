/datum/buildmode_overlay
	var/list/display_atoms = list()
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
			var/atom/movable/M = new
			M.mouse_opacity = 0
			M.icon = 'icons/turf/overlays.dmi'
			M.icon_state = icon_state
			M.screen_loc = "CENTER[x < 0 ? "-" : "+"][abs(x)],CENTER[y < 0 ? "-" : "+"][abs(y)]"
			M.appearance_flags = DEFAULT_APPEARANCE_FLAGS | KEEP_APART|RESET_COLOR|RESET_ALPHA|RESET_TRANSFORM|NO_CLIENT_COLOR|TILE_BOUND
			display_atoms += M
	. = ..()

/datum/buildmode_overlay/Destroy()
	Hide()
	display_atoms = null
	buildmode = null
	user = null
	. = ..()

/datum/buildmode_overlay/proc/Show()
	if (shown || QDELETED(user?.client))
		return
	user.client.screen += display_atoms
	shown = TRUE

/datum/buildmode_overlay/proc/Hide()
	if (!shown || QDELETED(user?.client))
		return
	user.client.screen -= display_atoms
	shown = FALSE

/datum/buildmode_overlay/proc/TimerEvent()
	if (!shown || QDELETED(buildmode) || QDELETED(user?.client))
		return
	var/i = 1
	for (var/x = -size to size step 1)
		for (var/y = -size to size step 1)
			var/atom/movable/M = display_atoms[i++]
			var/turf/T = locate(user.x + x, user.y + y, user.z)
			if (T)
				M.alpha = 255
				ImmediateInvokeAsync(buildmode, /datum/build_mode/.proc/UpdateOverlay, M, T)
			else
				M.alpha = 0
