/datum/food_transition/baked
	cooking_method = METHOD_BAKING
	cooking_message = "smells delicious"
	req_container = /obj/item/weapon/reagent_containers/kitchen/bakingtray

/datum/food_transition/baked/cracker
	input_type = /obj/item/weapon/reagent_containers/food/snacks/ingredient_mix/slice
	output_type = /obj/item/weapon/reagent_containers/food/snacks/baked/cracker

/datum/food_transition/baked/meatball
	input_type = /obj/item/weapon/reagent_containers/food/snacks/meat/rawmeatball
	output_type = /obj/item/weapon/reagent_containers/food/snacks/meat/meatball

/datum/food_transition/baked/bread
	input_type = /obj/item/weapon/reagent_containers/food/snacks/ingredient_mix/bread
	output_type = /obj/item/weapon/reagent_containers/food/snacks/baked/bread

/datum/food_transition/baked/bread/get_output_product(var/obj/item/source)
	var/obj/item/weapon/reagent_containers/food/snacks/ingredient_mix/D = source
	var/obj/item/food = new output_type(source.loc)
	if(istype(D) && D.content_descriptor != "")
		food.name = "[D.content_descriptor] [food.name]"
	return food

/datum/food_transition/baked/bread/bun
	input_type = /obj/item/weapon/reagent_containers/food/snacks/ingredient_mix/bun
	output_type = /obj/item/weapon/reagent_containers/food/snacks/baked/bun

/datum/food_transition/baked/bread/muffin
	input_type = /obj/item/weapon/reagent_containers/food/snacks/ingredient_mix/muffin
	output_type = /obj/item/weapon/reagent_containers/food/snacks/baked/muffin

/datum/food_transition/baked/bread/cake
	input_type = /obj/item/weapon/reagent_containers/food/snacks/ingredient_mix/batter
	output_type = /obj/item/weapon/reagent_containers/food/snacks/complex/cake
	req_container = /obj/item/weapon/reagent_containers/kitchen/caketin
