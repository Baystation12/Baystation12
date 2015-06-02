//Used for transitions that check for a given kitchen tag.
/datum/food_transition/grown
	input_type = /obj/item/weapon/reagent_containers/food/snacks/grown
	cooking_method = METHOD_SLICING
	cooking_message = "slices up"
	cooking_time = 0
	var/req_kitchen_tag

/datum/food_transition/grown/matches_input_type(var/obj/item/I)
	if(..())
		var/obj/item/weapon/reagent_containers/food/snacks/grown/G = I
		if(G.seed && G.seed.kitchen_tag == req_kitchen_tag)
			return 1
	return 0
