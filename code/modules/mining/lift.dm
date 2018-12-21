
/obj/machinery/mine_lift
	name = "automatic lift"
	desc = "For moving things between the surface and the lower levels."
	icon = 'icons/obj/mining.dmi'
	icon_state = "chute"
	var/moving_dir = 0

/obj/machinery/mine_lift/attack_hand(mob/user)
	if(isliving(user))
		add_fingerprint(user)
		toggle()

/obj/machinery/mine_lift/proc/toggle()
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

	set_state(new_icon_state, new_dir)

/obj/machinery/mine_lift/proc/set_state(var/new_icon_state, var/new_dir)
	dir = new_dir
	icon_state = new_icon_state

	if(icon_state == "chute_active")
		GLOB.processing_objects.Add(src)
	else
		GLOB.processing_objects.Remove(src)

	update_target_lift(icon_state, dir)

/obj/machinery/mine_lift/proc/get_target_lift()
	var/turf/T
	if(dir == SOUTH)
		//upwards
		T = GetAbove()
	else
		//downwards
		T = GetBelow()

	if(T)
		var/obj/machinery/mine_lift/other = locate() in T
		return other

/obj/machinery/mine_lift/proc/update_target_lift(var/new_icon_state, var/new_dir)
	var/obj/machinery/mine_lift/other = get_target_lift()
	if(other)
		other.set_state(icon_state, dir)

/obj/machinery/mine_lift/process()
	var/obj/machinery/mine_lift/other = get_target_lift()
	if(other)
		for(var/atom/movable/M in src.loc)
			if(M.anchored)
				continue

			M.loc = other.loc
			break
