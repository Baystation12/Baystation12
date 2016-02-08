/**********************
* Category Collection *
**********************/
/datum/category_collection
	var/category_group_type						// The type of categories to initialize
	var/list/datum/category_group/categories	// The list of initialized categories

/datum/category_collection/New()
	..()
	categories = new()
	for(var/category_type in typesof(category_group_type))
		var/datum/category_group/category = category_type
		if(initial(category.name))
			category = new category(src)
			categories += category
	categories = dd_sortedObjectList(categories)

/datum/category_collection/Destroy()
	for(var/category in categories)
		qdel(category)
	categories.Cut()
	return ..()

/******************
* Category Groups *
******************/
/datum/category_group
	var/name = ""
	var/category_item_type						// The type of items to initialize
	var/list/datum/category_item/items			// The list of initialized items
	var/datum/category_collection/collection	// The collection this group belongs to

/datum/category_group/New(var/datum/category_collection/cc)
	..()
	collection = cc
	items = new()

	for(var/item_type in typesof(category_item_type))
		var/datum/category_item/item = item_type
		if(initial(item.name))
			item = new item(src)
			items += item

	// For whatever reason dd_insertObjectList(items, item) doesn't insert in the correct order
	// If you change this, confirm that character setup doesn't become completely unordered.
	items = dd_sortedObjectList(items)

/datum/category_group/Destroy()
	for(var/item in items)
		qdel(item)
	items.Cut()
	collection = null
	return ..()

datum/category_group/dd_SortValue()
	return name


/*****************
* Category Items *
*****************/
/datum/category_item
	var/name = ""
	var/list/datum/category_group/category		// The group this item belongs to

/datum/category_item/New(var/datum/category_group/cg)
	..()
	category = cg

/datum/category_item/Destroy()
	category = null
	return ..()

datum/category_item/dd_SortValue()
	return name
