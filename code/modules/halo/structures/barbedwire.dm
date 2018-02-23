
/obj/structure/bardbedwire
	name = "barbed wire coil"
	icon = 'maps/desert_outpost/gamemode/desert_outpost.dmi'
	icon_state = "barbedwire"
	density = 0
	anchored = 1
	throwpass = 1
	var/first_dir = 0
	var/damage = 5
	var/health = 10

/obj/structure/bardbedwire/verb/arrange_dir()
	set name = "Choose barbed wire direction"
	set category = "Object"
	set src = view(1)

	var/list/dir_options = list("North" = NORTH,"South" = SOUTH, "East" = EAST, "West" = WEST,\
		"Northeast" = NORTHEAST, "Northwest" = NORTHWEST, "Southeast" = SOUTHEAST,"Southwest" = SOUTHWEST)
	var/newdirname = input("Pick new direction for [src]","New direction","North") in dir_options
	src.dir = dir_options[newdirname]

/obj/structure/bardbedwire/Crossed(atom/movable/AM)
	. = 1
	if(isliving(AM))
		var/mob/living/L = AM
		L.adjustBruteLoss(damage)
		if(prob(25))
			L.Weaken(2)
		if(ismob(AM))
			to_chat(AM,"<span class='warning'>You are caught in [src]!</span>")
		health -= 1
		if(health <= 0)
			new /obj/item/metalscraps(src.loc)
			qdel(src)

/obj/structure/bardbedwire/attackby(obj/item/I as obj, mob/user as mob)
	. = 1

	if(!I || !user)
		return 0

	if(istype(I, /obj/item/weapon/wirecutters))
		user.visible_message("<span class='notice'>[user] starts clearing [src]...</span>",\
			"<span class='notice'>You start deconstructing [src]...</span>")
		spawn(0)
			if(do_after(user, 10) && src && src.loc)
				new /obj/item/stack/material/steel(src.loc)
				qdel(src)
		return 1
	else
		return ..()

/obj/item/stack/barbedwire
	name = "barbed wire coil"
	desc = "A coil of wire covered in wickedly sharp barbs."
	icon = 'maps/desert_outpost/gamemode/desert_outpost.dmi'
	icon_state = "barbedwire_obj"
	flags = CONDUCT
	w_class = ITEM_SIZE_LARGE
	force = 9.0
	throwforce = 15.0
	throw_speed = 5
	throw_range = 20
	matter = list(DEFAULT_WALL_MATERIAL = 1875)
	max_amount = 10
	center_of_mass = null
	attack_verb = list("hit", "bludgeoned", "whacked")
	lock_picking_level = 3

/obj/item/stack/barbedwire/attack_self(var/mob/user)
	if(do_after(user, 10) && use(1))
		new /obj/structure/bardbedwire(user.loc)
		user.visible_message("<span class='info'>[user] spools out from a coil of barbed wire.</span>",\
			"<span class = 'info'>You spool out from the coil of barbed wire.</span>")
