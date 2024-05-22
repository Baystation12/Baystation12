/*
	Click code cleanup
	~Sayu
*/

// 1 decisecond click delay (above and beyond mob/next_move)
/mob/var/next_click = 0

/*
	Before anything else, defer these calls to a per-mobtype handler.  This allows us to
	remove istype() spaghetti code, but requires the addition of other handler procs to simplify it.

	Alternately, you could hardcode every mob's variation in a flat ClickOn() proc; however,
	that's a lot of code duplication and is hard to maintain.

	Note that this proc can be overridden, and is in the case of screen objects.
*/

/atom/Click(location, control, params) // This is their reaction to being clicked on (standard proc)
	var/list/L = params2list(params)
	var/dragged = L["drag"]
	if(dragged && !L[dragged])
		return

	var/datum/click_handler/click_handler = usr.GetClickHandler()
	click_handler.OnClick(src, params)

/atom/DblClick(location, control, params)
	var/datum/click_handler/click_handler = usr.GetClickHandler()
	click_handler.OnDblClick(src, params)


/**
 * Whether or not the atom should allow a mob to click things while inside it's contents.
 *
 * **Parameters**:
 * - `A` - The atom being clicked on.
 * - `params` (list) - The click parameters
 * - `user` - The mob performing the click action.
 *
 * Returns boolean.
 */
/atom/proc/allow_click_through(atom/A, params, mob/user)
	return FALSE

/turf/allow_click_through(atom/A, params, mob/user)
	return TRUE

/*
	Standard mob ClickOn()
	Handles exceptions: middle click, modified clicks, exosuit actions

	After that, mostly just check your state, check whether you're holding an item,
	check whether you're adjacent to the target, then pass off the click to whoever
	is recieving it.
	The most common are:
	* mob/UnarmedAttack(atom,adjacent) - used here only when adjacent, with no item in hand; in the case of humans, checks gloves
	* atom/resolve_attackby(item,user) - used only when adjacent
	* item/afterattack(atom,user,adjacent,params) - used for ranged; called when resolve_attackby returns FALSE.
	* mob/RangedAttack(atom,params) - used only ranged, only used for tk and laser eyes but could be changed
*/
/mob/proc/ClickOn(atom/A, params)

	if(world.time <= next_click) // Hard check, before anything else, to avoid crashing
		return

	next_click = world.time + 1

	var/list/modifiers = params2list(params)
	if (modifiers["ctrl"] && modifiers["alt"] && modifiers["shift"])
		if (CtrlAltShiftClickOn(A))
			return TRUE
	else if (modifiers["shift"] && modifiers["ctrl"])
		if (CtrlShiftClickOn(A))
			return TRUE
	else if (modifiers["ctrl"] && modifiers["alt"])
		if (CtrlAltClickOn(A))
			return TRUE
	else if (modifiers["shift"] && modifiers["alt"])
		if (AltShiftClickOn(A))
			return TRUE
	else if (modifiers["middle"])
		if (MiddleClickOn(A))
			return TRUE
	else if (modifiers["shift"])
		if (ShiftClickOn(A))
			return TRUE
	else if (modifiers["alt"])
		if (AltClickOn(A))
			return TRUE
	else if (modifiers["ctrl"])
		if (CtrlClickOn(A))
			return TRUE

	if(stat || paralysis || stunned || weakened || sleeping)
		return

	// Do not allow player facing change in fixed chairs
	if(!istype(buckled) || buckled.buckle_movable)
		face_atom(A) // change direction to face what you clicked on

	if(!canClick()) // in the year 2000...
		return

	if(restrained())
		setClickCooldown(10)
		RestrainedClickOn(A)
		return 1

	if(in_throw_mode)
		if(isturf(A) || isturf(A.loc))
			throw_item(A)
			trigger_aiming(TARGET_CAN_CLICK)
			return 1
		throw_mode_off()

	var/obj/item/W = get_active_hand()

	if(W == A) // Handle attack_self
		W.attack_self(src)
		trigger_aiming(TARGET_CAN_CLICK)
		if(hand)
			update_inv_l_hand(0)
		else
			update_inv_r_hand(0)
		return 1

	//Atoms on your person
	// A is your location but is not a turf; or is on you (backpack); or is on something on you (box in backpack); sdepth is needed here because contents depth does not equate inventory storage depth.
	var/sdepth = A.storage_depth(src)
	if((!isturf(A) && A == loc) || (sdepth != -1 && sdepth <= 1))
		if(W)
			var/resolved = W.resolve_attackby(A, src, modifiers)
			if(!resolved && A && W)
				W.afterattack(A, src, 1, modifiers) // 1 indicates adjacency
		else
			if(ismob(A)) // No instant mob attacking
				setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			UnarmedAttack(A, 1)

		trigger_aiming(TARGET_CAN_CLICK)
		return 1

	if(!loc.allow_click_through(A, modifiers, src)) // This is going to stop you from telekinesing from inside a closet, but I don't shed many tears for that
		return

	//Atoms on turfs (not on your person)
	// A is a turf or is on a turf, or in something on a turf (pen in a box); but not something in something on a turf (pen in a box in a backpack)
	sdepth = A.storage_depth_turf()
	if(isturf(A) || isturf(A.loc) || (sdepth != -1 && sdepth <= 1))
		if(A.Adjacent(src)) // see adjacent.dm
			if(W)
				// Return TRUE in resolve_attackby() to prevent afterattack() effects (when safely moving items for example)
				var/resolved = W.resolve_attackby(A,src, modifiers)
				if(!resolved && A && W)
					W.afterattack(A, src, 1, modifiers) // 1: clicking something Adjacent
			else
				if(ismob(A)) // No instant mob attacking
					setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
				UnarmedAttack(A, 1)

			trigger_aiming(TARGET_CAN_CLICK)
			return
		else // non-adjacent click
			if(W)
				W.afterattack(A, src, 0, modifiers) // 0: not Adjacent
			else
				RangedAttack(A, modifiers)

			trigger_aiming(TARGET_CAN_CLICK)
	return 1

