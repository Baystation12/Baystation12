/obj/structure/net//if you want to have fun, make them to be draggable as a whole unless at least one piece is attached to a non-space turf or anchored object
	name = "industrial net"
	desc = "A sturdy industrial net of synthetic belts reinforced with plasteel threads."
	icon = 'icons/obj/structures/industrial_net.dmi'
	icon_state = "net_f"
	anchored = TRUE
	layer = CATWALK_LAYER//probably? Should cover cables, pipes and the rest of objects that are secured on the floor
	health_max = 100
	health_min_damage = 10

/obj/structure/net/Initialize(mapload)
	. = ..()
	update_connections()
	if (!mapload)//if it's not mapped object but rather created during round, we should update visuals of adjacent net objects
		var/turf/T = get_turf(src)
		for (var/turf/AT in T.CardinalTurfs(FALSE))
			for (var/obj/structure/net/N in AT)
				if (type != N.type)//net-walls cause update for net-walls and floors for floors but not for each other
					continue
				N.update_connections()


/obj/structure/net/use_weapon(obj/item/weapon, mob/user, list/click_params)
	SHOULD_CALL_PARENT(FALSE)
	// Sharp Object - Cut through net
	if (!is_sharp(weapon) || weapon.force < 10)
		USE_FEEDBACK_FAILURE("\The [weapon] isn't sharp enough to cut \the [src].")
		return TRUE
	user.visible_message(
		SPAN_NOTICE("\The [user] starts cutting through \the [src] with \a [weapon]."),
		SPAN_NOTICE("You start cutting through \the [src] with \the [weapon].")
	)
	while (!health_dead())
		if (!do_after(user, 2 SECONDS, src, DO_PUBLIC_UNIQUE) || !user.use_sanity_check(src, weapon))
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] makes some progress cutting through \the [src]..."),
			SPAN_NOTICE("You make some progress cutting through \the [src]...")
		)
		if (damage_health(20 * (1 + (weapon.force - 10) / 10), weapon.damtype, weapon.damage_flags()))
			user.visible_message(
				SPAN_NOTICE("\The [user] cuts through \the [src] with \a [weapon]."),
				SPAN_NOTICE("You cut through \the [src] with \the [weapon].")
			)
			break
	return TRUE


/obj/structure/net/on_death()
	. = ..()
	new /obj/item/stack/net(loc)
	qdel_self()


/obj/structure/net/bullet_act(obj/item/projectile/P)
	. = PROJECTILE_CONTINUE //few cloth ribbons won't stop bullet or energy ray
	if (P.damage_type != DAMAGE_BURN)//beams, lasers, fire. Bullets won't make a lot of damage to the few hanging belts.
		return
	visible_message(SPAN_WARNING("\The [P] hits \the [src] and tears it!"))
	damage_health(P.damage, P.damage_type)

/obj/structure/net/update_connections()//maybe this should also be called when any of the walls nearby is removed but no idea how I can make it happen
	ClearOverlays()
	var/turf/turf = get_turf(src)
	for (var/turf/adjacent_turf in turf.CardinalTurfs(FALSE))
		if ( (locate(/obj/structure/net) in adjacent_turf) || (!istype(adjacent_turf, /turf/simulated/open) && !istype(adjacent_turf, /turf/space)) || (locate(/obj/structure/lattice) in adjacent_turf) )//connects to another net objects or walls/floors or lattices
			var/image/image = image(icon,"[icon_state]_ol_[get_dir(src, adjacent_turf)]")
			AddOverlays(image)

/obj/structure/net/net_wall
	icon_state = "net_w"
	density = TRUE
	layer = ABOVE_HUMAN_LAYER

/obj/structure/net/net_wall/Initialize(mapload)
	. = ..()
	if (mapload)//if it's pre-mapped, it should put floor-net below itself
		var/turf/turf = get_turf(src)
		for (var/obj/structure/net/net in turf)
			if (net.type != /obj/structure/net/net_wall)//if there's net that is not a net-wall, we don't need to spawn it
				return
		new /obj/structure/net(turf)


/obj/structure/net/net_wall/update_connections()//this is different for net-walls because they only connect to walls and net-walls
	ClearOverlays()
	var/turf/turf = get_turf(src)
	for (var/turf/adjacent_turf in turf.CardinalTurfs(FALSE))
		if ((locate(/obj/structure/net/net_wall) in adjacent_turf) || istype(adjacent_turf, /turf/simulated/wall)  || istype(adjacent_turf, /turf/unsimulated/wall) || istype(adjacent_turf, /turf/simulated/mineral))//connects to another net-wall objects or walls
			var/image/image = image(icon,"[icon_state]_ol_[get_dir(src, adjacent_turf)]")
			AddOverlays(image)

/obj/item/stack/net
	name = "industrial net roll"
	desc = "Sturdy industrial net reinforced with plasteel threads."
	singular_name = "industrial net"
	icon = 'maps/away/errant_pisces/errant_pisces_sprites.dmi'
	icon_state = "net_roll"
	w_class = ITEM_SIZE_LARGE
	force = 3.0
	throwforce = 5.0
	throw_speed = 5
	throw_range = 10
	matter = list("cloth" = 1875, "plasteel" = 350)
	max_amount = 30
	attack_verb = list("hit", "bludgeoned", "whacked")
	lock_picking_level = 3

/obj/item/stack/net/Initialize()
	. = ..()
	update_icon()

/obj/item/stack/net/thirty
	amount = 30

/obj/item/stack/net/on_update_icon()
	if (amount == 1)
		icon_state = "net"
	else
		icon_state = "net_roll"

/obj/item/stack/net/proc/attach_wall_check() //checks if wall can be attached to something vertical such as walls or another net-wall
	if (!has_gravity())
		return TRUE
	var/turf/turf = get_turf(src)
	for (var/turf/adjacent_turf in turf.CardinalTurfs(FALSE))
		if ((locate(/obj/structure/net/net_wall) in adjacent_turf) || istype(adjacent_turf, /turf/simulated/wall)  || istype(adjacent_turf, /turf/unsimulated/wall) || istype(adjacent_turf, /turf/simulated/mineral)) //connects to another net-wall objects or walls
			return TRUE
	return 0

/obj/item/stack/net/attack_self(mob/user) //press while holding to lay one. If there's net already, place wall
	var/turf/turf = get_turf(user)
	if (locate(/obj/structure/net/net_wall) in turf)
		to_chat(user, SPAN_WARNING("Net wall is already placed here!"))
		return
	if (locate(/obj/structure/net) in turf) //if there's already layed "floor" net
		if (!attach_wall_check())
			to_chat(user, SPAN_WARNING("You try to place net wall but it falls on the floor. Try to attach it to something vertical and stable."))
			return
		new /obj/structure/net/net_wall(turf)
	else
		new /obj/structure/net(turf)
	amount -= 1
	update_icon()
	if (amount < 1)
		qdel(src)
