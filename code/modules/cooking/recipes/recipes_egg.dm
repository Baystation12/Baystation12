/singleton/cooking_recipe/friedegg
	appliance = COOKING_APPLIANCE_SKILLET | COOKING_APPLIANCE_MICROWAVE | COOKING_APPLIANCE_GRILL
	required_reagents = list(
		/datum/reagent/sodiumchloride = 1,
		/datum/reagent/blackpepper = 1,
		/datum/reagent/nutriment/protein/egg = 3
	)
	result_path = /obj/item/reagent_containers/food/snacks/friedegg
	cooked_scent = /datum/extension/scent/food/egg


/singleton/cooking_recipe/friedegg2
	appliance = COOKING_APPLIANCE_SKILLET | COOKING_APPLIANCE_MICROWAVE | COOKING_APPLIANCE_GRILL
	required_reagents = list(
		/datum/reagent/nutriment/protein/egg = 6
	)
	result_path = /obj/item/reagent_containers/food/snacks/friedegg
	cooked_scent = /datum/extension/scent/food/egg

/singleton/cooking_recipe/boiledegg
	appliance = COOKING_APPLIANCE_SAUCEPAN | COOKING_APPLIANCE_POT | COOKING_APPLIANCE_MICROWAVE
	consumed_reagents = list(
		/datum/reagent/water = 10
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/egg
	)
	result_path = /obj/item/reagent_containers/food/snacks/boiledegg
	cooked_scent = /datum/extension/scent/food/egg

/singleton/cooking_recipe/omelette
	appliance = COOKING_APPLIANCE_SKILLET
	required_reagents = list(
		/datum/reagent/nutriment/protein/egg = 6
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result_path = /obj/item/reagent_containers/food/snacks/omelette
	cooked_scent = /datum/extension/scent/food/egg

/singleton/cooking_recipe/chocolateegg
	appliance = COOKING_APPLIANCE_SAUCEPAN | COOKING_APPLIANCE_POT
	required_items = list(
		/obj/item/reagent_containers/food/snacks/boiledegg,
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result_path = /obj/item/reagent_containers/food/snacks/chocolateegg

/singleton/cooking_recipe/chawanmushi
	appliance = COOKING_APPLIANCE_SAUCEPAN
	consumed_reagents = list(
		/datum/reagent/water = 10
	)
	required_reagents = list(
		/datum/reagent/nutriment/soysauce = 5,
		/datum/reagent/nutriment/protein/egg = 6
	)
	required_produce = list(
		"mushroom" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/chawanmushi
	cooked_scent = /datum/extension/scent/food/egg

/singleton/cooking_recipe/chilied_eggs
	appliance = COOKING_APPLIANCE_SKILLET
	required_items = list(
		/obj/item/reagent_containers/food/snacks/boiledegg,
		/obj/item/reagent_containers/food/snacks/boiledegg,
		/obj/item/reagent_containers/food/snacks/boiledegg,
		/obj/item/reagent_containers/food/snacks/hotchili
	)
	result_path = /obj/item/reagent_containers/food/snacks/chilied_eggs
	cooked_scent = /datum/extension/scent/food/egg

/singleton/cooking_recipe/hatchling_surprise
	appliance = COOKING_APPLIANCE_SKILLET | COOKING_APPLIANCE_GRILL
	required_items = list(
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/friedegg
	)
	result_path = /obj/item/reagent_containers/food/snacks/hatchling_surprise
	cooked_scent = /datum/extension/scent/food/egg

/singleton/cooking_recipe/sea_delight
	appliance = COOKING_APPLIANCE_SKILLET
	consumed_reagents = list(
		/datum/reagent/water = 10
	)
	required_reagents = list(
		/datum/reagent/nutriment/protein/egg = 9
	)
	required_produce = list(
		"gukhe" = 2
	)
	result_path = /obj/item/reagent_containers/food/snacks/sea_delight
	cooked_scent = /datum/extension/scent/food/egg

/singleton/cooking_recipe/frouka
	appliance = COOKING_APPLIANCE_SKILLET
	required_reagents = list(
		/datum/reagent/spacespice = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/boiledegg,
		/obj/item/reagent_containers/food/snacks/boiledegg
	)
	required_produce = list(
		"potato" = 2
	)
	result_path = /obj/item/reagent_containers/food/snacks/frouka
	cooked_scent = /datum/extension/scent/food/egg

/singleton/cooking_recipe/custard
	appliance = COOKING_APPLIANCE_SAUCEPAN | COOKING_APPLIANCE_MICROWAVE
	consumed_reagents = list(
		/datum/reagent/drink/milk = 2,
		/datum/reagent/drink/eggnog = 9,
	)
	required_reagents = list(
		/datum/reagent/sugar = 2
	)
	result_path = /obj/item/reagent_containers/food/snacks/custard
	cooked_scent = /datum/extension/scent/food/sugar
