/mob/proc/GetCablePlacementHandler()
	RETURN_TYPE(/datum/click_handler/default/cable)
	if (!click_handlers)
		return null
	return get_instance_of_strict_type(click_handlers, /datum/click_handler/default/cable)


/datum/action/item_action/cable

/datum/action/item_action/cable/Grant(mob/living/T)
	var/obj/item/stack/cable_coil/coil = target
	if (!istype(coil) || !coil.IsHeldBy(T))
		if (owner)
			Remove(owner)
		return
	return ..()


/datum/action/item_action/cable/UpdateName()
	return "[owner?.GetCablePlacementHandler() ? "Disable" : "Enable"] Advanced Wire Placement"


/**
 * 9   1   5
 *   \ | /
 * 8 - 0 - 4
 *   / | \
 * 10  2   6
 */
/proc/get_cable_dir_from_click(list/click_params)
	if (!length(click_params) || !click_params[MOUSE_ICON_X] || !click_params[MOUSE_ICON_Y])
		return 0
	var/mouse_x = text2num(click_params[MOUSE_ICON_X])
	var/mouse_y = text2num(click_params[MOUSE_ICON_Y])
	if (isnull(mouse_x) || isnull(mouse_y))
		return 0
	mouse_x -= 1
	mouse_y -= 1
	. = 0
	switch (mouse_y)
		if (-INFINITY to 10)
			. |= SOUTH
		if (22 to INFINITY)
			. |= NORTH
	switch (mouse_x)
		if (-INFINITY to 10)
			. |= WEST
		if (22 to INFINITY)
			. |= EAST


/datum/click_handler/default/cable
	flags = CLICK_HANDLER_REMOVE_ON_MOB_LOGOUT

	var/turf/anchor_turf
	var/anchor_dir = 0
	var/image/ghost
	var/turf/hover_turf
	var/hover_dir = 0
	var/catcher_shown = FALSE


/datum/click_handler/default/cable/New(mob/user)
	..()
	GLOB.mob_equipped_event.register(user, src, PROC_REF(OnLoadoutChanged))
	GLOB.mob_unequipped_event.register(user, src, PROC_REF(OnLoadoutChanged))
	GLOB.logged_in_event.register(user, src, PROC_REF(OnLoadoutChanged))
	GLOB.hands_swapped_event.register(user, src, PROC_REF(OnHandsSwapped))


/datum/click_handler/default/cable/Destroy()
	if (user)
		GLOB.mob_equipped_event.unregister(user, src, PROC_REF(OnLoadoutChanged))
		GLOB.mob_unequipped_event.unregister(user, src, PROC_REF(OnLoadoutChanged))
		GLOB.logged_in_event.unregister(user, src, PROC_REF(OnLoadoutChanged))
		GLOB.hands_swapped_event.unregister(user, src, PROC_REF(OnHandsSwapped))
	HideCatcher()
	ClearAnchor()
	return ..()


/datum/click_handler/default/cable/Enter()
	. = ..()
	UpdateCatcher()


/datum/click_handler/default/cable/Exit()
	HideCatcher()
	ClearAnchor()
	return ..()


/datum/click_handler/default/cable/proc/OnLoadoutChanged()
	UpdateCatcher()


/datum/click_handler/default/cable/proc/OnHandsSwapped()
	// defer to end of tick since the actual hand swap happens after event is fired
	spawn(0)
		if (!QDELETED(src))
			UpdateCatcher()


/datum/click_handler/default/cable/OnClick(atom/A, params)
	if (user.incapacitated())
		return
	var/obj/item/stack/cable_coil/coil = user.get_active_hand()
	if (!istype(coil))
		ClearAnchor()
		UpdateCatcher()
		return ..()

	if (!isturf(A) && !istype(A, /obj/structure/cable))
		return ..()

	var/turf/simulated/target = get_turf(A)
	// pass thru multiz
	if (!istype(target) || target.is_open())
		ClearAnchor()
		return ..()

	// pass thru modifier key clicks, i.e. examine
	var/list/click_params = params2list(params)
	if (click_params[MOUSE_CTRL] || click_params[MOUSE_ALT] || click_params[MOUSE_SHIFT] || click_params[MOUSE_3])
		return ..()

	var/cell = get_cable_dir_from_click(click_params)

	if (anchor_turf != target)
		SetAnchor(target, cell, coil)
		return

	if (cell == anchor_dir)
		ClearAnchor()
		return

	if (coil.PlaceCableBetween(target, user, anchor_dir, cell))
		ClearAnchor()
		UpdateCatcher()


/datum/click_handler/default/cable/proc/SetAnchor(turf/simulated/target, cell, obj/item/stack/cable_coil/coil)
	ClearAnchor()
	if (!target.can_build_cable(user) || !coil.CanPlaceCableOnTurf(target, user))
		return
	anchor_turf = target
	anchor_dir = cell
	UpdateGhost()


/datum/click_handler/default/cable/proc/ClearAnchor()
	anchor_turf = null
	anchor_dir = 0
	UpdateGhost()


