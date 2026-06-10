
/singleton/cooking_recipe/tossedsalad
	required_produce = list(
		"lettuce" = 2,
		"tomato" = 1,
		"carrot" = 1,
		"apple" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/tossedsalad

/singleton/cooking_recipe/aesirsalad
	required_items = list(
		/obj/item/reagent_containers/food/snacks/tossedsalad
	)
	required_produce = list(
		"goldapple" = 1,
		"ambrosiadeus" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/aesirsalad

/singleton/cooking_recipe/validsalad
	required_items = list(
		/obj/item/reagent_containers/food/snacks/meatball
	)
	required_produce = list(
		"potato" = 1,
		"ambrosia" = 3
	)
	result_path = /obj/item/reagent_containers/food/snacks/validsalad

/singleton/cooking_recipe/validsalad/CreateResult(obj/container as obj, ...)
	var/obj/item/reagent_containers/food/snacks/validsalad/salad = ..()
	salad.reagents.del_reagent(/datum/reagent/toxin)
	return salad

/singleton/cooking_recipe/capresesalad
	required_items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge/burrata
	)
	required_reagents = list(
		/datum/reagent/sodiumchloride = 1,
		/datum/reagent/blackpepper = 1
	)
	required_produce = list(
		"tomato" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/caprese

/singleton/cooking_recipe/charboard
	required_items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge/burrata,
		/obj/item/reagent_containers/food/snacks/cheesewedge/blue,
		/obj/item/reagent_containers/food/snacks/cracker,
		/obj/item/reagent_containers/food/snacks/bacon/ham,
		/obj/item/reagent_containers/food/snacks/sausage

	)
	required_reagents = list(
		/datum/reagent/pearcompote = 5
	)
	required_produce = list(
		"grapes" = 1,
		"blueberries" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/charboard
	cooked_scent = /datum/extension/scent/food/cheese