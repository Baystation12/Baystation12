/obj/item/weapon/reagent_containers/food/snacks/tofu
	name = "tofu"
	icon_state = "tofu"
	desc = "We all love tofu."
	filling_color = "#FFFEE0"
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/tofu/New()
	..()
	reagents.add_reagent("nutriment", 3)

/obj/item/weapon/reagent_containers/food/snacks/soydope
	name = "soy dope"
	desc = "Dope from a soy."
	icon_state = "soydope"
	filling_color = "#C4BF76"

/obj/item/weapon/reagent_containers/food/snacks/soydope/New()
	..()
	reagents.add_reagent("nutriment", 2)

/obj/item/weapon/reagent_containers/food/snacks/stewedsoymeat
	name = "stewed soy meat"
	desc = "Even non-vegetarians will LOVE this!"
	icon_state = "stewedsoymeat"

/obj/item/weapon/reagent_containers/food/snacks/stewedsoymeat/New()
	..()
	reagents.add_reagent("nutriment", 8)