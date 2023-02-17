/obj/structure/scrap_cube
	name = "compressed scrap"
	desc = "A cube made of scrap compressed with hydraulic clamp."
	density = TRUE
	anchored = FALSE
	icon_state = "trash_cube"
	icon = 'refine.dmi'

/obj/structure/scrap_cube/crush_act()
	playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
	for(var/obj/structure/rubble/r in contents)
		for(var/a in 1 to LAZYLEN(r.lootleft))
			new /obj/item/scrap_lump(loc)
	qdel(src)

/obj/structure/scrap_cube/proc/make_pile()
	for(var/obj/item in contents)
		item.forceMove(loc)
	qdel(src)

/obj/structure/scrap_cube/Initialize(mapload, size = -1)
	. = ..()
	if(size < 0)
		new /obj/structure/rubble/house(src)

/obj/structure/scrap_cube/attackby(obj/item/W, mob/user)
	user.do_attack_animation(src)
	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	if(istype(W,/obj/item) && W.force >=8)
		visible_message(SPAN_NOTICE ("The [user] smashes the [src], restoring it's original form."))
		make_pile()
	else
		visible_message(SPAN_NOTICE ("The [user] smashes the [src], but [W] is too weak to break it!"))


/obj/item/scrap_lump
	name = "unrefined scrap"
	desc = "This thing is messed up beyond any recognition. Into the grinder it goes!"
	icon = 'refine.dmi'
	icon_state = "unrefined"
	w_class = 4

/obj/item/scrap_lump/Initialize()
	. = ..()
	pixel_x = rand(0, 16) - 8
	pixel_y = rand(0, 8) - 8

/obj/item/scrap_lump/crush_act()
	return

// rubble //
/obj/structure/rubble/proc/make_cube()
	var/obj/container = new /obj/structure/scrap_cube(loc, lootleft)
	forceMove(container)

/obj/structure/rubble/crush_act()
	playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
	for(var/a in 1 to LAZYLEN(lootleft))
		new /obj/item/scrap_lump(loc)
	qdel(src)
