

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
		qdel(src)


/obj/structure/tanktrap
	name = "tanktrap"
	icon = 'desert_outpost.dmi'
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
			AM << "<span class='notice'>You start maneuvring past [src]...</span>"
			spawn(0)
				if(do_after(AM, 30))
					src.visible_message("<span class='info'>[AM] slips past [src].</span>")
					AM.loc = T
		else
			AM << "<span class='warning'>Something is blocking you from maneuvering past [src].</span>"
	..()

/obj/structure/tanktrap/attack_generic(var/mob/user, var/damage, var/attacktext)
	user.do_attack_animation(src)
	visible_message("<span class='danger'>[user] [attacktext] the [src]!</span>")
	//user.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [src.name]</font>")
	src.health -= damage
	playsound(src.loc, 'sound/weapons/bite.ogg', 50, 0, 0)
	if (src.health <= 0)
		new /obj/item/metalscraps(src.loc)
		if(prob(50))
			new /obj/item/metalscraps(src.loc)
		if(prob(50))
			new /obj/item/stack/rods(src.loc)
		if(prob(50))
			new /obj/item/stack/material/steel(src.loc)
		qdel(src)

/obj/structure/sandbag
	name = "sandbag"
	icon = 'desert_outpost.dmi'
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
			AM << "<span class='notice'>You start climbing over [src]...</span>"
			spawn(0)
				if(do_after(AM, 30))
					src.visible_message("<span class='info'>[AM] climbs over [src].</span>")
					AM.loc = T
		else
			AM << "<span class='warning'>You cannot climb over [src] as it is being blocked.</span>"
	..()

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
		qdel(src)

/obj/structure/sandbag/bullet_act(var/obj/item/projectile/Proj)
	health -= 1		//bullets do very little damage
	if (src.health <= 0)
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

/obj/item/empty_sandbags
	name = "empty sandbags"
	desc = "Fill them with sand to form a defensive barrier"
	icon = 'desert_outpost.dmi'
	icon_state = "empty sandbags"

/obj/item/empty_sandbags/verb/rotate()
	set name = "Rotate sandbags clockwise"
	set category = "Object"
	set src in oview(1)
	src.dir = turn(src.dir, 90)

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
	icon = 'desert_outpost.dmi'
	icon_state = "barbedwire"
	density = 0
	anchored = 1
	throwpass = 1
	var/damage = 5
	var/health = 10

/obj/structure/bardbedwire/Crossed(atom/movable/AM)
	. = 1
	if(isliving(AM))
		var/mob/living/L = AM
		L.adjustBruteLoss(damage)
		if(prob(25))
			L.Weaken(2)
		AM << "<span class='warning'>You are caught in [src]!</span>"
		health -= 1
		if(health <= 0)
			new /obj/item/metalscraps(src.loc)
			qdel(src)

/material/steel/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("barbed wire", /obj/structure/bardbedwire, 1, one_per_turf = 1, on_floor = 1, time = 30)
	recipes += new/datum/stack_recipe("tank trap", /obj/structure/tanktrap, 4, one_per_turf = 1, on_floor = 1, time = 50)


/obj/item/metalscraps
	name = "metal scraps"
	desc = "some ruined scraps of metal"
	icon = 'desert_outpost.dmi'
	icon_state = "metalscraps"

/obj/item/metalscraps/New()
	..()
	icon_state = "metalscraps[rand(1,4)]"


/obj/structure/barrel
	name = "metal barrel"
	icon = 'code/modules/halo/gamemodes/stranded/desert_outpost.dmi'
	icon_state = "barrel"
