/mob/living/bot
	name = "Bot"
	health = 20
	maxHealth = 20
	icon = 'icons/obj/aibots.dmi'
	universal_speak = 1
	density = 0
	var/obj/item/weapon/card/id/botcard = null
	var/list/botcard_access = list()
	var/on = 1
	var/open = 0
	var/locked = 1
	var/emagged = 0
	var/light_strength = 3
	var/busy = 0

	var/obj/access_scanner = null
	var/list/req_access = list()
	var/list/req_one_access = list()

	var/atom/target = null
	var/list/ignore_list = list()
	var/list/patrol_path = list()
	var/list/target_path = list()
	var/turf/obstacle = null

	var/wait_if_pulled = 0 // Only applies to moving to the target
	var/will_patrol = 0 // If set to 1, will patrol, duh
	var/patrol_speed = 1 // How many times per tick we move when patrolling
	var/target_speed = 2 // Ditto for chasing the target
	var/min_target_dist = 1 // How close we try to get to the target
	var/max_target_dist = 50 // How far we are willing to go
	var/max_patrol_dist = 250

	var/target_patience = 5
	var/frustration = 0
	var/max_frustration = 0

/mob/living/bot/New()
	..()
	update_icons()

	botcard = new /obj/item/weapon/card/id(src)
	botcard.access = botcard_access.Copy()

	access_scanner = new /obj(src)
	access_scanner.req_access = req_access.Copy()
	access_scanner.req_one_access = req_one_access.Copy()

/mob/living/bot/initialize()
	..()
	if(on)
		turn_on() // Update lights and other stuff
	else
		turn_off()

/mob/living/bot/Life()
	..()
	if(health <= 0)
		death()
		return
	weakened = 0
	stunned = 0
	paralysis = 0

	if(on && !client && !busy)
		spawn(0)
			handleAI()

/mob/living/bot/updatehealth()
	if(status_flags & GODMODE)
		health = maxHealth
		stat = CONSCIOUS
	else
		health = maxHealth - getFireLoss() - getBruteLoss()
	oxyloss = 0
	toxloss = 0
	cloneloss = 0
	halloss = 0

/mob/living/bot/death()
	explode()

/mob/living/bot/attackby(var/obj/item/O, var/mob/user)
	if(O.GetIdCard())
		if(access_scanner.allowed(user) && !open && !emagged)
			locked = !locked
			to_chat(user, "<span class='notice'>Controls are now [locked ? "locked." : "unlocked."]</span>")
			attack_hand(user)
		else
			if(emagged)
				to_chat(user, "<span class='warning'>ERROR</span>")
			if(open)
				to_chat(user, "<span class='warning'>Please close the access panel before locking it.</span>")
			else
				to_chat(user, "<span class='warning'>Access denied.</span>")
		return
	else if(istype(O, /obj/item/weapon/screwdriver))
		if(!locked)
			open = !open
			to_chat(user, "<span class='notice'>Maintenance panel is now [open ? "opened" : "closed"].</span>")
		else
			to_chat(user, "<span class='notice'>You need to unlock the controls first.</span>")
		return
	else if(istype(O, /obj/item/weapon/weldingtool))
		if(health < maxHealth)
			if(open)
				health = min(maxHealth, health + 10)
				user.visible_message("<span class='notice'>[user] repairs [src].</span>","<span class='notice'>You repair [src].</span>")
			else
				to_chat(user, "<span class='notice'>Unable to repair with the maintenance panel closed.</span>")
		else
			to_chat(user, "<span class='notice'>[src] does not need a repair.</span>")
		return
	else
		..()

/mob/living/bot/attack_ai(var/mob/user)
	return attack_hand(user)

/mob/living/bot/say(var/message)
	var/verb = "beeps"

	message = sanitize(message)

	..(message, null, verb)

/mob/living/bot/Bump(var/atom/A)
	if(on && botcard && istype(A, /obj/machinery/door))
		var/obj/machinery/door/D = A
		if(!istype(D, /obj/machinery/door/firedoor) && !istype(D, /obj/machinery/door/blast) && D.check_access(botcard))
			D.open()
	else
		..()

/mob/living/bot/emag_act(var/remaining_charges, var/mob/user)
	return 0

/mob/living/bot/proc/handleAI()
	if(ignore_list.len)
		for(var/atom/A in ignore_list)
			if(!A || !A.loc || prob(1))
				ignore_list -= A
	handleRegular()
	if(target && confirmTarget(target))
		if(Adjacent(target))
			handleAdjacentTarget()
		else
			handleRangedTarget()
		if(!wait_if_pulled || !pulledby)
			for(var/i = 1 to target_speed)
				sleep(20 / (target_speed + 1))
				stepToTarget()
		if(max_frustration && frustration > max_frustration * target_speed)
			handleFrustrated(1)
	else
		resetTarget()
		lookForTargets()
		if(will_patrol && !pulledby && !target)
			if(patrol_path && patrol_path.len)
				for(var/i = 1 to patrol_speed)
					sleep(20 / (patrol_speed + 1))
					handlePatrol()
				if(max_frustration && frustration > max_frustration * patrol_speed)
					handleFrustrated(0)
			else
				startPatrol()
		else
			handleIdle()

/mob/living/bot/proc/handleRegular()
	return

/mob/living/bot/proc/handleAdjacentTarget()
	return

/mob/living/bot/proc/handleRangedTarget()
	return

