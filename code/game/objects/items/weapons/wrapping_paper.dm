/**
 * Contains cargo's package wrapper and gift wrapping paper, with relevant procs to wrap items/mobs.
 * Gifts and parcels are found under gifts.dm and sortingmachinery.dm respectively.
 */

/obj/item/stack/package_wrap
	abstract_type = /obj/item/stack/package_wrap
	singular_name = "sheet"
	amount = 25
	max_amount = 25
	icon = 'icons/obj/parcels.dmi'
	var/package_type

/obj/item/stack/package_wrap/cargo_wrap
	name = "package wrapper"
	desc = "Heavy duty brown paper used to wrap packages to protect them during shipping."
	icon_state = "deliveryPaper"
	package_type = "parcel"

/obj/item/stack/package_wrap/cargo_wrap/cyborg
	name = "package wrapper synthesizer"
	gender = NEUTER
	uses_charge = 1
	charge_costs = list(1)
	stacktype = /obj/item/stack/package_wrap

/obj/item/stack/package_wrap/gift_wrap
	name = "gift wrapping paper"
	desc = "A roll of green and red wrapping paper, ready to package gifts in holiday charm."
	icon_state = "wrapping_paper"
	package_type = "gift"

/obj/item/c_tube
	name = "cardboard tube"
	desc = "A tube of cardboard."
	icon = 'icons/obj/parcels.dmi'
	icon_state = "c_tube"
	throwforce = 1
	w_class = ITEM_SIZE_SMALL
	throw_speed = 4
	throw_range = 5

/obj/item/stack/package_wrap/proc/wrap_item(package_type, obj/target, mob/user)
	var/amount_used
	if (!isobj(target) || !istype(user))
		return

	if (istype(target, /obj/structure/closet))
		var/obj/structure/bigDelivery/package/parcel = new /obj/structure/bigDelivery/package(get_turf(target.loc), target, package_type)
		parcel.add_fingerprint(user)
		amount_used = istype(target, /obj/structure/closet/crate) ? BASE_STORAGE_COST(ITEM_SIZE_NORMAL) : BASE_STORAGE_COST(ITEM_SIZE_LARGE)
	else if (istype(target, /obj/item))
		var/obj/item/smallDelivery/parcel = new /obj/item/smallDelivery(get_turf(target.loc), target, package_type)
		parcel.add_fingerprint(user)
		amount_used = parcel.get_storage_cost()
	else
		return

	target.add_fingerprint(user)
	add_fingerprint(user)
	use(amount_used)
	user.visible_message("\The [user] wraps \the [target] with [get_vague_name(TRUE)]].",
		SPAN_NOTICE("You wrap \the [target] with [get_exact_name(amount_used)]"),
		"You hear someone taping paper around an object.")
	playsound(user.loc, 'sound/effects/wrap.ogg', 65, 1)

	if (get_amount() <= 0)
		new /obj/item/c_tube(loc)
		qdel(src)
	return


/obj/item/stack/package_wrap/use_after(obj/object, mob/user)


