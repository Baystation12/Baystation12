//=======================================================================================

/datum/unit_test/cargo_crates_containment_test
	name = "CARGO: Supply crates containment"

/datum/unit_test/cargo_crates_containment_test/start_test()
	var/bad_tests = 0

	for(var/decl/hierarchy/supply_pack/supply_pack in SSsupply.master_supply_list)
		if(!ispath(supply_pack.containertype, /obj/structure/closet))
			continue

		var/obj/structure/closet/C = new supply_pack.containertype(get_safe_turf())
		supply_pack.spawn_contents(C)

		var/contents_pre_open = C.contents.Copy()
		C.dump_contents()
		C.store_contents()
		var/list/no_longer_contained_atoms = contents_pre_open - C.contents
		var/list/previously_not_contained_atoms = C.contents - contents_pre_open

		if(no_longer_contained_atoms.len)
			bad_tests++
			log_bad("[supply_pack] - [log_info_line(C)] no longer contains the following atoms: [log_info_line(no_longer_contained_atoms)]")
		if(previously_not_contained_atoms.len)
			log_debug("[supply_pack] - [log_info_line(C)] now contains the following atoms: [log_info_line(previously_not_contained_atoms)]")
		qdel(C)
		QDEL_NULL_LIST(no_longer_contained_atoms)

	if(bad_tests)
		fail("[bad_tests] cargo supply pack\s with inconsistent pre/post-open contents found.")
	else
		pass("No  cargo supply packs with inconsistent pre/post-open contents found.")

	return 1

/datum/unit_test/cargo_sufficient_cost_test
	name = "CARGO: Supply packs shall have sufficient cost"

/datum/unit_test/cargo_sufficient_cost_test/start_test()
	var/fail = FALSE
	for(var/decl/hierarchy/supply_pack/supply_pack in SSsupply.master_supply_list)
		var/sell_price = 0
		if(ispath(supply_pack.containertype, /obj/structure/closet/crate))
			var/obj/structure/closet/crate/crate = supply_pack.containertype
			sell_price += initial(crate.points_per_crate)
		sell_price += SSsupply.points_per_slip
		if(supply_pack.cost <= sell_price)
			log_bad("[supply_pack.name] ([supply_pack.type]) costs [supply_pack.cost], but can be sold for [sell_price].")
			fail = TRUE
	if(fail)
		fail("A supply pack did not have sufficient cost.")
	else
		pass("All supply packs cost sufficiently.")
	return 1