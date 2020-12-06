/mob/living/deity
	var/list/items
	var/list/items_by_category

/mob/living/deity/proc/set_items(var/list/_items)
	items = _items
	items_by_category = list()
	for(var/i in items)
		var/datum/deity_item/di = items[i]
		if(!items_by_category[di.category])
			items_by_category[di.category] = list()
		items_by_category[di.category] += di

/mob/living/deity/proc/has_item(var/name, var/minimum_level = 1)
	if(!(name in items))
		return FALSE
	var/datum/deity_item/di = items[name]
	. = di.level >= minimum_level

/mob/living/deity/proc/upgrade_item(var/name)
	if(!(name in items))
		return FALSE
	var/datum/deity_item/di = items[name]
	if(!di.can_buy(src))
		return FALSE
	di.buy(src)
	. = TRUE

/mob/living/deity/proc/get_item_level(var/name)
	. = 0
	if(items[name])
		var/datum/deity_item/di = items[name]
		. = di.level


/mob/living/deity/Destroy()
	for(var/cat in items_by_category)
		var/list/L = items_by_category[cat]
		L.Cut()
	items_by_category.Cut()
	for(var/i in items)
		qdel(items[i])
	items.Cut()
	. = ..()