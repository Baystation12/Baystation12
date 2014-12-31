/*
	Click code cleanup
	~Sayu
*/

// 1 decisecond click delay (above and beyond mob/next_move)
/mob/var/next_click	= 0

/*
	Before anything else, defer these calls to a per-mobtype handler.  This allows us to
	remove istype() spaghetti code, but requires the addition of other handler procs to simplify it.

	Alternately, you could hardcode every mob's variation in a flat ClickOn() proc; however,
	that's a lot of code duplication and is hard to maintain.

	Note that this proc can be overridden, and is in the case of screen objects.
*/
/atom/Click(location,control,params)
	usr.ClickOn(src, params)
/atom/DblClick(location,control,params)
	usr.DblClickOn(src,params)

/*
	Standard mob ClickOn()
	Handles exceptions: Buildmode, middle click, modified clicks, mech actions

	After that, mostly just check your state, check whether you're holding an item,
	check whether you're adjacent to the target, then pass off the click to whoever
	is recieving it.
	The most common are:
	* mob/UnarmedAttack(atom,adjacent) - used here only when adjacent, with no item in hand; in the case of humans, checks gloves
	* atom/attackby(item,user) - used only when adjacent
	* item/afterattack(atom,user,adjacent,params) - used both ranged and adjacent
	* mob/RangedAttack(atom,params) - used only ranged, only used for tk and laser eyes but could be changed
*/
/mob/proc/ClickOn( var/atom/A, var/params )
	if(world.time <= next_click)
		return
	next_click = world.time + 1

	if(client.buildmode)
		build_click(src, client.buildmode, params, A)
		return

	var/list/modifiers = params2list(params)
	if(modifiers["middle"])
		MiddleClickOn(A)
		return
	if(modifiers["shift"])
		ShiftClickOn(A)
		return
	if(modifiers["alt"]) // alt and alt-gr (rightalt)
		AltClickOn(A)
		return
	if(modifiers["ctrl"])
		CtrlClickOn(A)
		return

	if(stat || paralysis || stunned || weakened)
		return

	face_atom(A) // change direction to face what you clicked on

	if(next_move > world.time) // in the year 2000...
		return
	//world << "next_move is [next_move] and world.time is [world.time]"
	if(istype(loc,/obj/mecha))
		if(!locate(/turf) in list(A,A.loc)) // Prevents inventory from being drilled
			return
		var/obj/mecha/M = loc
		return M.click_action(A,src)

	if(restrained())
		RestrainedClickOn(A)
		return

	if(in_throw_mode)
		throw_item(A)
		return

	var/obj/item/W = get_active_hand()

	if(W == A)
		W.attack_self(src)
		if(hand)
			update_inv_l_hand(0)
		else
			update_inv_r_hand(0)

		return

	// operate two levels deep here (item in backpack in src; NOT item in box in backpack in src)
	if(A == loc || (A in loc) || (A in contents) || (A.loc in contents))

		// No adjacency needed
		if(W)

			var/resolved = A.attackby(W,src)
			if(istype(W, /obj/item/weapon/grab))
				changeNext_move(8)
			if(!resolved && A && W)
				W.afterattack(A,src,1,params) // 1 indicates adjacency
		else
			if(istype(W, /obj/item/weapon/grab))
				changeNext_move(10)
			UnarmedAttack(A)
		return

	if(!isturf(loc)) // This is going to stop you from telekinesing from inside a closet, but I don't shed many tears for that
		return

	// Allows you to click on a box's contents, if that box is on the ground, but no deeper than that
	if(isturf(A) || isturf(A.loc) || (A.loc && isturf(A.loc.loc)))
		if(A.Adjacent(src)) // see adjacent.dm
			if(W)
				// Return 1 in attackby() to prevent afterattack() effects (when safely moving items for example)
				if(istype(W, /obj/item/weapon/grab))
					changeNext_move(10)
				var/resolved = A.attackby(W,src)
				if(!resolved && A && W)
					W.afterattack(A,src,1,params) // 1: clicking something Adjacent
			else
				if(istype(W, /obj/item/weapon/grab))
					changeNext_move(10)
				UnarmedAttack(A, 1)
			return
		else // non-adjacent click
			if(W)
				if(ismob(A))
					changeNext_move(10)
				W.afterattack(A,src,0,params) // 0: not Adjacent
			else
				if(ismob(A))
					changeNext_move(10)
				RangedAttack(A, params)

	return

