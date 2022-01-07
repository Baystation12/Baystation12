/// A spider cocoon small enough to be carried. Holds small items and mobs.
/obj/item/spider_cocoon
	name = "small cocoon"
	desc = "A sac made from tough, sticky webbing."
	icon = 'icons/effects/spider.dmi'
	icon_state = "cocoon2"
	health_max = 30
	w_class = ITEM_SIZE_NORMAL

	/// [list] The list of movables this cocoon has collected
	var/list/held = list()

	/// [number] The inclusive upper limit on w_class the cocoon may collect
	var/held_w_class_limit = ITEM_SIZE_NORMAL // 2

	/// [number] The inclusive upper limit on mob_size the cocoon may collect
	var/held_mob_size_limit = MOB_SMALL // 10

	/// [number] The sum of item w_class and living mob_size the cocoon holds
	var/held_amount = 0

	/// [number] The inclusive upper limit of held_amount
	var/held_amount_max = 15


/obj/item/spider_cocoon/Destroy()
	if (drop_held(loc, TRUE))
		QDEL_NULL_LIST(held)
	return ..()


/**
* Initialize
*   collect [null|number|reference|list]
*     falsy: do not collect from the initial loc
*     truthy: collect from the initial loc
*     reference: collect the specified thing first, then others
*     list: collect the list contents first, then others
*/
/obj/item/spider_cocoon/Initialize(mapload, collect = TRUE)
	. = ..()
	icon_state = pick("cocoon1", "cocoon2", "cocoon3")
	if (islist(collect))
		collect_held(loc, collect)
	else if (ismovable(collect))
		collect_held(loc, list(collect))
	else if (collect)
		collect_held(loc)


/obj/item/spider_cocoon/handle_death_change(new_state)
	if (!new_state)
		return
	drop_held(loc)
	qdel(src)


/obj/item/spider_cocoon/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if (exposed_temperature > T50C)
		if (exposed_temperature > T100C)
			damage_health(health_max, DAMAGE_FIRE)
		else
			damage_health(3, DAMAGE_FIRE)


/obj/item/spider_cocoon/attackby(obj/item/item, mob/living/user)
	user.setClickCooldown(item.attack_cooldown || DEFAULT_ATTACK_COOLDOWN)
	var/visible = "uselessly prod"
	var/audible = "soft squishing"
	if (!(item.item_flags & ITEM_FLAG_NO_BLUDGEON))
		var/force = is_hot(item)
		if (force >= 1000)
			damage_health(health_max, DAMAGE_FIRE)
			visible = "incinerate"
			audible = "the swoosh of a quick flame"
		else if (force >= 100)
			damage_health(health_max / 3, DAMAGE_FIRE)
			visible = "singe"
			audible = "sizzling"
		else if (item.damtype == DAMAGE_BRUTE)
			force = item.force
			if (!item.edge && !item.sharp)
				force = force * 0.5
			if (force > health_current)
				damage_health(health_max, DAMAGE_BRUTE)
				visible = "splatter"
				audible = "wet splattering"
			else if (force >= 2)
				damage_health(force, DAMAGE_BRUTE)
				visible = "pop"
				audible = "wet popping"
	user.do_attack_animation(src)
	user.visible_message(
		SPAN_WARNING("\The [user] [visible]s \a [src] with \a [item]."),
		SPAN_WARNING("You [visible] \the [src] with \the [item]."),
		SPAN_WARNING("You hear [audible].")
	)


/obj/item/spider_cocoon/examine(mob/user, distance)
	. = ..()
	if (distance > 3 && !isobserver(user))
		return
	var/result = held_amount / held_amount_max
	if (result < 0.33)
		result = "loose and empty"
	else if (result < 0.67)
		result = "full up"
	else
		result = "stuffed tight"
	to_chat(user, "It looks [result].")


/obj/item/spider_cocoon/proc/collect_held(atom/from = loc, list/preferred)
	if (held_amount_max - held_amount < 1)
		return
	var/cost
	var/details
	var/obj/item/item
	var/mob/living/living
	var/list/targets = preferred?.Copy() || list()
	for (var/atom/movable/movable in from)
		targets += movable
	for (var/atom/movable/movable as anything in targets)
		if (held_amount_max - held_amount < 1)
			break
		else if (movable.anchored)
			continue
		else if (isitem(movable))
			item = movable
			cost = item.w_class
			if (cost > held_w_class_limit)
				continue
			details = COCOON_HOLDS_OBJECT
		else if (isliving(movable))
			living = movable
			cost = living.mob_size
			if (cost > held_mob_size_limit)
				continue
			if (living.status_flags & NOTARGET)
				details = COCOON_HOLDS_LIVING_NOTARGET
			else
				details = COCOON_HOLDS_LIVING
		else
			continue
		if (held_amount + cost > held_amount_max)
			continue
		if (living == movable)
			living.status_flags |= NOTARGET
		movable.forceMove(src)
		held[movable] = details
		held_amount += cost
	queue_icon_update()


/obj/item/spider_cocoon/proc/drop_held(atom/into = loc, silent)
	if (!held.len)
		return
	if (QDELETED(into))
		return TRUE
	var/obj/item/storage/storage
	if (istype(into, /obj/item/storage))
		storage = into
	if (storage || !isturf(into) && !istype(into, /obj/structure/closet))
		into = get_turf(src)
	if (storage)
		storage.remove_from_storage(src, into)
	var/details
	for (var/atom/movable/movable in held)
		details = held[movable]
		if (details == COCOON_HOLDS_OBJECT && storage?.can_be_inserted(movable, stop_messages = TRUE))
			storage.handle_item_insertion(movable, TRUE, TRUE)
		else
			movable.dropInto(into)
		if (details == COCOON_HOLDS_LIVING && isliving(movable))
			var/mob/living/living = movable
			living.status_flags &= ~NOTARGET
	if (storage)
		storage.update_ui_after_item_insertion()
	if (!silent)
		visible_message(
			SPAN_ITALIC("\The [src] splits apart."),
			SPAN_WARNING("You hear slithery tearing.")
		)
