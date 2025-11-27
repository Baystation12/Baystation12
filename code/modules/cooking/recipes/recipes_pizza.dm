/singleton/cooking_recipe/pizzamargherita
	appliance = COOKING_APPLIANCE_OVEN
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	required_produce = list(
		"tomato" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita
	cooked_scent = /datum/extension/scent/food/pizza


/singleton/cooking_recipe/pizza_meat
	appliance = COOKING_APPLIANCE_OVEN
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	required_produce = list(
		"tomato" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/meat
	cooked_scent = /datum/extension/scent/food/pizza


/singleton/cooking_recipe/pizza_mushroom
	appliance = COOKING_APPLIANCE_OVEN
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	required_produce = list(
		"mushroom" = 4,
		"tomato" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroom
	cooked_scent = /datum/extension/scent/food/pizza


/singleton/cooking_recipe/pizza_vegetable
	appliance = COOKING_APPLIANCE_OVEN
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	required_produce = list(
		"eggplant" = 1,
		"carrot" = 1,
		"corn" = 1,
		"tomato" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetable
	cooked_scent = /datum/extension/scent/food/pizza


/singleton/cooking_recipe/pizza_fruit
	appliance = COOKING_APPLIANCE_OVEN
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	required_reagents = list(
		/datum/reagent/drink/milk/cream = 10,
		/datum/reagent/sugar = 10
	)
	required_produce = list(
		"pineapple" = 1,
		"banana" = 1,
		"blueberries" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/fruit
	cooked_scent = /datum/extension/scent/food/pizza


/singleton/cooking_recipe/pizza_choco
	appliance = COOKING_APPLIANCE_OVEN
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/chocolatebar,
		/obj/item/reagent_containers/food/snacks/chocolatebar,
		/obj/item/reagent_containers/food/snacks/candy
	)
	required_reagents = list(
		/datum/reagent/drink/milk/cream = 5,
		/datum/reagent/sugar = 5
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/choco
	cooked_scent = /datum/extension/scent/food/pizza


/singleton/cooking_recipe/pizza_ham
	appliance = COOKING_APPLIANCE_OVEN
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/bacon/ham,
		/obj/item/reagent_containers/food/snacks/bacon/ham,
		/obj/item/reagent_containers/food/snacks/bacon/ham,
		/obj/item/reagent_containers/food/snacks/bacon/ham
	)
	required_produce = list(
		"tomato" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/ham
	cooked_scent = /datum/extension/scent/food/pizza


/singleton/cooking_recipe/pizza_hawaiian
	appliance = COOKING_APPLIANCE_OVEN
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/bacon/ham,
		/obj/item/reagent_containers/food/snacks/bacon/ham
	)
	required_produce = list(
		"tomato" = 1,
		"pineapple" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/hawaiian
	cooked_scent = /datum/extension/scent/food/pizza


/singleton/cooking_recipe/pizza_capricciosa
	appliance = COOKING_APPLIANCE_OVEN
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/bacon/ham,
		/obj/item/reagent_containers/food/snacks/bacon/ham
	)
	required_produce = list(
		"tomato" = 1,
		"mushroom" = 2
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/pizza/capricciosa
	cooked_scent = /datum/extension/scent/food/pizza
