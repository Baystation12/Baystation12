/obj/vehicle/train
	name = "train"
	dir = 4

	move_delay = 1

	health = 100
	maxhealth = 100
	fire_dam_coeff = 0.7
	brute_dam_coeff = 0.5

	var/passenger_allowed = 1

	var/active_engines = 0
	var/train_length = 0

	var/obj/vehicle/train/lead
	var/obj/vehicle/train/tow


//-------------------------------------------
// Standard procs
//-------------------------------------------
/obj/vehicle/train/initialize()
	for(var/obj/vehicle/train/T in orange(1, src))
		latch(T)

/obj/vehicle/train/Move()
	var/old_loc = get_turf(src)
	if(..())
		if(tow)
			tow.Move(old_loc)
		return 1
	else
		return 0

/obj/vehicle/train/Bump(atom/Obstacle)
	if(!istype(Obstacle, /atom/movable) || !anchored)
		return

	var/atom/movable/A = Obstacle

	if(!A.anchored)
		var/turf/T = get_step(A, dir)
		if(isturf(T))
			if(!emagged)	//if not emagged, bump people away, else just run over them
				A.Move(T)
			else if(!ismob(A))	//always bump objects even if emagged
				A.Move(T)

	if(istype(A, /mob/living))
		var/mob/living/M = A
		if(istype(load, /mob/living/carbon/human))
			load << "\red You hit [M]!"
		visible_message("\red [src] knocks over [M]!")
		M.apply_effects(5, 5)								//knock people down if you hit them
		if(emagged)											//and do damage if it's emagged
			M.apply_damages(5 * train_length / move_delay)	// according to how fast the train is going and how heavy it is


//-------------------------------------------
// Interaction procs
//-------------------------------------------
/obj/vehicle/train/relaymove(mob/user, direction)
	var/turf/T = get_step_to(src, get_step(src, direction))
	if(!T)
		user << "You can't find a clear area to step onto."
		return 0

	if(user != load)
		if(user in src)		//for handling players stuck in src
			unload(user, direction, 1)
			return 1
		return 0

	unload(user, direction)

	user << "\blue You climb down from [src]."

	return 1

/obj/vehicle/train/MouseDrop_T(var/atom/movable/C, mob/user as mob)
	if(!usr.canmove || usr.stat || usr.restrained() || !Adjacent(usr) || !user.Adjacent(C))
		return

	if(istype(C,/obj/vehicle/train))
		if(latch(C))
			user << "\blue You successfully connect the [C] to [src]."
		else
			user << "\red You were unable to connect the [C] to [src]."
		return

	if(!load(C))
		user << "\red You were unable to load [C] on [src]."

/obj/vehicle/train/attack_hand(mob/user as mob)
	if(!user.canmove || user.stat || user.restrained() || !Adjacent(user))
		return 0

	if(user != load && (user in src))
		unload(user, null, 1)	//for handling players stuck in src
	else if(load)
		unload(user)			//unload if loaded
	else if(!load)
		load(user)				//else try climbing on board
	else
		return 0

/obj/vehicle/train/verb/unlatch_v()
	set name = "Unlatch"
	set category = "Object"
	set src in view(1)

	if(!usr.canmove || usr.stat || usr.restrained() || !Adjacent(usr))
		return

	if(unlatch())
		usr << "\blue You unlatch [src]."
	else
		usr << "\red [src] is already unlatched."


//-------------------------------------------
// Latching/unlatching procs
//-------------------------------------------
/obj/vehicle/train/proc/latch(var/obj/vehicle/train/T)
	if(!istype(T) || !Adjacent(T))
		return 0

	if(dir != T.dir)	//cars need to be inline to latch
		return 0

	var/T_dir = get_dir(src, T)

	if(dir & T_dir) 	//if car is ahead
		if(!lead && !T.tow)
			lead = T
			T.tow = src
		else
			return 0
	else if(reverse_direction(dir) & T_dir)	//else if car is behind
		if(!tow && !T.lead)
			tow = T
			T.lead = src
		else
			return 0
	else
		return 0

	update_stats()

	return 1

/obj/vehicle/train/proc/unlatch()
	if(!lead && !tow)
		return 0

	if(tow)
		tow.lead = null
		tow.update_stats()
		tow = null
	if(lead)
		lead.tow = null
		lead.update_stats()
		lead = null

	update_stats()

	return 1



//-------------------------------------------------------
// Stat update procs
//
// Used for updating the stats for how long the train is.
// These are useful for calculating speed based on the
// size of the train, to limit super long trains.
//-------------------------------------------------------
/obj/vehicle/train/update_stats()
	if(!tow)
		update_train_stats()
	else
		return tow.update_stats()

/obj/vehicle/train/proc/update_train_stats()
	if(powered && on)
		active_engines = 1	//increment active engine count if this is a running engine
	else
		active_engines = 0

	train_length = 1

	if(tow)
		active_engines += tow.active_engines
		train_length += tow.train_length

	//update the next section of train ahead of us
	if(lead)
		lead.update_train_stats()