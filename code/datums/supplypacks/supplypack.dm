/singleton/hierarchy/supply_pack
	name = "Supply Packs"
	hierarchy_type = /singleton/hierarchy/supply_pack
	var/list/contains = list()
	var/manifest = ""
	var/cost = null
	var/containertype = /obj/structure/closet/crate
	var/containername = null
	var/access = null
	var/hidden = 0
	var/contraband = 0
	var/num_contained = 0 //number of items picked to be contained in a randomised crate
	var/supply_method = /singleton/supply_method
	var/singleton/security_level/security_level

//Is run once on init for non-base-category supplypacks.
/singleton/hierarchy/supply_pack/proc/setup()
	if(!num_contained)
		for(var/entry in contains)
			num_contained += max(1, contains[entry])

	var/singleton/supply_method/sm = get_supply_method(supply_method)
	manifest = sm.setup_manifest(src)

/singleton/hierarchy/supply_pack/proc/sec_available()
	if(isnull(security_level))
		return TRUE
	var/singleton/security_state/security_state = GET_SINGLETON(GLOB.using_map.security_state)
	switch(security_level)
		if(SUPPLY_SECURITY_ELEVATED)
			if(length(security_state.all_security_levels) > 1)
				security_level = security_state.all_security_levels[2]
			else
				security_level = security_state.high_security_level
		if(SUPPLY_SECURITY_HIGH)
			security_level = security_state.high_security_level
	if(!istype(security_level))
		return TRUE
	return security_state.current_security_level_is_same_or_higher_than(security_level)

/singleton/hierarchy/supply_pack/proc/spawn_contents(location)
	var/singleton/supply_method/sm = get_supply_method(supply_method)
	return sm.spawn_contents(src, location)

/*
//SUPPLY PACKS
//NOTE: only secure crate types use the access var (and are lockable)
//NOTE: hidden packs only show up when the computer has been hacked.
//ANOTER NOTE: Contraband is obtainable through modified supplycomp circuitboards.
//BIG NOTE: Don't add living things to crates, that's bad, it will break the shuttle.
//NEW NOTE: Do NOT set the price of any crates below 7 points. Doing so allows infinite points.
*/

var/global/list/supply_methods_
/proc/get_supply_method(method_type)
	if(!supply_methods_)
		supply_methods_ = list()
	. = supply_methods_[method_type]
	if(!.)
		. = new method_type()
		supply_methods_[method_type] = .

/singleton/supply_method/proc/spawn_contents(singleton/hierarchy/supply_pack/sp, location)
	if(!sp || !location)
		return
	. = list()
	for(var/entry in sp.contains)
		for(var/i = 1 to max(1, sp.contains[entry]))
			dd_insertObjectList(.,new entry(location))

/singleton/supply_method/proc/setup_manifest(singleton/hierarchy/supply_pack/sp)
	. = list()
	. += "<ul>"
	for(var/path in sp.contains)
		var/atom/A = path
		if(!ispath(A))
			continue
		. += "<li>[initial(A.name)]</li>"
	. += "</ul>"
	. = jointext(.,null)

/singleton/supply_method/randomized/spawn_contents(singleton/hierarchy/supply_pack/sp, location)
	if(!sp || !location)
		return
	. = list()
	for(var/j = 1 to sp.num_contained)
		var/picked = pick(sp.contains)
		. += new picked(location)

/singleton/supply_method/randomized/setup_manifest(singleton/hierarchy/supply_pack/sp)
	return "Contains any [sp.num_contained] of:" + ..()
