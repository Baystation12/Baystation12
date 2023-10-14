/**
 * Contains cargo's package wrapper and gift wrapping paper, with relevant procs to wrap items/mobs.
 * Gifts and parcels are found under gifts.dm and sortingmachinery.dm respectively.
 */

/obj/item/stack/package_wrap
	abstract_type = /obj/item/stack/package_wrap
	singular_name = "sheet"
	amount = 25
	max_amount = 25
	item_flags = ITEM_FLAG_TRY_ATTACK
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
		var/obj/structure/bigDelivery/parcel = new /obj/structure/bigDelivery(get_turf(target.loc), target, package_type)
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

	if (get_amount() <= 0)
		new /obj/item/c_tube(loc)
		qdel(src)
	return


/obj/item/stack/package_wrap/use_on(obj/object, mob/user)
	if (!isobj(object) || istype(object, src))
		return FALSE
	if (istype(object, /obj/item/smallDelivery) || istype(object,/obj/structure/bigDelivery) || istype(object, /obj/item/evidencebag))
		to_chat(user, SPAN_WARNING("\The [object] is already wrapped."))
		return TRUE
	if (object.anchored)
		to_chat(user, SPAN_WARNING("\The [object] is bolted down and can't be wrapped."))
		return TRUE
	if (user in object)
		to_chat(user, SPAN_WARNING("You cannot wrap \the [object] while inside it."))
		return TRUE
	var/amount = get_amount()
	if (amount < 1)
		to_chat(user, SPAN_WARNING("\The [src] is out of [plural_name]."))
		return TRUE

	if (istype(object, /obj/item))
		var/obj/item/target = object
		var/a_used = target.get_storage_cost()
		if (target.w_class == ITEM_SIZE_NO_CONTAINER || target.w_class == ITEM_SIZE_GARGANTUAN)
			to_chat(user, SPAN_WARNING("\The [target] is too big to wrap!"))
			return TRUE
		if (user.isEquipped(target))
			to_chat(user, SPAN_WARNING("You must put down \the [target] in order to wrap it."))
			return TRUE
		if (amount < a_used)
			USE_FEEDBACK_STACK_NOT_ENOUGH(src, a_used, "to wrap \the [target]!")
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] starts wrapping \the [target] with \the [src]."),
			SPAN_NOTICE("You start wrapping \the [target] with \the [src].")
		)
		if (!do_after(user, target.w_class SECONDS, target, DO_PUBLIC_UNIQUE) || !user.use_sanity_check(target, src))
			return TRUE
		wrap_item(package_type, target, user)
		return TRUE

	if (istype(object, /obj/structure/closet/crate) || istype(object, /obj/structure/closet))
		var/item_size
		var/obj/structure/closet/target = object
		if (target.opened)
			return FALSE
		if (istype(object, /obj/structure/closet/crate))
			item_size = BASE_STORAGE_COST(ITEM_SIZE_NORMAL)
		else
			item_size = BASE_STORAGE_COST(ITEM_SIZE_LARGE)
		if (amount < item_size)
			USE_FEEDBACK_STACK_NOT_ENOUGH(src, item_size, "to wrap \the [target]!")
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] starts wrapping \the [target] with \the [src]."),
			SPAN_NOTICE("You start wrapping \the [target] with \the [src].")
		)
		if (!do_after(user, item_size SECONDS, target, DO_PUBLIC_UNIQUE) || !user.use_sanity_check(target, src))
			return TRUE
		wrap_item(package_type, target, user)
		return TRUE

/obj/item/stack/package_wrap/attack(mob/living/target, mob/living/user)
	if (!istype(target, /mob/living/carbon/human))
		return FALSE
	var/mob/living/carbon/human/H = target
	var/a_used = BASE_STORAGE_COST(ITEM_SIZE_LARGE) //get_storage_cost() does not work on mobs, will reproduce same logic here.

	if (get_amount() < a_used)
		USE_FEEDBACK_STACK_NOT_ENOUGH(src, a_used, "to wrap \the [target]!")
		return TRUE
	if (!H.has_danger_grab(user))
		to_chat(user, SPAN_WARNING("You need to have a firm grip on \the [target] in order to wrap them."))
		return TRUE
	H.visible_message(
		SPAN_NOTICE("\The [H] starts wrapping \the [target] with \the [src]."),
		SPAN_NOTICE("You start wrapping \the [target] with \the [src].")
	)
	if (!do_after(user, ITEM_SIZE_LARGE SECONDS, target, DO_PUBLIC_UNIQUE) || !H.has_danger_grab(user) || !user.use_sanity_check(H, src))
		return TRUE

	var/obj/mobpresent/present = new (H.loc, H, package_type)
	use(a_used)

	if (user == target)
		user.visible_message(
			SPAN_DANGER("\The [user] wraps themselves with [get_vague_name(TRUE)]."),
			SPAN_DANGER("You wrap yourself with [get_exact_name(a_used)].")
		)
	else
		user.visible_message(
			SPAN_DANGER("\The [user] wraps \the [target] with [get_vague_name(TRUE)]."),
			SPAN_DANGER("You wrap \the [target] with [get_exact_name(a_used)].")
		)

	H.forceMove(present)
	H.remove_grabs_and_pulls()
	admin_attack_log(user, H, "Used \a [src] to wrap their victim", "Was wrapepd with \a [src]", "used \the [src] to wrap")
	return TRUE