/mob/living/bot/proc/stepToTarget()
	if(!target || !target.loc)
		return
	if(get_dist(src, target) > min_target_dist)
		if(!target_path.len || get_turf(target) != target_path[target_path.len])
			calcTargetPath()
		if(makeStep(target_path))
			frustration = 0
		else if(max_frustration)
			++frustration
	return

/mob/living/bot/proc/handleFrustrated(var/targ)
	obstacle = targ ? target_path[1] : patrol_path[1]
	target_path = list()
	patrol_path = list()
	return

/mob/living/bot/proc/lookForTargets()
	return

/mob/living/bot/proc/confirmTarget(var/atom/A)
	if(A.invisibility >= INVISIBILITY_LEVEL_ONE)
		return 0
	if(A in ignore_list)
		return 0
	if(!A.loc)
		return 0
	return 1

/mob/living/bot/proc/handlePatrol()
	makeStep(patrol_path)
	return

/mob/living/bot/proc/startPatrol()
	var/turf/T = getPatrolTurf()
	if(T)
		patrol_path = AStar(get_turf(loc), T, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, max_patrol_dist, id = botcard, exclude = obstacle)
		if(!patrol_path)
			patrol_path = list()
		obstacle = null
	return

/mob/living/bot/proc/getPatrolTurf()
	var/minDist = INFINITY
	var/obj/machinery/navbeacon/targ = locate() in get_turf(src)
	
	if(!targ)
		for(var/obj/machinery/navbeacon/N in navbeacons)
			if(!N.codes["patrol"])
				continue
			if(get_dist(src, N) < minDist)
				minDist = get_dist(src, N)
				targ = N

	if(targ && targ.codes["next_patrol"])
		for(var/obj/machinery/navbeacon/N in navbeacons)
			if(N.location == targ.codes["next_patrol"])
				targ = N
				break

	if(targ)
		return get_turf(targ)
	return null

/mob/living/bot/proc/handleIdle()
	return

/mob/living/bot/proc/calcTargetPath()
	target_path = AStar(get_turf(loc), get_turf(target), /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, max_target_dist, id = botcard, exclude = obstacle)
	if(!target_path)
		if(target && target.loc)
			ignore_list |= target
		resetTarget()
		obstacle = null
	return

/mob/living/bot/proc/makeStep(var/list/path)
	if(!path.len)
		return 0
	var/turf/T = path[1]
	if(get_turf(src) == T)
		path -= T
		return makeStep(path)

	return step_towards(src, T)

/mob/living/bot/proc/resetTarget()
	target = null
	target_path = list()
	frustration = 0
	obstacle = null

/mob/living/bot/proc/turn_on()
	if(stat)
		return 0
	on = 1
	set_light(light_strength)
	update_icons()
	resetTarget()
	patrol_path = list()
	ignore_list = list()
	return 1

/mob/living/bot/proc/turn_off()
	on = 0
	set_light(0)
	update_icons()

/mob/living/bot/proc/explode()
	qdel(src)

/******************************************************************/
// Navigation procs
// Used for A-star pathfinding


// Returns the surrounding cardinal turfs with open links
// Including through doors openable with the ID
/turf/proc/CardinalTurfsWithAccess(var/obj/item/weapon/card/id/ID)
	var/L[] = new()

	//	for(var/turf/simulated/t in oview(src,1))

	for(var/d in cardinal)
		var/turf/simulated/T = get_step(src, d)
		if(istype(T) && !T.density)
			if(!LinkBlockedWithAccess(src, T, ID))
				L.Add(T)
	return L


// Returns true if a link between A and B is blocked
// Movement through doors allowed if ID has access
/proc/LinkBlockedWithAccess(turf/A, turf/B, obj/item/weapon/card/id/ID)

	if(A == null || B == null) return 1
	var/adir = get_dir(A,B)
	var/rdir = get_dir(B,A)
	if((adir & (NORTH|SOUTH)) && (adir & (EAST|WEST)))	//	diagonal
		var/iStep = get_step(A,adir&(NORTH|SOUTH))
		if(!LinkBlockedWithAccess(A,iStep, ID) && !LinkBlockedWithAccess(iStep,B,ID))
			return 0

		var/pStep = get_step(A,adir&(EAST|WEST))
		if(!LinkBlockedWithAccess(A,pStep,ID) && !LinkBlockedWithAccess(pStep,B,ID))
			return 0
		return 1

	if(DirBlockedWithAccess(A,adir, ID))
		return 1

	if(DirBlockedWithAccess(B,rdir, ID))
		return 1

	for(var/obj/O in B)
		if(O.density && !istype(O, /obj/machinery/door) && !(O.flags & ON_BORDER))
			return 1

	return 0

// Returns true if direction is blocked from loc
// Checks doors against access with given ID
/proc/DirBlockedWithAccess(turf/loc,var/dir,var/obj/item/weapon/card/id/ID)
	for(var/obj/structure/window/D in loc)
		if(!D.density)			continue
		if(D.dir == SOUTHWEST)	return 1
		if(D.dir == dir)		return 1

	for(var/obj/machinery/door/D in loc)
		if(!D.density)			continue
		if(istype(D, /obj/machinery/door/window))
			if( dir & D.dir )	return !D.check_access(ID)

			//if((dir & SOUTH) && (D.dir & (EAST|WEST)))		return !D.check_access(ID)
			//if((dir & EAST ) && (D.dir & (NORTH|SOUTH)))	return !D.check_access(ID)
		else return !D.check_access(ID)	// it's a real, air blocking door
	return 0
