/obj/item/storage/fancy/bugmeat
	name = "box of insect protein"
	desc = "What a horrible idea. Who funded this?"
	icon = 'icons/obj/food/food_bugmeat.dmi'
	icon_state = "box"
	open_sound = 'sound/effects/storage/box.ogg'
	storage_slots = 6
	max_w_class = ITEM_SIZE_SMALL
	w_class = ITEM_SIZE_NORMAL
	key_type = list(/obj/item/reagent_containers/food/snacks/rawcutlet/bugmeat)
	contents_allowed = list(
		/obj/item/reagent_containers/food/snacks/rawcutlet/bugmeat,
		/obj/item/reagent_containers/food/snacks/cutlet/bugmeat
	)
	startswith = list(
		/obj/item/reagent_containers/food/snacks/rawcutlet/bugmeat = 6
	)


/obj/item/storage/fancy/bugmeat/on_update_icon()
	if (opened)
		icon_state = "box-open"
	else
		icon_state = "box"


/obj/item/reagent_containers/food/snacks/rawcutlet/bugmeat
	name = "raw insect protein"
	desc = "A small mass of extruded bug stuff."
	icon = 'icons/obj/food/food_bugmeat.dmi'
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
	icon = 'icons/obj/food/food_bugmeat.dmi'
	icon_state = "cutlet"
	filling_color = "#858040"
	slice_path = /obj/item/reagent_containers/food/snacks/bacon/bugmeat
	slices_num = 2
	bitesize = 2
	center_of_mass = "x=16;y=16"
	nutriment_desc = list("rubbery meat" = 10)


/obj/item/reagent_containers/food/snacks/rawbacon/bugmeat
	name = "raw sliced insect protein"
	desc = "A small mass of extruded bug stuff, lovingly cut thin."
	icon = 'icons/obj/food/food_bugmeat.dmi'
	icon_state = "rawbacon"
	filling_color = "#7bc578"
	bitesize = 1
	center_of_mass = "x=16;y=16"
	nutriment_desc = list("soft, slimey flesh" = 10)


/obj/item/reagent_containers/food/snacks/bacon/bugmeat
	name = "sliced insect protein"
	desc = "A small mass of cooked extruded bug stuff, lovingly cut thin."
	icon = 'icons/obj/food/food_bugmeat.dmi'
	icon_state = "bacon"
	filling_color = "#858040"
	bitesize = 2
	center_of_mass = "x=16;y=16"
	nutriment_desc = list("rubbery meat" = 10)


/datum/microwave_recipe/bugmeat_cutlet
	required_items = list(
		/obj/item/reagent_containers/food/snacks/rawcutlet/bugmeat
	)
	result_path = /obj/item/reagent_containers/food/snacks/cutlet/bugmeat


/datum/microwave_recipe/bugmeat_bacon
	required_items = list(
		/obj/item/reagent_containers/food/snacks/rawbacon/bugmeat
	)
	result_path = /obj/item/reagent_containers/food/snacks/bacon/bugmeat


/singleton/hierarchy/supply_pack/galley/bugmeat
	name = "Perishables - Insect Protein"
	contains = list(/obj/item/storage/fancy/bugmeat = 2)
	containertype = /obj/item/storage/backpack/dufflebag
	containername = "insect protein dufflebag"
	cost = 20