/obj/item/stack/package_wrap/use_before(atom/target, mob/living/user)
	if (isobj(target))
		var/obj/wrapped_object = target
		if (istype(wrapped_object, /obj/item/stack/package_wrap) || istype(wrapped_object, /obj/item/storage/backpack) || istype(wrapped_object, /obj/item/storage/belt) || istype(wrapped_object,/obj/item/storage/bag || istype(wrapped_object, /obj/item/storage/briefcase)))
			return FALSE
		if (istype(wrapped_object, /obj/item/smallDelivery) || istype(wrapped_object, /obj/structure/bigDelivery) || istype(wrapped_object, /obj/item/evidencebag))
			to_chat(user, SPAN_WARNING("\The [wrapped_object] is already wrapped."))
			return TRUE
		if (wrapped_object.anchored)
			to_chat(user, SPAN_WARNING("\The [wrapped_object] is bolted down and can't be wrapped."))
			return TRUE
		if (user in wrapped_object)
			to_chat(user, SPAN_WARNING("You cannot wrap \the [wrapped_object] while inside it."))
			return TRUE
		var/amount = get_amount()
		if (amount < 1)
			to_chat(user, SPAN_WARNING("\The [src] is out of [plural_name]."))
			return TRUE

		if (istype(target, /obj/item))
			var/obj/item/wrapped_item = target
			var/a_used = wrapped_item.get_storage_cost()
			if (wrapped_item.w_class == ITEM_SIZE_NO_CONTAINER || wrapped_item.w_class == ITEM_SIZE_GARGANTUAN)
				to_chat(user, SPAN_WARNING("\The [wrapped_item] is too big to wrap!"))
				return TRUE
			if (istype(wrapped_item.loc, /obj/item/storage))
				to_chat(user, SPAN_WARNING("You must take \the [wrapped_item] out of \the [wrapped_item.loc] to wrap it."))
				return TRUE
			if (user.isEquipped(wrapped_item))
				to_chat(user, SPAN_WARNING("You must put down \the [wrapped_item] in order to wrap it."))
				return TRUE
			if (amount < a_used)
				USE_FEEDBACK_STACK_NOT_ENOUGH(src, a_used, "to wrap \the [wrapped_item]!")
				return TRUE
			user.visible_message(
				SPAN_NOTICE("\The [user] starts wrapping \the [wrapped_item] with \the [src]."),
				SPAN_NOTICE("You start wrapping \the [wrapped_item] with \the [src].")
			)
			if (!do_after(user, wrapped_item.w_class SECONDS, wrapped_item, DO_PUBLIC_UNIQUE) || !user.use_sanity_check(wrapped_item, src))
				return TRUE
			wrap_item(package_type, wrapped_item, user)
			return TRUE

		if (istype(target, /obj/structure/closet/crate) || istype(target, /obj/structure/closet))
			var/item_size
			var/obj/structure/closet/wrapped_closet = target
			if (istype(target, /obj/structure/closet/crate))
				item_size = BASE_STORAGE_COST(ITEM_SIZE_NORMAL)
			else
				item_size = BASE_STORAGE_COST(ITEM_SIZE_LARGE)
			if (amount < item_size)
				USE_FEEDBACK_STACK_NOT_ENOUGH(src, item_size, "to wrap \the [wrapped_closet]!")
				return TRUE
			user.visible_message(
				SPAN_NOTICE("\The [user] starts wrapping \the [wrapped_closet] with \the [src]."),
				SPAN_NOTICE("You start wrapping \the [wrapped_closet] with \the [src].")
			)
			if (!do_after(user, item_size SECONDS, wrapped_closet, DO_PUBLIC_UNIQUE) || !user.use_sanity_check(wrapped_closet, src))
				return TRUE
			wrap_item(package_type, wrapped_closet, user)
			return TRUE

	if (istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/wrapped_human = target
		var/a_used = BASE_STORAGE_COST(ITEM_SIZE_LARGE) //get_storage_cost() does not work on mobs, will reproduce same logic here.

		if (get_amount() < a_used)
			USE_FEEDBACK_STACK_NOT_ENOUGH(src, a_used, "to wrap \the [wrapped_human]!")
			return TRUE
		if (!wrapped_human.has_danger_grab(user))
			to_chat(user, SPAN_WARNING("You need to have a firm grip on \the [wrapped_human] in order to wrap them."))
			return TRUE
		wrapped_human.visible_message(
			SPAN_NOTICE("\The [user] starts wrapping \the [wrapped_human] with \the [src]."),
			SPAN_NOTICE("You start wrapping \the [wrapped_human] with \the [src].")
		)
		if (!do_after(user, ITEM_SIZE_LARGE SECONDS, wrapped_human, DO_PUBLIC_UNIQUE) || !wrapped_human.has_danger_grab(user) || !user.use_sanity_check(wrapped_human, src))
			return TRUE

		var/obj/structure/bigDelivery/mobpresent/present = new (wrapped_human.loc, wrapped_human, package_type)
		use(a_used)

		if (user == wrapped_human)
			user.visible_message(
				SPAN_DANGER("\The [user] wraps themselves with [get_vague_name(TRUE)]."),
				SPAN_DANGER("You wrap yourself with [get_exact_name(a_used)].")
			)
		else
			user.visible_message(
				SPAN_DANGER("\The [user] wraps \the [wrapped_human] with [get_vague_name(TRUE)]."),
				SPAN_DANGER("You wrap \the [wrapped_human] with [get_exact_name(a_used)].")
			)

		playsound(user.loc, 'sound/effects/wrap.ogg', 65, 1)
		present.add_fingerprint(user)
		wrapped_human.remove_grabs_and_pulls()
		admin_attack_log(user, wrapped_human, "Used \a [src] to wrap their victim", "Was wrapepd with \a [src]", "used \the [src] to wrap")
		return TRUE
