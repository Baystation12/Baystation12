/turf
	icon = 'icons/turf/floors.dmi'
	level = ATOM_LEVEL_UNDER_TILE

	layer = TURF_LAYER

	var/turf_flags

	var/holy = 0

	// Initial air contents (in moles)
	var/list/initial_gas

	//Properties for airtight tiles (/wall)
	var/thermal_conductivity = 0.05
	var/heat_capacity = 1

	//Properties for both
	var/blocks_air = 0          // Does this turf contain air/let air through?

	// General properties.
	var/icon_old = null
	var/pathweight = 1          // How much does it cost to pathfind over this turf?
	var/blessed = 0             // Has the turf been blessed?

	var/list/decals

	var/movement_delay

	var/fluid_can_pass
	var/obj/effect/flood/flood_object
	var/fluid_blocked_dirs = 0
	var/flooded // Whether or not this turf is absolutely flooded ie. a water source.
	var/height = 0 // Determines if fluids can overflow onto next turf
	var/footstep_type

	var/changing_turf

	/// List of 'dangerous' objs that the turf holds that can cause something bad to happen when stepped on, used for AI mobs.
	var/list/dangerous_objects

	var/has_dense_atom
	var/has_opaque_atom

	/// Reference to the turf fire on the turf
	var/obj/effect/turf_fire/turf_fire

/turf/Initialize(mapload, ...)
	. = ..()
	if(dynamic_lighting)
		luminosity = 0
	else
		luminosity = 1

	RecalculateOpacity()

	if (mapload && permit_ao)
		queue_ao()

	if (z_flags & ZM_MIMIC_BELOW)
		setup_zmimic(mapload)

/turf/on_update_icon()
	update_flood_overlay()
	queue_ao(FALSE)

/turf/proc/update_flood_overlay()
	if(is_flooded(absolute = TRUE))
		if(!flood_object)
			flood_object = new(src)
	else if(flood_object)
		QDEL_NULL(flood_object)

/turf/Destroy()
	if (!changing_turf)
		crash_with("Improper turf qdel. Do not qdel turfs directly.")

	changing_turf = FALSE

	remove_cleanables(FALSE)
	fluid_update()
	REMOVE_ACTIVE_FLUID_SOURCE(src)

	if (ao_queued)
		SSao.queue -= src
		ao_queued = 0

	if (z_flags & ZM_MIMIC_BELOW)
		cleanup_zmimic()

	if (mimic_proxy)
		QDEL_NULL(mimic_proxy)

	..()
	return QDEL_HINT_LETMELIVE

/turf/proc/is_solid_structure()
	return 1

/turf/attack_hand(mob/user)
	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)

	if(user.restrained())
		return 0
	if (user.pulling)
		if(user.pulling.anchored || !isturf(user.pulling.loc))
			return 0
		if(user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1)
			return 0
		do_pull_click(user, src)

	.=handle_hand_interception(user)
	if (!.)
		return 1

/turf/proc/handle_hand_interception(mob/user)
	var/datum/extension/turf_hand/THE
	for (var/A in src)
		var/datum/extension/turf_hand/TH = get_extension(A, /datum/extension/turf_hand)
		if (istype(TH) && TH.priority > THE?.priority) //Only overwrite if the new one is higher. For matching values, its first come first served
			THE = TH

	if (THE)
		return THE.OnHandInterception(user)

/turf/attack_robot(mob/user)
	if(Adjacent(user))
		attack_hand(user)

/turf/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/storage))
		var/obj/item/storage/S = W
		if(S.use_to_pickup && S.collection_mode)
			S.gather_all(src, user)
	return ..()

/turf/Enter(atom/movable/mover as mob|obj, atom/forget as mob|obj|turf|area)

	..()

	if (!mover || !isturf(mover.loc) || isobserver(mover))
		return 1

	//First, check objects to block exit that are not on the border
	for(var/obj/obstacle in mover.loc)
		if(!(obstacle.atom_flags & ATOM_FLAG_CHECKS_BORDER) && (mover != obstacle) && (forget != obstacle))
			if(!obstacle.CheckExit(mover, src))
				mover.Bump(obstacle, 1)
				return 0

	//Now, check objects to block exit that are on the border
	for(var/obj/border_obstacle in mover.loc)
		if((border_obstacle.atom_flags & ATOM_FLAG_CHECKS_BORDER) && (mover != border_obstacle) && (forget != border_obstacle))
			if(!border_obstacle.CheckExit(mover, src))
				mover.Bump(border_obstacle, 1)
				return 0

	//Next, check objects to block entry that are on the border
	for(var/obj/border_obstacle in src)
		if(border_obstacle.atom_flags & ATOM_FLAG_CHECKS_BORDER)
			if(!border_obstacle.CanPass(mover, mover.loc, 1, 0) && (forget != border_obstacle))
				mover.Bump(border_obstacle, 1)
				return 0

	//Then, check the turf itself
	if (!src.CanPass(mover, src))
		mover.Bump(src, 1)
		return 0

	//Finally, check objects/mobs to block entry that are not on the border
	for(var/atom/movable/obstacle in src)
		if(!(obstacle.atom_flags & ATOM_FLAG_CHECKS_BORDER))
			if(!obstacle.CanPass(mover, mover.loc, 1, 0) && (forget != obstacle))
				mover.Bump(obstacle, 1)
				return 0
	return 1 //Nothing found to block so return success!

