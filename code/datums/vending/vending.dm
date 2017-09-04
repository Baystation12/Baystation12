#define CAT_NORMAL 1
#define CAT_HIDDEN 2  // also used in corresponding wires/vending.dm
#define CAT_COIN   4

/**
 *  Datum used to hold information about a product in a vending machine
 */

/datum/stored_items/vending_products
	item_name = "generic" // Display name for the product
	var/price = 0              // Price to buy one
	var/display_color = null   // Display color for vending machine listing
	var/category = CAT_NORMAL  // CAT_HIDDEN for contraband, CAT_COIN for premium

/datum/stored_items/vending_products/New(var/atom/storing_object, var/path, var/name = null, var/amount = 0, var/price = 0, var/color = null, var/category = CAT_NORMAL)
	..()
	src.price = price
	src.display_color = color
	src.category = category
