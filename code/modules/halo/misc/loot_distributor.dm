var/global/datum/loot_distributor/loot_distributor = new

//NOTE: YOU MAY BE CONFUSED AS TO WHY SOME LOOT LISTS ARE PADDED WITH NULLS. THIS IS DUE TO THE DISTRIBUTOR PREVIOUSLY UTILISING AN OLD METHOD OF DISTRIBUTION
//NOTE: WHEN ADDING TO THE LOOT LIST, IT'S BETTER TO ADD VIA A MAP SPECIFIC ITEM SUCH AS OVERMAP OBJECT /New().
/datum/loot_distributor
	//Format, "loot_type" = list(loot_typepaths)
	var/list/loot_list = list(
	"pizza" = list(/obj/item/pizzabox/margherita,/obj/item/pizzabox/vegetable,/obj/item/pizzabox/mushroom,/obj/item/pizzabox/meat)
	)
	var/list/distribute_locs = list() //Format is created by points, but it's "listid" = list(turfs_to_distribute_to)

/datum/loot_distributor/proc/get_lootlist_for_type(var/type_name)
	var/list/loot_pickfrom = list()
	loot_pickfrom = loot_list[type_name]
	if(loot_pickfrom.len == 0)
		return
	return loot_pickfrom

/datum/loot_distributor/proc/add_distribute_loc(var/loc,var/type)
	var/list/loclist = distribute_locs[type]
	if(!loclist)
		loclist = list()
	loclist += loc
	distribute_locs[type] = loclist
	GLOB.processing_objects |= src

/datum/loot_distributor/proc/process()
	for(var/tag in distribute_locs)
		var/list/lootlist = get_lootlist_for_type(tag)
		var/list/loclist = distribute_locs[tag]
		while(lootlist.len > 0 && loclist.len > 0)
			var/item = pick(lootlist)
			lootlist -= item
			var/spawnloc = pick(loclist)
			loclist -= spawnloc
			//This if statement is to allow backwards compatability with the older system.//
			if(isnull(item))
				continue
			new item (spawnloc)
		distribute_locs[tag] = loclist
		loot_list[tag] = lootlist

	return PROCESS_KILL

/obj/effect/loot_marker
	opacity = 0
	invisibility = 101
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"

	var/loot_type = "generic"

/obj/effect/loot_marker/Initialize()
	..()
	. = INITIALIZE_HINT_QDEL
	loot_distributor.add_distribute_loc(loc,loot_type)

//Example Subtype//
/obj/effect/loot_marker/pizza
	loot_type = "pizza"
