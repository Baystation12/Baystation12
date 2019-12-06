/area
	var/list/req_access = list()
	var/secure = TRUE    // unsecure areas will have doors between them use access diff; secure ones use union.

// Given two areas, find the minimal req_access needed such that (return value) + (area access) >= (other area access) and vice versa
/proc/req_access_diff(area/first, area/second)
	if(!length(first.req_access))
		return second.req_access.Copy()
	if(!length(second.req_access))
		return first.req_access.Copy()
	. = list()
	for(var/requirement in first.req_access)
		add_access_requirement(., get_minimal_requirement(second.req_access, requirement))
	for(var/requirement in second.req_access)
		add_access_requirement(., get_minimal_requirement(first.req_access, requirement))

// Given two areas, find the minimal req_access needed such that req_access >= (area access) + (other area access)
/proc/req_access_union(area/first, area/second)
	if(!length(first.req_access))
		return second.req_access.Copy()
	if(!length(second.req_access))
		return first.req_access.Copy()
	. = first.req_access.Copy()
	for(var/requirement in second.req_access)
		add_access_requirement(., requirement)

// Comes up with the minimal thing to add to the first argument so that the new list guarantees that the access requirement in the second argument is satisfied.
// Second argument is a number access code or list thereof (like an entry in req_access); the typecasting is false.
/proc/get_minimal_requirement(list/req_access, list/requirement)
	if(!requirement)
		return
	if(!islist(requirement))
		return (requirement in req_access) ? null : requirement
	for(var/req in req_access)
		if(req in requirement)
			return // have one of the requirements, and these use OR, so we're good
		if(islist(req))
			var/fully_contained = TRUE // In this case we check if we are already requiring something more stringent than the new thing.
			for(var/one_req in req)
				if(!(one_req in requirement))
					fully_contained = FALSE
					break
			if(fully_contained)
				return
	return requirement.Copy()

// Modifies req_access in place. Ensures that the list remains miminal.
/proc/add_access_requirement(list/req_access, requirement)
	var/minimal = get_minimal_requirement(req_access, requirement)
	if(minimal)
		req_access[++req_access.len] = minimal