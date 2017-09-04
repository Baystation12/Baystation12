/decl/hierarchy
	var/name = "Hierarchy"
	var/hierarchy_type
	var/decl/hierarchy/parent
	var/list/decl/hierarchy/children

/decl/hierarchy/New(var/full_init = TRUE)
	children = list()
	if(!full_init)
		return

	var/list/all_subtypes = list()
	all_subtypes[type] = src
	for(var/subtype in subtypesof(type))
		all_subtypes[subtype] = new subtype(FALSE)

	for(var/subtype in (all_subtypes - type))
		var/decl/hierarchy/subtype_instance = all_subtypes[subtype]
		var/decl/hierarchy/subtype_parent = all_subtypes[subtype_instance.parent_type]
		subtype_instance.parent = subtype_parent
		dd_insertObjectList(subtype_parent.children, subtype_instance)

/decl/hierarchy/proc/is_category()
	return hierarchy_type == type || children.len

/decl/hierarchy/proc/is_hidden_category()
	return hierarchy_type == type

/decl/hierarchy/dd_SortValue()
	return name
