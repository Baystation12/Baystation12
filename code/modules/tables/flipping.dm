
/obj/structure/table/proc/straight_table_check(var/direction)
	if(health > 100)
		return 0
	var/obj/structure/table/T
	for(var/angle in list(-90,90))
		T = locate() in get_step(src.loc,turn(direction,angle))
		if(T && T.flipped == 0 && T.material && material && T.material.name == material.name)
			return 0
	T = locate() in get_step(src.loc,direction)
	if (!T || T.flipped == 1 || T.material != material)
		return 1
	return T.straight_table_check(direction)

/obj/structure/table/verb/do_flip()
	set name = "Flip table"
	set desc = "Flips a non-reinforced table"
	set category = "Object"
	set src in oview(1)

	if (!can_touch(usr) || ismouse(usr))
		return

	if(flipped < 0 || !flip(get_cardinal_dir(usr,src)))
		to_chat(usr, "<span class='notice'>It won't budge.</span>")
		return

	usr.visible_message("<span class='warning'>[usr] flips \the [src]!</span>")

	if(flags & OBJ_CLIMBABLE)
		object_shaken()

	return

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
	for(var/new_dir in L)
		var/obj/structure/table/T = locate() in get_step(src.loc,new_dir)
		if(T && T.material && material && T.material.name == material.name)
			if(T.flipped == 1 && T.dir == src.dir && !T.unflipping_check(new_dir))
				return 0
	return 1

/obj/structure/table/proc/do_put()
	set name = "Put table back"
	set desc = "Puts flipped table back"
	set category = "Object"
	set src in oview(1)

	if (!can_touch(usr))
		return

	if (!unflipping_check())
		to_chat(usr, "<span class='notice'>It won't budge.</span>")
		return
	unflip()

/obj/structure/table/proc/flip(var/direction)
	if( !straight_table_check(turn(direction,90)) || !straight_table_check(turn(direction,-90)) )
		return 0

	verbs -=/obj/structure/table/verb/do_flip
	verbs +=/obj/structure/table/proc/do_put

	var/list/targets = list(get_step(src,dir),get_step(src,turn(dir, 45)),get_step(src,turn(dir, -45)))
	for (var/atom/movable/A in get_turf(src))
		if (!A.anchored)
			spawn(0)
				A.throw_at(pick(targets),1,1)

	set_dir(direction)
	if(dir != NORTH)
		plane = ABOVE_HUMAN_PLANE
		layer = ABOVE_HUMAN_LAYER
	flags &= ~OBJ_CLIMBABLE //flipping tables allows them to be used as makeshift barriers
	flipped = 1
	flags |= ON_BORDER
	for(var/D in list(turn(direction, 90), turn(direction, -90)))
		var/obj/structure/table/T = locate() in get_step(src,D)
		if(T && T.can_connect() && T.flipped == 0 && material && T.material && T.material.name == material.name)
			T.flip(direction)
	take_damage(rand(5, 10))
	update_connections(1)
	update_icon()

	return 1

/obj/structure/table/proc/unflip()
	verbs -=/obj/structure/table/proc/do_put
	verbs +=/obj/structure/table/verb/do_flip

	reset_plane_and_layer()
	flags |= OBJ_CLIMBABLE
	flipped = 0
	flags &= ~ON_BORDER
	for(var/D in list(turn(dir, 90), turn(dir, -90)))
		var/obj/structure/table/T = locate() in get_step(src.loc,D)
		if(T && T.flipped == 1 && T.dir == src.dir && material && T.material&& T.material.name == material.name)
			T.unflip()

	update_connections(1)
	update_icon()

	return 1