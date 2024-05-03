/atom
	/// Integer. The atom's layering level. Primarily used for determining whether the atom is visible or not on certain tile/flooring types/layers (I.e. plating and non-plating).
	var/level = ATOM_LEVEL_OVER_TILE
	/// Bitflag (Any of `ATOM_FLAG_*`). General atom level flags. See `code\__defines\flags.dm`.
	var/atom_flags = ATOM_FLAG_NO_TEMP_CHANGE
	/// LAZYLIST of all DNA strings present on the atom from blood. Do not modify directly. See `add_blood()` and `clean_blood()`.
	var/list/blood_DNA
	/// Boolean. Whether or not the atom was bloodied at any point. This remains TRUE even when `is_bloodied` is set to FALSE, except in very specific circumstances. Used for luminol handling to detect cleaned blood.
	var/was_bloodied = FALSE
	/// Color. The color of the blood overlay effect, if present.
	var/blood_color
	/// Integer. The `world.time` the atom was last bumped into. Only used by some subtypes to prevent bump spamming.
	var/last_bumped = 0
	/// Bitflag (Any of `PASS_FLAG_*`). Flags indicating the types of dense objects this atom is able to pass through/over.
	var/pass_flags = EMPTY_BITFIELD
	/// Boolean. Whether or not thrown objects can pass through/over the atom.
	var/throwpass = FALSE
	/// Integer. The atom's current germ level. The higher the germ level, the more germ on the atom.
	var/germ_level = GERM_LEVEL_AMBIENT
	/// Boolean. Whether or not the atom is considered simulated. If `FALSE`, blocks a majority of interactions, processes, etc.
	var/simulated = TRUE
	/// Integer (One of `ATOM_FLOURESCENCE_*`). Whether or not the atom is visible under a UV light. If set to `2`, the atom is actively highlighted by a light. See `code\__defines\misc.dm`.
	var/fluorescent = ATOM_FLOURESCENCE_NONE
	/// The reagents contained within the atom. Handles all reagent interactions and processing.
	var/datum/reagents/reagents
	/// LAZYLIST of mobs currently climbing the atom.
	var/list/climbers
	/// Float. The multiplier applied to the `do_after()` timer when a mob climbs the atom.
	var/climb_speed_mult = 1
	/// Bitflag (Any of `INIT_*`). Flags for special/additional handling of the `Initialize()` chain. See `code\__defines\misc.dm`.
	var/init_flags = EMPTY_BITFIELD

	/// This atom's cache of non-protected overlays, used for normal icon additions. Do not manipulate directly- See SSoverlays.
	var/list/atom_overlay_cache

	/// This atom's cache of overlays that can only be removed explicitly, like C4. Do not manipulate directly- See SSoverlays.
	var/list/atom_protected_overlay_cache


/atom/New(loc, ...)
	SHOULD_CALL_PARENT(TRUE)
	if (GLOB.use_preloader && type == GLOB._preloader.target_path)
		GLOB._preloader.load(src)
	var/atom_init_stage = SSatoms.atom_init_stage
	var/list/init_queue = SSatoms.init_queue
	if (atom_init_stage > INITIALIZATION_INSSATOMS_LATE)
		args[1] = atom_init_stage == INITIALIZATION_INNEW_MAPLOAD
		if (SSatoms.InitAtom(src, args))
			return
	else if (init_queue)
		var/list/argument_list
		if (length(args) > 1)
			argument_list = args.Copy(2)
		if (argument_list || atom_init_stage == INITIALIZATION_INSSATOMS_LATE)
			init_queue[src] = argument_list
	if (atom_flags & ATOM_FLAG_CLIMBABLE)
		verbs += /atom/proc/climb_on
	..()


/**
 * Initialization handler for atoms. It is preferred to use this over `New()`.
 *
 * This is called after `New()` if the map is being loaded (`mapload` is `TRUE`), or called from the base of `New()` otherwise.
 *
 * All overrides should call parent or set the `ATOM_FLAG_INITIALIZED` flag and return a valid `INITIALIZE_HINT_*` value. All overrides must not sleep.
 *
 * **Parameters**:
 * - `mapload` - Whether or not the initialization was called while the map was being loaded.
 * - All parameters except `loc` are passed directly from `New()`.
 *
 * Returns int (One of `INITIALIZE_HINT_*`). Return hint indicates what should be done with the atom once the initialization process is finished. See `code\__defines\__initialization.dm`.
 */
/atom/proc/Initialize(mapload, ...)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	if(atom_flags & ATOM_FLAG_INITIALIZED)
		crash_with("Warning: [src]([type]) initialized multiple times!")
	atom_flags |= ATOM_FLAG_INITIALIZED

	if (IsAbstract())
		log_debug("Abstract atom [type] created!")
		return INITIALIZE_HINT_QDEL

	if(light_power && light_range)
		update_light()

	if(opacity)
		updateVisibility(src)
		var/turf/T = loc
		if(istype(T))
			T.recalc_atom_opacity()

	if (health_max)
		health_current = health_max
		health_dead = FALSE

	return INITIALIZE_HINT_NORMAL

