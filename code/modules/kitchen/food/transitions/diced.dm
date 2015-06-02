/datum/food_transition/diced
	input_type = /obj/item/weapon/reagent_containers/food/snacks/grown
	cooking_method = METHOD_DICING
	cooking_message = "dices up"
	cooking_time = 0

/datum/food_transition/diced/chocchips
	input_type = /obj/item/weapon/reagent_containers/food/snacks/chocolatebar
	output_type = /obj/item/weapon/reagent_containers/food/snacks/chocolatechips
	cooking_message = "roughly chops"

/datum/food_transition/diced/hash
	output_type = /obj/item/weapon/reagent_containers/food/snacks/vegetable/hash

/datum/food_transition/diced/hash/get_output_product(var/obj/item/source)
	var/obj/item/food = new output_type(source.loc)
	update_strings(food, source)
	if(source.color) food.color = source.color
	return food

/datum/food_transition/diced/hash/proc/update_strings(var/obj/item/I, var/obj/item/source)
	I.name = "diced [source.name]"
	I.desc += " It's made from [source.name]."
	var/obj/item/weapon/reagent_containers/food/snacks/vegetable/hash/H = I
	if(istype(H)) H.base_grown = source.name
