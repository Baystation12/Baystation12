
/obj/structure/sandbag
	name = "sandbag"
	icon = 'maps/desert_outpost/gamemode/desert_outpost.dmi'
	icon_state = "sandbag"
	density = 1
	anchored = 1
	flags = ON_BORDER
	throwpass = 1
	var/health = 50

/obj/structure/barricadeunsc
	name = "Barricade"
	icon = 'code/modules/halo/icons/machinery/structures.dmi'
	icon_state = "barricade"
	density = 1
	anchored = 1
	flags = ON_BORDER
	throwpass = 1
	var/health = 100

/obj/structure/sandbag/New()
	..()
	if(dir == 2)
		//might regret this but it looks cool
		layer = 5

/obj/structure/sandbag/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover))
		if(mover.throwing)
			return 1
		if(mover.checkpass(PASSTABLE))
			return 1
	if(get_dir(loc, target) == dir)
		return !density
	else
		return 1

/obj/structure/sandbag/Bumped(atom/movable/AM)
	if(isliving(AM) && AM:a_intent == I_HELP)
		if(istype(AM, /mob/living/simple_animal/))
			return
		if(istype(AM, /mob/living/simple_animal/hostile))
			var/mob/living/simple_animal/hostile/H = AM
			if(!H.assault_target && !H.target_mob)
				return

		var/turf/T = get_step(AM, AM.dir)
		if(T.CanPass(AM, T))
			if(ismob(AM))
				to_chat(AM,"<span class='notice'>You start climbing over [src]...</span>")
			spawn(0)
				if(do_after(AM, 30))
					src.visible_message("<span class='info'>[AM] climbs over [src].</span>")
					AM.loc = T
		else if(ismob(AM))
			to_chat(AM,"<span class='warning'>You cannot climb over [src] as it is being blocked.</span>")
	..()

/obj/structure/sandbag/verb/climb()
	set name = "Climb over sandbag"
	set category = "Object"
	set src = view(1)

	var/mob/living/M = usr
	if(M && istype(M))
		var/climb_dir = get_dir(M, src)
		if(M.loc == src.loc)
			climb_dir = src.dir
		var/turf/T = get_step(src, climb_dir)
		if(T.CanPass(M, T))
			M.dir = climb_dir
			to_chat(M, "<span class='notice'>You start climbing over [src]...</span>")
			spawn(0)
				if(do_after(M, 30))
					src.visible_message("<span class='info'>[M] climbs over [src].</span>")
					M.loc = T
		else
			to_chat(M,"<span class='warning'>You cannot climb over [src] as it is being blocked.</span>")

/obj/structure/sandbag/CheckExit(atom/movable/mover as mob|obj, turf/target as turf)
	if(mover.throwing)
		return 1
	if(get_dir(loc, target) == dir)
		//bullets fired and objects thrown from behind the sandbag can go past
		var/obj/item/projectile/P = mover
		if(istype(P) && mover.checkpass(PASSTABLE))
			if(P.starting == src.loc)
				return 1

		return !density
	return 1

/obj/structure/sandbag/attack_generic(var/mob/user, var/damage, var/attacktext)
	user.do_attack_animation(src)
	visible_message("<span class='danger'>[user] [attacktext] the [src]!</span>")
	//user.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [src.name]</font>")
	src.health -= damage
	playsound(src.loc, 'sound/weapons/bite.ogg', 50, 0, 0)
	if (src.health <= 0)
		new/obj/item/weapon/ore/glass(src)
		new/obj/structure/sandbag_dead(src.loc, dir = src.dir)
		qdel(src)

/obj/structure/sandbag/bullet_act(var/obj/item/projectile/Proj)
	health -= 1		//bullets do very little damage
	if (src.health <= 0)
		new/obj/item/weapon/ore/glass(src)
		new/obj/structure/sandbag_dead(src.loc, dir = src.dir)
		qdel(src)

/obj/structure/sandbag/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(!W || !user)
		return 0

	var/list/usable_tools = list(
		/obj/item/weapon/shovel,
		/obj/item/weapon/pickaxe/diamonddrill,
		/obj/item/weapon/pickaxe/drill,
		/obj/item/weapon/pickaxe/borgdrill
		)

	if(W.type in usable_tools)
		user.visible_message("<span class='notice'>[user] starts deconstructing [src]...</span>",\
			"<span class='notice'>You start deconstructing [src]...</span>")
		spawn(0)
			if(do_after(user, 30) && src && src.loc)
				new /obj/item/empty_sandbags(src.loc)
				new/obj/item/weapon/ore/glass(src)
				qdel(src)
		return 1
	else
		return ..()

/obj/structure/sandbag_dead
	name = "sandbag"
	icon = 'maps/desert_outpost/gamemode/desert_outpost.dmi'
	icon_state = "sandbag_dead"
	anchored = 1
	flags = ON_BORDER
	throwpass = 1
	var/health = 50

/obj/structure/sandbag_dead/attackby(obj/item/I as obj, mob/user as mob)
	. = 1

	if(!I || !user)
		return 0

	if(is_sharp(I))
		user.visible_message("<span class='notice'>[user] starts deconstructing [src]...</span>",\
			"<span class='notice'>You start deconstructing [src]...</span>")
		spawn(0)
			if(do_after(user, 30) && src && src.loc)
				new /obj/item/stack/material/cloth(src.loc)
				qdel(src)
		return 1
	else
		return ..()

/obj/item/empty_sandbags
	name = "empty sandbags"
	desc = "Fill them with sand to form a defensive barrier"
	icon = 'maps/desert_outpost/gamemode/desert_outpost.dmi'
	icon_state = "empty sandbags"

/obj/item/empty_sandbags/examine(mob/user)
	to_chat(user,"It is oriented [src.dir].")

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
				var/obj/structure/sandbag/S = new(loc_dropon)
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
