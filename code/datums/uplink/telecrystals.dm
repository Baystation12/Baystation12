/***************
* Telecrystals *
***************/
/datum/uplink_item/item/telecrystal
	category = /datum/uplink_category/telecrystals
	desc = "Acquire the uplink crystals in pure form."

/datum/uplink_item/item/telecrystal/get_goods(var/obj/item/device/uplink/U, var/loc)
	return new /obj/item/stack/telecrystal(loc, cost(U.uses, U))

/datum/uplink_item/item/telecrystal/one
	name = "1x Telecrystal"
	desc = "Remove 1 telecrystal from this uplink."
	item_cost = 1

/datum/uplink_item/item/telecrystal/five
	name = "5x Telecrystals"
	desc = "Remove 5 telecrystals from this uplink."
	item_cost = 5

/datum/uplink_item/item/telecrystal/ten
	name = "10x Telecrystals"
	desc = "Remove 10 telecrystals from this uplink."
	item_cost = 10

/datum/uplink_item/item/telecrystal/twentyfive
	name = "25x Telecrystals"
	desc = "Remove 25 telecrystals from this uplink."
	item_cost = 25

/datum/uplink_item/item/telecrystal/fifty
	name = "50x Telecrystals"
	desc = "Remove 50 telecrystals from this uplink."
	item_cost = 50

/datum/uplink_item/item/telecrystal/all
	name = "Empty Uplink"
	desc = "Completely empties this uplink of all remaining telecrystals."

/datum/uplink_item/item/telecrystal/all/cost(var/telecrystals, obj/item/device/uplink/U)
	return max(1, telecrystals)