/mob/proc/changeNext_move(num)
	next_move = world.time + num

// Default behavior: ignore double clicks, consider them normal clicks instead
/mob/proc/DblClickOn(var/atom/A, var/params)
	//ClickOn(A,params)
	return


/*
	Translates into attack_hand, etc.

	Note: proximity_flag here is used to distinguish between normal usage (flag=1),
	and usage when clicking on things telekinetically (flag=0).  This proc will
	not be called at ranged except with telekinesis.

	proximity_flag is not currently passed to attack_hand, and is instead used
	in human click code to allow glove touches only at melee range.
*/
/mob/proc/UnarmedAttack(var/atom/A, var/proximity_flag)
	if(ismob(A))
		changeNext_move(10)
	return

/*
	Ranged unarmed attack:

	This currently is just a default for all mobs, involving
	laser eyes and telekinesis.  You could easily add exceptions
	for things like ranged glove touches, spitting alien acid/neurotoxin,
	animals lunging, etc.
*/
/mob/proc/RangedAttack(var/atom/A, var/params)
	if(!mutations.len) return
	if((M_LASER in mutations) && a_intent == "hurt")
		LaserEyes(A) // moved into a proc below
	else if(M_TK in mutations)
		/*switch(get_dist(src,A))
			if(0)
				;
			if(1 to 5) // not adjacent may mean blocked by window
				next_move += 2
			if(5 to 7)
				next_move += 5
			if(8 to tk_maxrange)
				next_move += 10
			else
				return
		*/
		A.attack_tk(src)
/*
	Restrained ClickOn

	Used when you are handcuffed and click things.
	Not currently used by anything but could easily be.
*/
/mob/proc/RestrainedClickOn(var/atom/A)
	return

/*
	Middle click
	Only used for swapping hands
*/
/mob/proc/MiddleClickOn(var/atom/A)
	return
/mob/living/carbon/MiddleClickOn(var/atom/A)
	swap_hand()

// In case of use break glass
/*
/atom/proc/MiddleClick(var/mob/M as mob)
	return
*/

/*
	Shift click
	For most mobs, examine.
	This is overridden in ai.dm
*/
/mob/proc/ShiftClickOn(var/atom/A)
	A.ShiftClick(src)
	return
/atom/proc/ShiftClick(var/mob/user)
	if(user.client && user.client.eye == user)
		examine()
	return

/*
	Ctrl click
	For most objects, pull
*/
/mob/proc/CtrlClickOn(var/atom/A)
	A.CtrlClick(src)
	return
/atom/proc/CtrlClick(var/mob/user)
	return

/atom/movable/CtrlClick(var/mob/user)
	if(Adjacent(user))
		user.start_pulling(src)

/*
	Alt click
	Unused except for AI
*/
/mob/proc/AltClickOn(var/atom/A)
	A.AltClick(src)
	return

/atom/proc/AltClick(var/mob/user)
	if(ishuman(src) && user.Adjacent(src))
		src:give_item(user)
		return
	var/turf/T = get_turf(src)
	if(T && T.Adjacent(user))
		if(user.listed_turf == T)
			user.listed_turf = null
		else
			user.listed_turf = T
			user.client.statpanel = T.name
	return

/*
	Misc helpers

	Laser Eyes: as the name implies, handles this since nothing else does currently
	face_atom: turns the mob towards what you clicked on
*/
/mob/proc/LaserEyes(atom/A)
	return

