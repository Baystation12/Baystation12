/**
 *  Each slice origin items should cut into the same slice.
 *
 *  Each slice type defines an item from which it originates. Each sliceable
 *  item defines what item it cuts into. This test checks if the two defnitions 
 *  are consistent between the two items.
 */
/datum/unit_test/food_slices_and_origin_items_should_be_consistent
	name = "FOOD: Each slice origin item should cut into the appropriate slice"
	
/datum/unit_test/food_slices_and_origin_items_should_be_consistent/start_test()
	var/any_failed = FALSE
	
	for (var/subtype in subtypesof(/obj/item/weapon/reagent_containers/food/snacks/slice))
		var/obj/item/weapon/reagent_containers/food/snacks/slice/slice = subtype
		if(!initial(slice.whole_path))
			log_unit_test("[ascii_red]----- [slice] does not define a whole_path.[ascii_reset]")
			any_failed = TRUE
			continue
		
		if(!ispath(initial(slice.whole_path), /obj/item/weapon/reagent_containers/food/snacks/sliceable))
			log_unit_test("[ascii_red]----- [slice]/whole_path is not a subtype of sliceable.[ascii_reset]")
			any_failed = TRUE
			continue
		
		var/obj/item/weapon/reagent_containers/food/snacks/sliceable/whole = initial(slice.whole_path)
		
		// note that the slice can be a subtype of the one defined in slice_path
		if(!ispath(slice, initial(whole.slice_path)))
			log_unit_test("[ascii_red]----- [whole] does not define slice_path as [slice][ascii_reset]")
			any_failed = TRUE
			continue
	
	if(any_failed)
		fail("Some slice types were incorrectly defined.")
	else
		pass("All slice types defined correctly.")
		
	return 1
		