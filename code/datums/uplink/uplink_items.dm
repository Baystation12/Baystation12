var/global/datum/uplink/uplink = new()

/datum/uplink
	var/list/items_assoc
	var/list/datum/uplink_item/items
	var/list/datum/uplink_category/categories

/datum/uplink/New()
	items_assoc = list()
	items = init_subtypes(/datum/uplink_item)
	categories = init_subtypes(/datum/uplink_category)
	categories = dd_sortedObjectList(categories)

	for(var/datum/uplink_item/item in items)
		if(!item.name)
			items -= item
			continue

		items_assoc[item.type] = item

		for(var/datum/uplink_category/category in categories)
			if(item.category == category.type)
				category.items += item
				item.category = category

	for(var/datum/uplink_category/category in categories)
		category.items = dd_sortedObjectList(category.items)

/datum/uplink_item
	var/name
	var/desc
	var/item_cost = 0
	var/list/antag_costs = list()			// Allows specific antag roles to purchase at a different cost
	var/datum/uplink_category/category		// Item category
	var/list/datum/antagonist/antag_roles	// Antag roles this item is displayed to. If empty, display to all. If it includes 'Exclude", anybody except this role can view it

/datum/uplink_item/item
	var/path = null

/datum/uplink_item/proc/buy(obj/item/device/uplink/U, mob/user)
	var/extra_args = extra_args(user)
	if(!extra_args)
		return

	if(!can_buy(U))
		return

	var/cost = cost(U.uses, U)

	var/goods = get_goods(U, get_turf(user), user, extra_args)
	if(!goods)
		return

	purchase_log(U, user, cost)
	U.uses -= cost
	U.used_TC += cost
	return goods

// Any additional arguments you wish to send to the get_goods
/datum/uplink_item/proc/extra_args(mob/user)
	return 1

/datum/uplink_item/proc/can_buy(obj/item/device/uplink/U)
	if(cost(U.uses, U) > U.uses)
		return 0

	return can_view(U)

/datum/uplink_item/proc/can_view(obj/item/device/uplink/U)
	if (!length(antag_roles))
		return TRUE
	if (!U?.uplink_owner)
		return FALSE
	for (var/antag_role in antag_roles)
		if (antag_role == "Exclude")
			continue
		var/datum/antagonist/antag = GLOB.all_antag_types_[antag_role]
		if (!antag)
			log_debug({"Invalid antag_role "[antag_role]" in [src.type]"})
			continue
		if (antag.is_antagonist(U.uplink_owner))
			return !("Exclude" in antag_roles)
	return ("Exclude" in antag_roles)

/datum/uplink_item/proc/cost(telecrystals, obj/item/device/uplink/U)
	. = item_cost
	if(U && U.uplink_owner)
		for(var/antag_role in antag_costs)
			var/datum/antagonist/antag = GLOB.all_antag_types_[antag_role]
			if(antag.is_antagonist(U.uplink_owner))
				. = min(antag_costs[antag_role], .)
	return max(1, U ?  U.get_item_cost(src, .) : .)

/datum/uplink_item/proc/name()
	return name

/datum/uplink_item/proc/description()
	return desc

// get_goods does not necessarily return physical objects, it is simply a way to acquire the uplink item without paying
/datum/uplink_item/proc/get_goods(obj/item/device/uplink/U, loc)
	return 0

/datum/uplink_item/proc/log_icon()
	return

/datum/uplink_item/proc/purchase_log(obj/item/device/uplink/U, mob/user, cost)
	log_and_message_admins("used \the [U.loc] to buy \a [src]")
	if(user)
		uplink_purchase_repository.add_entry(user.mind, src, cost)

/datum/uplink_item/dd_SortValue()
	return cost(INFINITY, null)

/********************************
*                           	*
*	Physical Uplink Entries		*
*                           	*
********************************/
/datum/uplink_item/item/buy(obj/item/device/uplink/U, mob/user)
	var/obj/item/I = ..()
	if(!I)
		return

	if(istype(I, /list))
		var/list/L = I
		if(length(L)) I = L[1]

	if(istype(I) && ishuman(user))
		var/mob/living/carbon/human/A = user
		A.put_in_any_hand_if_possible(I)
	return I

/datum/uplink_item/item/get_goods(obj/item/device/uplink/U, loc)
	var/obj/item/I = new path(loc)
	return I

/datum/uplink_item/item/description()
	if(!desc)
		// Fallback description
		var/obj/temp = src.path
		desc = initial(temp.desc)
	return ..()

/datum/uplink_item/item/log_icon()
	var/obj/I = path
	return "\icon[I]"

/****************
* Support procs *
****************/
/proc/get_random_uplink_items(obj/item/device/uplink/U, remaining_TC, loc)
	var/list/bought_items = list()
	while(remaining_TC)
		var/datum/uplink_random_selection/uplink_selection = get_uplink_random_selection_by_type(/datum/uplink_random_selection/default)
		var/datum/uplink_item/I = uplink_selection.get_random_item(remaining_TC, U, bought_items)
		if(!I)
			break
		bought_items += I
		remaining_TC -= I.cost(remaining_TC, U)

	return bought_items
