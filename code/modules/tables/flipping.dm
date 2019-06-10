//handles flips & unanchoring tables
/obj/structure/table/CtrlClick()
	if(Adjacent(usr))
		if(anchored)
			unlock()
		else
			.=..()
		return TRUE	
	return FALSE

/obj/structure/table/ShiftClick()
	if(Adjacent(usr))
		if(!flipped)
			do_flip()
		else
			do_put()
	else
		.=..()

/obj/structure/table/Move()
	var/old_dir = dir
	. = ..()
	set_dir(old_dir)
	playsound(src, pick(move_sounds), 75, 1)

/obj/structure/table/proc/straight_table_check(var/direction)
	var/obj/structure/table/T
	for(var/angle in list(-90,90))
		T = locate() in get_step(src.loc,turn(direction,angle))
		if(can_connect(T))
			return 0
	T = locate() in get_step(src.loc,direction)
	if(!can_connect(T))
		return 1
	return T.straight_table_check(direction)

/obj/structure/table/verb/do_flip()
	set name = "Flip table"
	set desc = "Flips a non-reinforced table"
	set category = "Object"
	set src in oview(1)

	if (!can_touch(usr) || ismouse(usr) || manipulating)
		return

	if(reinforced || flipped < 0 || !flip(get_cardinal_dir(usr,src)))
		to_chat(usr, "<span class='notice'>It won't budge.</span>")
		return

	usr.visible_message("<span class='warning'>[usr] flips \the [src]!</span>")

	if(atom_flags & ATOM_FLAG_CLIMBABLE)
		object_shaken()

	return

/obj/structure/table/proc/flip(var/direction)
	if(anchored && ( !straight_table_check(turn(direction,90)) || !straight_table_check(turn(direction,-90)) ) )
		return FALSE

	manipulating = 1
	if(!do_after(usr, 1 SECOND, src))
		manipulating = 0
		return FALSE
	manipulating = 0

	verbs -=/obj/structure/table/verb/do_flip
	verbs +=/obj/structure/table/proc/do_put

	var/list/targets = list(get_step(src,dir),get_step(src,turn(dir, 45)),get_step(src,turn(dir, -45)))
	for (var/atom/movable/A in get_turf(src))
		if (!A.anchored && A != src)//don't throw the table itself
			spawn(0)
				A.throw_at(pick(targets),1,1)

	set_dir(direction)
	flipped = 1
	atom_flags |= ATOM_FLAG_CHECKS_BORDER
	obj_flags |= OBJ_FLAG_ROTATABLE
	for(var/D in list(turn(direction, 90), turn(direction, -90)))
		var/obj/structure/table/T = locate() in get_step(src,D)
		if(can_connect(T, FALSE) && !T.flipped)
			T.flip(direction)
	take_damage(rand(1, 8))
	update_connections(1)
	update_icon()

	return TRUE

/obj/structure/table/proc/do_put()
	set name = "Put table back"
	set desc = "Puts flipped table back"
	set category = "Object"
	set src in oview(1)

	if (!can_touch(usr) || ismouse(usr) || manipulating)
		return

	if (!unflipping_check())
		to_chat(usr, "<span class='notice'>It won't budge.</span>")
		return
	unflip()

/obj/structure/table/proc/unflipping_check(var/direction)

	for(var/mob/M in oview(src,0))
		return 0

	var/obj/occupied = turf_is_crowded()
	if(occupied)
		to_chat(usr, "There's \a [occupied] in the way.")
		return 0

	var/list/L = list()
	if(direction)
		L.Add(direction)
	else
		L.Add(turn(src.dir,-90))
		L.Add(turn(src.dir,90))
	for(var/new_dir in L)//checking side group?
		var/obj/structure/table/T = locate() in get_step(src.loc,new_dir)
		if(can_connect(T, FALSE))
			if(T.flipped == 1 && T.dir == src.dir && !T.unflipping_check(new_dir))
				return 0
	return 1

/obj/structure/table/proc/unflip()
	manipulating = 1
	if(!do_after(usr, 2 SECOND, src))
		manipulating = 0
		return FALSE
	manipulating = 0

	verbs -=/obj/structure/table/proc/do_put
	verbs +=/obj/structure/table/verb/do_flip

	flipped = 0
	atom_flags &= ~ATOM_FLAG_CHECKS_BORDER
	obj_flags &= ~OBJ_FLAG_ROTATABLE
	for(var/D in list(turn(dir, 90), turn(dir, -90)))
		var/obj/structure/table/T = locate() in get_step(src.loc,D)
		if(can_connect(T, FALSE) && T.flipped && T.dir == dir)
			T.unflip()

	update_connections(1)
	update_icon()
	playsound(src, pick(move_sounds), 75, 1)

	return TRUE

/obj/structure/table/verb/unlock()
	set name = "Unlock table"
	set desc = "Unlock a non-reinforced table from the ground"
	set category = "Object"
	set src in oview(1)

	if (!can_touch(usr) || ismouse(usr) || manipulating)
		return

	if(reinforced)
		to_chat(usr, "<span class='notice'>It won't budge.</span>")
		return

	playsound(src, pick(move_sounds), 75, 1)
	usr.visible_message("<span class='notice'>\The [usr] starts to pull \the [src] from its anchoring locks.</span>",
		                            "<span class='notice'>You start to pull \the [src] from its anchoring locks.</span>")

	manipulating = 1
	if(!do_after(usr, 1.5 SECOND, src)) 
		manipulating = 0
		return
	manipulating = 0
	usr.visible_message("<span class='notice'>\The [usr] pulls \the [src] free from its anchoring locks.</span>",
		                            "<span class='notice'>You pulls \the [src] free from its anchoring locks.</span>")
	anchored = 0
	update_connections(1)
	update_icon()
	verbs +=/obj/structure/table/proc/lock
	verbs -=/obj/structure/table/verb/unlock

	if(atom_flags & ATOM_FLAG_CLIMBABLE)
		object_shaken()

/obj/structure/table/proc/lock()
	set name = "lock table"
	set desc = "lock a table to the ground"
	set category = "Object"
	set src in oview(1)

	if (!can_touch(usr) || ismouse(usr) || manipulating)
		return

	if(reinforced)
		to_chat(usr, "<span class='notice'>It won't budge.</span>")
		return

	usr.visible_message("<span class='notice'>\The [usr] starts locking \the [src] to the ground.</span>",
		                            "<span class='notice'>You start locking \the [src] to the ground.</span>")

	manipulating = 1
	if(!do_after(usr, 3 SECOND, src))
		manipulating = 0
		return
	manipulating = 0
	
	usr.visible_message("<span class='notice'>\The [usr] locks \the [src] to the ground.</span>",
		                            "<span class='notice'>You lock \the [src] to the ground.</span>")
	
	anchored = 1
	update_connections(1)
	update_icon()
	verbs +=/obj/structure/table/verb/unlock
	verbs -=/obj/structure/table/proc/lock

/obj/structure/table/rotate(mob/user)
	if(!CanPhysicallyInteract(user))
		to_chat(user, SPAN_NOTICE("You can't interact with \the [src] right now!"))
		return

	if(anchored || !flipped)
		to_chat(user, "<span class='notice'>It won't budge.</span>")
		return

	if(manipulating)
		return

	manipulating = 1
	
	if(!do_after(usr, 1 SECOND, src)) 
		manipulating = 0
		return
	set_dir(turn(dir, 90))
	update_icon()
	playsound(src, pick(move_sounds), 75, 1)
	manipulating = 0