/**
 * Late initialization handler.
 * Called after the `Initialize()` chain for any atoms that returned `INITIALIZE_HINT_LATELOAD`.
 * Primarily used for atoms that rely on initialized values from other atoms.
 *
 * **Parameters**:
 * - `mapload` - Whether or not the initialization was called while the map was being loaded.
 * - All parameters except `loc` are passed directly from `New()`.
 *
 * Has no return value.
 */
/atom/proc/LateInitialize(mapload, ...)
	return

/atom/Destroy()
	QDEL_NULL(reagents)
	QDEL_NULL(light)
	. = ..()

/**
 * Called when the atom is affected by luminol. Reveals blood present on the atom, or blood decal atoms.
 */
/atom/proc/reveal_blood()
	return

/**
 * Whether or not the atom is permitted to 'zoom' - I.e., binocular or scope handlers.
 *
 * Returns boolean.
 */
/atom/proc/MayZoom()
	return TRUE


/**
 * Handler for receiving gas.
 *
 * **Parameters**:
 * - `giver` - The gas mixture to receive gas from.
 */
/atom/proc/assume_air(datum/gas_mixture/giver)
	return null


/**
 * Removes air from the atom.
 *
 * **Parameters**:
 * - `amount` integer - The number of moles to remove.
 *
 * Returns instance of `/datum/gas_mixture`. The air that was removed from the atom.
 */
/atom/proc/remove_air(amount)
	return null

/**
 * Retrieves the atom's air contents. Used for subtypes that implement their own forms of air contents.
 *
 * Returns instance of `/datum/gas_mixture`.
 */
/atom/proc/return_air()
	if(loc)
		return loc.return_air()
	else
		return null

/**
 * Determines sight flags that should be added to user's sight var.
 *
 * Returns bitflag or `-1` to indicate the view should be cancelled.
 */
/atom/proc/check_eye(user as mob)
	if (istype(user, /mob/living/silicon/ai)) // WHYYYY
		return 0
	return -1


/**
 * Retrieves additional sight flags the atom may provide. Called on atoms contained in a mob's `additional_vision_handlers` list. See `/mob/proc/get_accumulated_vision_handlers()`.
 *
 * Returns bitflag (Any valid flag for `sight` - See DM reference).
 */
/atom/proc/additional_sight_flags()
	return 0


/**
 * Retrieves see invisible values the atom may provide. Called on atoms contained in a mob's `additional_vision_handlers` list. See `/mob/proc/get_accumulated_vision_handlers()`.
 *
 * Returns int.
 */
/atom/proc/additional_see_invisible()
	return 0

/**
 * Called whenever the contents of the atom's `reagents` changes.
 */
/atom/proc/on_reagent_change()
	return

/**
 * Handler for color changes related to transferred reagents. For atoms whos color is based on the contents of
 * `reagents`.
 */
/atom/proc/on_color_transfer_reagent_change()
	return

/**
 * Called when an object 'bumps' into the atom, typically by entering or attempting to enter the same tile.
 *
 * **Parameters**:
 * - `AM` - The atom that bumped into src.
 */
/atom/proc/Bumped(AM as mob|obj)
	return

/**
 * Whether or not the atom is considered an open container for chemistry handling.
 *
 * TODO: Redundant. Replace with flat bit check.
 *
 * Returns int (`ATOM_FLAG_OPEN_CONTAINER` or `0`).
 */
/atom/proc/is_open_container()
	return atom_flags & ATOM_FLAG_OPEN_CONTAINER


/**
 * Used to check if this atom blocks another atom's movement to the target turf. Called on all atom's in `mover`'s current location.
 *
 * **Parameters**:
 * - `mover` - The atom that's attempting to move.
 * - `target` - The detination turf `mover` is attempting to move to.
 *
 * Returns boolean. If `FALSE`, blocks movement and calls `mover.Bump(src)`.
 */
/atom/proc/CheckExit(atom/movable/mover, turf/target)
	return TRUE

/**
 * Called when an atom moves into 'proximity' (Currently, `range(1)`) of src. Only called on atoms that have the `MOVABLE_FLAG_PROXMOVE` flag in `movable_flags`.
 *
 * **Parameters**:
 * - `AM` - The movable atom triggering the call.
 */
/atom/proc/HasProximity(atom/movable/AM as mob|obj)
	return

/**
 * Called when the atom is affected by an EMP.
 *
 * **Parameters**:
 * - `severity` Integer. The strength of the EMP, ranging from 1 to 3. NOTE: Lower numbers are stronger.
 */
