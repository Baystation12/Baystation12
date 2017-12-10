

/obj/structure/barricade/attack_generic(var/mob/user, var/damage, var/attacktext)
	src.health -= damage
	//user.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [src.name]</font>")
	playsound(src.loc, 'sound/weapons/bite.ogg', 50, 0, 0)
	if(src.health <= 0)
		visible_message("<span class='danger'>[src] is smashed apart by [user]!</span>")
		dismantle()
		qdel(src)
	else
		visible_message("<span class='danger'>[user] [attacktext] the [src]!</span>")

/obj/structure/barricade/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage/10
	playsound(loc, 'sound/weapons/tablehit1.ogg', 50, 1)
	if (src.health <= 0)
		dismantle()
		qdel(src)


/obj/structure/tanktrap
	name = "tanktrap"
	icon = 'maps/desert_outpost/gamemode/desert_outpost.dmi'
	icon_state = "tanktrap"
	density = 1
	anchored = 1
	throwpass = 1
	var/health = 50
	var/list/maneuvring_mobs = list()

/obj/structure/tanktrap/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover))
		if(mover.checkpass(PASSTABLE))
			return 1
		if(mover.throwing)
			return 1
	return !density

/obj/structure/tanktrap/Bumped(atom/movable/AM)
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
				var/mob/moving = AM
				moving.show_message("<span class='notice'>You start maneuvring past [src]...</span>")
			spawn(0)
				if(do_after(AM, 30))
					src.visible_message("<span class='info'>[AM] slips past [src].</span>")
					AM.loc = T
		else if(ismob(AM))
			var/mob/moving = AM
			moving.show_message("<span class='warning'>Something is blocking you from maneuvering past [src].</span>")
	..()

/obj/structure/tanktrap/attack_generic(var/mob/user, var/damage, var/attacktext)
	user.do_attack_animation(src)
	visible_message("<span class='danger'>[user] [attacktext] the [src]!</span>")
	//user.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [src.name]</font>")
	src.health -= damage
	playsound(src.loc, 'sound/weapons/bite.ogg', 50, 0, 0)
	if (src.health <= 0)
		new /obj/structure/tanktrap_dead(src.loc)
		if(prob(50))
			new /obj/item/stack/rods(src.loc)
		if(prob(50))
			new /obj/item/stack/rods(src.loc)
		if(prob(50))
			new /obj/item/stack/material/steel(src.loc)
		if(prob(50))
			new /obj/item/stack/material/steel(src.loc)
		qdel(src)

/obj/structure/tanktrap_dead/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(do_after(user, 20) && WT.remove_fuel(3, user))
			user.visible_message("<span class='info'>You salvage the tank trap.</span>")
			new /obj/item/stack/material/steel(src.loc)
			new /obj/item/stack/material/steel(src.loc)
			new /obj/item/stack/material/steel(src.loc)
			qdel(src)
		else
			to_chat(user, "<span class='warning'>There is not enough fuel to salvage the tank trap!</span>")
	else
		..()

/obj/structure/tanktrap_dead
	name = "tanktrap"
	icon = 'maps/desert_outpost/gamemode/desert_outpost.dmi'
	icon_state = "tanktrap_dead"
	density = 0
	anchored = 1

/obj/structure/tanktrap_dead/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.remove_fuel(1, user))
			user.visible_message("<span class='info'>You salvage the ruined tank trap.</span>")
			new /obj/item/stack/material/steel(src.loc)
			qdel(src)
		else
			to_chat(user, "<span class='warning'>There is not enough fuel to salvage the tank trap!</span>")
	else
		..()

/obj/structure/sandbag
	name = "sandbag"
	icon = 'maps/desert_outpost/gamemode/desert_outpost.dmi'
	icon_state = "sandbag"
	density = 1
	anchored = 1
	flags = ON_BORDER
	throwpass = 1
	var/health = 50

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
				var/obj/structure/sandbag/S = new(src.loc)
				S.dir = src.dir
				user.remove_from_mob(I)
				qdel(I)
				qdel(src)
	else
		return ..()

/material/cloth/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("empty sandbags", /obj/item/empty_sandbags, 1, time = 30)

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


/material/steel/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("barbed wire coil", /obj/item/stack/barbedwire, time = 30)
	recipes += new/datum/stack_recipe("tank trap", /obj/structure/tanktrap, 4, one_per_turf = 1, on_floor = 1, time = 50)


/obj/item/metalscraps
	name = "metal scraps"
	desc = "some ruined scraps of metal"
	icon = 'maps/desert_outpost/gamemode/desert_outpost.dmi'
	icon_state = "barbedwire_dead"


/obj/structure/barrel
	name = "metal barrel"
	icon = 'maps/desert_outpost/gamemode/desert_outpost.dmi'
	icon_state = "barrel"
