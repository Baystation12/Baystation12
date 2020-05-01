
/obj/structure/destructible/sandbag
	name = "sandbag"
	icon = 'code/modules/halo/icons/machinery/structures.dmi'
	icon_state = "sandbag"
	density = 1
	anchored = 1
	flags = ON_BORDER
	cover_rating = 50
	deconstruct_tools = list(/obj/item/weapon/shovel, /obj/item/weapon/pickaxe)
	loot_type = /obj/item/empty_sandbags

/obj/structure/destructible/sandbag/verb/climb()
	set name = "Climb over sandbag"
	set category = "Object"
	set src = view(1)

	climb(usr)

/obj/structure/destructible/sandbag/place_scraps()
	var/list/scraplist = list()
	if(prob(50))
		scraplist.Add(/obj/item/stack/material/cloth)
	if(prob(50))
		scraplist.Add(/obj/item/weapon/ore/glass)

	for(var/scraptype in scraplist)
		new scraptype(src.loc)

	new /obj/structure/sandbag_dead(src.loc)

/obj/structure/sandbag_dead
	name = "sandbag"
	icon = 'code/modules/halo/icons/machinery/structures.dmi'
	icon_state = "sandbag_dead"
	anchored = 1
	flags = ON_BORDER
	throwpass = 1
	var/health = 50

/obj/item/empty_sandbags
	name = "empty sandbags"
	desc = "Fill them with sand to form a defensive barrier"
	icon = 'code/modules/halo/structures/structures.dmi'
	icon_state = "empty sandbags"

/obj/item/empty_sandbags/verb/arrange_dir()
	set name = "Choose sandbag direction"
	set category = "Object"
	set src = view(1)

	var/list/dir_options = list("North" = NORTH,"South" = SOUTH, "East" = EAST, "West" = WEST)
	var/newdirname = input("Pick new direction for [src]","New direction","North") in dir_options
	src.dir = dir_options[newdirname]

/obj/item/empty_sandbags/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/ore/glass))
		if(user)
			user.visible_message("<span class='notice'>[user] starts filling [src]...</span>",\
				"<span class='notice'>You start filling [src]...</span>")
			if(do_after(user,50))
				var/loc_dropon = get_turf(src)
				if(src.loc == user)
					loc_dropon = get_turf(user)
				var/obj/structure/destructible/sandbag/S = new(loc_dropon)
				S.dir = src.dir
				if(src.loc == user)
					S.dir = user.dir
				user.remove_from_mob(I)
				if(src.loc == user)
					user.remove_from_mob(src)
				qdel(I)
				qdel(src)
	else
		return ..()
