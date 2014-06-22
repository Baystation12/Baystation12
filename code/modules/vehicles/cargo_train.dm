/obj/vehicle/train/cargo/engine
	name = "cargo train tug"
	icon = 'icons/obj/aibots.dmi'
	icon_state = "mulebot1"			//mulebot icons until I get some proper icons
	on = 1
	powered = 1
	locked = 0

	standing_mob = 1
	load_item_visible = 1
	load_offset_x = 0
	load_offset_y = 9

	var/car_limit = 3		//how many cars an engine can pull before performance degrades
	active_engines = 1

/obj/vehicle/train/cargo/trolley
	name = "cargo train trolley"
	icon = 'icons/obj/aibots.dmi'
	icon_state = "mulebot0"
	anchored = 0
	passenger_allowed = 0
	locked = 0

	standing_mob = 1
	load_item_visible = 1
	load_offset_x = 0
	load_offset_y = 9

//-------------------------------------------
// Standard procs
//-------------------------------------------
/obj/vehicle/train/cargo/engine/New()
	..()
	cell = new /obj/item/weapon/cell/high
	verbs -= /atom/movable/verb/pull

/obj/vehicle/train/cargo/engine/initialize()
	..()

/obj/vehicle/train/cargo/engine/Move()
	if(on && cell.charge < power_use)
		turn_off()
		update_stats()
		if(load && is_train_head())
			load << "The drive motor briefly whines, then crawls to a stop."
	
	if(is_train_head() && !on)
		return 0

	return ..()

/obj/vehicle/train/cargo/trolley/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(open && istype(W, /obj/item/weapon/wirecutters))
		passenger_allowed = !passenger_allowed
		user.visible_message("<span class='notice'>[user] [passenger_allowed ? "cuts" : "mends"] a cable in [src].</span>","<span class='notice'>You [passenger_allowed ? "cut" : "mend"] the load limiter cable.</span>")
	else
		..()

/obj/vehicle/train/cargo/update_icon()
	if(open)
		icon_state = "mulebot-hatch"
	else
		icon_state = initial(icon_state)

/obj/vehicle/train/cargo/engine/Emag(mob/user as mob)
	..()
	flick("mulebot-emagged", src)

/obj/vehicle/train/cargo/trolley/insert_cell(var/obj/item/weapon/cell/C, var/mob/living/carbon/human/H)
	return

/obj/vehicle/train/cargo/engine/insert_cell(var/obj/item/weapon/cell/C, var/mob/living/carbon/human/H)
	..()
	update_stats()

/obj/vehicle/train/cargo/engine/remove_cell(var/mob/living/carbon/human/H)
	..()
	update_stats()

/obj/vehicle/train/cargo/engine/Bump(atom/Obstacle)
	var/obj/machinery/door/D = Obstacle
	var/mob/living/carbon/human/H = load
	if(istype(D) && istype(H))
		D.Bumped(H)		//a little hacky, but hey, it works, and repects access rights

	..()

/obj/vehicle/train/cargo/trolley/Bump(atom/Obstacle)
	if(!lead)
		return //so people can't knock others over by pushing a trolley around
	..()

//-------------------------------------------
// Train procs
//-------------------------------------------
/obj/vehicle/train/cargo/RunOver(var/mob/living/carbon/human/H)
	var/list/parts = list("head", "chest", "l_leg", "r_leg", "l_arm", "r_arm")

	H.apply_effects(5, 5)
	for(var/i = 0, i < rand(1,3), i++)
		H.apply_damage(rand(1,5), BRUTE, pick(parts))

/obj/vehicle/train/cargo/trolley/RunOver(var/mob/living/carbon/human/H)
	..()
	attack_log += text("\[[time_stamp()]\] <font color='red'>ran over [H.name] ([H.ckey])</font>")

/obj/vehicle/train/cargo/engine/RunOver(var/mob/living/carbon/human/H)
	..()

	if(is_train_head() && istype(load, /mob/living/carbon/human))
		var/mob/living/carbon/human/D = load
		D << "\red \b You ran over [H]!"
		visible_message("<B>\red \The [src] ran over [H]!</B>")
		attack_log += text("\[[time_stamp()]\] <font color='red'>ran over [H.name] ([H.ckey]), driven by [D.name] ([D.ckey])</font>")
		msg_admin_attack("[D.name] ([D.ckey]) ran over [H.name] ([H.ckey]). (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)")
	else
		attack_log += text("\[[time_stamp()]\] <font color='red'>ran over [H.name] ([H.ckey])</font>")


