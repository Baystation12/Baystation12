
#define BARBEDWIRE_LAY_DELAY 0.75 SECONDS

/obj/structure/bardbedwire
	name = "barbed wire coil"
	desc = "Heavily impairs movement and causes damage through the use of barbed coils of wire."
	icon = 'code/modules/halo/structures/structures.dmi'
	icon_state = "barbedwire"
	density = 0
	anchored = 1
	throwpass = 1
	var/first_dir = 0
	var/damage = 15
	var/health = 10
	var/mat_decon = /obj/item/stack/material/steel

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
	if(isliving(AM) && AM.elevation == elevation)
		var/mob/living/L = AM
		L.adjustBruteLoss(damage)
		L.Stun(2)
		if(ismob(AM))
			to_chat(AM,"<span class='warning'>You are caught in [src]!</span>")

/obj/structure/bardbedwire/attackby(obj/item/I as obj, mob/user as mob)
	. = 1
	if(!I || !user)
		return 0

	if(istype(I, /obj/item/weapon/wirecutters))
		user.visible_message("<span class='notice'>[user] starts clearing [src]...</span>",\
			"<span class='notice'>You start deconstructing [src]...</span>")
		spawn(0)
			if(do_after(user, 10) && src && src.loc)
				new mat_decon(src.loc)
				qdel(src)
		return 1
	else
		return ..()

/obj/structure/bardbedwire/covenant
	name = "energy wire coil"
	desc = "Heavily impairs movement and causes damage through the use of arcing lines of plasma."
	icon_state = "plaswire"
	mat_decon = /obj/item/stack/material/nanolaminate

/obj/item/stack/barbedwire
	name = "barbed wire coil"
	desc = "A coil of wire covered in wickedly sharp barbs."
	icon = 'code/modules/halo/structures/structures.dmi'
	icon_state = "barbedwire_obj"
	flags = CONDUCT
	w_class = ITEM_SIZE_LARGE
	force = 15
	armor_penetration = 70 //Melee weapon pierce, for fun
	throwforce = 15.0
	throw_speed = 5
	throw_range = 20
	matter = list(DEFAULT_WALL_MATERIAL = 1875)
	max_amount = 15
	center_of_mass = null
	attack_verb = list("hit", "bludgeoned", "whacked")
	lock_picking_level = 3
	var/type_create = /obj/structure/bardbedwire
	var/is_spooling = 0

/obj/item/stack/barbedwire/ten
	amount = 10

/obj/item/stack/barbedwire/fifteen
	amount = 15

/obj/item/stack/barbedwire/attack_self(var/mob/user)
	for(var/obj/structure/bardbedwire/D in user.loc)
		if(istype(D))
			to_chat(user, "<span class='warning'>There is a spool already here!</span>")
			return
	if(!is_spooling)
		visible_message("[user] starts spooling the \the [src].")
		is_spooling = 1
		if(do_after(user, BARBEDWIRE_LAY_DELAY) && use(1))
			new type_create (user.loc)
			user.visible_message("<span class='info'>[user] spools out from \the [src].</span>",\
			"<span class = 'info'>You spool out from \the [src].</span>")
		is_spooling = 0
	else
		to_chat(user, "<span class='warning'>Someone is already spooling a [src] here!</span>")

/obj/item/stack/barbedwire/covenant
	name = "energy wire coil"
	desc = "A set of containment field generators for a line of coiled plasma wire."
	icon_state = "plaswire_obj"
	type_create = /obj/structure/bardbedwire/covenant

/obj/item/stack/barbedwire/covenant/ten
	amount = 10

/obj/item/stack/barbedwire/covenant/fifteen
	amount = 15

#undef BARBEDWIRE_LAY_DELAY