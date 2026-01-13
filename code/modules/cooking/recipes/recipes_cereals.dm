

/singleton/cooking_recipe/sandwich
	required_items = list(
		/obj/item/reagent_containers/food/snacks/plainsteak,
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result_path = /obj/item/reagent_containers/food/snacks/sandwich

/singleton/cooking_recipe/toastedsandwich
	appliance = COOKING_APPLIANCE_SKILLET | COOKING_APPLIANCE_MICROWAVE
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sandwich
	)
	result_path = /obj/item/reagent_containers/food/snacks/toastedsandwich
	cooked_scent = /datum/extension/scent/food/toast

/singleton/cooking_recipe/grilledcheese
	appliance = COOKING_APPLIANCE_SKILLET | COOKING_APPLIANCE_MICROWAVE
	required_items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result_path = /obj/item/reagent_containers/food/snacks/grilledcheese
	cooked_scent = /datum/extension/scent/food/toast

/singleton/cooking_recipe/slimetoast
	appliance = COOKING_APPLIANCE_SKILLET | COOKING_APPLIANCE_MICROWAVE
	required_reagents = list(
		/datum/reagent/slimejelly = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result_path = /obj/item/reagent_containers/food/snacks/jelliedtoast
	cooked_scent = /datum/extension/scent/food/toast

/singleton/cooking_recipe/jelliedtoast
	appliance = COOKING_APPLIANCE_SKILLET | COOKING_APPLIANCE_MICROWAVE
	required_reagents = list(
		/datum/reagent/nutriment/cherryjelly = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result_path = /obj/item/reagent_containers/food/snacks/jelliedtoast
	cooked_scent = /datum/extension/scent/food/toast

/singleton/cooking_recipe/pbtoast
	appliance = COOKING_APPLIANCE_SKILLET | COOKING_APPLIANCE_MICROWAVE
	required_reagents = list(
		/datum/reagent/nutriment/peanut/peanutbutter = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result_path = /obj/item/reagent_containers/food/snacks/pbtoast
	cooked_scent = /datum/extension/scent/food/toast