/mob/proc/setClickCooldown(timeout)
	next_move = max(world.time + timeout, next_move)

/mob/proc/canClick()
	if(config.no_click_cooldown || next_move <= world.time)
		return 1
	return 0

// Default behavior: ignore double clicks, the second click that makes the doubleclick call already calls for a normal click
/mob/proc/DblClickOn(atom/A, params)
	return

/**
 * Called when the mob interacts with something it is adjacent to. For complex mobs, this includes interacting with an empty hand or empty module. Generally, this translates to `attack_hand()`, `attack_robot()`, etc.
 *
 * Exception: This is also called when telekinesis is used, even if not adjacent to the target.
 *
 * **Parameters**:
 * - `A` - The atom that was clicked on/interacted with.
 * - `proximity_flag` - Whether or not the mob was at range from the targeted atom. Generally, this is always `1` unless telekinesis was used, where this will be `0`. This is not currently passed to attack_hand, and is instead used in human click code to allow glove touches only at melee range.
 *
 * Returns boolean - Whether or not the mob was able to perform the interaction.
 */
/mob/proc/UnarmedAttack(atom/A, proximity_flag)
	return

/mob/living/UnarmedAttack(atom/A, proximity_flag)

	if(GAME_STATE < RUNLEVEL_GAME)
		to_chat(src, "You cannot attack people before the game has started.")
		return 0

	if(stat)
		return 0

	return 1

/*
	Ranged unarmed attack:

	This currently is just a default for all mobs, involving
	laser eyes and telekinesis.  You could easily add exceptions
	for things like ranged glove touches, spitting alien acid/neurotoxin,
	animals lunging, etc.
*/
/**
 * Called when a mob attmepts to interact with an object that it is not adjacent to. For complex mobs, this includes interacting with an empty hand or empty module.
 *
 * Exception: Telekinesis will call `UnarmedAttack([target], 0)` instead.
 *
 * **Parameters**:
 * - `A` - The atom that was clicked on/interacted with.
 * - `params` - List of click parameters. See BYOND's `CLick()` documentation.
 *
 * Returns boolean - Whether or not the mob was able to perform the interaction.
 */
/mob/proc/RangedAttack(atom/A, params)
	if(!length(mutations))
		return FALSE

	if((MUTATION_LASER in mutations) && a_intent == I_HURT)
		LaserEyes(A) // moved into a proc below
		return TRUE

/**
 * Called when a mob attempts to interact with an atom while handcuffed or otherwise restrained. Not currently used.
 *
 * **Parameters**:
 * - `A` - The atom that was clicked on/interacted with.
 */
/mob/proc/RestrainedClickOn(atom/A)
	return


/**
 * Called when a mob middle-clicks on an object. By default, this is used only as a hotkey to call `swap_hand()`.
 *
 * **Parameters**:
 * - `A` - The atom that was clicked on.
 *
 * Returns boolean. Whether or not the interaction was handled.
 */
/mob/proc/MiddleClickOn(atom/A)
	if (A.MiddleClick(src))
		return TRUE
	// [SIERRA-EDIT] - SSINPUT
	// swap_hand() // SIERRA-EDIT - ORIGINAL
	pointed(A)
	// [/SIERRA-EDIT]
	return TRUE

/atom/proc/MiddleClick(mob/M as mob)
	return FALSE


/**
 * Called when the mob shift+clicks on an atom. By default, this calls the targeted atom's `ShiftClick()` proc.
 *
 * **Parameters**:
 * - `A` - The atom that was clicked on.
 *
 * Returns boolean. Whether or not the interaction was handled.
 */
