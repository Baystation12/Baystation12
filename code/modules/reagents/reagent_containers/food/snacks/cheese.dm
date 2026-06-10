/obj/item/reagent_containers/food/snacks/sliceable/cheesewheel
	abstract_type = /obj/item/reagent_containers/food/snacks/sliceable/cheesewheel
	name = "parent cheese wheel"
	desc = "A wheel of impossible dreams."
	icon_state = "cheesewheel"
	slice_path = /obj/item/reagent_containers/food/snacks/cheesewedge
	slices_num = 5
	filling_color = "#fff700"
	center_of_mass = "x=16;y=10"
	nutriment_amt = 10
	bitesize = 2

/obj/item/reagent_containers/food/snacks/cheesewedge
	abstract_type = /obj/item/reagent_containers/food/snacks/cheesewedge
	name = "parent cheese wedge"
	desc = "A slice of impossible dreams."
	icon_state = "cheesewedge"
	filling_color = "#fff700"
	bitesize = 2
	center_of_mass = "x=16;y=10"
	nutriment_amt = 2

/obj/item/reagent_containers/food/snacks/sliceable/cheesewheel/fresh
	name = "fresh cheese wheel"
	desc = "A wheel of soft, fresh cheese."
	icon_state = "cheesewheel-fresh"
	filling_color = "#fffddd"
	nutriment_desc = list("mild cheese" = 10)
	slice_path = /obj/item/reagent_containers/food/snacks/cheesewedge/fresh

/obj/item/reagent_containers/food/snacks/sliceable/cheesewheel/fresh/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein/cheese, 10)

/obj/item/reagent_containers/food/snacks/cheesewedge/fresh
	name = "fresh cheese wedge"
	desc = "A wedge of soft, fresh cheese."
	icon_state = "cheesewedge-fresh"
	filling_color = "#fffddd"
	nutriment_desc = list("mild cheese" = 10)


/obj/item/reagent_containers/food/snacks/cheesewedge/fresh/Initialize()
	. = ..()



/obj/item/reagent_containers/food/snacks/sliceable/cheesewheel/aged
	name = "aged cheese wheel"
	desc = "A wheel of firm, sharp cheese."
	filling_color = "#fff700"
	nutriment_desc = list("sharp cheese" = 10)
	slice_path = /obj/item/reagent_containers/food/snacks/cheesewedge/aged
	scent_extension = /datum/extension/scent/cheese_aged


/obj/item/reagent_containers/food/snacks/cheesewedge/aged
	name = "aged cheese wedge"
	desc = "A wedge of firm, sharp cheese."
	filling_color = "#fff700"
	nutriment_desc = list("sharp cheese" = 10)
	scent_extension = /datum/extension/scent/cheese_aged


/datum/extension/scent/cheese_aged
	scent = "sharp cheese"
	intensity = /singleton/scent_intensity
	descriptor = SCENT_DESC_ODOR
	range = 2


/obj/item/reagent_containers/food/snacks/sliceable/cheesewheel/blue
	name = "blue cheese wheel"
	desc = "A wheel of intense blue cheese."
	icon_state = "cheesewheel-blue"
	filling_color = "#9eee86"
	nutriment_desc = list("funky cheese" = 10)
	slice_path = /obj/item/reagent_containers/food/snacks/cheesewedge/blue
	scent_extension = /datum/extension/scent/cheese_blue


/obj/item/reagent_containers/food/snacks/cheesewedge/blue
	name = "blue cheese wedge"
	desc = "A wedge of intense blue cheese."
	icon_state = "cheesewedge-blue"
	filling_color = "#9eee86"
	nutriment_desc = list("funky cheese" = 10)
	scent_extension = /datum/extension/scent/cheese_blue


/datum/extension/scent/cheese_blue
	scent = "funky cheese"
	intensity = /singleton/scent_intensity/strong
	descriptor = SCENT_DESC_ODOR
	range = 3

/obj/item/reagent_containers/food/snacks/sliceable/cheesewheel/mozzarella
	name = "lump of mozzarella"
	desc = "A lump of mozzarella cheese."
	icon_state = "cheesewheel-mozz"
	filling_color = "#9eee86"
	nutriment_desc = list("mild and stretchy cheese" = 10)
	slice_path = /obj/item/reagent_containers/food/snacks/cheesewedge/mozz

/obj/item/reagent_containers/food/snacks/cheesewedge/mozz
	name = "slice of mozzarella"
	desc = "A slice of soft, stretchy mozzarella."
	icon_state = "cheesewedge-mozz"
	filling_color = "#9eee86"
	nutriment_desc = list("mild and stretchy" = 10)

/obj/item/reagent_containers/food/snacks/sliceable/cheesewheel/burrata
	name = "lump of burrata"
	desc = "A lump of burrata cheese."
	icon_state = "cheesewheel-burrata"
	filling_color = "#9eee86"
	nutriment_desc = list("mild and soft cheese" = 10)
	slice_path = /obj/item/reagent_containers/food/snacks/cheesewedge/burrata

/obj/item/reagent_containers/food/snacks/cheesewedge/burrata
	name = "slice of burrata"
	desc = "A slice of burrata cheese."
	icon_state = "cheesewedge-burrata"
	filling_color = "#9eee86"
	nutriment_desc = list("mild and soft cheese" = 10)