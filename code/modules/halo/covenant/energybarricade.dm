
/obj/item/energybarricade
	name = "energy barricade (packed)"
	desc = "A shimmering curved shield for Covenant footsoldiers to take cover behind. This one is deactivated for transport."
	icon = 'energybarricade.dmi'
	icon_state = "item"

/obj/item/energybarricade/attack_self(var/mob/user)
	if(user)
		var/turf/T = get_turf(user)
		var/obj/structure/energybarricade/E = locate() in T
		if(E)
			user.visible_message("<span class='notice'>There is already [E] there!</span>")
		else
			user.visible_message("<span class='info'>[user] begins setting up [src].</span>")
			if(do_after(user, 30, src.loc))
				user.visible_message("<span class='info'>[user] finishes setting up [src].</span>")
				user.drop_item()
				T = get_turf(user)
				E = new(T)
				E.dir = user.dir
				E.overload()
				qdel(src)




/obj/structure/energybarricade
	name = "energy barricade"
	desc = "A shimmering curved shield for Covenant footsoldiers to take cover behind."
	icon = 'energybarricade.dmi'
	icon_state = "1"
	anchored = 1
	var/active = 1
	var/time_recharged = 0
	var/recharge_time = 50
	var/can_deconstruct = 1

/obj/structure/energybarricade/CanPass(atom/A, turf/T)
	. = ..()

	//block movement from some directions if we are active
	if(active && A && T)
		var/turf/front_turf = get_step(src, dir)

		//movement in front of the shield
		if(front_turf == T)
			to_chat(A,"<span class='warning'>[src] blocks your way.</span>")
			return 0

/obj/structure/energybarricade/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(get_dir(O.loc, target) == dir)
		to_chat(O,"<span class='warning'>[src] blocks your way.</span>")
		return 0
	return ..()

/obj/structure/energybarricade/attack_hand(var/mob/user)
	//deconstruct the shield if we are behind it
	if(can_deconstruct)
		if(user.loc == src.loc)
			user.visible_message("<span class='info'>[user] begins deactivating [src] and begin packing it for transport.</span>")

			//spend some time breaking down the shield
			if(do_after(user, recharge_time, src))
				GLOB.processing_objects.Remove(src)
				new /obj/item/energybarricade(src.loc)
				qdel(src)
				user.visible_message("<span class='info'>[user] finishes deactivating [src] and packs it for transport.</span>")
		else
			to_chat(user,"<span class='info'>You must be behind [src] to do this.</span>")
	else
		to_chat(user,"<span class='info'>This one has been secured and cannot be deactivated.</span>")

/obj/structure/energybarricade/process()
	if(world.time > time_recharged)
		recharge()

/obj/structure/energybarricade/proc/overload()
	icon_state = "0"
	active = 0
	GLOB.processing_objects.Add(src)
	time_recharged = world.time + recharge_time

/obj/structure/energybarricade/proc/recharge()
	icon_state = "1"
	active = 1
	if(src.dir == NORTH)
		src.plane = OBJ_PLANE
	else
		src.plane = ABOVE_HUMAN_PLANE
	GLOB.processing_objects.Remove(src)
