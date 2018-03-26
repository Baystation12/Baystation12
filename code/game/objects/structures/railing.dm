/obj/structure/railing
	name = "railing"
	desc = "A standart steel railing. Prevents from human stupidity."
	icon = 'icons/obj/railing.dmi'
	icon_state = "railing0"
	density = 1
	anchored = 1
	obj_flags = ATOM_FLAG_CHECKS_BORDER | ATOM_FLAG_CLIMBABLE
	layer = 5.2 // Just above doors
	throwpass = 1
	can_buckle = 1
	buckle_require_restraints = 1
	var/health = 40
	var/maxhealth = 40
	var/check = 0

/obj/structure/railing/constructed // a cheap trick to spawn unanchored railings for construction
	anchored = 0

/obj/structure/railing/Initialize()
	. = ..()
	if(src.anchored)
		update_icon(0)

/obj/structure/railing/Destroy()
	var/turf/location = loc
	. = ..()
	for(var/obj/structure/railing/R in orange(location, 1))
		R.update_icon()

/obj/structure/railing/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(!mover)
		return 1
	if(istype(mover) && mover.checkpass(PASS_FLAG_TABLE))
		return 1
	if(get_dir(loc, target) == dir)
		return !density
	else
		return 1

/obj/structure/railing/examine(mob/user)
	. = ..()
	if(health < maxhealth)
		switch(health / maxhealth)
			if(0.0 to 0.5)
				to_chat(user, "<span class='warning'>It looks severely damaged!</span>") // Just like me ;)
			if(0.25 to 0.5)
				to_chat(user, "<span class='warning'>It looks damaged!</span>")
			if(0.5 to 1.0)
				to_chat(user, "<span class='notice'>It has a few scrapes and dents.</span>")

// Owwie, ouch, oof
/obj/structure/railing/proc/take_damage(amount)
	health -= amount
	if(health <= 0)
		visible_message("<span class='warning'>\The [src] breaks down!</span>")
		playsound(loc, 'sound/effects/grillehit.ogg', 50, 1)
		new /obj/item/stack/rods(get_turf(src))
		qdel(src)

// Meet the neighbors
/obj/structure/railing/proc/NeighborsCheck(var/UpdateNeighbors = 1)
	check = 0
	var/Rturn = turn(src.dir, -90)
	var/Lturn = turn(src.dir, 90)

	for(var/obj/structure/railing/R in src.loc)
		if ((R.dir == Lturn) && R.anchored)
			check |= 32
			if (UpdateNeighbors)
				R.update_icon(0)
		if ((R.dir == Rturn) && R.anchored)
			check |= 2
			if (UpdateNeighbors)
				R.update_icon(0)

	for (var/obj/structure/railing/R in get_step(src, Lturn))
		if ((R.dir == src.dir) && R.anchored)
			check |= 16
			if (UpdateNeighbors)
				R.update_icon(0)
	for (var/obj/structure/railing/R in get_step(src, Rturn))
		if ((R.dir == src.dir) && R.anchored)
			check |= 1
			if (UpdateNeighbors)
				R.update_icon(0)

	for (var/obj/structure/railing/R in get_step(src, (Lturn + src.dir)))
		if ((R.dir == Rturn) && R.anchored)
			check |= 64
			if (UpdateNeighbors)
				R.update_icon(0)
	for (var/obj/structure/railing/R in get_step(src, (Rturn + src.dir)))
		if ((R.dir == Lturn) && R.anchored)
			check |= 4
			if (UpdateNeighbors)
				R.update_icon(0)

// Greet the neighbors
/obj/structure/railing/update_icon(var/UpdateNeighgors = 1)
	NeighborsCheck(UpdateNeighgors)
	overlays.Cut()
	if (!check || !anchored)
		icon_state = "railing0"
	else
		icon_state = "railing1"
		if (check & 32)
			overlays += image ('icons/obj/railing.dmi', src, "corneroverlay")
		if ((check & 16) || !(check & 32) || (check & 64))
			overlays += image ('icons/obj/railing.dmi', src, "frontoverlay_l")
		if (!(check & 2) || (check & 1) || (check & 4))
			overlays += image ('icons/obj/railing.dmi', src, "frontoverlay_r")
			if(check & 4)
				switch (src.dir)
					if (NORTH)
						overlays += image ('icons/obj/railing.dmi', src, "mcorneroverlay", pixel_x = 32)
					if (SOUTH)
						overlays += image ('icons/obj/railing.dmi', src, "mcorneroverlay", pixel_x = -32)
					if (EAST)
						overlays += image ('icons/obj/railing.dmi', src, "mcorneroverlay", pixel_y = -32)
					if (WEST)
						overlays += image ('icons/obj/railing.dmi', src, "mcorneroverlay", pixel_y = 32)

// You spin me right round baby right round, like a record baby
/obj/structure/railing/verb/rotate()
	set name = "Rotate Counter-Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if (!can_touch(usr) || ismouse(usr))
		return

	if(anchored)
		to_chat(usr, "It is fastened to the floor therefore you can't rotate it!")
		return 0

	set_dir(turn(dir, 90))
	update_icon()
	return

