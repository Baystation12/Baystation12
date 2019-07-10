/datum/stored_items
	var/item_name = "name"	//Name of the item(s) displayed
	var/item_path = null	// The original amount held
	var/amount = 0
	var/list/instances		//What items are actually stored
	var/atom/storing_object

/datum/stored_items/New(var/atom/storing_object, var/path, var/name = null, var/amount = 0)
	if(!istype(storing_object))
		CRASH("Unexpected storing object.")
	src.storing_object = storing_object
	src.item_path = path
	src.amount = amount

	if(!name)
		var/atom/tmp = path
		src.item_name = initial(tmp.name)
	else
		src.item_name = name
	..()

/datum/stored_items/Destroy()
	storing_object = null
	QDEL_NULL_LIST(instances)
	. = ..()

/datum/stored_items/dd_SortValue()
	return item_name

/datum/stored_items/proc/get_amount()
	return amount

/datum/stored_items/proc/add_product(var/atom/movable/product)
	if(product.type != item_path)
		return 0
	if(product in instances)
		return 0
	product.forceMove(storing_object)
	LAZYADD(instances, product)
	amount++
	return 1

/datum/stored_items/proc/get_product(var/product_location)
	if(!get_amount() || !product_location)
		return

	var/atom/movable/product
	if(LAZYLEN(instances))
		product = instances[instances.len]	// Remove the last added product
		LAZYREMOVE(instances, product)
	else
		product = new item_path(storing_object)

	amount--
	product.forceMove(product_location)
	return product

/datum/stored_items/proc/get_specific_product(var/product_location, var/atom/movable/product)
	if(!get_amount() || !instances || !product_location || !product)
		return FALSE

	. = instances.Remove(product)
	if(.)
		product.forceMove(product_location)

/datum/stored_items/proc/merge(datum/stored_items/other)
	if(other.item_path != item_path)
		return FALSE
	for(var/atom/movable/thing in other.instances)
		other.instances -= thing
		if(thing in instances)
			amount-- // Don't double-count
		else
			thing.forceMove(storing_object)
			LAZYADD(instances, thing)
	amount += other.amount
	qdel(other)
	return TRUE

/datum/stored_items/proc/migrate(atom/new_storing_obj)
	storing_object = new_storing_obj
	for(var/atom/movable/thing in instances)
		thing.forceMove(new_storing_obj)