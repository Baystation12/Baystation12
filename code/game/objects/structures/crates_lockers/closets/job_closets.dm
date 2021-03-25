/* Closets for specific jobs
 * Contains:
 *		Bartender
 *		Janitor
 *		Lawyer
 */

/*
 * Bartender
 */
/obj/structure/closet/gmcloset
	name = "formal closet"
	desc = "It's a storage unit for formal clothing."
	closet_appearance = /decl/closet_appearance/wardrobe/black

/obj/structure/closet/gmcloset/WillContain()
	return list(
		/obj/item/clothing/head/that = 2,
		/obj/item/device/radio/headset/headset_service = 2,
		/obj/item/clothing/head/hairflower,
		/obj/item/clothing/head/hairflower/pink,
		/obj/item/clothing/head/hairflower/yellow,
		/obj/item/clothing/head/hairflower/blue,
		/obj/item/clothing/under/sl_suit = 2,
		/obj/item/clothing/under/rank/bartender = 2,
		/obj/item/clothing/under/dress/dress_saloon,
		/obj/item/clothing/accessory/wcoat/black = 2,
		/obj/item/clothing/shoes/black = 2
	)

/*
 * Chef
 */
/obj/structure/closet/chefcloset
	name = "chef's closet"
	desc = "It's a storage unit for foodservice garments."
	closet_appearance = /decl/closet_appearance/wardrobe/black

/obj/structure/closet/chefcloset/WillContain()
	return list(
		/obj/item/clothing/under/sundress,
		/obj/item/clothing/under/waiter = 2,
		/obj/item/device/radio/headset/headset_service = 2,
		/obj/item/storage/box/mousetraps = 2,
		/obj/item/clothing/under/rank/chef,
		/obj/item/clothing/head/chefhat
	)

/*
 * Janitor
 */
/obj/structure/closet/jcloset
	name = "custodial closet"
	desc = "It's a storage unit for janitorial clothes and gear."
	closet_appearance = /decl/closet_appearance/wardrobe/mixed

/obj/structure/closet/jcloset/WillContain()
	return list(
		/obj/item/clothing/under/rank/janitor,
		/obj/item/device/radio/headset/headset_service,
		/obj/item/clothing/gloves/thick,
		/obj/item/clothing/head/soft/purple,
		/obj/item/clothing/head/beret/purple,
		/obj/item/device/flashlight,
		/obj/item/caution = 4,
		/obj/item/device/lightreplacer,
		/obj/item/storage/bag/trash,
		/obj/item/clothing/shoes/galoshes,
		/obj/item/soap,
		/obj/item/storage/belt/janitor
	)

/*
 * Lawyer
 */
/obj/structure/closet/lawcloset
	name = "legal closet"
	desc = "It's a storage unit for courtroom apparel and items."
	closet_appearance = /decl/closet_appearance/wardrobe


/obj/structure/closet/lawcloset/WillContain()
	return list(
		/obj/item/clothing/under/lawyer/female,
		/obj/item/clothing/under/lawyer/black,
		/obj/item/clothing/under/lawyer/red,
		/obj/item/clothing/under/lawyer/bluesuit,
		/obj/item/clothing/suit/storage/toggle/suit/blue,
		/obj/item/clothing/under/lawyer/purpsuit,
		/obj/item/clothing/suit/storage/toggle/suit/purple,
		/obj/item/clothing/shoes/brown,
		/obj/item/clothing/shoes/black
	)