/obj/structure/railing/verb/revrotate()
	set name = "Rotate Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if (!can_touch(usr) || ismouse(usr))
		return

	if(anchored)
		to_chat(usr, "It is fastened to the floor therefore you can't rotate it!")
		return 0

	set_dir(turn(dir, -90))
	update_icon()
	return

/obj/structure/railing/verb/flip() // This will help push railing to remote places, such as open space turfs
	set name = "Flip Railing"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if(!can_touch(usr) || ismouse(usr))
		return

	if(anchored)
		to_chat(usr, "It is fastened to the floor therefore you can't flip it!")
		return 0

	if(!neighbor_turf_passable())
		to_chat(usr, "You can't flip the [src] because something blocking it.")
		return 0

	src.loc = get_step(src, src.dir)
	set_dir(turn(dir, 180))
	update_icon()
	return

/obj/structure/railing/proc/neighbor_turf_passable()
	var/turf/T = get_step(src, src.dir)
	if(!T || !istype(T))
		return 0
	if(T.density == 1)
		return 0
	for(var/obj/O in T.contents)
		if(istype(O,/obj/structure))
			if(istype(O,/obj/structure/railing))
				return 1
			else if(O.density == 1)
				return 0
	return 1

// So you can toss people or objects over
/obj/structure/railing/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(istype(O) && O.checkpass(PASS_FLAG_TABLE))
		return 1
	if(get_dir(O.loc, target) == dir)
		return 0
	return 1

/obj/structure/railing/attackby(obj/item/W as obj, mob/user as mob)
	// Dismantle
	if(isWrench(W) && !anchored)
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user, 20, src))
			user.visible_message("<span class='notice'>\The [user] dismantles \the [src].</span>", "<span class='notice'>You dismantle \the [src].</span>")
			new /obj/item/stack/material/steel(get_turf(usr), 2)
			qdel(src)
			return

	// Repair
	if(health < maxhealth && istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/F = W
		if(F.welding)
			playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
			if(do_after(user, 20, src))
				user.visible_message("<span class='notice'>\The [user] repairs some damage to \the [src].</span>", "<span class='notice'>You repair some damage to \the [src].</span>")
				health = min(health+(maxhealth/4), maxhealth) // 25% repair per application
				return

	// (Un)Anchor
	if(istype(W, /obj/item/weapon/screwdriver))
		user.visible_message(anchored ? "<span class='notice'>\The [user] begins unscrewing \the [src].</span>" : "<span class='notice'>\The [user] begins fasten \the [src].</span>" )
		playsound(loc, 'sound/items/Screwdriver.ogg', 75, 1)
		if(do_after(user, 10, src))
			to_chat(user, (anchored ? "<span class='notice'>You have unfastened \the [src] from the floor.</span>" : "<span class='notice'>You have fastened \the [src] to the floor.</span>"))
			anchored = !anchored
			update_icon()
			return

	else
		playsound(loc, 'sound/effects/grillehit.ogg', 50, 1)
		take_damage(W.force)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	return ..()

/obj/structure/railing/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			qdel(src)
			return
		if(3.0)
			qdel(src)
			return
		else
	return

// can_climb() allows climbing from an adjacent turf onto the src turf.
// However, railings allow the inverse as well.
/obj/structure/railing/can_climb(var/mob/living/usr, post_climb_check=0)
	if(!..())
		return 0

	if(get_turf(usr) == get_turf(src))
		var/occupied
		var/turf/T = get_step(src, src.dir)
		if(T && istype(T))
			if(T.density == 1)
				occupied = 1
			else
				for(var/obj/O in T.contents)
					if(O == usr) // trying to climb onto yourself? Sure, go ahead bud.
						continue
					if(istype(O,/obj/structure))
						var/obj/structure/S = O
						if(S.atom_flags & ATOM_FLAG_CLIMBABLE)
							continue
					// Not entirely sure what this next line does. But it looks important.
					if(O && O.density && !(O.atom_flags & ATOM_FLAG_CHECKS_BORDER && !(turn(O.dir, 180) & dir)))
						continue
					occupied = 1

		if(occupied)
			to_chat(usr, "<span class='danger'>There's \a [occupied] in the way.</span>")
			return 0
	return 1

// Snowflake do_climb code that handles special railing cases.
/obj/structure/railing/do_climb(var/mob/living/user)
	if (!can_climb(user))
		return

	user.visible_message("<span class='warning'>\The [user] starts climbing over \the [src]!</span>")
	climbers |= user

	if(!do_after(user,(issmall(user) ? 30 : 50), src))
		climbers -= user
		return

	if (!can_climb(user, post_climb_check=1))
		climbers -= user
		return

	if(get_turf(user) == get_turf(src))
		usr.forceMove(get_step(src, src.dir))
	else
		usr.forceMove(get_turf(src))

	// If the rail isn't anchored, it'll fall over the edge.
	// Always fun to climb over a railing, fall to the floor below, and then have the railing fall on you.
	if(!anchored)
		user.visible_message("<span class='warning'>\The [user] tries to climb over \the [src], but it collapses!</span>")
		user.Weaken(30)
		src.forceMove(get_turf(user))
		take_damage(maxhealth/2)
	else
		user.visible_message("<span class='warning'>\The [user] climbs over \the [src]!</span>")

	climbers -= user
