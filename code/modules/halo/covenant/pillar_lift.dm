
/turf/simulated/open/pillar_lift
	name = "Pillar lift"
	desc = "A single pillar that can extend upwards to reach or seal off higher floors. Used for flying ship crew."
	icon = 'pillar_lift.dmi'
	icon_state = "filled"
	var/turf/simulated/open/pillar_lift/top_floor
	var/list/all_pillars = list()
	var/move_timer = 10
	var/time_finish_moving = 0
	var/move_dir = 0
	var/is_base = 0
	var/turf/simulated/open/pillar_lift/controller

/turf/simulated/open/pillar_lift/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

//setup the shaft above us
/turf/simulated/open/pillar_lift/LateInitialize()
	. = ..()

	//check what's below us
	var/turf/simulated/open/below = GetBelow(src)
	if(below && istype(below))
		//assume there is a proper base somewhere below us
		src.update_icon("open")
	else
		//we are the base of a shaft
		is_base = 1
		var/turf/simulated/open/above = GetAbove(src)
		while(istype(above))
			above.ChangeTurf(/turf/simulated/open/pillar_lift)
			above = GetAbove(above)

/turf/simulated/open/pillar_lift/proc/get_controller()
	//if we are the pillar controller, return immediately
	if(is_base)
		return src

	//loop down until we find the bottom most pillar turf
	var/turf/simulated/open/below = GetBelow(src)
	while(istype(below))
		var/turf/simulated/open/pillar_lift/current = below
		if(istype(current) && current.is_base)
			controller = current
			return current
		below = GetBelow(below)

	//return null if unable to locate a controller

/turf/simulated/open/pillar_lift/update_icon(var/new_icon_state)
	//. = ..()
	//overlays += current_icon_state
	overlays = list()
	if(new_icon_state)
		icon_state = new_icon_state

//if there is a pillar there, seal it
/turf/simulated/open/pillar_lift/CanZPass(var/atom/movable/A, direction)
	if(direction == DOWN)
		if(icon_state == "open")
			return 1
		if(A.loc != src)
			return 1
	else if(direction == UP)
		return 1
	return 0

//can't build on this tile
/turf/simulated/open/pillar_lift/attackby(obj/item/C as obj, mob/user as mob)
	return

/turf/simulated/open/pillar_lift/process()
	. = 1
	if(world.time >= time_finish_moving)
		GLOB.processing_objects -= src
		if(move_dir > 0)
			do_extend()
		else if(move_dir < 0)
			do_retract()
		move_dir = 0

/turf/simulated/open/pillar_lift/proc/begin_extend()
	. = 0

	//only move if we're not already moving
	if(!move_dir)
		//get the highest floor
		var/turf/highest_floor = src
		if(top_floor)
			highest_floor = top_floor

		//check if we can extend any further
		var/turf/simulated/open/pillar_lift/above = GetAbove(highest_floor)
		if(above && istype(above))

			//pillars start animating
			for(var/obj/structure/lift_pillar/pillar in all_pillars)
				//pillar.visible_message("<span class='info'>[pillar] grinds as it begins extending into the roof.</span>")
				pillar.icon_state = "pillarup"

			//floor starts animating
			highest_floor.update_icon("filled_up")

			highest_floor.visible_message("<span class='info'>The pillar grinds as it begins extending into the roof.</span>")

			//check back later to finish the move
			move_dir = 1
			GLOB.processing_objects += src
			time_finish_moving = world.time + move_timer

			. = 1

//extend one level then stop
/turf/simulated/open/pillar_lift/proc/do_extend()
	. = 0
	var/turf/highest_floor = src
	if(top_floor)
		highest_floor = top_floor

	var/turf/simulated/open/pillar_lift/above = GetAbove(highest_floor)
	if(above && istype(above))

		//update the old highest floor icon and icon_state
		highest_floor.update_icon("filled")

		//set the new highest floor and icon_state
		top_floor = above
		highest_floor.update_icon("filled")

		//move everything up
		for(var/atom/movable/A in highest_floor)
			if(!A.anchored)
				A.loc = above
				to_chat(A,"<span class='info'>The pillar moves you up a level.</span>")

		//add the new pillar
		var/obj/structure/lift_pillar/new_pillar = new(highest_floor)
		all_pillars.Add(new_pillar)
		above.visible_message("<span class='info'>A pillar crunches up to the floor from a lower level, blocking the passage below.</span>")

		//pillars finish animating
		for(var/obj/structure/lift_pillar/pillar in all_pillars)
			pillar.visible_message("<span class='info'>[pillar] crunches as it extends into the roof.</span>")
			pillar.update_icon("pillar")

		//set the new highest floor and update the sprites of both floors
		if(top_floor)
			top_floor.update_icon("filled")
		top_floor = above
		//top_floor.update_icon("filled")

		. = 1
	else
		highest_floor.visible_message("<span class='info'>[src] crunches to a halt. It's unable to extend any farther</span>")
		src.visible_message("<span class='info'>[src] crunches to a halt. It's unable to extend any farther</span>")

