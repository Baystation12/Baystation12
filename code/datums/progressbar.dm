
/datum/progressbar
	var/max_progress

/datum/progressbar/proc/update(progress)


/datum/progressbar/private
	var/mob/actor
	var/image/bar
	var/client/client
	var/visible
	var/shown

/datum/progressbar/private/Destroy()
	if (client && bar)
		client.images -= bar
	qdel(bar)
	. = ..()

/datum/progressbar/private/New(mob/actor, max_progress, atom/actee)
	actee = actee || actor
	if (!istype(actee))
		EXCEPTION("Invalid progressbar/private instance")
	src.actor = actor
	src.max_progress = max_progress
	client = actor.client
	visible = actor.get_preference_value(/datum/client_preference/show_progress_bar) == GLOB.PREF_SHOW
	if (!visible)
		return
	bar = image('icons/effects/progessbar.dmi', actee, "prog_bar_0", HUD_ABOVE_ITEM_LAYER)
	bar.appearance_flags = DEFAULT_APPEARANCE_FLAGS | APPEARANCE_UI_IGNORE_ALPHA
	bar.pixel_y = WORLD_ICON_SIZE
	bar.plane = HUD_PLANE

/datum/progressbar/private/update(progress)
	if (!visible || !actor || !actor.client)
		shown = FALSE
		return
	if (actor.client != client)
		if (client)
			client.images -= bar
			shown = FALSE
		client = actor.client
	progress = clamp(progress, 0, max_progress)
	bar.icon_state = "prog_bar_[round(progress * 100 / max_progress, 5)]"
	if (!shown)
		client.images += bar
		shown = TRUE


/datum/progressbar/public
	var/atom/movable/actor
	var/atom/movable/actee
	var/atom/movable/bar

/datum/progressbar/public/Destroy()
	if (actor && bar)
		actor.vis_contents -= bar
	qdel(bar)
	. = ..()

/datum/progressbar/public/New(atom/movable/actor, max_progress, atom/movable/actee)
	actee = actee || actor
	if (!istype(actee))
		EXCEPTION("Invalid progressbar/public instance")
	src.actor = actor
	src.max_progress = max_progress
	src.actee = actee
	bar = new()
	bar.mouse_opacity = 0
	bar.icon = 'icons/effects/progessbar.dmi'
	bar.icon_state = "prog_bar_0"
	bar.pixel_x = (actee.x - actor.x) * WORLD_ICON_SIZE
	bar.pixel_y = (actee.y - actor.y) * WORLD_ICON_SIZE + WORLD_ICON_SIZE
	bar.layer = ABOVE_HUMAN_LAYER
	actor.vis_contents += bar

/datum/progressbar/public/update(progress)
	if (!actor || !actee)
		return
	progress = clamp(progress, 0, max_progress)
	bar.icon_state = "prog_bar_[round(progress * 100 / max_progress, 5)]"
	bar.pixel_x = (actee.x - actor.x) * WORLD_ICON_SIZE
	bar.pixel_y = (actee.y - actor.y) * WORLD_ICON_SIZE + WORLD_ICON_SIZE
