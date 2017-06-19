// A combined debugging tool/Borderlands 2 reference in one easy package!
var/list/all_premade_gun_types = typesof(/obj/item/weapon/gun/composite/premade)-/obj/item/weapon/gun/composite/premade

/obj/structure/gun_crate
	name = "gun chest"
	desc = "It looks pretty beat-up."
	icon = 'icons/obj/gun_components/loot_chest.dmi'
	pixel_x = -25
	pixel_y = -5
	icon_state = "closed"
	density = 1
	anchored = 1
	layer = 2.8

	var/open
	var/offset_contents

/obj/structure/gun_crate/loot
	name = "loot crate"
	desc = "It looks pretty beat-up. Maybe you'll get a purple."
	var/gun_count = 3

/obj/structure/gun_crate/loot/New()
	..()
	for(var/x=1 to gun_count)
		new /obj/item/random_composite_gun(src)

/obj/structure/gun_crate/all_guns
	name = "endgame loot crate"
	desc = "You can just taste the eridium."
	offset_contents = 1

/obj/structure/gun_crate/all_guns/New()
	..()
	for(var/guntype in all_premade_gun_types)
		new guntype(src)

/obj/structure/gun_crate/all_ammo
	name = "endgame ammo crate"
	desc = "You can just taste the gunpowder."
	offset_contents = 1

/obj/structure/gun_crate/all_ammo/New()
	..()
	for(var/ammotype in typesof(/obj/item/ammo_magazine)-/obj/item/ammo_magazine)
		new ammotype(src)
		new ammotype(src)
		new ammotype(src)
		new ammotype(src)
		new ammotype(src)
	for(var/ammotype in typesof(/obj/item/ammo_casing)-/obj/item/ammo_casing)
		new ammotype(src)
		new ammotype(src)
		new ammotype(src)
		new ammotype(src)
		new ammotype(src)

/obj/structure/gun_crate/attack_hand(var/mob/user)

	if(open)
		open = 0
		icon_state = "closed"
		for(var/obj/item/I in get_turf(src))
			if(I.simulated && !I.anchored)
				I.forceMove(src)
		for(var/obj/item/I in get_step(get_turf(src),EAST))
			if(I.simulated && !I.anchored)
				I.forceMove(src)
		for(var/obj/item/I in get_step(get_turf(src),WEST))
			if(I.simulated && !I.anchored)
				I.forceMove(src)
		return

	open = 1
	icon_state = "open"

	var/ticker = 0
	var/offset_ticker = 0
	while(contents.len)
		var/obj/item/thing = pick(contents)
		thing.forceMove(get_turf(src))
		if(ticker == 1)
			var/turf/T = get_step(get_turf(src), EAST)
			if(T)
				spawn(5)
					if(thing) thing.forceMove(T)
		else if (ticker == 2)
			var/turf/T = get_step(get_turf(src), WEST)
			if(T)
				spawn(5)
					if(thing) thing.forceMove(T)
		ticker++
		if(ticker>2)
			ticker = 0
			if(offset_ticker < 4)
				offset_ticker++
		if(offset_contents)
			thing.pixel_y = -12 + (6 * offset_ticker)

/obj/item/random_composite_gun
	name = "random gun"
	icon_state = "gun"
	icon = 'icons/obj/gun.dmi'
	var/list/guns = list()

/obj/item/random_composite_gun/New(var/newloc)
	..()
	if(!guns.len)
		guns = all_premade_gun_types
	var/newgun = pick(guns)
	new newgun(newloc)
	qdel(src)