/mob/proc/ShiftClickOn(atom/A)
	return A.ShiftClick(src)

/**
 * Called when a mob shift+clicks on the atom. By default, this calls the examine proc chain.
 *
 * **Parameters**:
 * - `user` - The mob that clicked on the atom.
 *
 * Returns boolean. Whether or not the interaction was handled.
 */
/atom/proc/ShiftClick(mob/user)
	if (user.client && user.client.eye == user)
		examinate(user, src)
		return TRUE
	return FALSE

/**
 * Called when the mob ctrl+clicks on an atom. By default, this calls the targeted atom's `CtrlClick()` proc.
 *
 * **Parameters**:
 * - `A` - The atom that was clicked on.
 *
 * Returns boolean - Whether or not the action was handled.
 */
/mob/proc/CtrlClickOn(atom/A)
	return A.CtrlClick(src)

/**
 * Called when a mob ctrl+clicks on the atom. By default, this starts pulling a movable atom if adjacent.
 *
 * **Parameters**:
 * - `user` - The mob that clicked on the atom.
 *
 * Returns boolean - Whether or not the action was handled.
 */
/atom/proc/CtrlClick(mob/user)
	return FALSE

/atom/movable/CtrlClick(mob/user)
	if(Adjacent(user))
		user.start_pulling(src)
		return TRUE
	return ..()

/**
 * Called when the mob alt+clicks on an atom. By default, this calls the targeted atom's `on_click/alt` extension's `on_click()` proc, or the atom's `AltClick()` proc.
 *
 * **Parameters**:
 * - `A` - The atom that was clicked on.
 *
 * Returns boolean. Whether or not the interaction was handled.
 */
/mob/proc/AltClickOn(atom/A)
	var/datum/extension/on_click/alt = get_extension(A, /datum/extension/on_click/alt)
	return alt?.on_click(src) || A.AltClick(src)

/**
 * Called when a mob alt+clicks the atom. By default, this creates and populates the Turf panel, displaying all objects on the atom's turf.
 *
 * **Parameters**:
 * - `user` - The mob that clicked on the atom.
 *
 * Returns boolean - Whether or not the action was handled.
 */
/atom/proc/AltClick(mob/user)
	var/turf/T = get_turf(src)
	if(T && user.TurfAdjacent(T))
		if(user.listed_turf == T)
			user.listed_turf = null
		else
			user.listed_turf = T
			user.client.statpanel = "Turf"
		return TRUE
	return FALSE

/mob/proc/TurfAdjacent(turf/T)
	return T.AdjacentQuick(src)

/mob/observer/ghost/TurfAdjacent(turf/T)
	if(!isturf(loc) || !client)
		return FALSE

	return z == T.z && (get_dist(loc, T) <= get_view_size_x(client.view))

/**
 * Called when the mob ctrl+shift+clicks on an atom. By default, calls the atom's `CtrlShiftClick()` proc.
 *
 * **Parameters**:
 * - `A` - The atom that was clicked on.
 *
 * Returns boolean. Whether or not the interaction was handled.
 */
/mob/proc/CtrlShiftClickOn(atom/A)
	return A.CtrlShiftClick(src)

/**
 * Called when a mob ctrl+shift+clicks on the atom.
 *
 * **Parameters**:
 * - `user` - The mob that clicked on the atom.
 *
 * Returns boolean. Whether or not the interaction was handled.
 */
/atom/proc/CtrlShiftClick(mob/user)
	return FALSE

/**
 * Called when the mob ctrl+alt+clicks on an atom. By default, this calls the atom's `CtrlAltClick()` proc or calls the mob's `pointed()` proc.
 *
 * **Parameters**:
 * - `A` - The atom that was clicked on.
 *
 * Returns boolean. Whether or not the interaction was handled.
 */
/mob/proc/CtrlAltClickOn(atom/A)
	return A.CtrlAltClick(src) || pointed(A)

/**
 * Called when a mob ctrl+alt+clicks on the atom.
 *
 * **Parameters**:
 * - `user` - The mob that clicked on the atom.
 *
 * Returns boolean - Whather or not the interaction was handled.
 */
/atom/proc/CtrlAltClick(mob/user)
	return FALSE


/**
 * Called when the mob alt+shift+clicks on an atom. By default, this calls the atom's `AltShiftClick()` proc.
 *
 * **Parameters**:
 * - `A` - The atom that was clicked on.
 *
 * Returns boolean - Whether or not the interaction was handled.
 */
/mob/proc/AltShiftClickOn(atom/A)
	return A.AltShiftClick(src)