/atom/proc/emp_act(severity)
	SHOULD_CALL_PARENT(TRUE)
	if (get_max_health())
		// No hitsound here - Doesn't make sense for EMPs.
		// Generalized - 75-125 damage at max, 38-63 at medium, 25-42 at minimum severities.
		damage_health(rand(75, 125) / severity, DAMAGE_EMP, severity = severity)
	GLOB.empd_event.raise_event(src, severity)


/**
 * Sets the atom's density, raises the density set event, and updates turfs for dense atom checks.
 *
 * **Parameters**:
 * - `new_density` boolean - The new density value to set.
 */
/atom/proc/set_density(new_density)
	var/changed = density != new_density
	if(changed)
		density = !density
		if (isturf(loc))
			var/turf/T = loc
			if (density)
				T.has_dense_atom = TRUE
			else
				T.has_dense_atom = null
		GLOB.density_set_event.raise_event(src, !density, density)


/**
 * Called when a projectile impacts the atom.
 *
 * **Parameters**:
 * - `P` - The projectile impacting the atom.
 * - `def_zone` (string) - The targeting zone the projectile is hitting.
 *
 * Returns boolean. Whether or not the projectile should pass through the atom.
 */
/atom/proc/bullet_act(obj/item/projectile/P, def_zone)
	P.on_hit(src, 0, def_zone)
	. = 0
	if (get_max_health())
		var/damage = P.damage
		if (istype(src, /obj/structure) || istype(src, /turf/simulated/wall) || istype(src, /obj/machinery)) // TODO Better conditions for non-structures that want to use structure damage
			damage = P.get_structure_damage()
		if (!can_damage_health(damage, P.damage_type, P.damage_flags))
			return
		playsound(src, use_weapon_hitsound ? P.hitsound : damage_hitsound, 75)
		damage_health(damage, P.damage_type, P.damage_flags, skip_can_damage_check = TRUE)

/**
 * Determines whether or not the atom is in the contents of the container or an instance of container if provided as a
 * path.
 *
 * TODO: Only used once, and the usage is redundant. Replace with `istype(loc)` check.
 *
 * **Parameters**:
 * - `container` instance or path of `/atom`
 *
 * Returns boolean.
 */
/atom/proc/in_contents_of(container)//can take class or object instance as argument
	if(ispath(container))
		if(istype(src.loc, container))
			return 1
	else if(src in container)
		return 1
	return

/**
 * Recursively searches all atom contents for a given path.
 *
 * **Parameters**:
 * - `path` type path - The type path to search for.
 * - `filter_path` list (type paths) - Any paths provided here will not be searched if found during the recursive search.
 *
 * Returns list (Instances of `/atom`). All found matches.
 */
/atom/proc/search_contents_for(path,list/filter_path=null)
	var/list/found = list()
	for(var/atom/A in src)
		if(istype(A, path))
			found += A
		if(filter_path)
			var/pass = 0
			for(var/type in filter_path)
				pass |= istype(A, type)
			if(!pass)
				continue
		if(length(A.contents))
			found += A.search_contents_for(path,filter_path)
	return found

/**
 * Recursively searches containers for a given path, and returns the first match.
 */
/atom/proc/get_container(container_type)
	var/atom/A = src
	while (!istype(A, /area))
		if (istype(A.loc, container_type))
			return A.loc
		A = A.loc

/**
 * Called when a user examines the atom. This proc and its overrides handle displaying the text that appears in chat
 * during examines.
 *
 * Any overrides must either call parent, or return `TRUE`. There is no need to check the return value of `..()`, this
 * is only used by the calling `examinate()` proc to validate the call chain.
 *
 * For `infix` and `suffix`, generally, these are inserted at the beginning of the examine text, as:
 * `That's \a [name][infix]. [suffix]`.
 *
 * **Parameters**:
 * - `user` - The mob performing the examine.
 * - `distance` - The distance in tiles from `user` to `src`.
 * - `is_adjacent` - Whether `user` is adjacent to `src`.
 * - `infix` String - String that is appended immediately after the atom's name.
 * - `suffix` String - Additional string appended after the atom's name and infix.
 *
 * Returns boolean - The caller always expects TRUE
 *  This is used rather than SHOULD_CALL_PARENT as it enforces that subtypes of a type that explicitly returns still call parent
 */
/atom/proc/examine(mob/user, distance, is_adjacent, infix = "", suffix = "")
	//This reformat names to get a/an properly working on item descriptions when they are bloody
	var/f_name = "\a [src][infix]."
	if(blood_color && !istype(src, /obj/decal))
		if(gender == PLURAL)
			f_name = "some "
		else
			f_name = "a "
		f_name += "[SPAN_COLOR(blood_color, "stained")] [name][infix]!"

	to_chat(user, "[icon2html(src, user)] That's [f_name] [suffix]")
	to_chat(user, desc)
	if (get_max_health())
		examine_damage_state(user)

	if (IsFlameSource())
		to_chat(user, SPAN_DANGER("It has an open flame."))
	else if (distance <= 1 && IsHeatSource())
		to_chat(user, SPAN_WARNING("It's hot to the touch."))

	return TRUE

