/*
	welcome to space war kiddo

	These are overmap capable missiles. Upon being activated, they appear on the overmap and travel along it until it enters a tile with associated z levels.
	Then it appears on the z level and travels on it. Maybe it hits something, maybe not. When it hits the z level edge, it'll disappear into the overmap again.

	The missiles are intended to be very modular, and thus do very little on their own except for handling the missile-overmap object interaction and calling appropriate procs on the missile equipment contained inside.

	Also note that while they're called missiles, it's a bit of a misleading name since the missile behavior is almost wholly determined by what equipment it has.
	Check equipment/missile_equipment.dm for more info.
*/

/obj/structure/missile
	name = "missile"
	desc = "A general purpose payload delivery system. Has several mounting points for parts."
	icon = 'icons/obj/bigmissile.dmi'
	icon_state = "base"

	density = TRUE
	w_class = ITEM_SIZE_HUGE
	dir = WEST
	does_spin = FALSE

	atom_flags = ATOM_FLAG_CLIMBABLE

	pixel_x = -16
	pixel_y = -16

	matter = list(MATERIAL_ALUMINIUM = 2000)

	var/overmap_name = "missile"

	// how many pieces of dense objects can this missile still punch through
	var/inertia = 12

	var/maintenance_hatch_open = FALSE
	var/armed = FALSE
	var/list/equipment = list(
		MISSILE_PART_PAYLOAD = null,
		MISSILE_PART_THRUSTER = null
	)
	var/obj/overmap/projectile/overmap_missile = null

/obj/structure/missile/examine(mob/user)
	. = ..()
	to_chat(user, get_additional_info())

/obj/structure/missile/proc/get_additional_info()
	var/list/info = list("Detected components:<ul>")
	for (var/slot in equipment)
		var/obj/item/missile_equipment/missile_part = equipment[slot]
		if (missile_part)
			info += ("<li>" + missile_part.name)
	info += "</ul>"
	return jointext(info, null)

/obj/structure/missile/Initialize()
	. = ..()
	material = SSmaterials.get_material_by_name(MATERIAL_ALUMINIUM)
	for (var/i in equipment)
		var/path = equipment[i]
		if (ispath(path))
			equipment[i] = new path(src)
	update_icon()
	update_designation()

/obj/structure/missile/get_interactions_info()
	. = ..()
	.[CODEX_INTERACTION_SCREWDRIVER] = "<p>Toggles the access panel.</p>"
	.[CODEX_INTERACTION_MULTITOOL] = "<p>Manually arms the missile. Access panel must be open and a thruster must be attached.</p>"
	.[CODEX_INTERACTION_CROWBAR] = "<p>Removes attached parts. Access panel must be open.</p>"
	.[CODEX_INTERACTION_WELDER] = "<p>Dismantles the frame. All parts must be removed.</p>"
	.["Missile Part"] = "<p>Adds part to the frame. Must not have an existing part of the same type.</p>"

/obj/structure/missile/proc/update_designation()
	var/obj/item/missile_equipment/payload/payload_part = equipment[MISSILE_PART_PAYLOAD]
	if (payload_part)
		name = payload_part.missile_name_override
		overmap_name = payload_part.missile_name_override
		return
	name = initial(name)
	overmap_name = initial(overmap_name)

/obj/structure/missile/Destroy()
	for (var/part in equipment)
		var/obj/item/missile_equipment/missile_equipment = equipment[part]
		QDEL_NULL(missile_equipment)
	if (!QDELETED(overmap_missile))
		QDEL_NULL(overmap_missile)
	overmap_missile = null
	. = ..()

/obj/structure/missile/Move()
	. = ..()
	// for some reason, touch_map_edge doesn't always trigger like it should
	// this ensures that it does
	if (x < TRANSITIONEDGE || x > world.maxx - TRANSITIONEDGE || y < TRANSITIONEDGE || y > world.maxy - TRANSITIONEDGE)
		touch_map_edge()

/obj/structure/missile/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	return istype(mover, /obj/structure/missile) ? 1 : ..()

/obj/structure/missile/Bump(atom/obstacle)
	. = ..()
	if (!armed)
		return
	// This doesn't have a detonation mechanism, it simply punches through hulls.
	var/obj/item/missile_equipment/payload/payload_part = equipment[MISSILE_PART_PAYLOAD]
	if ((!payload_part || !payload_part.is_dangerous) && inertia)
		if (istype(obstacle, /obj/machinery/shield))
			inertia = 0
		else
			penetrate(obstacle)
			damping_inertia()
	else
		// Detonating on hit
		walk(src, 0)
		detonate(obstacle)

