/datum/food_transition/boiled
	cooking_method = METHOD_BOILING
	req_reagents = list("water" = 5)
	cooking_message = "floats about"

/datum/food_transition/boiled/egg
	input_type =  /obj/item/weapon/reagent_containers/food/snacks/egg/rawegg
	output_type = /obj/item/weapon/reagent_containers/food/snacks/egg/boiled

/datum/food_transition/boiled/spaghetti
	input_type = /obj/item/weapon/reagent_containers/food/snacks/spagetti
	output_type = /obj/item/weapon/reagent_containers/food/snacks/boiledspagetti

/datum/food_transition/boiled/soydope
	input_type = /obj/item/weapon/reagent_containers/food/snacks/soydope
	output_type = /obj/item/weapon/reagent_containers/food/snacks/stewedsoymeat
	req_reagents = list("water" = 5, "tomatojuice" = 5, "carrotjuice" = 5)