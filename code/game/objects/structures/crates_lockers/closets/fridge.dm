/obj/structure/closet/kitchen
	name = "kitchen cabinet"

/obj/structure/closet/kitchen/WillContain()
	return list(
		/obj/item/reagent_containers/food/condiment/salt = 1,
		/obj/item/reagent_containers/food/condiment/spacespice = 1,
		/obj/item/reagent_containers/food/condiment/flour = 7,
		/obj/item/reagent_containers/food/condiment/sugar = 2,
		/obj/item/reagent_containers/glass/bottle/dye/polychromic = 2
	)

/obj/structure/closet/fridge
	name = "refrigerator"
	desc = "It's a refrigerated storage unit."
	icon = 'icons/obj/closets/fridge.dmi'
	icon_state = "closed_unlocked"
	closet_appearance = null

/obj/structure/closet/fridge/WillContain()
	return list(
		/obj/item/reagent_containers/food/drinks/milk = 6,
		/obj/item/reagent_containers/food/drinks/soymilk = 4,
		/obj/item/storage/fancy/egg_box/full = 4
	)

/obj/structure/closet/fridge/meat/WillContain()
	return list(
		/obj/item/storage/fancy/bugmeat = 8,
		/obj/item/reagent_containers/food/snacks/meat/chicken = 4,
		/obj/item/reagent_containers/food/snacks/meat/beef = 4,
		/obj/item/reagent_containers/food/snacks/cutlet/ham = 4,
		/obj/random/fish = 8
	)

/obj/structure/closet/fridge/extra/WillContain()
	return list(
		/obj/item/reagent_containers/food/snacks/grown/cabbage = rand(0, 4),
		/obj/item/reagent_containers/food/snacks/grown/lettuce = rand(0, 4),
		/obj/item/reagent_containers/food/snacks/grown/tomato = rand(0, 4),
		/obj/item/reagent_containers/food/snacks/grown/potato = rand(0, 4),
		/obj/item/reagent_containers/food/snacks/grown/carrots = rand(0, 4)
	)