/obj/structure/missile/proc/penetrate(turf/target_turf)
	//first bust whatever is in the turf
	for(var/atom/contained_atom in target_turf)
		if(contained_atom != src && !contained_atom.CanPass(src, loc, 0.5, 0)) //only penetrate stuff that would actually block us
			contained_atom.ex_act(EX_ACT_HEAVY)

	//then, penetrate the turf if it still exists
	if(target_turf && !target_turf.CanPass(src, loc, 0.5, 0))
		target_turf.ex_act(EX_ACT_HEAVY, TRUE)

/obj/structure/missile/proc/damping_inertia()
	inertia--
	if(inertia <= 0)
		detonate()

/obj/structure/missile/ex_act()
	return

// Move to the overmap until we encounter a new z
/obj/structure/missile/touch_map_edge()
	// In case the proc is called normally alongside the call in Move()
	if (loc == overmap_missile)
		return

	for (var/part in equipment)
		var/obj/item/missile_equipment/missile_equipment = equipment[part]
		if (missile_equipment)
			missile_equipment.on_touch_map_edge(overmap_missile)

	// didn't activate the missile in time, so it drifts off into space harmlessly or something
	if (!armed)
		qdel_self()
		return

	// Abort walk
	walk(src, 0)
	forceMove(overmap_missile)
	overmap_missile.set_moving(TRUE)
	overmap_missile.forceMove(get_turf(loc))

	if (overmap_missile.dangerous)
		log_and_message_admins("A dangerous missile has entered the overmap (<A HREF='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[overmap_missile.x];Y=[overmap_missile.y];Z=[overmap_missile.z]'>JMP</a>)")

/obj/structure/missile/use_tool(obj/item/tool, mob/user)
	if (isWelder(tool))
		if (equipment[MISSILE_PART_PAYLOAD] || equipment[MISSILE_PART_THRUSTER])
			to_chat(user, SPAN_WARNING("You cannot deconstruct \The [src] while there are parts attached!"))
			return TRUE
		var/obj/item/weldingtool/welder = tool
		if (!welder.remove_fuel(1, user))
			return TRUE
		playsound(loc, 'sound/items/Welder.ogg', 50, TRUE)
		if (do_after(user, 6 SECONDS, src, DO_REPAIR_CONSTRUCT))
			playsound(loc, 'sound/items/Welder.ogg', 50, TRUE)
			user.visible_message(
				SPAN_NOTICE("\The [user] slices \the [src] apart with \a [tool]."),
				SPAN_NOTICE("You \the [src] apart with \the [tool].")
			)
			new /obj/item/stack/material/aluminium(loc, 20, material.name)
			qdel_self()
		return TRUE

	if (isScrewdriver(tool))
		maintenance_hatch_open = !maintenance_hatch_open
		playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
		user.visible_message(
			SPAN_NOTICE("\The [user] [maintenance_hatch_open ? "opens" : "closes"] the maintenance hatch of \the [src]."),
			SPAN_NOTICE("You [maintenance_hatch_open ? "open" : "close"] the maintenance hatch of \the [src].")
		)

		update_icon()
		return TRUE

	if (maintenance_hatch_open)
		if (isMultitool(tool))
			if (!armed)
				if (arm(user))
					addtimer(new Callback(src, PROC_REF(fire)), 2 SECONDS)
			else
				to_chat(user, SPAN_WARNING("You begin disarming \the [src]..."))
				if (do_after(user, 6 SECONDS, src, DO_REPAIR_CONSTRUCT))
					to_chat(user, "You successfully disarm \the [src]!")
					disarm()
			return TRUE

		if (istype(tool, /obj/item/missile_equipment))
			var/obj/item/missile_equipment/part = tool
			if (equipment[part.slot])
				to_chat(user, "There is already a [part.slot] installed.")
				return TRUE
			if (do_after(user, 3 SECONDS, src, DO_REPAIR_CONSTRUCT))
				if (!user.unEquip(tool, src))
					FEEDBACK_UNEQUIP_FAILURE(user, tool)
					return FALSE
				equipment[part.slot] = tool
				playsound(src, 'sound/items/Deconstruct.ogg', 50, TRUE)
				user.visible_message(
					SPAN_NOTICE("\The [user] installs \a [tool] into \the [src]."),
					SPAN_NOTICE("You install \the [tool] into \the [src].")
				)
				update_designation()
				update_icon()
			return TRUE

		if (isCrowbar(tool))
			var/list/valid_equipment = list()
			for (var/slot in equipment)
				var/obj/item/missile_equipment/part = equipment[slot]
				if (part)
					valid_equipment += slot
			if (LAZYLEN(valid_equipment))
				var/slot_to_remove = input("Which component would you like to remove?") as anything in valid_equipment
				var/obj/item/missile_equipment/removed_component = equipment[slot_to_remove]
				if (do_after(user, 3 SECONDS, src, DO_REPAIR_CONSTRUCT))
					if (removed_component)
						playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
						user.visible_message(
							SPAN_NOTICE("\The [user] removes \a [removed_component] from \the [src]."),
							SPAN_NOTICE("You remove \the [removed_component] from \the [src].")
						)
						user.put_in_hands(removed_component)
						equipment[slot_to_remove] = null
						update_designation()
						update_icon()
			else
				to_chat(user, "There are no parts to remove!")
			return TRUE
	return ..()

