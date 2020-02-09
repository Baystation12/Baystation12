#define PROGRESSBAR_HEIGHT 6

/datum/progressbar
	var/goal = 1
	var/image/bar
	var/shown = 0
	var/mob/user
	var/client/client
	var/listindex

/datum/progressbar/New(mob/user, goal_number, atom/target)
	. = ..()
	if(!target) target = user
	if(!istype(target))
		EXCEPTION("Invalid target given")
	if(goal_number)
		goal = goal_number
	bar = image('icons/effects/progessbar.dmi', target, "prog_bar_0", HUD_ABOVE_ITEM_LAYER)
	bar.alpha = 0
	bar.plane = HUD_PLANE
	bar.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	src.user = user
	if(user)
		client = user.client

	LAZYINITLIST(user.progressbars)
	LAZYINITLIST(user.progressbars[bar.loc])
	var/list/bars = user.progressbars[bar.loc]
	LAZYADD(bars, src)
	listindex = bars.len
	animate(bar, pixel_y = 32 + (PROGRESSBAR_HEIGHT * (listindex - 1)), alpha = 255, time = 5, easing = SINE_EASING)

/datum/progressbar/Destroy()
	for(var/I in LAZYACCESS(user.progressbars, bar.loc))
		var/datum/progressbar/P = I
		if(P != src && P.listindex > listindex)
			P.shiftDown()

	var/list/bars = LAZYACCESS(user.progressbars, bar.loc)
	bars.Remove(src)
	if(!bars.len)
		LAZYREMOVE(user.progressbars, bar.loc)
	animate(bar, alpha = 0, time = 5)
	addtimer(CALLBACK(src, .proc/remove_self), 5)

/datum/progressbar/proc/remove_self()
	if(client)
		client.images -= bar
	QDEL_NULL(bar)

/datum/progressbar/proc/update(progress)
	if(!user || !user.client)
		shown = 0
		return
	if(user.client != client)
		if(client)
			client.images -= bar
		if(user.client)
			user.client.images += bar

	progress = Clamp(progress, 0, goal)
	bar.icon_state = "prog_bar_[round(((progress / goal) * 100), 5)]"
	if (!shown && user.get_preference_value(/datum/client_preference/show_progress_bar) == GLOB.PREF_SHOW)
		user.client.images += bar
		shown = 1

/datum/progressbar/proc/shiftDown()
	listindex--
	var/shiftheight = bar.pixel_y - PROGRESSBAR_HEIGHT
	animate(bar, pixel_y = shiftheight, time = 5, easing = SINE_EASING)

#undef PROGRESSBAR_HEIGHT
