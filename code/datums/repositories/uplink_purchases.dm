var/repository/uplink_purchases/uplink_purchase_repository = new()

/repository/uplink_purchases
	var/list/purchases_by_mind

/repository/uplink_purchases/New()
	purchases_by_mind = list()

/repository/uplink_purchases/proc/add_entry(var/datum/mind/m, var/item, var/cost)
	var/uplink_purchase_entry/upe = purchases_by_mind[m]
	if(!upe)
		upe = new()
		purchases_by_mind[m] = upe
	upe.add_entry(item, cost)

/repository/uplink_purchases/proc/print_entries()
	if(purchases_by_mind.len)
		to_world("<b>The following went shopping:</b>")

	var/list/pur_log = list()
	for(var/datum/mind/ply in purchases_by_mind)
		pur_log.Cut()
		var/uplink_purchase_entry/upe = purchases_by_mind[ply]
		to_world("<b>[ply.name]</b> (<b>[ply.key]</b>) (used [upe.total_cost] TC\s):")

		for(var/datum/uplink_item/UI in upe.purchased_items)
			pur_log += "[upe.purchased_items[UI]]x[UI.log_icon()][UI.name]"
		to_world(english_list(pur_log, nothing_text = ""))


/proc/debug_print()
	uplink_purchase_repository.print_entries()

/uplink_purchase_entry
	var/total_cost
	var/list/purchased_items

/uplink_purchase_entry/New()
	purchased_items = new()

/uplink_purchase_entry/proc/add_entry(var/item, var/cost)
	total_cost += cost
	purchased_items[item] = purchased_items[item] + 1
