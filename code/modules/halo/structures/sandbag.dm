
/obj/structure/destructible/sandbag
	name = "sandbag"
	icon = 'code/modules/halo/structures/structures.dmi'
	icon_state = "sandbag"
	density = 1
	anchored = 1
	flags = ON_BORDER
	cover_rating = 50
	deconstruct_tools = list(/obj/item/weapon/shovel, /obj/item/weapon/pickaxe)
	loot_types = list(/obj/item/empty_sandbags)
	scrap_types = list(/obj/item/stack/material/cloth, /obj/item/weapon/ore/glass)
	dead_type = /obj/structure/sandbag_dead

/obj/structure/sandbag_dead
	name = "sandbag"
	desc = "Can be cleared with a shovel."
	icon = 'code/modules/halo/structures/structures.dmi'
	icon_state = "sandbag_dead"
	anchored = 1
	flags = ON_BORDER
	throwpass = 1
	var/health = 50

/obj/structure/sandbag_dead/attackby(obj/item/W as obj, mob/user as mob)

	if(istype(W, /obj/item/weapon/shovel))
		user.visible_message("<span class='notice'>[user] clears [src].</span>",\
			"<span class='notice'>You clear [src].</span>")
		if(prob(50))
			new /obj/item/stack/material/cloth(src.loc)
		else
			new /obj/item/weapon/ore/glass(src.loc)
		qdel(src)
		return 1
	else
		. = ..()


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
			var/obj/structure/destructible/sandbag/S = locate() in get_turf(src)
			if(S && (S.dir == src.dir))
				to_chat(user,"\icon[S] <span class='warning'>There is already [S] in that direction.</span>")
				return
			user.visible_message("<span class='notice'>[user] starts filling [src]...</span>",\
				"<span class='notice'>You start filling [src]...</span>")
			if(do_after(user,50))
				var/loc_dropon = get_turf(src)
				if(src.loc == user)
					loc_dropon = get_turf(user)
				S = new(loc_dropon)
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
