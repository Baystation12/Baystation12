/obj/item/weapon/reagent_containers/food/snacks/vegetable
	icon = 'icons/obj/kitchen/staples/grown.dmi'
	var/base_grown = "potato"

/obj/item/weapon/reagent_containers/food/snacks/vegetable/New()
	..()
	reagents.add_reagent("nutriment", 4)

/obj/item/weapon/reagent_containers/food/snacks/vegetable/rawsticks
	name = "raw potato sticks"
	desc = "Raw fries, not very tasty."
	icon_state = "rawsticks"

/obj/item/weapon/reagent_containers/food/snacks/vegetable/fries
	name = "potato fries"
	desc = "Chips, if you're Space British."
	icon_state = "fries"

/obj/item/weapon/reagent_containers/food/snacks/vegetable/hash
	name = "diced"
	desc = "Diced-up vegetables."
	icon_state = "rawsticks"

/obj/item/weapon/reagent_containers/food/snacks/vegetable/friedhash
	name = "hashbrown"
	desc = "A fried vegetable cake made from "
	icon_state = "rawsticks"
