
/singleton/cooking_recipe/cubancarp
	appliance = COOKING_APPLIANCE_FRYER
	required_reagents = list(
		/datum/reagent/nutriment/batter = 10
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/fish
	)
	required_produce = list(
		"chili" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/cubancarp
	cooked_scent = /datum/extension/scent/food/fish

/singleton/cooking_recipe/fishandchips
	appliance = COOKING_APPLIANCE_FRYER
	required_items = list(
		/obj/item/reagent_containers/food/snacks/fries,
		/obj/item/reagent_containers/food/snacks/fish
	)
	result_path = /obj/item/reagent_containers/food/snacks/fishandchips
	cooked_scent = /datum/extension/scent/food/fish

/singleton/cooking_recipe/fishfingers
	appliance = COOKING_APPLIANCE_FRYER
	required_reagents = list(
		/datum/reagent/nutriment/batter = 10
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/fish
	)
	result_path = /obj/item/reagent_containers/food/snacks/fishfingers
	cooked_scent = /datum/extension/scent/food/fish

/singleton/cooking_recipe/fries
	appliance = COOKING_APPLIANCE_FRYER | COOKING_APPLIANCE_OVEN
	required_items = list(
		/obj/item/reagent_containers/food/snacks/rawsticks
	)
	result_path = /obj/item/reagent_containers/food/snacks/fries
	cooked_scent = /datum/extension/scent/food/grease

/singleton/cooking_recipe/onionrings
	appliance = COOKING_APPLIANCE_FRYER | COOKING_APPLIANCE_OVEN
	required_reagents = list(
		/datum/reagent/nutriment/batter = 10
	)
	required_produce = list(
		"onion" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/onionrings
	cooked_scent = /datum/extension/scent/food/grease

/singleton/cooking_recipe/shrimp_tempura
	appliance = COOKING_APPLIANCE_FRYER
	required_reagents = list(
		/datum/reagent/nutriment/batter = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/shellfish/shrimp
	)
	result_path = /obj/item/reagent_containers/food/snacks/shrimp_tempura
	cooked_scent = /datum/extension/scent/food/grease

/singleton/cooking_recipe/mozzsticks
	appliance = COOKING_APPLIANCE_FRYER
	required_reagents = list(
		/datum/reagent/nutriment/batter = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge/mozz,
		/obj/item/reagent_containers/food/snacks/cheesewedge/mozz
	)
	result_path = /obj/item/reagent_containers/food/snacks/mozzsticks
	cooked_scent = /datum/extension/scent/food/grease
