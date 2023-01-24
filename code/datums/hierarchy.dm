/singleton/hierarchy
	var/name = "Hierarchy"
	var/hierarchy_type
	var/singleton/hierarchy/parent
	var/list/singleton/hierarchy/children

/singleton/hierarchy/Initialize()
	children = list()
	for(var/subtype in subtypesof(type))
		var/singleton/hierarchy/child = GET_SINGLETON(subtype) // Might be a grandchild, which has already been handled.
		if(child.parent_type == type)
			dd_insertObjectList(children, child)
			child.parent = src
	return ..()

/singleton/hierarchy/proc/is_category()
	return hierarchy_type == type || length(children)

/singleton/hierarchy/proc/is_hidden_category()
	return hierarchy_type == type

/singleton/hierarchy/proc/get_descendents()
	if(!children)
		return
	. = children.Copy()
	for(var/singleton/hierarchy/child in children)
		if(child.children)
			. += child.get_descendents()

/singleton/hierarchy/dd_SortValue()
	return name
