
/singleton/cooking_recipe/cheesewheel_aged
	appliance = COOKING_APPLIANCE_OVEN | COOKING_APPLIANCE_MICROWAVE
	consumed_reagents = list(
		/datum/reagent/enzyme = 5
	)
	required_reagents = list(
		/datum/reagent/sodiumchloride = 10
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/cheesewheel
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/cheesewheel/aged


/singleton/cooking_recipe/cheesewedge_aged
	appliance = COOKING_APPLIANCE_OVEN | COOKING_APPLIANCE_MICROWAVE
	consumed_reagents = list(
		/datum/reagent/enzyme = 1
	)
	required_reagents = list(
		/datum/reagent/sodiumchloride = 2
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result_path = /obj/item/reagent_containers/food/snacks/cheesewedge/aged


/singleton/cooking_recipe/cheesewheel_blue
	appliance = COOKING_APPLIANCE_POT
	consumed_reagents = list(
		/datum/reagent/enzyme = 5
	)
	required_reagents = list(
		/datum/reagent/sodiumchloride = 5,
		/datum/reagent/drink/kefir = 5
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/cheesewheel
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/cheesewheel/blue


/singleton/cooking_recipe/cheesewedge_blue
	appliance = COOKING_APPLIANCE_POT
	consumed_reagents = list(
		/datum/reagent/enzyme = 1
	)
	required_reagents = list(
		/datum/reagent/sodiumchloride = 1,
		/datum/reagent/drink/kefir = 1
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result_path = /obj/item/reagent_containers/food/snacks/cheesewedge/blue

/singleton/cooking_recipe/mozzarella
	appliance = COOKING_APPLIANCE_CHEESE
	required_reagents = list(
		/datum/reagent/enzyme = 5,
		/datum/reagent/drink/milk = 5,
		/datum/reagent/sodiumchloride = 3
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/cheesewheel/mozzarella

/singleton/cooking_recipe/burrata
	appliance = COOKING_APPLIANCE_CHEESE
	required_reagents = list(
		/datum/reagent/enzyme = 5,
		/datum/reagent/drink/milk/cream = 5,
		/datum/reagent/sodiumchloride = 3
	)
	required_items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/cheesewheel/mozzarella
	)
	result_path = /obj/item/reagent_containers/food/snacks/sliceable/cheesewheel/burrata
