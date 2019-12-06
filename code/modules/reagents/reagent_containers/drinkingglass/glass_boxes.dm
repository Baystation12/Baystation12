/obj/item/weapon/storage/box/mixedglasses
	name = "glassware box"
	desc = "A box of assorted glassware"
	can_hold = list(/obj/item/weapon/reagent_containers/food/drinks/glass2)

	startswith = list(
		/obj/item/weapon/reagent_containers/food/drinks/glass2/square,
		/obj/item/weapon/reagent_containers/food/drinks/glass2/rocks,
		/obj/item/weapon/reagent_containers/food/drinks/glass2/shake,
		/obj/item/weapon/reagent_containers/food/drinks/glass2/cocktail,
		/obj/item/weapon/reagent_containers/food/drinks/glass2/shot,
		/obj/item/weapon/reagent_containers/food/drinks/glass2/pint,
		/obj/item/weapon/reagent_containers/food/drinks/glass2/mug,
		/obj/item/weapon/reagent_containers/food/drinks/glass2/wine
	)

/obj/item/weapon/storage/box/mixedglasses/Initialize()
	. = ..()
	make_exact_fit()

/obj/item/weapon/storage/box/glasses
	name = "box of glasses"
	var/glass_type = /obj/item/weapon/reagent_containers/food/drinks/glass2
	can_hold = list(/obj/item/weapon/reagent_containers/food/drinks/glass2)

/obj/item/weapon/storage/box/glasses/Initialize()
	. = ..()

	for(var/i = 1 to 7)
		new glass_type(src)
	make_exact_fit()

/obj/item/weapon/storage/box/glasses/square
	name = "box of half-pint glasses"
	glass_type = /obj/item/weapon/reagent_containers/food/drinks/glass2/square

/obj/item/weapon/storage/box/glasses/rocks
	name = "box of rocks glasses"
	glass_type = /obj/item/weapon/reagent_containers/food/drinks/glass2/rocks

/obj/item/weapon/storage/box/glasses/shake
	name = "box of milkshake glasses"
	glass_type = /obj/item/weapon/reagent_containers/food/drinks/glass2/shake

/obj/item/weapon/storage/box/glasses/cocktail
	name = "box of cocktail glasses"
	glass_type = /obj/item/weapon/reagent_containers/food/drinks/glass2/cocktail

/obj/item/weapon/storage/box/glasses/shot
	name = "box of shot glasses"
	glass_type = /obj/item/weapon/reagent_containers/food/drinks/glass2/shot

/obj/item/weapon/storage/box/glasses/pint
	name = "box of pint glasses"
	glass_type = /obj/item/weapon/reagent_containers/food/drinks/glass2/pint

/obj/item/weapon/storage/box/glasses/mug
	name = "box of glass mugs"
	glass_type = /obj/item/weapon/reagent_containers/food/drinks/glass2/mug

/obj/item/weapon/storage/box/glasses/wine
	name = "box of wine glasses"
	glass_type = /obj/item/weapon/reagent_containers/food/drinks/glass2/wine

/obj/item/weapon/storage/box/glass_extras
	name = "box of cocktail garnishings"
	var/extra_type = /obj/item/weapon/glass_extra
	can_hold = list(/obj/item/weapon/glass_extra)
	storage_slots = 14

/obj/item/weapon/storage/box/glass_extras/Initialize()
	for(var/i = 1 to 14)
		new extra_type(src)
	. = ..()

/obj/item/weapon/storage/box/glass_extras/straws
	name = "box of straws"
	extra_type = /obj/item/weapon/glass_extra/straw

/obj/item/weapon/storage/box/glass_extras/sticks
	name = "box of drink sticks"
	extra_type = /obj/item/weapon/glass_extra/stick
