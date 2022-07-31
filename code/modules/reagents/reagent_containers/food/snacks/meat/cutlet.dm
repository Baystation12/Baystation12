/obj/item/reagent_containers/food/snacks/rawcutlet
	name = "raw cutlet"
	desc = "A thin piece of raw meat."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "rawcutlet"
	filling_color = "#fb8258"
	slice_path = /obj/item/reagent_containers/food/snacks/rawbacon
	slices_num = 2
	bitesize = 1
	center_of_mass = "x=17;y=20"


/obj/item/reagent_containers/food/snacks/rawcutlet/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 1)


/obj/item/reagent_containers/food/snacks/cutlet
	name = "cutlet"
	desc = "A tasty meat slice."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "cutlet"
	filling_color = "#d75608"
	bitesize = 2
	center_of_mass = "x=17;y=20"


/obj/item/reagent_containers/food/snacks/cutlet/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 2)


/datum/recipe/cutlet
	items = list(
		/obj/item/reagent_containers/food/snacks/rawcutlet
	)
	result = /obj/item/reagent_containers/food/snacks/cutlet


/obj/item/reagent_containers/food/snacks/rawcutlet/bugmeat
	name = "raw insect protein"
	desc = "A small mass of extruded bug stuff."
	icon = 'packs/event_2022jul30/bugmeat.dmi'
	icon_state = "rawcutlet"
	filling_color = "#7bc578"
	slice_path = /obj/item/reagent_containers/food/snacks/rawbacon/bugmeat
	slices_num = 2
	bitesize = 1
	center_of_mass = "x=16;y=16"
	nutriment_desc = list("soft, slimey flesh" = 10)


/obj/item/reagent_containers/food/snacks/cutlet/bugmeat
	name = "insect protein"
	desc = "A small mass of cooked extruded bug stuff."
	icon = 'packs/event_2022jul30/bugmeat.dmi'
	icon_state = "cutlet"
	filling_color = "#858040"
	slice_path = /obj/item/reagent_containers/food/snacks/bacon/bugmeat
	slices_num = 2
	bitesize = 2
	center_of_mass = "x=16;y=16"
	nutriment_desc = list("rubbery meat" = 10)


/datum/recipe/bugmeat_cutlet
	items = list(
		/obj/item/reagent_containers/food/snacks/rawcutlet/bugmeat
	)
	result = /obj/item/reagent_containers/food/snacks/cutlet/bugmeat


/obj/item/reagent_containers/food/snacks/rawcutlet/chicken
	name = "raw chicken"
	iconstate = "rawchicken"
	filling_color = "#e9a690"
	slice_path = /obj/item/reagent_containers/food/snacks/rawbacon/chicken


/obj/item/reagent_containers/food/snacks/cutlet/chicken
