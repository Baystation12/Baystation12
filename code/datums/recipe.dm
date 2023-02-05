/datum/microwave_recipe
	/// An /atom/movable/... path. Required.
	var/atom/result_path

	/// A base ds time for how long the recipe waits before completing.
	var/time = 10 SECONDS

	/// A map? of (/datum/reagent/... = amount). Highest specificity first.
	var/list/datum/reagent/required_reagents

	/// A list? of (/obj/item/...). Highest specificity first. Multiple entries for multiple same items.
	var/list/obj/item/required_items

	/// A map? of ("fruit tag" = amount).
	var/list/required_produce

	/// The sum of required_produce entries. Generated.
	var/produce_amount

	/// The sum length of each required_* for sorting. Generated. Must be > 0.
	var/weight

	// Codex values.
	var/display_name
	var/hidden_from_codex
	var/lore_text
	var/mechanics_text
	var/antag_text


/datum/microwave_recipe/proc/CreateResult(obj/machinery/microwave/microwave)
	var/atom/movable/result = new result_path (microwave)
	microwave.reagents.clear_reagents()
	if (!length(microwave.ingredients))
		return result
	for (var/obj/item/item as anything in microwave.ingredients)
		var/datum/reagents/reagents = item.reagents
		if (reagents)
			reagents.del_reagent(/datum/reagent/nutriment)
			reagents.update_total()
			if (ismob(result))
				reagents.trans_to_mob(result, reagents.total_volume)
			else
				reagents.trans_to_obj(result, reagents.total_volume)
		if (istype(item, /obj/item/holder))
			var/obj/item/holder/holder = item
			holder.destroy_all()
		qdel(item)
	return result


/datum/microwave_recipe/proc/CheckReagents(obj/machinery/microwave/microwave)
	var/required_count = length(required_reagents)
	if (!required_count)
		return TRUE
	var/datum/reagents/reagents = microwave.reagents
	if (required_count > length(reagents.reagent_list))
		return FALSE
	for (var/datum/reagent/reagent as anything in required_reagents)
		var/amount = reagents.get_reagent_amount(reagent)
		if (!amount || abs(required_reagents[reagent] - amount) > 0.5)
			return FALSE
	return TRUE


/datum/microwave_recipe/proc/CheckProduce(obj/machinery/microwave/microwave)
	if (!produce_amount)
		return TRUE
	if (produce_amount > length(microwave.ingredients))
		return FALSE
	var/list/remaining_produce = required_produce.Copy()
	for (var/obj/item/reagent_containers/food/snacks/grown/grown in microwave.ingredients)
		var/tag = grown.seed?.kitchen_tag
		if (!tag)
			return FALSE
		if (--remaining_produce[tag] < 0)
			return FALSE
	for (var/tag in remaining_produce)
		if (remaining_produce[tag])
			return FALSE
	return TRUE


/datum/microwave_recipe/proc/CheckItems(obj/machinery/microwave/microwave)
	var/required_count = length(required_items)
	if (!required_count)
		return TRUE
	if (required_count > length(microwave.ingredients))
		return FALSE
	var/list/remaining = required_items.Copy()
	for (var/obj/item/item as anything in microwave.ingredients)
		if (istype(item, /obj/item/reagent_containers/food/snacks/grown))
			continue
		var/remaining_count = length(remaining)
		if (!remaining_count)
			return FALSE
		var/found
		for (var/i = 1 to length(remaining))
			if (istype(item, remaining[i]))
				remaining.Cut(i, i + 1)
				found = TRUE
				break
		if (!found)
			return FALSE
	if (length(remaining))
		return FALSE
	return TRUE