var/global/const/enterloopsanity = 100
/turf/Entered(atom/atom, atom/old_loc)

	..()

	QUEUE_TEMPERATURE_ATOMS(atom)

	if(!istype(atom, /atom/movable))
		return

	var/atom/movable/A = atom

	if(ismob(A))
		var/mob/M = A
		M.make_floating(0) //we know we're not on solid ground so skip the checks to save a bit of processing

	var/objects = 0
	if(A && (A.movable_flags & MOVABLE_FLAG_PROXMOVE))
		for(var/atom/movable/thing in range(1))
			if(objects > enterloopsanity) break
			objects++
			spawn(0)
				if(A)
					A.HasProximity(thing)
					if ((thing && A) && (thing.movable_flags & MOVABLE_FLAG_PROXMOVE))
						thing.HasProximity(A)
	return

/turf/proc/adjacent_fire_act(turf/simulated/floor/adj_turf, datum/gas_mixture/adj_air, adj_temp, adj_volume)
	return

/turf/proc/is_plating()
	return 0

/turf/proc/protects_atom(atom/A)
	return FALSE

/turf/proc/levelupdate()
	for(var/obj/O in src)
		O.hide(O.hides_under_flooring() && !is_plating())

/turf/proc/AdjacentTurfs(check_blockage = TRUE)
	. = list()
	for(var/turf/t in (trange(1,src) - src))
		if(check_blockage)
			if(!t.density)
				if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
					. += t
		else
			. += t

/turf/proc/CardinalTurfs(check_blockage = TRUE)
	. = list()
	for(var/ad in AdjacentTurfs(check_blockage))
		var/turf/T = ad
		if(T.x == src.x || T.y == src.y)
			. += T

/turf/proc/Distance(turf/t)
	if(get_dist(src,t) == 1)
		var/cost = (src.x - t.x) * (src.x - t.x) + (src.y - t.y) * (src.y - t.y)
		cost *= (pathweight+t.pathweight)/2
		return cost
	else
		return get_dist(src,t)

/turf/proc/AdjacentTurfsSpace()
	var/L[] = new()
	for(var/turf/t in oview(src,1))
		if(!t.density)
			if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
				L.Add(t)
	return L

/turf/proc/contains_dense_objects()
	if(density)
		return 1
	for(var/atom/A in src)
		if(A.density && !(A.atom_flags & ATOM_FLAG_CHECKS_BORDER))
			return 1
	return 0

//expects an atom containing the reagents used to clean the turf
/turf/proc/clean(atom/source, mob/user = null, time = null, message = null)
	if(source.reagents.has_reagent(/datum/reagent/water, 1) || source.reagents.has_reagent(/datum/reagent/space_cleaner, 1))
		if(user && time && !do_after(user, time, src, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS))
			return
		clean_blood()
		remove_cleanables()
		if(message)
			to_chat(user, message)
	else
		to_chat(user, SPAN_WARNING("\The [source] is too dry to wash that."))
	source.reagents.trans_to_turf(src, 1, 10)	//10 is the multiplier for the reaction effect. probably needed to wet the floor properly.

/turf/proc/remove_cleanables(skip_blood = TRUE)
	for(var/obj/effect/O in src)
		if(istype(O,/obj/effect/rune) || (istype(O,/obj/effect/decal/cleanable) && (!skip_blood || !istype(O, /obj/effect/decal/cleanable/blood))))
			qdel(O)

/turf/proc/update_blood_overlays()
	return

/turf/proc/remove_decals()
	if(decals && length(decals))
		decals.Cut()
		decals = null

// Called when turf is hit by a thrown object
/turf/hitby(atom/movable/AM as mob|obj, datum/thrownthing/TT)
	if(src.density)
		if(isliving(AM))
			var/mob/living/M = AM
			M.turf_collision(src, TT.speed)
			if(length(M.pinned))
				return

			if(M.pinned)
				return
		addtimer(new Callback(src, /turf/proc/bounce_off, AM, TT.init_dir), 2)

	..()