//-------------------------------------------
// Interaction procs
//-------------------------------------------
/obj/vehicle/train/cargo/trolley/verb/rotate()
	set name = "Rotate"
	set category = "Object"
	set src in view(1)

	if(anchored)
		usr << "You cannot turn the trolley while it is latched onto a train."
		return

	var/cur_dir = null
	switch(dir)
		if(NORTH)
			cur_dir = "North"
		if(SOUTH)
			cur_dir = "South"
		if(EAST)
			cur_dir = "East"
		if(WEST)
			cur_dir = "West"

	var/new_dir = input("Select a new direction:", "Rotate", cur_dir) in list("North", "South", "East", "West")

	switch(new_dir)
		if("North")
			dir = NORTH
		if("South")
			dir = SOUTH
		if("East")
			dir = EAST
		if("West")
			dir = WEST


/obj/vehicle/train/cargo/engine/relaymove(mob/user, direction)
	if(user != load)
		return 0

	if(is_train_head())
		if(direction == reverse_direction(dir))
			return 0
		if(Move(get_step(src, direction)))
			return 1
		return 0
	else
		return ..()

/obj/vehicle/train/cargo/engine/verb/climb_down(mob/user as mob)
	set name = "Exit vehicle"
	set category = "Object"
	set src in range(0)
	
	if(!load)
		return
	if(user != load)
		return
	
	unload(user)


/obj/vehicle/train/cargo/engine/verb/start_engine()
	set name = "Start engine"
	set category = "Object"
	set src in view(1)

	if(on)
		usr << "The engine is already running."
		return

	turn_on()
	if (on)
		usr << "You start [src]'s engine."
	else
		if(cell.charge < power_use)
			usr << "[src] is out of power."
		else
			usr << "[src]'s engine won't start."

/obj/vehicle/train/cargo/engine/verb/stop_engine()
	set name = "Stop engine"
	set category = "Object"
	set src in view(1)
	
	if(!on)
		usr << "The engine is already stopped."
		return

	turn_off()
	if (!on)
		usr << "You stop [src]'s engine."

//-------------------------------------------
// Latching/unlatching procs
//-------------------------------------------
/obj/vehicle/train/cargo/trolley/attach_to(obj/vehicle/train/T, mob/user)
	..()
	if (lead)
		//This is now part of a train, anchor it so it cant be pushed around
		anchored = 1

/obj/vehicle/train/cargo/trolley/unattach(mob/user)
	..()
	if (!lead && !tow)
		//if this carriage isn't part of a train anymore; unanchor it so it can be pushed around
		anchored = 0

//-------------------------------------------
// Loading/unloading procs
//-------------------------------------------
/obj/vehicle/train/cargo/trolley/load(var/atom/movable/C)
	if(ismob(C) && !passenger_allowed)
		return 0
	if(!istype(C,/obj/machinery) && !istype(C,/obj/structure/closet) && !istype(C,/obj/structure/largecrate) && !istype(C,/obj/structure/reagent_dispensers) && !istype(C,/obj/structure/ore_box) && !ismob(C))
		return 0

	return ..()

/obj/vehicle/train/cargo/engine/load(var/atom/movable/C)
	if(!ismob(C))
		return 0

	return ..()


//-------------------------------------------------------
// Stat update procs
//
// Update the trains stats for speed calculations.
// The longer the train, the slower it will go. car_limit
// sets the max number of cars one engine can pull at
// full speed. Adding more cars beyond this will slow the
// train proportionate to the length of the train. Adding
// more engines increases this limit by car_limit per
// engine.
//-------------------------------------------------------
/obj/vehicle/train/cargo/engine/update_train_stats()
	..()

	update_move_delay()


/obj/vehicle/train/cargo/engine/proc/update_move_delay()
	if(!is_train_head())
		move_delay = initial(move_delay)		//so that engines that have been turned off don't lag behind
	else
		move_delay = max(0, (-car_limit * active_engines) + train_length - active_engines)	//limits base overweight so you cant overspeed trains
		move_delay *= (1 / max(1, active_engines)) * 2 										//overweight penalty (scaled by the number of engines)
		move_delay += config.run_speed 														//base reference speed
		move_delay *= 1.05 																	//makes cargo trains 5% slower than running when not overweight