/**
 * Called when a mob alt+shift+clicks on the atom.
 *
 * **Parameters**:
 * - `user` - The mob that clicked on the atom.
 *
 * Returns boolean - Whether or not the interaction was handled.
 */
/atom/proc/AltShiftClick(mob/user)
	return FALSE


/**
 * Called when the mob ctrl+alt+shift+clicks on an atom. By default, this calls the atom's `CtrlAltShiftClick()` proc.
 *
 * **Parameters**:
 * - `A` - The atom that was clicked on.
 *
 * Returns boolean - Whether or not the interaction was handled.
 */
/mob/proc/CtrlAltShiftClickOn(atom/A)
	return A.CtrlAltShiftClick(src)


/**
 * Called when a mob ctrl+alt+shift+clicks on the atom.
 *
 * **Parameters**:
 * - `user` - The mob that clicked on the atom.
 *
 * Returns boolean - Whether or not the interaction was handled.
 */
/atom/proc/CtrlAltShiftClick(mob/user)
	return FALSE


/*
	Misc helpers

	Laser Eyes: as the name implies, handles this since nothing else does currently
	face_atom: turns the mob towards what you clicked on
*/
/mob/proc/LaserEyes(atom/A)
	return

/mob/living/LaserEyes(atom/A)
	setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	var/turf/T = get_turf(src)

	var/obj/item/projectile/beam/LE = new (T)
	LE.icon = 'icons/effects/genetics.dmi'
	LE.icon_state = "eyelasers"
	playsound(usr.loc, 'sound/weapons/taser2.ogg', 75, 1)
	LE.launch(A)
/mob/living/carbon/human/LaserEyes()
	if(nutrition>0)
		..()
		adjust_nutrition(-(rand(1,5)))
		handle_regular_hud_updates()
	else
		to_chat(src, SPAN_WARNING("You're out of energy! You need food!"))

// Simple helper to face what you clicked on, in case it should be needed in more than one place
/mob/proc/face_atom(atom/A)
	if(!A || !x || !y || !A.x || !A.y) return
	var/dx = A.x - x
	var/dy = A.y - y
	if(!dx && !dy) return

	var/direction
	if(abs(dx) < abs(dy))
		if(dy > 0)	direction = NORTH
		else		direction = SOUTH
	else
		if(dx > 0)	direction = EAST
		else		direction = WEST
	if(direction != dir)
		facedir(direction)

GLOBAL_LIST_INIT(click_catchers, create_click_catcher())

/obj/screen/click_catcher
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "click_catcher"
	plane = CLICKCATCHER_PLANE
	mouse_opacity = 2
	screen_loc = "CENTER-7,CENTER-7"

/obj/screen/click_catcher/Destroy()
	SHOULD_CALL_PARENT(FALSE)
	return QDEL_HINT_LETMELIVE

/proc/create_click_catcher()
	RETURN_TYPE(/list)
	. = list()
	for(var/i = 0, i<15, i++)
		for(var/j = 0, j<15, j++)
			var/obj/screen/click_catcher/CC = new()
			CC.screen_loc = "NORTH-[i],EAST-[j]"
			. += CC

/obj/screen/click_catcher/Click(location, control, params)
	var/list/modifiers = params2list(params)
	if(modifiers["middle"] && istype(usr, /mob/living/carbon))
		var/mob/living/carbon/C = usr
		C.swap_hand()
	else
		var/turf/T = screen_loc2turf(screen_loc, get_turf(usr))
		if(T)
			T.Click(location, control, params)
	. = 1

/client/MouseDown(object, location, control, params)
	var/delay = mob.CanMobAutoclick(object, location, params)
	if(delay)
		selected_target[1] = object
		selected_target[2] = params
		while(selected_target[1])
			Click(selected_target[1], location, control, selected_target[2])
			sleep(delay)

/client/MouseUp(object, location, control, params)
	selected_target[1] = null

/client/MouseDrag(src_object,atom/over_object,src_location,over_location,src_control,over_control,params)
	if(selected_target[1] && over_object.IsAutoclickable())
		selected_target[1] = over_object
		selected_target[2] = params

/mob/proc/CanMobAutoclick(object, location, params)
	return

/mob/living/carbon/CanMobAutoclick(atom/object, location, params)
	if(!object.IsAutoclickable())
		return
	var/obj/item/h = get_active_hand()
	if(h)
		. = h.CanItemAutoclick(object, location, params)

/obj/item/proc/CanItemAutoclick(object, location, params)
	return

/obj/item/gun/CanItemAutoclick(object, location, params)
	return can_autofire

/obj/item/gun/CanItemAutoclick(object, location, params)
	return can_autofire

/atom/proc/IsAutoclickable()
	return TRUE

/obj/screen/IsAutoclickable()
	return FALSE

/obj/screen/click_catcher/IsAutoclickable()
	return TRUE
