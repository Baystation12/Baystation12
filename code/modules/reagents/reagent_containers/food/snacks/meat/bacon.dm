/obj/item/reagent_containers/food/snacks/rawbacon
	name = "raw bacon"
	desc = "A raw, fatty strip of meat."
	icon_state = "rawbacon"
	filling_color = "#ffa7a3"
	bitesize = 1
	center_of_mass = "x=16;y=15"


/obj/item/reagent_containers/food/snacks/rawbacon/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 1)


/obj/item/reagent_containers/food/snacks/bacon
	name = "bacon"
	desc = "A delicious, crispy strip of meat."
	icon_state = "bacon"
	filling_color = "#cb5d27"
	bitesize = 2
	center_of_mass = "x=16;y=15"


/obj/item/reagent_containers/food/snacks/bacon/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 1)


/datum/recipe/bacon
	items = list(
		/obj/item/reagent_containers/food/snacks/rawbacon
	)
	result = /obj/item/reagent_containers/food/snacks/bacon


/obj/item/reagent_containers/food/snacks/rawbacon/bugmeat
	name = "raw sliced insect protein"
	desc = "A small mass of extruded bug stuff, lovingly cut thin."
	icon = 'packs/event_2022jul30/bugmeat.dmi'
	icon_state = "rawbacon"
	filling_color = "#7bc578"
	bitesize = 1
	center_of_mass = "x=16;y=16"
	nutriment_desc = list("soft, slimey flesh" = 10)


/obj/item/reagent_containers/food/snacks/bacon/bugmeat
	name = "sliced insect protein"
	desc = "A small mass of cooked extruded bug stuff, lovingly cut thin."
	icon = 'packs/event_2022jul30/bugmeat.dmi'
	icon_state = "bacon"
	filling_color = "#858040"
	bitesize = 2
	center_of_mass = "x=16;y=16"
	nutriment_desc = list("rubbery meat" = 10)


/datum/recipe/bugmeat_bacon
	items = list(
		/obj/item/reagent_containers/food/snacks/rawbacon/bugmeat
	)
	result = /obj/item/reagent_containers/food/snacks/bacon/bugmeat
