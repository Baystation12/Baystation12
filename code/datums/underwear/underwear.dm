/****************************
* Category Collection Setup *
****************************/
/datum/category_collection/underwear
	category_group_type = /datum/category_group/underwear

/*************
* Categories *
*************/
/datum/category_group/underwear
	var/sort_order		// Lower sort order is applied as icons first

datum/category_group/underwear/dd_SortValue()
	return sort_order

/datum/category_group/underwear/top
	name = "Underwear, top"
	sort_order = 1
	category_item_type = /datum/category_item/underwear/top

/datum/category_group/underwear/bottom
	name = "Underwear, bottom"
	sort_order = 2
	category_item_type = /datum/category_item/underwear/bottom

/datum/category_group/underwear/socks
	name = "Socks"
	sort_order = 3
	category_item_type = /datum/category_item/underwear/socks

/datum/category_group/underwear/undershirt
	name = "Undershirt"
	sort_order = 4		// Undershirts currently have the highest sort order because they may cover both underwear and socks.
	category_item_type = /datum/category_item/underwear/undershirt

/*******************
* Category entries *
*******************/
/datum/category_item/underwear
	var/always_last = FALSE          // Should this entry be sorte last?
	var/is_default = FALSE           // Should this entry be considered the default for its type?
	var/icon = 'icons/mob/human.dmi' // Which icon to get the underwear from
	var/icon_state                   // And the particular item state

/datum/category_item/underwear/dd_SortValue()
	if(always_last)
		return "~"+name
	return name

/datum/category_item/underwear/proc/is_default(var/gender)
	return is_default

/datum/category_item/underwear/proc/apply_to_icon(var/icon/I)
	if(!icon_state)
		return
	I.Blend(new /icon('icons/mob/human.dmi', icon_state), ICON_OVERLAY)