/datum/click_handler/default/cable/proc/UpdateCatcher()
	if (!user?.client || user.GetClickHandler() != src || !istype(user.get_active_hand(), /obj/item/stack/cable_coil))
		HideCatcher()
		ClearAnchor()
		return
	if (catcher_shown)
		return
	user.client.screen |= GLOB.cable_catchers
	catcher_shown = TRUE


/datum/click_handler/default/cable/proc/HideCatcher()
	if (catcher_shown && user?.client)
		user.client.screen -= GLOB.cable_catchers
	catcher_shown = FALSE
	hover_turf = null
	hover_dir = 0
	UpdateGhost()


/datum/click_handler/default/cable/proc/OnCatcherMouseMove(obj/screen/cable_catcher/catcher, params)
	if (!catcher_shown)
		return
	var/turf/target = catcher.GetCaughtTurf(user)
	var/cell = get_cable_dir_from_click(params2list(params))
	if (hover_turf == target && hover_dir == cell)
		return
	hover_turf = target
	hover_dir = cell
	UpdateGhost()


/datum/click_handler/default/cable/proc/CanPreviewOn(turf/target)
	var/turf/simulated/simulated_target = target
	if (!istype(simulated_target) || simulated_target.is_open() || !simulated_target.is_plating())
		return FALSE
	return user.Adjacent(simulated_target)


/datum/click_handler/default/cable/proc/UpdateGhost()
	if (!user?.client)
		DropGhost()
		return

	var/turf/preview_turf
	var/preview_state

	if (anchor_turf)
		preview_turf = anchor_turf
		if (hover_turf == anchor_turf && hover_dir != anchor_dir)
			preview_state = "[min(anchor_dir, hover_dir)]-[max(anchor_dir, hover_dir)]"
		else if (anchor_dir)
			preview_state = "0-[anchor_dir]"
	else if (hover_turf && CanPreviewOn(hover_turf))
		preview_turf = hover_turf
		if (hover_dir)
			preview_state = "0-[hover_dir]"

	if (!preview_turf)
		DropGhost()
		return
	if (!preview_state)
		preview_state = "knot"
	else if (preview_state == "0-1")
		// hack, but 0-1 dir is shifted weird compared to other knot-cables so i just made a hacky icon_state instead of fixing the existing one
		preview_state = "0-1__shifted"


	var/obj/item/stack/cable_coil/coil = user.get_active_hand()
	var/coil_color = istype(coil) ? coil.color : CABLE_COLOR_RED // just in case above fails... which what???

	if (!ghost)
		ghost = image('icons/obj/machines/power/power_cond_white.dmi', preview_turf, preview_state)
		ghost.appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_ALPHA | RESET_COLOR
		ghost.alpha = 128
		ghost.plane = DEFAULT_PLANE
		ghost.layer = ABOVE_EXPOSED_WIRE_LAYER
		user.client.images += ghost
	else
		ghost.loc = preview_turf
		ghost.icon_state = preview_state

	if (ghost.color != coil_color)
		ghost.color = coil_color
		ghost.filters = filter(type = "outline", size = 1, color = coil_color)


/datum/click_handler/default/cable/proc/DropGhost()
	if (!ghost)
		return
	user?.client?.images -= ghost
	ghost = null


/obj/screen/cable_catcher
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "click_catcher"
	plane = EFFECTS_ABOVE_LIGHTING_PLANE
	layer = CURSOR_CATCHER_LAYER
	alpha = 0
	mouse_opacity = MOUSE_OPACITY_PRIORITY
	globalscreen = TRUE

	var/offset_x = 0
	var/offset_y = 0


/obj/screen/cable_catcher/Destroy()
	SHOULD_CALL_PARENT(FALSE)
	return QDEL_HINT_LETMELIVE // cable catchers are shared so we shouldn't kill em


/obj/screen/cable_catcher/proc/GetCaughtTurf(mob/viewer)
	var/turf/origin = get_turf(viewer)
	return locate(clamp(origin.x + offset_x, 1, world.maxx), clamp(origin.y + offset_y, 1, world.maxy), origin.z)


/obj/screen/cable_catcher/Click(location, control, params)
	var/turf/target = GetCaughtTurf(usr)
	if (!target)
		return TRUE
	// stack coils in advanced mode
	var/obj/item/stack/cable_coil/loose_coil = locate() in target
	if (loose_coil)
		loose_coil.Click(location, control, params)
		return TRUE
	target.Click(location, control, params)
	return TRUE


/obj/screen/cable_catcher/MouseMove(location, control, params)
	var/datum/click_handler/default/cable/handler = usr.GetClickHandler()
	if (!istype(handler))
		return
	handler.OnCatcherMouseMove(src, params)


GLOBAL_LIST_INIT(cable_catchers)
	cable_catchers = list()
	var/obj/screen/cable_catcher/catcher
	// whole screen
	for (var/x = -7 to 7)
		for (var/y = -7 to 7)
			catcher = new
			catcher.offset_x = x
			catcher.offset_y = y
			catcher.screen_loc = "CENTER[x ? (x > 0 ? "+[x]" : "[x]") : ""],CENTER[y ? (y > 0 ? "+[y]" : "[y]") : ""]"
			cable_catchers += catcher