/turf/proc/bounce_off(atom/movable/AM, direction)
	step(AM, turn(direction, 180))

/turf/proc/can_engrave()
	return FALSE

/turf/proc/try_graffiti(mob/vandal, obj/item/tool)

	if(!tool.sharp || !can_engrave() || vandal.a_intent != I_HELP)
		return FALSE

	if(jobban_isbanned(vandal, "Graffiti"))
		to_chat(vandal, SPAN_WARNING("You are banned from leaving persistent information across rounds."))
		return

	var/too_much_graffiti = 0
	for(var/obj/effect/decal/writing/W in src)
		too_much_graffiti++
	if(too_much_graffiti >= 5)
		to_chat(vandal, SPAN_WARNING("There's too much graffiti here to add more."))
		return FALSE

	var/message = sanitize(input("Enter a message to engrave.", "Graffiti") as null|text, trim = TRUE)
	if(!message)
		return FALSE

	if(!vandal || vandal.incapacitated() || !Adjacent(vandal) || !tool.loc == vandal)
		return FALSE

	vandal.visible_message(SPAN_WARNING("\The [vandal] begins carving something into \the [src]."))

	if(!do_after(vandal, max(20, length(message)), src, DO_PUBLIC_UNIQUE))
		return FALSE

	vandal.visible_message(SPAN_DANGER("\The [vandal] carves some graffiti into \the [src]."))
	var/obj/effect/decal/writing/graffiti = new(src)
	graffiti.message = message
	graffiti.author = vandal.ckey
	vandal.update_personal_goal(/datum/goal/achievement/graffiti, TRUE)

	if(lowertext(message) == "elbereth")
		to_chat(vandal, SPAN_NOTICE("You feel much safer."))

	return TRUE

/turf/proc/is_wall()
	return FALSE

/turf/proc/is_open()
	return FALSE

/turf/proc/is_floor()
	return FALSE

/turf/proc/get_obstruction()
	if (density)
		LAZYADD(., src)
	if (length(contents) > 100 || length(contents) <= !!lighting_overlay)
		return    // fuck it, too/not-enough much shit here
	for (var/thing in src)
		var/atom/movable/AM = thing
		if (AM.simulated && AM.blocks_airlock())
			LAZYADD(., AM)

/**
 * Returns false if stepping into a tile would cause harm (e.g. open space while unable to fly, water tile while a slime, lava, etc).
 */
/turf/proc/is_safe_to_enter(mob/living/L)
	if(LAZYLEN(dangerous_objects))
		for(var/obj/O in dangerous_objects)
			if(!O.is_safe_to_step(L))
				return FALSE
	return TRUE

/**
 * Tells the turf that it currently contains something that automated movement should consider if planning to enter the tile.
 * This uses lazy list macros to reduce memory footprint since for 99% of turfs the list would've been empty anyway.
 */
/turf/proc/register_dangerous_object(obj/O)
	if(!istype(O))
		return FALSE
	LAZYADD(dangerous_objects, O)

/**
 * Similar to `register_dangerous_object()`, for when the dangerous object stops being dangerous/gets deleted/moved/etc.
 */
/turf/proc/unregister_dangerous_object(obj/O)
	if(!istype(O))
		return FALSE
	LAZYREMOVE(dangerous_objects, O)
	UNSETEMPTY(dangerous_objects) // This nulls the list var if it's empty.

/turf/proc/is_dense()
	if (density)
		return TRUE
	if (isnull(has_dense_atom))
		has_dense_atom = FALSE
		if (contains_dense_objects())
			has_dense_atom = TRUE
	return has_dense_atom

/turf/proc/is_opaque()
	if (opacity)
		return TRUE
	if (isnull(has_opaque_atom))
		has_opaque_atom = FALSE
		for (var/atom/A in contents)
			if (A.opacity)
				has_opaque_atom = TRUE
				break
	return has_opaque_atom

/turf/Entered(atom/movable/AM)
	. = ..()
	if (istype(AM))
		if (AM.density)
			has_dense_atom = TRUE
		if (AM.opacity)
			has_opaque_atom = TRUE

/turf/Exited(atom/movable/AM, atom/newloc)
	. = ..()
	if (istype(AM))
		if(AM.density)
			has_dense_atom = null
		if (AM.opacity)
			has_opaque_atom = null
	else
		has_dense_atom = null
		has_opaque_atom = null

/turf/proc/IgniteTurf(power, fire_colour)
	return
