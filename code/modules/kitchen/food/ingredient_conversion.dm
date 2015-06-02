// This is a simple helper for things like eggs being cracked into pans (since boiling an egg and frying an egg are distinct).
/datum/ingredient_conversion
	var/input_type = /obj/item
	var/output_type = /obj/item
	var/conversion_message = "puts the thing into the object. Bug a coder"

/datum/ingredient_conversion/fryingpan_egg
	input_type = /obj/item/weapon/reagent_containers/food/snacks/egg/rawegg
	output_type = /obj/item/weapon/reagent_containers/food/snacks/egg/frying
	conversion_message = "cracks the egg into the pan"