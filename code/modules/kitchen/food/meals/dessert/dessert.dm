/obj/item/weapon/reagent_containers/food/snacks/ricepudding
	name = "rice pudding"
	desc = "Where's the jam?"
	icon_state = "rpudding"
	filling_color = "#FFFBDB"

	New()
		..()
		reagents.add_reagent("nutriment", 4)

/obj/item/weapon/reagent_containers/food/snacks/chawanmushi
	name = "chawanmushi"
	desc = "A legendary egg custard that makes friends out of enemies. Probably too hot for a cat to eat."
	icon_state = "chawanmushi"
	filling_color = "#F0F2E4"

	New()
		..()
		reagents.add_reagent("protein", 5)
		bitesize = 1

/obj/item/weapon/reagent_containers/food/snacks/waffles
	name = "waffles"
	desc = "Mmm, waffles"
	icon_state = "waffles"
	filling_color = "#E6DEB5"

/obj/item/weapon/reagent_containers/food/snacks/waffles/New()
	..()
	reagents.add_reagent("nutriment", 8)

/obj/item/weapon/reagent_containers/food/snacks/pancakes
	name = "pancakes"
	desc = "Pass the syrup."
	icon_state = "waffles"
	filling_color = "#E6DEB5"

/obj/item/weapon/reagent_containers/food/snacks/pancakes/New()
	..()
	reagents.add_reagent("nutriment", 8)