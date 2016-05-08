/************
* Badassery *
************/
/datum/uplink_item/item/badassery
	category = /datum/uplink_category/badassery

/datum/uplink_item/item/badassery/balloon
	name = "For showing that You Are The BOSS (Useless Balloon)"
	item_cost = DEFAULT_TELECRYSTAL_AMOUNT
	path = /obj/item/toy/syndicateballoon

/datum/uplink_item/item/badassery/balloon/NT
	name = "For showing that you love NT SOO much (Useless Balloon)"
	path = /obj/item/toy/nanotrasenballoon

/**************
* Random Item *
**************/
/datum/uplink_item/item/badassery/random_one
	name = "Random Item"
	desc = "Buys you one random item."

/datum/uplink_item/item/badassery/random_one/buy(var/obj/item/device/uplink/U, var/mob/user)
	var/datum/uplink_item/item = default_uplink_selection.get_random_item(U.uses)
	return item.buy(U, user)

/datum/uplink_item/item/badassery/random_one/can_buy(obj/item/device/uplink/U)
	return default_uplink_selection.get_random_item(U.uses, U) != null

/datum/uplink_item/item/badassery/random_many
	name = "Random Items"
	desc = "Buys you as many random items you can afford. Convenient packaging NOT included."

/datum/uplink_item/item/badassery/random_many/cost(var/telecrystals, obj/item/device/uplink/U)
	return max(1, telecrystals)

/datum/uplink_item/item/badassery/random_many/get_goods(var/obj/item/device/uplink/U, var/loc)
	var/list/bought_items = list()
	for(var/datum/uplink_item/UI in get_random_uplink_items(U, U.uses, loc))
		UI.purchase_log(U)
		var/obj/item/I = UI.get_goods(U, loc)
		if(istype(I))
			bought_items += I

	return bought_items

/datum/uplink_item/item/badassery/random_many/purchase_log(obj/item/device/uplink/U)
	feedback_add_details("traitor_uplink_items_bought", "[src]")
	log_and_message_admins("used \the [U.loc] to buy \a [src]")

/****************
* Surplus Crate *
****************/
/datum/uplink_item/item/badassery/surplus
	name = "Surplus Crate"
	item_cost = DEFAULT_TELECRYSTAL_AMOUNT * 4
	var/item_worth = DEFAULT_TELECRYSTAL_AMOUNT * 6
	var/icon

/datum/uplink_item/item/badassery/surplus/New()
	..()
	antag_roles = list(MODE_MERCENARY)
	desc = "A crate containing [item_worth] telecrystal\s worth of surplus leftovers."

/datum/uplink_item/item/badassery/surplus/get_goods(var/obj/item/device/uplink/U, var/loc)
	var/obj/structure/largecrate/C = new(loc)
	var/random_items = get_random_uplink_items(null, item_worth, C)
	for(var/datum/uplink_item/I in random_items)
		I.purchase_log(U)
		I.get_goods(U, C)

	return C

/datum/uplink_item/item/badassery/surplus/log_icon()
	if(!icon)
		var/obj/structure/largecrate/C = /obj/structure/largecrate
		icon = image(initial(C.icon), initial(C.icon_state))

	return "\icon[icon]"
