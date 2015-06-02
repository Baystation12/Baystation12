/obj/item/weapon/reagent_containers/food/snacks/stuffing
	name = "breadcrumb stuffing"
	desc = "Moist, peppery breadcrumbs for filling the body cavities of dead birds. Dig in!"
	icon_state = "stuffing"
	filling_color = "#C9AC83"

/obj/item/weapon/reagent_containers/food/snacks/stuffing/New()
	..()
	reagents.add_reagent("nutriment", 3)
	bitesize = 1