/turf/simulated/open/pillar_lift/proc/begin_retract()
	. = 0

	//only move if we're not already moving
	if(!move_dir)

		//check if we have extended at all
		if(top_floor)

			//pillars start animating
			for(var/obj/structure/lift_pillar/pillar in all_pillars)
				//pillar.visible_message("<span class='info'>[pillar] grinds as it begins retracting into the floor.</span>")
				pillar.icon_state = "pillardown"
			top_floor.visible_message("<span class='info'>The pillar grinds as it begins retracting into the floor, revealing a passage to a lower level.</span>")
			top_floor.update_icon("filled_down")

			//check back later to finish the move
			move_dir = -1
			GLOB.processing_objects += src
			time_finish_moving = world.time + move_timer

			. = 1

/turf/simulated/open/pillar_lift/proc/do_retract()
	. = 0
	if(top_floor)

		//update the old highest floor
		top_floor.update_icon("open")

		//pillars finish animating
		for(var/obj/structure/lift_pillar/pillar in all_pillars)
			pillar.visible_message("<span class='info'>[pillar] crunches as it retracts into the floor.</span>")
			pillar.icon_state = "pillar"

		//remove the old pillar
		var/turf/below = GetBelow(top_floor)
		var/obj/structure/lift_pillar/old_pillar = locate() in below
		all_pillars.Remove(old_pillar)
		qdel(old_pillar)

		//move the stuff down a level
		for(var/atom/movable/A in top_floor)
			if(!A.anchored)
				A.loc = below
				to_chat(A,"<span class='info'>The pillar moves you down a level.</span>")

		//set the new highest floor
		top_floor = below
		top_floor.update_icon("filled")
		if(below == src)
			top_floor = null

		. = 1
	else
		src.visible_message("<span class='info'>[src] crunches to a halt. It's unable to retract any farther</span>")







/obj/structure/lift_pillar
	name = "Pillar"
	desc = "A single pillar that can extend upwards or retract downwards to reach or seal off other floors. Used for flying ship crew."
	icon = 'pillar_lift.dmi'
	icon_state = "pillar"
	density = 1
	anchored = 1




/obj/structure/lift_pillar_console
	name = "Pillar Control Console"
	desc = "A control console for the lift pillar."
	icon = 'pillar_lift.dmi'
	icon_state = "Small Covie Holo"
	density = 0
	anchored = 1

/obj/structure/lift_pillar_console/Initialize()
	. = ..()
	set_light(1, 3, "#00FFFF")

/obj/structure/lift_pillar_console/attack_hand(mob/user as mob)
	//search nearby for the base turf
	var/turf/simulated/open/pillar_lift/controller
	controller = locate() in range(1, src)
	if(controller)
		//get this pillar_lift turf's controller
		controller = controller.get_controller()

	if(!controller)
		to_chat(user,"<span class='warning'>[src] is unable to locate a nearby lift pillar.</span>")
		return 0

	var/dirchoice = input("Select direction the lift should go in","Select direction","Cancel") in list("Up","Down","Cancel")
	if(dirchoice == "Up")
		if(controller.begin_extend())
			to_chat(user,"<span class='info'>[src] blinks acknowledgement.</span>")
		else
			to_chat(user,"<span class='warning'>[src] cannot extend the pillar any further upwards.</span>")
	else if(dirchoice == "Down")
		if(controller.begin_retract())
			to_chat(user,"<span class='info'>[src] blinks in acknowledgement.</span>")
		else
			to_chat(user,"<span class='warning'>[src] cannot retract the pillar any further downwards.</span>")