/mob/living/LaserEyes(atom/A)
	//next_move = world.time + 6
	changeNext_move(4)
	var/turf/T = get_turf(src)
	var/turf/U = get_turf(A)

	var/obj/item/projectile/beam/LE = getFromPool(/obj/item/projectile/beam, loc)
	LE.icon = 'icons/effects/genetics.dmi'
	LE.icon_state = "eyelasers"
	playsound(usr.loc, 'sound/weapons/taser2.ogg', 75, 1)

	LE.firer = src
	LE.def_zone = get_organ_target()
	LE.original = A
	LE.current = T
	LE.yo = U.y - T.y
	LE.xo = U.x - T.x
	spawn( 1 )
		LE.process()

/mob/living/carbon/human/LaserEyes()
	if(nutrition>0)
		..()
		nutrition = max(nutrition - rand(1,5),0)
		handle_regular_hud_updates()
	else
		src << "\red You're out of energy!  You need food!"

/mob/proc/PowerGlove(atom/A)
	return

/mob/living/carbon/human/PowerGlove(atom/A)
	var/obj/item/clothing/gloves/yellow/power/G = src:gloves
	var/time = 100
	var/turf/T = get_turf(src)
	var/turf/U = get_turf(A)
	var/obj/structure/cable/cable = locate() in T
	if(!cable || !istype(cable))
		return
	if(world.time < G.next_shock)
		src << "<span class='warning'>[G] aren't ready to shock again!</span>"
		return
	src.visible_message("<span class='warning'>[name] fires an arc of electricity!</span>", \
	"<span class='warning'>You fire an arc of electricity!</span>", \
	"You hear the loud crackle of electricity!")
	var/datum/powernet/PN = cable.get_powernet()
	var/obj/item/projectile/beam/lightning/L = getFromPool(/obj/item/projectile/beam/lightning, loc)
	if(PN)
		L.damage = PN.get_electrocute_damage()
		if(L.damage >= 200)
			apply_damage(15, BURN, (hand ? "l_hand" : "r_hand"))
			//usr:Stun(15)
			//usr:Weaken(15)
			//if(usr:status_flags & CANSTUN) // stun is usually associated with stutter
			//	usr:stuttering += 20
			time = 200
			src << "<span class='warning'>[G] overloads from the massive current, shocking you in the process!"
		else if(L.damage >= 100)
			apply_damage(5, BURN, (hand ? "l_hand" : "r_hand"))
			//usr:Stun(10)
			//usr:Weaken(10)
			//if(usr:status_flags & CANSTUN) // stun is usually associated with stutter
			//	usr:stuttering += 10
			time = 150
			src << "<span class='warning'>[G] overloads from the massive current, shocking you in the process!"
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, src)
		s.start()
	if(L.damage <= 0)
		returnToPool(L)
		//del(L)
	if(L)
		playsound(get_turf(src), 'sound/effects/eleczap.ogg', 75, 1)
		L.tang = L.adjustAngle(get_angle(U,T))
		L.icon = midicon
		L.icon_state = "[L.tang]"
		L.firer = usr
		L.def_zone = get_organ_target()
		L.original = src
		L.current = U
		L.starting = U
		L.yo = U.y - T.y
		L.xo = U.x - T.x
		spawn( 1 )
			L.process()

	next_move = world.time + 12
	G.next_shock = world.time + time

// Simple helper to face what you clicked on, in case it should be needed in more than one place
/mob/proc/face_atom(var/atom/A)
	if(stat != CONSCIOUS || buckled || !A || !x || !y || !A.x || !A.y )
		return

	var/dx = A.x - x
	var/dy = A.y - y

	if(!dx && !dy) // Wall items are graphically shifted but on the floor
		if(A.pixel_y > 16)
			dir = NORTH
		else if(A.pixel_y < -16)
			dir = SOUTH
		else if(A.pixel_x > 16)
			dir = EAST
		else if(A.pixel_x < -16)
			dir = WEST

		return

	if(abs(dx) < abs(dy))
		if(dy > 0)
			dir = NORTH
		else
			dir = SOUTH
	else
		if(dx > 0)
			dir = EAST
		else
			dir = WEST
