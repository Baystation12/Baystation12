/obj/item/storage/box/mixedglasses
	name = "glassware box"
	desc = "A box of assorted glassware."
	can_hold = list(/obj/item/reagent_containers/food/drinks/glass2)

	startswith = list(
		/obj/item/reagent_containers/food/drinks/glass2/square,
		/obj/item/reagent_containers/food/drinks/glass2/rocks,
		/obj/item/reagent_containers/food/drinks/glass2/shake,
		/obj/item/reagent_containers/food/drinks/glass2/cocktail,
		/obj/item/reagent_containers/food/drinks/glass2/shot,
		/obj/item/reagent_containers/food/drinks/glass2/pint,
		/obj/item/reagent_containers/food/drinks/glass2/mug,
		/obj/item/reagent_containers/food/drinks/glass2/wine
	)

/obj/item/storage/box/mixedglasses/Initialize()
	. = ..()
	make_exact_fit()

/obj/item/storage/box/glasses
	name = "box of glasses"
	var/glass_type = /obj/item/reagent_containers/food/drinks/glass2
	can_hold = list(/obj/item/reagent_containers/food/drinks/glass2)

/obj/item/storage/box/glasses/Initialize()
	. = ..()

	for(var/i = 1 to 7)
		new glass_type(src)
	make_exact_fit()

/obj/item/storage/box/glasses/square
	name = "box of half-pint glasses"
	glass_type = /obj/item/reagent_containers/food/drinks/glass2/square

/obj/item/storage/box/glasses/rocks
	name = "box of rocks glasses"
	glass_type = /obj/item/reagent_containers/food/drinks/glass2/rocks

/obj/item/storage/box/glasses/shake
	name = "box of milkshake glasses"
	glass_type = /obj/item/reagent_containers/food/drinks/glass2/shake

/obj/item/storage/box/glasses/cocktail
	name = "box of cocktail glasses"
	glass_type = /obj/item/reagent_containers/food/drinks/glass2/cocktail

/obj/item/storage/box/glasses/shot
	name = "box of shot glasses"
	glass_type = /obj/item/reagent_containers/food/drinks/glass2/shot

/obj/item/storage/box/glasses/pint
	name = "box of pint glasses"
	glass_type = /obj/item/reagent_containers/food/drinks/glass2/pint

/obj/item/storage/box/glasses/mug
	name = "box of glass mugs"
	glass_type = /obj/item/reagent_containers/food/drinks/glass2/mug

/obj/item/storage/box/glasses/wine
	name = "box of wine glasses"
	glass_type = /obj/item/reagent_containers/food/drinks/glass2/wine

/obj/item/storage/box/glass_extras
	name = "box of cocktail garnishings"
	var/extra_type = /obj/item/glass_extra
	can_hold = list(/obj/item/glass_extra)
	storage_slots = 14

/obj/item/storage/box/glass_extras/Initialize()
	for(var/i = 1 to 14)
		new extra_type(src)
	. = ..()

/obj/item/storage/box/glass_extras/straws
	name = "box of straws"
	extra_type = /obj/item/glass_extra/straw

/obj/item/storage/box/glass_extras/sticks
	name = "box of drink sticks"
	extra_type = /obj/item/glass_extra/stick
