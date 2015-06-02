/obj/item/weapon/reagent_containers/food/snacks/badrecipe
	name = "burned mess"
	desc = "Someone should be demoted from chef for this."
	icon = 'icons/obj/kitchen/inedible/misc.dmi'
	icon_state = "badrecipe"
	filling_color = "#211F02"

/obj/item/weapon/reagent_containers/food/snacks/badrecipe/New()
	..()
	reagents.add_reagent("toxin", 1)
	reagents.add_reagent("carbon", 3)

