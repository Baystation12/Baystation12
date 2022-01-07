/// A spider cocoon too large to be carried. Holds large items, humans, lockers, etc.
/obj/structure/spider_cocoon
	name = "large cocoon"
	desc = "A sac made from tough, sticky webbing."
	icon = 'icons/effects/spider.dmi'
	icon_state = "cocoon_large3"
	health_max = 60

	/// The single large movable that the cocoon holds
	var/atom/movable/held

	/// One of HOLDS_*. What held is
	var/held_type

	var/static/const/HOLDS_OBJECT = 1

	var/static/const/HOLDS_LIVING = 2

	var/static/const/LIVING_NOTARGET = 3

	/// The [exclusive, inclusive] limits on mob_size the cocoon may collect
	var/held_mob_size_limit = list(MOB_SMALL, MOB_LARGE)

	/// The [exclusive, inclusive] limits on w_class the cocoon may collect
	var/held_w_class_limit = list(ITEM_SIZE_NORMAL, ITEM_SIZE_HUGE)


/obj/structure/spider_cocoon/Destroy()
	if (!drop_held(loc, TRUE))
		QDEL_NULL(held)
	return ..()


/**
* Initialize
*   collect [null|number|reference|list]
*     falsy: do not collect from the initial loc
*     truthy: collect from the initial loc
*     reference: collect the specified thing
*/
/obj/structure/spider_cocoon/Initialize(mapload, collect = TRUE)
	. = ..()
	icon_state = pick("cocoon_large1", "cocoon_large2", "cocoon_large3")
	if (ismovable(collect))
		collect_held(loc, collect)
	else if (collect)
		collect_held(loc)


/obj/structure/spider_cocoon/handle_death_change(new_state)
	if (!new_state)
		return
	qdel(src)


/obj/structure/spider_cocoon/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if (exposed_temperature > T50C)
		if (exposed_temperature > T100C)
			damage_health(health_max, DAMAGE_FIRE)
		else
			damage_health(3, DAMAGE_FIRE)


/obj/structure/spider_cocoon/examine(mob/user, distance)
	. = ..()
	if (distance > 5 && !isobserver(user))
		return
	var/result = "loose and empty"
	if (held)
		if (held_details == HOLDS_OBJECT)
			result = "wrapped around something inanimate"
		else if (held_details == HOLDS_LIVING || held_details == LIVING_NOTARGET)
			result = "wrapped around a limp form"
	to_chat(user, "It is [result].")


/obj/structure/spider_cocoon/proc/collect_held(atom/from = loc, atom/movable/preferred)
	if (held)
		return
	var/list/targets = list()
	if (preferred)
		targets += preferred
	for (var/atom/movable/movable in from)
		targets += movable
	for (var/atom/movable/movable as anything in targets)
		if (movable.anchored)
			continue
		else if (isliving(movable))
			var/mob/living/living = movable
			if (living.mob_size <= held_mob_size_limit[1])
				continue
			if (living.mob_size > held_mob_size_limit[2])
				continue
			if (living.status_flags & NOTARGET)
				held_details = LIVING_NOTARGET
			else
				held_details = HOLDS_LIVING
		else if (isitem(movable))
			var/obj/item/item = movable
			if (item.w_class <= held_w_class_limit[1])
				continue
			if (item.w_class > held_w_class_limit[2])
				continue
			held_details = HOLDS_OBJECT
		else if (istype(movable, /obj/structure))
			held_details = HOLDS_OBJECT
		else
			continue
		held = movable
		movable.forceMove(src)
		break
	queue_icon_update()


/obj/structure/spider_cocoon/proc/drop_held(atom/into = loc, silent)
	if (!held)
		return
	if (QDELETED(into))
		return TRUE
	if (!isturf(into))
		into = get_turf(into)
	held.dropInto(into)
	if (held_details == HOLDS_LIVING)
		var/mob/living/living = movable
		living.status_flags &= ~NOTARGET
	held = null
	if (!silent)
		visible_message(
			SPAN_ITALIC("\The [src] splits apart."),
			SPAN_WARNING("You hear slithery tearing.")
		)
