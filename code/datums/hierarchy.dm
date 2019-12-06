/decl/hierarchy
	var/name = "Hierarchy"
	var/hierarchy_type
	var/decl/hierarchy/parent
	var/list/decl/hierarchy/children

/decl/hierarchy/Initialize()
	children = list()
	for(var/subtype in subtypesof(type))
		var/decl/hierarchy/child = decls_repository.get_decl(subtype) // Might be a grandchild, which has already been handled.
		if(child.parent_type == type)
			dd_insertObjectList(children, child)
			child.parent = src

/decl/hierarchy/proc/is_category()
	return hierarchy_type == type || children.len

/decl/hierarchy/proc/is_hidden_category()
	return hierarchy_type == type

/decl/hierarchy/proc/get_descendents()
	if(!children)
		return
	. = children.Copy()
	for(var/decl/hierarchy/child in children)
		if(child.children)
			. += child.get_descendents()

/decl/hierarchy/dd_SortValue()
	return name
