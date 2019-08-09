/*
	welcome to space war kiddo

	These are overmap capable missiles. Upon being activated, they appear on the overmap and travel along it until it enters a tile with associated z levels.
	Then it appears on the z level and travels on it. Maybe it hits something, maybe not. When it hits the z level edge, it'll disappear into the overmap again.

	The missiles are intended to be very modular, and thus do very little on their own except for handling the missile-overmap object interaction and calling appropriate procs on the missile equipment contained inside.

	Also note that while they're called missiles, it's a bit of a misleading name since the missile behavior is almost wholly determined by what equipment it has.
	Check equipment/missile_equipment.dm for more info.
*/

/obj/structure/missile
	name = "intergalactic missile"
	desc = "big scary missile that boom boom the ship. go open an issue for having seen this."
	icon = 'icons/obj/bigmissile.dmi'
	icon_state = "base"

	density = 1
	w_class = ITEM_SIZE_HUGE
	dir = WEST
	does_spin = FALSE

	var/overmap_name = "projectile"

	var/maintenance_hatch_open = FALSE
	var/active = FALSE
	var/list/equipment
	var/obj/effect/overmap/projectile/overmap_missile = null

/obj/structure/missile/proc/get_additional_info()
	var/list/info = list("Detected components:<ul>")
	for(var/obj/item/missile_equipment/E in equipment)
		info += ("<li>" + E.name)
	info += "</ul>"
	return JOINTEXT(info)

/obj/structure/missile/proc/update_bounds()
	if(dir in list(EAST, WEST))
		bound_width = 2 * world.icon_size
		bound_height = world.icon_size
	else
		bound_width = world.icon_size
		bound_height = 2 * world.icon_size

/obj/structure/missile/Initialize()
	. = ..()

	for(var/i = 1; i <= LAZYLEN(equipment); i++)
		var/path = equipment[i]
		equipment[i] = new path(src)

	update_bounds()
	update_icon()

/obj/structure/missile/Destroy()
	. = ..()

	walk(src, 0)
	QDEL_NULL_LIST(equipment)

	if(!QDELETED(overmap_missile))
		QDEL_NULL(overmap_missile)
	overmap_missile = null

/obj/structure/missile/Move()
	. = ..()
	update_bounds()

	// for some reason, touch_map_edge doesn't always trigger like it should
	// this ensures that it does
	if(x < TRANSITIONEDGE || x > world.maxx - TRANSITIONEDGE || y < TRANSITIONEDGE || y > world.maxy - TRANSITIONEDGE)
		touch_map_edge()

/obj/structure/missile/Bump(var/atom/obstacle)
	..()
	detonate(obstacle)

// Move to the overmap until we encounter a new z
/obj/structure/missile/touch_map_edge()
	// In case the proc is called normally alongside the call in Move()
	if(loc == overmap_missile)
		return

	for(var/obj/item/missile_equipment/E in equipment)
		E.on_touch_map_edge(overmap_missile)

	// didn't activate the missile in time, so it drifts off into space harmlessly or something
	if(!active)
		qdel(src)
		return

	if(overmap_missile.dangerous)
		log_and_message_admins("A dangerous missile has entered the overmap (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[overmap_missile.x];Y=[overmap_missile.y];Z=[overmap_missile.z]'>JMP</a>)")

	// Abort walk
	walk(src, 0)
	forceMove(overmap_missile)
	overmap_missile.set_moving(TRUE)

/obj/structure/missile/attackby(var/obj/item/I, var/mob/user)
	if(!active && isMultitool(I))
		if(activate())
			if(overmap_missile.dangerous)
				log_and_message_admins("[key_name(user)] has armed a dangerous missile at ([x],[y],[z]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)")
			src.visible_message(SPAN_WARNING("\The [src] beeps. It's armed!"))
			playsound(src, 'sound/effects/alert.ogg', 50, 0, 0)
			return

	if(isScrewdriver(I))
		maintenance_hatch_open = !maintenance_hatch_open
		to_chat(user, "You [maintenance_hatch_open ? "open" : "close"] the maintenance hatch of \the [src].")

		update_icon()
		return

	if(maintenance_hatch_open)
		if(istype(I, /obj/item/missile_equipment))
			if(!user.unEquip(I, src))
				return
			equipment += I
			to_chat(user, "You install \the [I] into \the [src].")

			update_icon()
			return

		if(isCrowbar(I))
			var/obj/item/missile_equipment/removed_component = input("Which component would you like to remove?") as null|obj in equipment
			if(removed_component)
				to_chat(user, "You remove \the [removed_component] from \the [src].")
				user.put_in_hands(removed_component)
				equipment -= removed_component

				update_icon()
			return

	..()

/obj/structure/missile/on_update_icon()
	overlays.Cut()

	for(var/obj/item/missile_equipment/E in equipment)
		overlays += E.icon_state
	overlays += "panel[maintenance_hatch_open ? "_open" : ""]"

// primes the missile and puts it on the overmap
/obj/structure/missile/proc/activate()
	if(active)
		return 0

	var/obj/effect/overmap/start_object = waypoint_sector(src)
	if(!start_object)
		return 0

	active = TRUE

	overmap_missile = new /obj/effect/overmap/projectile(null, start_object.x, start_object.y)
	overmap_missile.set_missile(src)
	overmap_missile.SetName(overmap_name)

	for(var/obj/item/missile_equipment/E in equipment)
		E.on_missile_activated(overmap_missile)

	return 1

/obj/structure/missile/proc/detonate(var/atom/obstacle)
	if(!active)
		return

	// missile equipment triggers before the missile itself
	for(var/obj/item/missile_equipment/E in equipment)
		E.on_trigger(obstacle)

	// stop moving
	walk(src, 0)
	active = FALSE
	qdel(src)

// Figure out where to pop in and set the missile flying
/obj/structure/missile/proc/enter_level(var/z_level)
	// prevent the missile from moving on the overmap
	overmap_missile.set_moving(FALSE)

	var/heading = overmap_missile.dir
	if(!heading)
		heading = random_dir() // To prevent the missile from popping into the middle of the map and sitting there

	var/start_x = 0
	var/start_y = 0

	if(heading & WEST)
		start_x = world.maxx - TRANSITIONEDGE - 2
	else if(heading & EAST)
		start_x = TRANSITIONEDGE + 2
	else
		start_x = Floor(world.maxx / 2) + rand(-10, 10)

	if(heading & NORTH)
		start_y = TRANSITIONEDGE + 2
	else if(heading & SOUTH)
		start_y = world.maxy - TRANSITIONEDGE - 2
	else
		start_y = Floor(world.maxy / 2) + rand(-10, 10)

	var/turf/start = locate(start_x, start_y, z_level)

	if(overmap_missile.dangerous)
		log_and_message_admins("A dangerous missile has entered z level [z_level] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)")
	forceMove(start)

	// if we enter into a dense place, just detonate immediately
	if(start.contains_dense_objects())
		detonate()
		return

	// let missile equipment decide a target
	var/list/goal_coords = null
	for(var/obj/item/missile_equipment/E in equipment)
		var/list/coords = E.on_enter_level(z_level)
		if(coords)
			goal_coords = coords
			break

	// if a piece of equipment gave us a target, move towards that
	if(!isnull(goal_coords))
		var/turf/goal = locate(goal_coords[1], goal_coords[2], z_level)
		if(goal)
			walk_towards(src, goal, 1)
			return

	walk(src, heading, 1)
