//=======================================================================================

/datum/unit_test/cargo_crates_containment_test
	name = "CARGO: Supply crates containment"

/datum/unit_test/cargo_crates_containment_test/start_test()
	var/bad_tests = 0

	for(var/decl/hierarchy/supply_pack/supply_pack in cargo_supply_packs)
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