/obj/structure/missile/on_update_icon()
	ClearOverlays()
	for (var/slot in equipment)
		var/obj/item/missile_equipment/part = equipment[slot]
		if (part)
			AddOverlays(part.icon_state)
	AddOverlays("panel[maintenance_hatch_open ? "_open" : ""]")

// primes the missile and puts it on the overmap
/obj/structure/missile/proc/arm(mob/user)
	if (armed)
		return FALSE

	if (!equipment[MISSILE_PART_THRUSTER])
		if (user && Adjacent(user))
			to_chat(user, "\The [src] doesn't have a [MISSILE_PART_THRUSTER] installed!")
		return FALSE

	visible_message(SPAN_WARNING("\The [src] beeps. It's armed!"))
	playsound(src, 'sound/effects/alert.ogg', 50, 0, 0)

	anchored = TRUE
	armed = TRUE

	var/obj/overmap/start_object = waypoint_sector(src)
	if (start_object)
		overmap_missile = new /obj/overmap/projectile(start_object)
		overmap_missile.set_missile(src)
		overmap_missile.SetName(overmap_name)

	for (var/slot in equipment)
		var/obj/item/missile_equipment/part = equipment[slot]
		if (part)
			part.on_missile_armed(overmap_missile)

	if (overmap_missile.dangerous)
		log_and_message_admins("[key_name(user)] has armed a dangerous missile at ([x],[y],[z]) (<A HREF='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)")

	return TRUE

/obj/structure/missile/proc/disarm()
	armed = FALSE
	if (overmap_missile)
		qdel(overmap_missile)

/obj/structure/missile/proc/fire()
	if (!armed)
		return
	var/obj/item/missile_equipment/thruster/thruster = equipment[MISSILE_PART_THRUSTER]
	if (thruster && thruster.try_consume_fuel())
		pass_flags |= PASS_FLAG_TABLE
		playsound(src, 'sound/machines/thruster.ogg', 50, 0, 0)
		walk(src, dir, 1)

/obj/structure/missile/proc/detonate(atom/obstacle)
	// missile equipment triggers before the missile itself
	for (var/slot in equipment)
		var/obj/item/missile_equipment/part = equipment[slot]
		if (part)
			part.on_trigger(armed, obstacle)
	qdel_self()

// Figure out where to pop in and set the missile flying
/obj/structure/missile/proc/enter_level(z_level)
	// prevent the missile from moving on the overmap
	overmap_missile.set_moving(FALSE)

	var/heading = overmap_missile.dir
	if (!heading)
		var/datum/prng/rng = new()
		heading = rng.random_dir() // To prevent the missile from popping into the middle of the map and sitting there

	var/start_x = 0
	var/start_y = 0

	if (heading & WEST)
		start_x = world.maxx - TRANSITIONEDGE - 2
	else if (heading & EAST)
		start_x = TRANSITIONEDGE + 2
	else
		start_x = floor(world.maxx / 2) + rand(-10, 10)

	if (heading & NORTH)
		start_y = TRANSITIONEDGE + 2
	else if (heading & SOUTH)
		start_y = world.maxy - TRANSITIONEDGE - 2
	else
		start_y = floor(world.maxy / 2) + rand(-10, 10)

	var/turf/start = locate(start_x, start_y, z_level)

	if (overmap_missile.dangerous)
		log_and_message_admins("A dangerous missile has entered z level [z_level] (<A HREF='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)")

	var/should_detonate = start.contains_dense_objects()
	forceMove(start)
	qdel(overmap_missile)

	// if we enter into a dense place, just detonate immediately
	if (should_detonate)
		detonate()
		return

	// let missile equipment decide a target
	var/list/goal_coords = null
	for (var/slot in equipment)
		var/obj/item/missile_equipment/part = equipment[slot]
		if (part)
			var/list/coords = part.on_enter_level(z_level)
			if (coords)
				goal_coords = coords
				break

	// if a piece of equipment gave us a target, move towards that
	if (!isnull(goal_coords))
		var/turf/goal = locate(goal_coords[1], goal_coords[2], z_level)
		if (goal)
			walk_towards(src, goal, 1)
			return

	walk(src, heading, 1)

/obj/structure/missile/proc/get_target()
	var/obj/item/missile_equipment/thruster/thruster = equipment[MISSILE_PART_THRUSTER]
	if (thruster)
		return thruster.target
	return null

/obj/structure/missile/proc/set_target(atom/new_target)
	var/obj/item/missile_equipment/thruster/thruster = equipment[MISSILE_PART_THRUSTER]
	if (thruster)
		thruster.target = new_target
