var/global/datum/loot_distributor/loot_distributor = new

//NOTE: WHEN ADDING TO THE LOOT LIST, IT'S BETTER TO ADD VIA A MAP SPECIFIC ITEM SUCH AS OVERMAP OBJECT /New().
/datum/loot_distributor
	//Format, "loot_type" = list(loot_typepaths)
	var/list/loot_list = list(
	"pizza" = list(/obj/item/pizzabox/margherita,/obj/item/pizzabox/vegetable,/obj/item/pizzabox/mushroom,/obj/item/pizzabox/meat)
	)

/datum/loot_distributor/proc/get_loot_for_type(var/type_name)
	var/list/loot_pickfrom = list()
	loot_pickfrom = loot_list[type_name]
	if(loot_pickfrom.len == 0)
		return
	var/picked = pick(loot_pickfrom)
	loot_list[type_name] = loot_pickfrom - picked
	return picked

/obj/effect/loot_marker
	opacity = 0
	invisibility = 101
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"

	var/loot_type = "generic"

/obj/effect/loot_marker/Initialize()
	..()
	. = INITIALIZE_HINT_QDEL
	var/loot_to_spawn = loot_distributor.get_loot_for_type(loot_type)
	if(isnull(loot_to_spawn))
		return
	var/obj/spawned_loot = new loot_to_spawn (loc)
	if(!istype(loc,/turf))
		loc.contents += spawned_loot
	do_loot_modifications(spawned_loot)

/obj/effect/loot_marker/proc/do_loot_modifications(var/obj/loot_spawned)
	loot_spawned.dir = dir

//Example Subtype//
/obj/effect/loot_marker/pizza
	loot_type = "pizza"