/// Works same as /atom/proc/Examine(), only this output comes immediately after any and all made by /atom/proc/Examine()
/atom/proc/LateExamine(mob/user, distance, is_adjacent)
	SHOULD_NOT_SLEEP(TRUE)

	user.ForensicsExamination(src, distance)
	return TRUE

/**
 * Called when a mob with this atom as their machine, pulledby, loc, buckled, or other relevant var atom attempts to move.
 */
/atom/proc/relaymove()
	return


/**
 * Sets the atom's direction and raises the dir set event.
 *
 * **Parameters**:
 * - new_dir direction - The new direction to set.
 *
 * Returns boolean. Whether or not the direction was changed.
 */
/atom/proc/set_dir(new_dir)
	var/old_dir = dir
	if(new_dir == old_dir)
		return FALSE
	dir = new_dir
	GLOB.dir_set_event.raise_event(src, old_dir, dir)

	//Lighting
	if(light_source_solo)
		if(light_source_solo.light_angle)
			light_source_solo.source_atom.update_light()
	else if(light_source_multi)
		var/datum/light_source/L
		for(var/thing in light_source_multi)
			L = thing
			if(L.light_angle)
				L.source_atom.update_light()

	return TRUE

/**
 * Sets the atom's icon state, also updating the base icon state extension if present. You should only use this proc if
 * you intend to permanently alter the base state.
 *
 * **Parameters**:
 * - `new_icon_state` icon state.
 */
/atom/proc/set_icon_state(new_icon_state)
	if(has_extension(src, /datum/extension/base_icon_state))
		var/datum/extension/base_icon_state/bis = get_extension(src, /datum/extension/base_icon_state)
		bis.base_icon_state = new_icon_state
		update_icon()
	else
		icon_state = new_icon_state

/**
 * Updates the atom's icon. You should call this to trigger icon updates, but should not override it. Override
 * `on_update_icon()` instead.
 *
 * If you're expecting to be calling a lot of icon updates at once, use `queue_icon_update()` instead.
 */
/atom/proc/update_icon()
	if (QDELETED(src))
		return
	on_update_icon(arglist(args))


/**
 * Handler for updating the atom's icon and overlay states. Generally, all changes to `overlays`, `underlays`, `icon`,
 * `icon_state`, `item_state`, etc should be contained in here.
 *
 * Do not call this directly. Use `update_icon()` or `queue_icon_update()` instead.
 */
/atom/proc/on_update_icon()
	return


/**
 * Called when an explosion affects the atom.
 *
 * **Parameters**:
 * - `severity` Integer (One of `EX_ACT_*`) - The strength of the explosion affecting the atom. NOTE: Lower numbers are
 * stronger.
 */
/atom/proc/ex_act(severity, turf_breaker)
	var/max_health = get_max_health()
	if (max_health)
		// No hitsound here to avoid noise spam.
		// Damage is based on severity and maximum health, with DEVASTATING being guaranteed death without any resistances.
		var/damage_flags = turf_breaker ? DAMAGE_FLAG_TURF_BREAKER : EMPTY_BITFIELD
		var/damage = 0
		switch (severity)
			if (EX_ACT_DEVASTATING)
				damage = round(max_health * (rand(100, 200) / 100)) // So that even atoms resistant to explosions may still be heavily damaged at this severity. Effective range of 100% to 200%.
			if (EX_ACT_HEAVY)
				damage = round(max_health * (rand(50, 100) / 100)) // Effective range of 50% to 100%.
			if (EX_ACT_LIGHT)
				damage = round(max_health * (rand(10, 50) / 100)) // Effective range of 10% to 50%.
		if (damage)
			damage_health(damage, DAMAGE_EXPLODE, damage_flags, severity)


/**
 * Handler for the effects of being emagged by a cryptographic sequencer. Other situations may also call this for
 * certain atoms, such as EMP'd or hacked machinery, or antagonist robots.
 *
 * **Parameters**:
 * - `remaining_charges` - The number of emag charges left on the atom used to perform the emag.
 * - `user` - The user performing the emag.
 * - `emag_source` - The atom used to perform the emag.
 *
 * Returns integer. The amount of emag charges to expend. If `NO_EMAG_ACT`, then emag interactions are skipped and the
 * emag will be passed on to other interaction checks.
 */
/atom/proc/emag_act(remaining_charges, mob/user, emag_source)
	return NO_EMAG_ACT

/**
 * Called when fire affects the atom.
 *
 * **Parameters**:
 * - `air` - Air contents of the turf that's on fire and affecting this atom. It could be from the current atom's turf
 * or an adjacent one.
 * - `exposed_temperature` - The temperature of the fire affecting the atom. Usually, this is `air.temperature`.
 * - `exposed_volume` - The volume of the air for the fire affecting the atom. Usually, this is `air.volume`.
 */
