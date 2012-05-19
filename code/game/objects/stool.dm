/obj/structure/stool/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			if (prob(50))
				del(src)
				return
		if(3.0)
			if (prob(5))
				del(src)
				return
	return

/obj/structure/stool/blob_act()
	if(prob(75))
		new /obj/item/stack/sheet/metal(src.loc)
		del(src)

/obj/structure/stool/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/screwdriver))
		if (src.anchored)
			src.anchored = 0
			user << "\blue You unfasten [src] from the floor."
		else
			src.anchored = 1
			user << "\blue You fasten [src] to the floor."
	if(istype(W, /obj/item/weapon/wrench))
		playsound(src.loc, 'Ratchet.ogg', 50, 1)
		new /obj/item/stack/sheet/metal(src.loc)
		del(src)
	return

/obj/structure/stool/bed/chair/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/assembly/shock_kit))
		var/obj/structure/stool/bed/chair/e_chair/E = new /obj/structure/stool/bed/chair/e_chair(src.loc)
		playsound(src.loc, 'Deconstruct.ogg', 50, 1)
		E.dir = src.dir
		E.part1 = W
		W.loc = E
		W.master = E
		user.u_equip(W)
		W.layer = initial(W.layer)
		del(src)
		return
	return

/obj/structure/stool/bed/Del()
	unbuckle()
	..()
	return

/obj/structure/stool/bed/proc/unbuckle()
	if(buckled_mob)
		if(buckled_mob.buckled == src)	//this is probably unneccesary, but it doesn't hurt
			buckled_mob.buckled = null
			buckled_mob.anchored = 0
			buckled_mob.lying = 0
			buckled_mob = null
	return

/obj/structure/stool/bed/proc/manual_unbuckle(mob/user as mob)
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			if(buckled_mob != user)
				buckled_mob.visible_message(\
					"\blue [buckled_mob.name] was unbuckled by [user.name]!",\
					"You unbuckled from [src] by [user.name].",\
					"You hear metal clanking")
			else
				buckled_mob.visible_message(\
					"\blue [buckled_mob.name] unbuckled himself!",\
					"You unbuckle yourself from [src].",\
					"You hear metal clanking")
			unbuckle()
			src.add_fingerprint(user)
	return

/obj/structure/stool/bed/proc/buckle_mob(mob/M as mob, mob/user as mob)
	if (!ticker)
		user << "You can't buckle anyone in before the game starts."
	if ((!( istype(M, /mob) ) || get_dist(src, user) > 1 || M.loc != src.loc || user.restrained() || usr.stat || M.buckled || istype(user, /mob/living/silicon/pai)))
		return

	unbuckle()

	if (M == usr)
		M.visible_message(\
			"\blue [M.name] buckles in!",\
			"You buckle yourself to [src].",\
			"You hear metal clanking")
	else
		M.visible_message(\
			"\blue [M.name] is buckled in to [src] by [user.name]!",\
			"You are buckled in to [src] by [user.name].",\
			"You hear metal clanking")
	M.anchored = 1
	M.buckled = src
	M.loc = src.loc
	M.dir = src.dir
	src.buckled_mob = M
	src.add_fingerprint(user)
	return

/obj/structure/stool/bed/MouseDrop_T(mob/M as mob, mob/user as mob)
	if(!istype(M)) return
	buckle_mob(M, user)
	M.lying = 1
	return

/obj/structure/stool/bed/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/structure/stool/bed/attack_hand(mob/user as mob)
	manual_unbuckle(user)
	return

/obj/structure/stool/bed/chair/New()
	if(anchored)
		src.verbs -= /atom/movable/verb/pull
	if(src.dir == NORTH)
		src.layer = FLY_LAYER
	..()
	return

/obj/structure/stool/bed/chair/verb/rotate()
	set name = "Rotate Chair"
	set category = "Object"
	set src in oview(1)

	src.dir = turn(src.dir, 90)
	if(src.dir == NORTH)
		src.layer = FLY_LAYER
	else
		src.layer = OBJ_LAYER

	if(buckled_mob)
		buckled_mob.dir = dir
	return

/obj/structure/stool/bed/chair/MouseDrop_T(mob/M as mob, mob/user as mob)
	if(!istype(M)) return
	buckle_mob(M, user)
	return

//roller bed

/obj/structure/stool/bed/roller
	name = "roller bed"
	icon = 'rollerbed.dmi'
	icon_state = "down"
	anchored = 0

/obj/item/roller
	name = "roller bed"
	desc = "A collapsed roller bed that can be carried around."
	icon = 'rollerbed.dmi'
	icon_state = "folded"
	w_class = 4.0 // Can't be put in backpacks. Oh well.

	attack_self(mob/user)
		var/obj/structure/stool/bed/roller/R = new /obj/structure/stool/bed/roller(user.loc)
		R.add_fingerprint(user)
		del(src)

//obj/structure/stool/bed/roller/Move()
/obj/structure/stool/bed/Move()
	..()
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			buckled_mob.loc = src.loc
			buckled_mob.dir = src.dir

/obj/structure/stool/bed/chair/Move()
	..()
	if(src.dir == NORTH)
		src.layer = FLY_LAYER
	else
		src.layer = OBJ_LAYER

/obj/structure/stool/bed/roller/buckle_mob(mob/M as mob, mob/user as mob)
	if ((!( istype(M, /mob) ) || get_dist(src, user) > 1 || M.loc != src.loc || user.restrained() || usr.stat || M.buckled || istype(usr, /mob/living/silicon/pai)))
		return
	M.pixel_y = 6
	M.update_clothing()
	density = 1
	icon_state = "up"
	..()
	return

/obj/structure/stool/bed/roller/manual_unbuckle(mob/user as mob)
	if(buckled_mob)
		buckled_mob.pixel_y = 0
		buckled_mob.anchored = 0
		buckled_mob.buckled = null
		buckled_mob = null
	density = 0
	icon_state = "down"
	..()
	return

/obj/structure/stool/bed/roller/MouseDrop(over_object, src_location, over_location)
	..()
	if((over_object == usr && (in_range(src, usr) || usr.contents.Find(src))))
		if(!ishuman(usr))	return
		if(buckled_mob)	return 0
		visible_message("[usr] collapses \the [src.name]")
		new/obj/item/roller(get_turf(src))
		spawn(0)
			del(src)
		return

