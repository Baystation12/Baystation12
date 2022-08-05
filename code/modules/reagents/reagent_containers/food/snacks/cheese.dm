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


/obj/item/reagent_containers/food/snacks/sliceable/cheesewheel/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 10)


/obj/item/reagent_containers/food/snacks/cheesewedge
	abstract_type = /obj/item/reagent_containers/food/snacks/cheesewedge
	name = "parent cheese wedge"
	desc = "A slice of impossible dreams."
	icon_state = "cheesewedge"
	filling_color = "#fff700"
	bitesize = 2
	center_of_mass = "x=16;y=10"


/obj/item/reagent_containers/food/snacks/cheesewedge/Initialize()
	. = ..()
	if (!reagents.has_reagent(/datum/reagent/nutriment))
		reagents.add_reagent(/datum/reagent/nutriment, 2, nutriment_desc)
	if (!reagents.has_reagent(/datum/reagent/nutriment/protein))
		reagents.add_reagent(/datum/reagent/nutriment/protein, 2)


/obj/item/reagent_containers/food/snacks/sliceable/cheesewheel/fresh
	name = "fresh cheese wheel"
	desc = "A wheel of soft, fresh cheese."
	icon_state = "cheesewheel-fresh"
	filling_color = "#fffddd"
	nutriment_desc = list("mild cheese" = 10)
	slice_path = /obj/item/reagent_containers/food/snacks/cheesewedge/fresh


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
	intensity = /decl/scent_intensity
	descriptor = SCENT_DESC_ODOR
	range = 2


/datum/recipe/cheesewheel_aged
	reagents = list(
		/datum/reagent/enzyme = 5,
		/datum/reagent/sodiumchloride = 10
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/cheesewheel
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cheesewheel/aged


/datum/recipe/cheesewedge_aged
	reagents = list(
		/datum/reagent/enzyme = 1,
		/datum/reagent/sodiumchloride = 2
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/cheesewedge/aged


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
	intensity = /decl/scent_intensity/strong
	descriptor = SCENT_DESC_ODOR
	range = 3


/datum/recipe/cheesewheel_blue
	reagents = list(
		/datum/reagent/enzyme = 5,
		/datum/reagent/sodiumchloride = 5,
		/datum/reagent/drink/kefir = 5
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/cheesewheel
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cheesewheel/blue


/datum/recipe/cheesewedge_blue
	reagents = list(
		/datum/reagent/enzyme = 1,
		/datum/reagent/sodiumchloride = 1,
		/datum/reagent/drink/kefir = 1
	)
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/cheesewedge/blue