/atom/proc/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	var/melting_point = get_material_melting_point()
	if (get_max_health() && exposed_temperature > melting_point)
		// No hitsound here to avoid noise spam.
		// 1 point of damage for every 100 kelvin above 300 (~27 C), minimum of 1.
		damage_health(max(round((exposed_temperature - melting_point) / 100), 1), DAMAGE_FIRE)

/**
 * Handler for melting from heat or other sources. Called by terrain generation and some instances of `fire_act()` or
 * `lava_act()`.
 */
/atom/proc/melt()
	return

/**
 * Called when lava affects the atom. By default, this melts and deletes the atom.
 *
 * Returns boolean. Whether or not the atom was destroyed.
 */
/atom/proc/lava_act(datum/gas_mixture/air, temperature, pressure)
	if (is_damage_immune(DAMAGE_FIRE))
		return FALSE
	if (get_max_health())
		fire_act(air, temperature)
		if (!health_dead())
			return FALSE
	visible_message(SPAN_DANGER("\The [src] sizzles and melts away, consumed by the lava!"))
	playsound(src, 'sound/effects/flare.ogg', 100, 3)
	qdel(src)
	. = TRUE

/**
 * Called when the atom is hit by a thrown object.
 *
 * **Parameters**:
 * - `AM` - The atom impacting `src`.
 * - `TT` - The thrownthing datum associated with the impact.
 */
/atom/proc/hitby(atom/movable/AM, datum/thrownthing/TT)//already handled by throw impact
	if(isliving(AM) && !isturf(src)) // See `/turf/hitby()` for turf handling of mob impacts
		var/mob/living/M = AM
		M.apply_damage(TT.speed * 5, DAMAGE_BRUTE)

	if (get_max_health())
		var/damage = 0
		var/damage_type = DAMAGE_BRUTE
		var/damage_flags = EMPTY_BITFIELD
		var/damage_hitsound = src.damage_hitsound
		if (isobj(AM))
			var/obj/O = AM
			damage = O.throwforce
			damage_type = O.damtype
			if (use_weapon_hitsound && isitem(O))
				var/obj/item/I = O
				damage_hitsound = I.hitsound
		else if (ismob(AM))
			var/mob/M = AM
			damage = M.mob_size
		damage = damage * (TT.speed / THROWFORCE_SPEED_DIVISOR)
		if (!can_damage_health(damage, damage_type))
			playsound(src, damage_hitsound, 50)
			AM.visible_message(SPAN_NOTICE("\The [AM] bounces off \the [src] harmlessly."))
			return
		damage_health(damage, damage_type, damage_flags, skip_can_damage_check = TRUE)
		AM.visible_message(SPAN_WARNING("\The [AM] impacts \the [src], causing damage!"))


/**
 * Adds blood effects and DNA to the atom.
 *
 * **Parameters**:
 * - `M` - The mob the blood and DNA originated from.
 *
 * Returns boolean - `TRUE` if the atom was bloodied, `FALSE` otherwise.
 */
/atom/proc/add_blood(mob/living/carbon/human/M as mob)
	if(atom_flags & ATOM_FLAG_NO_BLOOD)
		return 0

	if(!blood_DNA || !istype(blood_DNA, /list))	//if our list of DNA doesn't exist yet (or isn't a list) initialise it.
		blood_DNA = list()

	was_bloodied = 1
	blood_color = COLOR_BLOOD_HUMAN
	if(istype(M))
		if (!istype(M.dna, /datum/dna))
			M.dna = new /datum/dna(null)
			M.dna.real_name = M.real_name
		M.check_dna()
		blood_color = M.species.get_blood_colour(M)
	. = 1
	return 1

/mob/living/proc/handle_additional_vomit_reagents(obj/decal/cleanable/vomit/vomit)
	vomit.reagents.add_reagent(/datum/reagent/acid/stomach, 5)

/**
 * Removes all blood, DNA, residue, germs, etc from the atom.
 *
 * Returns boolean. If `TRUE`, blood DNA was present and removed.
 */
/atom/proc/clean_blood()
	if(!simulated)
		return
	fluorescent = ATOM_FLOURESCENCE_NONE
	germ_level = 0
	blood_color = null
	gunshot_residue = null
	if(istype(blood_DNA, /list))
		blood_DNA = null
		return 1

/**
 * Retrieves the atom's x and y coordinates from the global map.
 *
 * TODO: Unused. Remove.
 *
 * Returns list ("x" and "y" values as integers), `null` if there is no global map, or `0` if the atom has no position
 * within the global map..
 */
/atom/proc/get_global_map_pos()
	if (!islist(GLOB.global_map) || !length(GLOB.global_map))
		return
	var/cur_x = null
	var/cur_y = null
	var/list/y_arr = null
	for(cur_x = 1 to length(GLOB.global_map))
		y_arr = GLOB.global_map[cur_x]
		cur_y = y_arr.Find(src.z)
		if(cur_y)
			break
