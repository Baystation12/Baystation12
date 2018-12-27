
/obj/machinery/mine_lift
	name = "equipment conveyor lift"
	desc = "For moving things between the surface and the lower levels."
	icon = 'icons/obj/mining.dmi'
	icon_state = "chute"
	anchored = 1
	var/obj/machinery/mine_lift/target_lift

/obj/machinery/mine_lift/New()
	. = ..()
	GLOB.processing_objects.Remove(src)

/obj/machinery/mine_lift/attack_hand(mob/user)
	if(isliving(user))
		add_fingerprint(user)
		toggle(user)

/obj/machinery/mine_lift/proc/toggle(var/mob/user)
	var/new_icon_state
	var/new_dir = dir
	if(icon_state == "chute_active")
		new_icon_state = "chute"
		if(dir == SOUTH)
			new_dir = NORTH
		else
			new_dir = SOUTH
	else
		new_icon_state = "chute_active"
		to_chat(user, "\icon[src] <span class='info'>You set [src] moving [dir == SOUTH ? "down" : "up"]wards.</span>")

	set_state(new_icon_state, new_dir)

/obj/machinery/mine_lift/proc/set_state(var/new_icon_state, var/new_dir)
	dir = new_dir
	icon_state = new_icon_state

	if(icon_state == "chute_active")
		GLOB.processing_objects.Add(src)
	else
		GLOB.processing_objects.Remove(src)

	update_target_lift(icon_state, dir)

/obj/machinery/mine_lift/proc/update_target_lift(var/new_icon_state, var/new_dir)
	target_lift = get_target_lift()
	if(target_lift)
		target_lift.set_state(new_icon_state, new_dir)

/obj/machinery/mine_lift/proc/get_target_lift()
	var/turf/T
	if(dir == SOUTH)
		//downwards
		T = GetBelow(src)
	else
		//upwards
		T = GetAbove(src)

	if(T)
		target_lift = locate() in T
		return target_lift

	return null

/obj/machinery/mine_lift/process()
	if(icon_state == "chute_active")
		if(target_lift)
			for(var/obj/O in src.loc)
				if(O.anchored)
					continue

				O.loc = target_lift.loc
				break
