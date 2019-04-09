/datum/stack_recipe/rod
	title = "rod"
	result_type = /obj/item/stack/material/rods
	res_amount = 2
	max_res_amount = 60
	send_material_data = 1
	time = 5
	difficulty = 1

/datum/stack_recipe/rod/spawn_result(user, location, amount)
	var/obj/item/stack/S = new result_type(location, amount, use_material)
	S.add_to_stacks(user, 1)
	return S

// Tiles 
/datum/stack_recipe/tile
	res_amount = 4
	max_res_amount = 20
	time = 5
	difficulty = 1
	apply_material_name = FALSE

/datum/stack_recipe/tile/nullglass
	title = "nullglass floor tile"
	result_type = /obj/item/stack/tile/floor_nullglass

/datum/stack_recipe/tile/spawn_result(user, location, amount)
	var/obj/item/stack/S = ..()
	if(istype(S))
		S.amount = amount
		S.add_to_stacks(user, 1)
	return S

/datum/stack_recipe/tile/metal/floor
	title = "regular floor tile"
	result_type = /obj/item/stack/tile/floor

/datum/stack_recipe/tile/metal/mono
	title = "mono floor tile"
	result_type = /obj/item/stack/tile/mono

/datum/stack_recipe/tile/metal/mono_dark
	title = "dark mono floor tile"
	result_type = /obj/item/stack/tile/mono/dark

/datum/stack_recipe/tile/metal/grid
	title = "grid floor tile"
	result_type = /obj/item/stack/tile/grid

/datum/stack_recipe/tile/metal/ridged
	title = "ridged floor tile"
	result_type = /obj/item/stack/tile/ridge

/datum/stack_recipe/tile/metal/tech_grey
	title = "grey techfloor tile"
	result_type = /obj/item/stack/tile/techgrey

/datum/stack_recipe/tile/metal/tech_grid
	title = "grid techfloor tile"
	result_type = /obj/item/stack/tile/techgrid

/datum/stack_recipe/tile/metal/tech_maint
	title = "dark techfloor tile"
	result_type = /obj/item/stack/tile/techmaint

/datum/stack_recipe/tile/metal/dark
	title = "dark floor tile"
	result_type = /obj/item/stack/tile/floor_dark

/datum/stack_recipe/tile/light/floor
	title = "white floor tile"
	result_type = /obj/item/stack/tile/floor_white

/datum/stack_recipe/tile/light/freezer
	title = "freezer floor tile"
	result_type = /obj/item/stack/tile/floor_freezer

/datum/stack_recipe/tile/wood
	title = "wood floor tile"
	result_type = /obj/item/stack/tile/wood

/datum/stack_recipe/tile/mahogany
	title = "mahogany floor tile"
	result_type = /obj/item/stack/tile/mahogany

/datum/stack_recipe/tile/maple
	title = "maple floor tile"
	result_type = /obj/item/stack/tile/maple

/datum/stack_recipe/tile/ebony
	title = "ebony floor tile"
	difficulty = 3
	result_type = /obj/item/stack/tile/ebony

/datum/stack_recipe/tile/walnut
	title = "walnut floor tile"
	result_type = /obj/item/stack/tile/walnut