//	log_debug("X = [cur_x]; Y = [cur_y]")

	if(cur_x && cur_y)
		return list("x"=cur_x,"y"=cur_y)
	else
		return 0

/**
 * Whether or not the atom allows the given passflag to pass through it.
 *
 * **Parameters**
 * `passflag` bitfield (Any of `PASS_FLAG_*`) - The passflag(s) to check.
 *
 * Returns bitfield (Any of `PASS_FLAG_*`). All matching bitflags provided in `passflag` that the atom allows to pass through, or `0` if the atom does not allow them.
 */
/atom/proc/checkpass(passflag)
	return pass_flags&passflag

/**
 * Whether or not the atom is in space.
 *
 * TODO: Redundant.
 *
 * Returns boolean.
 */
/atom/proc/isinspace()
	if(istype(get_turf(src), /turf/space))
		return 1
	else
		return 0


// Show a message to all mobs and objects in sight of this atom
// Use for objects performing visible actions
// message is output to anyone who can see, e.g. "The [src] does something!"
// blind_message (optional) is what blind people will hear e.g. "You hear something!"
/**
 * Shows a message to all atoms in sight of this item. Use for objects performing visible actions.
 *
 * **Parameters**:
 * - `message` string - The message to display.
 * - `blind_message` string - If set, this message is displayed to blind mobs in range.
 * - `range` int (Default `world.view`) - The range, in tiles, the message should display.
 * - `checkghosts` path (`/datum/client_preference`) - If set, will also display for ghosts with the provided preference
 * enabled. Typically, `ghost_sight`.
 * - `exclude_objs` LAZYLIST of instances of `/obj` - If provided, objects in this list will not be displayed the
 * message.
 * - `exclude_mobs` LAZYLIST of instances of `/mob` - Ig provided, mobs in this list will not be displayed the message.
 */
/atom/proc/visible_message(message, blind_message, range = world.view, checkghosts = null, list/exclude_objs = null, list/exclude_mobs = null)
	set waitfor = FALSE
	var/turf/T = get_turf(src)
	var/list/mobs = list()
	var/list/objs = list()
	get_mobs_and_objs_in_view_fast(T,range, mobs, objs, checkghosts)

	for(var/o in objs)
		var/obj/O = o
		if (length(exclude_objs) && (O in exclude_objs))
			exclude_objs -= O
			continue
		O.show_message(message, VISIBLE_MESSAGE, blind_message, AUDIBLE_MESSAGE)

	for(var/m in mobs)
		var/mob/M = m
		if (length(exclude_mobs) && (M in exclude_mobs))
			exclude_mobs -= M
			continue
		if(M.see_invisible >= invisibility)
			M.show_message(message, VISIBLE_MESSAGE, blind_message, AUDIBLE_MESSAGE)
		else if(blind_message)
			M.show_message(blind_message, AUDIBLE_MESSAGE)


/**
 * Shows a message to all mobs and objects within earshot of this atom. Use for objects performing audible actions.
 *
 * Calls `show_message()` on all valid mobs and objects in range.
 *
 * **Parameters**:
 * - `message` (string) - The message output to anyone who can hear.
 * - `deaf_message` (string) - The message output to anyone who is deaf.
 * - `hearing_distance` (int) - The range of the message in tiles.
 * - `checkghosts` (null or `/datum/client_preference/ghost_sight`) - If set, will also display to any ghosts with global ears turned on.
 * - `exclude_objs` - List of objects to not display the message to.
 * - `exclude_mobs` - List of mobs to not display the message to.
 */
/atom/proc/audible_message(message, deaf_message, hearing_distance = world.view, checkghosts = null, list/exclude_objs = null, list/exclude_mobs = null)
	var/turf/T = get_turf(src)
	var/list/mobs = list()
	var/list/objs = list()
	get_mobs_and_objs_in_view_fast(T, hearing_distance, mobs, objs, checkghosts)

	for(var/m in mobs)
		var/mob/M = m
		if (length(exclude_mobs) && (M in exclude_mobs))
			exclude_mobs -= M
			continue
		M.show_message(message,2,deaf_message,1)

	for(var/o in objs)
		var/obj/O = o
		if (length(exclude_objs) && (O in exclude_objs))
			exclude_objs -= O
			continue
		O.show_message(message,2,deaf_message,1)

/atom/movable/proc/dropInto(atom/destination)
	while(istype(destination))
		var/atom/drop_destination = destination.onDropInto(src)
		if(!istype(drop_destination) || drop_destination == destination)
			return forceMove(destination)
		destination = drop_destination
	return forceMove(null)

/**
 * Handler for items being dropped onto or into the atom. Called by `dropInto()`.
 *
 * **Parameters**:
 * - `AM` - The atom being dragged and dropped.
 *
 * Returns instance of `/atom` or `null`. The atom to `forceMove()` `AM` into. If `null`, assumes `src`.
 */
