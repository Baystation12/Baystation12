/decl/hierarchy/supply_pack
	name = "Supply Packs"
	hierarchy_type = /decl/hierarchy/supply_pack
	var/list/contains = list()
	var/manifest = ""
	var/cost = null
	var/containertype = /obj/structure/closet/crate
	var/containername = null
	var/access = null
	var/hidden = 0
	var/contraband = 0
	var/num_contained = 0 //number of items picked to be contained in a randomised crate
	var/supply_method = /decl/supply_method
	var/decl/security_level/security_level

//Is run once on init for non-base-category supplypacks.
/decl/hierarchy/supply_pack/proc/setup()
	if(!num_contained)
		for(var/entry in contains)
			num_contained += max(1, contains[entry])

	var/decl/supply_method/sm = get_supply_method(supply_method)
	manifest = sm.setup_manifest(src)

/decl/hierarchy/supply_pack/proc/sec_available()
	if(isnull(security_level))
		return TRUE
	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
	switch(security_level)
		if(SUPPLY_SECURITY_ELEVATED)
			if(security_state.all_security_levels.len > 1)
				security_level = security_state.all_security_levels[2] 
			else
				security_level = security_state.high_security_level 
		if(SUPPLY_SECURITY_HIGH)
			security_level = security_state.high_security_level
	if(!istype(security_level))
		return TRUE
	return security_state.current_security_level_is_same_or_higher_than(security_level)

/decl/hierarchy/supply_pack/proc/spawn_contents(var/location)
	var/decl/supply_method/sm = get_supply_method(supply_method)
	return sm.spawn_contents(src, location)

/*
//SUPPLY PACKS
//NOTE: only secure crate types use the access var (and are lockable)
//NOTE: hidden packs only show up when the computer has been hacked.
//ANOTER NOTE: Contraband is obtainable through modified supplycomp circuitboards.
//BIG NOTE: Don't add living things to crates, that's bad, it will break the shuttle.
//NEW NOTE: Do NOT set the price of any crates below 7 points. Doing so allows infinite points.
*/

var/list/supply_methods_
/proc/get_supply_method(var/method_type)
	if(!supply_methods_)
		supply_methods_ = list()
	. = supply_methods_[method_type]
	if(!.)
		. = new method_type()
		supply_methods_[method_type] = .

/decl/supply_method/proc/spawn_contents(var/decl/hierarchy/supply_pack/sp, var/location)
	if(!sp || !location)
		return
	. = list()
	for(var/entry in sp.contains)
		for(var/i = 1 to max(1, sp.contains[entry]))
			dd_insertObjectList(.,new entry(location))

/decl/supply_method/proc/setup_manifest(var/decl/hierarchy/supply_pack/sp)
	. = list()
	. += "<ul>"
	for(var/path in sp.contains)
		var/atom/A = path
		if(!ispath(A))
			continue
		. += "<li>[initial(A.name)]</li>"
	. += "</ul>"
	. = jointext(.,null)

/decl/supply_method/randomized/spawn_contents(var/decl/hierarchy/supply_pack/sp, var/location)
	if(!sp || !location)
		return
	. = list()
	for(var/j = 1 to sp.num_contained)
		var/picked = pick(sp.contains)
		. += new picked(location)

/decl/supply_method/randomized/setup_manifest(var/decl/hierarchy/supply_pack/sp)
	return "Contains any [sp.num_contained] of:" + ..()