/atom/proc/onDropInto(atom/movable/AM)
	return

/atom/movable/onDropInto(atom/movable/AM)
	return loc

/**
 * Returns a list of contents that can be inserted and/or removed. By default, this simply returns `contents`.
 */
/atom/proc/InsertedContents()
	return contents

//all things climbable

/atom/attack_hand(mob/user)
	..()
	if(LAZYLEN(climbers) && !(user in climbers))
		user.visible_message(SPAN_WARNING("[user.name] shakes \the [src]."), \
					SPAN_NOTICE("You shake \the [src]."))
		object_shaken()

/**
 * Verb to allow climbing onto an object. Passes directly to `/atom/proc/do_climb(usr)`.
 */
/atom/proc/climb_on()

	set name = "Climb"
	set desc = "Climbs onto an object."
	set category = "Object"
	set src in oview(1)

	do_climb(usr)

/**
 * Whether or not a mob can climb this atom.
 *
 * If this check fails, it generally also sends a feedback message to `user`.
 *
 * **Parameters**:
 * - `user` - The mob attempting the climb check.
 * - `post_climb_check` boolean default `FALSE` - If set, skips checking the `climbers` list for if the mob is already attempting to climb.
 * - `check_silicon` boolean default `TRUE` - If set, blocks silicon mobs. Passed directly to `can_touch()`.
 *
 * Returns boolean.
 */
/atom/proc/can_climb(mob/living/user, post_climb_check=FALSE, check_silicon=TRUE)
	if (!(atom_flags & ATOM_FLAG_CLIMBABLE) || !can_touch(user, check_silicon) || (!post_climb_check && climbers && (user in climbers)))
		return 0

	if (!user.Adjacent(src))
		to_chat(user, SPAN_DANGER("You can't climb there, the way is blocked."))
		return 0

	var/obj/occupied = turf_is_crowded(user)
	//because Adjacent() has exceptions for windows, those must be handled here
	if(!occupied && istype(src, /obj/structure/wall_frame))
		var/original_dir = get_dir(src, user.loc)
		var/progress_dir = original_dir
		for(var/atom/A in loc.contents)
			if(A.atom_flags & ATOM_FLAG_CHECKS_BORDER)
				var/obj/structure/window/W = A
				if(istype(W))
					//progressively check if a window matches the X or Y component of the dir, if collision, set the dir bit off
					if(W.is_fulltile() || (progress_dir &= ~W.dir) == 0) //if dir components are 0, fully blocked on diagonal
						occupied = A
						break
		//if true, means one dir was blocked and bit set off, so check the unblocked
		if(progress_dir != original_dir && progress_dir != 0)
			var/turf/here = get_turf(src)
			if(!here.Adjacent_free_dir(user, progress_dir))
				to_chat(user, SPAN_DANGER("You can't climb there, the way is blocked."))
				return FALSE

	if(occupied)
		to_chat(user, SPAN_DANGER("There's \a [occupied] in the way."))
		return 0
	return 1

/**
 * Checks if a mob can perform certain physical interactions with the atom. Primarily used for climbing and flipping tables.
 *
 * If this check fails, it generally also sends a feedback mesage to `user`.
 *
 * **Parameters**:
 * - `user` - The mob attempting the interaction check.
 * - `check_silicon` boolean default `TRUE` - If set, blocks silicon mobs.
 *
 * Returns boolean.
 */
/atom/proc/can_touch(mob/user, check_silicon=TRUE)
	if (!user)
		return 0
	if(!Adjacent(user))
		return 0
	if (user.restrained() || user.buckled)
		to_chat(user, SPAN_NOTICE("You need your hands and legs free for this."))
		return 0
	if (user.incapacitated())
		return 0
	if (check_silicon && issilicon(user))
		to_chat(user, SPAN_NOTICE("You need hands for this."))
		return 0
	return 1

/**
 * Whether or not dense atoms exist on the same turf.
 *
 * **Parameters**:
 * - `ignore` - If set, this atom will be ignored during checks.
 *
 * Returns instance of `/atom` (The atom with density found on the turf) or `FALSE` (No dense atoms were found).
 */
/atom/proc/turf_is_crowded(atom/ignore)
	var/turf/T = get_turf(src)
	if(!istype(T))
		return 0
	for(var/atom/A in T.contents)
		if(ignore && ignore == A)
			continue
		if(A.atom_flags & ATOM_FLAG_CLIMBABLE)
			continue
		if(A.density && !(A.atom_flags & ATOM_FLAG_CHECKS_BORDER)) //ON_BORDER structures are handled by the Adjacent() check.
			return A
	return 0

/**
 * Handles climbing atoms for mobs. This proc includes a `do_after()` timer.
 *
 * **Parameters**:
 * - `user` - The mob attempting to climb the atom.
 * - `check_silicon` boolean (default `TRUE`) - Passed directly to `/atom/proc/can_climb()` - If set, will block silicon
 *     mobs.
 *
 * Returns boolean. Whether or not the mob successfully completed the climb action.
 */
/atom/proc/do_climb(mob/living/user, check_silicon=TRUE)
	if (!can_climb(user, check_silicon=check_silicon))
		return 0

	add_fingerprint(user)
	user.visible_message(SPAN_WARNING("\The [user] starts climbing onto \the [src]!"))
	LAZYDISTINCTADD(climbers,user)

	if(!do_after(user,(issmall(user) ? MOB_CLIMB_TIME_SMALL : MOB_CLIMB_TIME_MEDIUM) * climb_speed_mult, src, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_BAR_OVER_USER))
		LAZYREMOVE(climbers,user)
		return 0

	if(!can_climb(user, post_climb_check=1, check_silicon=check_silicon))
		LAZYREMOVE(climbers,user)
		return 0

	var/target_turf = get_turf(src)

	//climbing over border objects like railings
	if((atom_flags & ATOM_FLAG_CHECKS_BORDER) && get_turf(user) == target_turf)
		target_turf = get_step(src, dir)

	user.forceMove(target_turf)

	if (get_turf(user) == target_turf)
		user.visible_message(SPAN_WARNING("\The [user] climbs onto \the [src]!"))
	LAZYREMOVE(climbers,user)
	return 1

/**
 * Handler for atoms being moved, shaken, or otherwise interacted with in a manner that would affect atoms on top of if.
 */
/atom/proc/object_shaken()
	for(var/mob/living/M in climbers)
		M.Weaken(1)
		to_chat(M, SPAN_DANGER("You topple as you are shaken off \the [src]!"))
		climbers.Cut(1,2)

	for(var/mob/living/M in get_turf(src))
		if(M.lying) return //No spamming this on people.

		M.Weaken(3)
		to_chat(M, SPAN_DANGER("You topple as \the [src] moves under you!"))

		if(prob(25))

			var/damage = rand(15,30)
			var/mob/living/carbon/human/H = M
			if(!istype(H))
				to_chat(H, SPAN_DANGER("You land heavily!"))
				M.adjustBruteLoss(damage)
				return

			var/obj/item/organ/external/affecting
			var/list/limbs = BP_ALL_LIMBS //sanity check, can otherwise be shortened to affecting = pick(BP_ALL_LIMBS)
			if(length(limbs))
				affecting = H.get_organ(pick(limbs))

			if(affecting)
				to_chat(M, SPAN_DANGER("You land heavily on your [affecting.name]!"))
				affecting.take_external_damage(damage, 0)
				if(affecting.parent)
					affecting.parent.add_autopsy_data("Misadventure", damage)
			else
				to_chat(H, SPAN_DANGER("You land heavily!"))
				H.adjustBruteLoss(damage)

			H.UpdateDamageIcon()
			H.updatehealth()
	return

/atom/MouseDrop_T(mob/target, mob/user)
	var/mob/living/H = user
	if(istype(H) && can_climb(H) && target == user)
		do_climb(target)
		return TRUE
	else
		return ..()

/**
 * Returns the atom's current color or white if it has no color.
 */
/atom/proc/get_color()
	return isnull(color) ? COLOR_WHITE : color

/**
 * Handler for setting the atom's color.
 */
/atom/proc/set_color(color)
	src.color = color

/**
 * Retrieves the atom's power cell, if it has one.
 *
 * Returns instance of `/obj/item/cell` or `null`.
 */
/atom/proc/get_cell()
	return

/**
 * Called when a mob walks into the atom while confused.
 *
 * **Parameters**:
 * - `L` - The mob that walked into the atom.
 */
/atom/proc/slam_into(mob/living/L)
	L.Weaken(2)
	L.visible_message(SPAN_WARNING("\The [L] [pick("ran", "slammed")] into \the [src]!"))
	playsound(L, "punch", 25, 1, FALSE)


/atom/proc/create_bullethole(obj/item/projectile/Proj)
	var/p_x = Proj.p_x + rand(-8, 8)
	var/p_y = Proj.p_y + rand(-8, 8)
	var/obj/overlay/bmark/bullet_mark = new(src)

	bullet_mark.pixel_x = p_x
	bullet_mark.pixel_y = p_y

	// offset correction
	bullet_mark.pixel_x--
	bullet_mark.pixel_y--

	if(Proj.damage >= 50)
		bullet_mark.icon_state = "scorch"
		bullet_mark.set_dir(pick(NORTH,SOUTH,EAST,WEST)) // random scorch design
	else
		bullet_mark.icon_state = "light_scorch"

/atom/proc/clear_bulletholes()
	for(var/obj/overlay/bmark/bullet_mark in src)
		qdel(bullet_mark)

//this is for thermal imaging, anything that gets called with this should have its own special definition
/atom/proc/get_warmth()
	return //if this gets called without proper definition, it should runtime because you're not supposed to do this.
