/mob/living/bot
	name = "Bot"
	health = 20
	maxHealth = 20
	icon = 'icons/mob/bot/placeholder.dmi'
	universal_speak = TRUE
	density = FALSE

	meat_type = null
	meat_amount = 0
	skin_material = null
	skin_amount = 0
	bone_material = null
	bone_amount = 0

	var/obj/item/card/id/botcard = null
	var/list/botcard_access = list()
	var/on = 1
	var/open = 0
	var/locked = 1
	var/emagged = FALSE
	var/light_strength = 3
	var/busy = 0

	var/obj/access_scanner = null
	var/list/req_access = list()

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
	var/RequiresAccessToToggle = 0 // If 1, will check access to be turned on/off

	var/target_patience = 5
	var/frustration = 0
	var/max_frustration = 0

	layer = HIDING_MOB_LAYER


/mob/living/bot/Initialize(mapload)
	. = ..()
	update_icons()

	botcard = new /obj/item/card/id(src)
	botcard.access = botcard_access.Copy()

	access_scanner = new /obj(src)
	access_scanner.req_access = req_access.Copy()


/mob/living/bot/Initialize()
	. = ..()
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

/mob/living/bot/death()
	explode()


/mob/living/bot/get_interactions_info()
	. = ..()
	.[CODEX_INTERACTION_ID_CARD] = "<p>Toggles the access panel lock. The ID must have access, and the panel must be closed.</p>"
	.[CODEX_INTERACTION_SCREWDRIVER] = "<p>Opens and closes the access panel. The panel must be unlocked.</p>"
	.[CODEX_INTERACTION_WELDER] = "<p>Repairs 10 points of damage. The access panel must be open. Uses 5 units of fuel.</p>"


/mob/living/bot/use_tool(obj/item/tool, mob/user, list/click_params)
	// ID Card - Toggle access panel lock
	var/obj/item/card/id/id = tool.GetIdCard()
	if (istype(id))
		if (open)
			USE_FEEDBACK_FAILURE("\The [src]'s access panel must be closed before you can lock it.")
			return TRUE
		var/id_name = GET_ID_NAME(id, tool)
		if (!access_scanner.check_access(id))
			USE_FEEDBACK_ID_CARD_DENIED(src, id_name)
			return TRUE
		locked = !locked
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] [locked ? "locks" : "unlocks"] \the [src]'s access panel lock with \a [tool]."),
			SPAN_NOTICE("You [locked ? "lock" : "unlock"] \the [src]'s access panel lock with \the [tool].")
		)
		Interact(user)
		return TRUE

	// Screwdriver - Toggle access panel open/closed
	if (isScrewdriver(tool))
		if (locked)
			USE_FEEDBACK_FAILURE("\The [src]'s access panel must be unlocked before you can open it.")
			return TRUE
		open = !open
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] [open ? "opens" : "closes"] \the [src]'s access panel with \a [tool]."),
			SPAN_NOTICE("You [open ? "open" : "close"] \the [src]'s access panel with \the [tool].")
		)
		Interact(user)
		return TRUE

	// Welder - Repairs damage
	if (isWelder(tool))
		if (health >= maxHealth)
			USE_FEEDBACK_FAILURE("\The [src] doesn't need any repairs.")
			return TRUE
		if (!open)
			USE_FEEDBACK_FAILURE("\The [src]'s access panel must be open to repair it.")
			return TRUE
		var/obj/item/weldingtool/welder = tool
		if (!welder.can_use(5, user, "to repair \the [src]."))
			return TRUE
		welder.remove_fuel(5, user)
		health = min(maxHealth, health + 10)
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] repairs some of \the [src]'s damage with \a [tool]."),
			SPAN_NOTICE("You repair some of \the [src]'s damage with \the [tool].")
		)
		return TRUE

	return ..()


/mob/living/bot/attack_ai(mob/user)
	Interact(user)

/mob/living/bot/attack_hand(mob/user)
	Interact(user)

/mob/living/bot/proc/Interact(mob/user)
	add_fingerprint(user)
	var/dat

	var/curText = GetInteractTitle()
	if(curText)
		dat += curText
		dat += "<hr>"

	curText = GetInteractStatus()
	if(curText)
		dat += curText
		dat += "<hr>"

	curText = (CanAccessPanel(user)) ? GetInteractPanel() : "The access panel is locked."
	if(curText)
		dat += curText
		dat += "<hr>"

	curText = (CanAccessMaintenance(user)) ? GetInteractMaintenance() : "The maintenance panel is locked."
	if(curText)
		dat += curText

	var/datum/browser/popup = new(user, "botpanel", "[src] controls")
	popup.set_content(dat)
	popup.open()

/mob/living/bot/DefaultTopicState()
	return GLOB.default_state

/mob/living/bot/OnTopic(mob/user, href_list)
	if(href_list["command"])
		ProcessCommand(user, href_list["command"], href_list)
	Interact(user)

/mob/living/bot/proc/GetInteractTitle()
	return

/mob/living/bot/proc/GetInteractStatus()
	. = "Status: <A href='?src=\ref[src];command=toggle'>[on ? "On" : "Off"]</A>"
	. += "<BR>Behaviour controls are [locked ? "locked" : "unlocked"]"
	. += "<BR>Maintenance panel is [open ? "opened" : "closed"]"

/mob/living/bot/proc/GetInteractPanel()
	return

/mob/living/bot/proc/GetInteractMaintenance()
	return

/mob/living/bot/proc/ProcessCommand(mob/user, command, href_list)
	if(command == "toggle" && CanToggle(user))
		if(on)
			turn_off()
		else
			turn_on()
	return

/mob/living/bot/proc/CanToggle(mob/user)
	return (!RequiresAccessToToggle || access_scanner.allowed(user) || issilicon(user))

/mob/living/bot/proc/CanAccessPanel(mob/user)
	return (!locked || issilicon(user))

/mob/living/bot/proc/CanAccessMaintenance(mob/user)
	return (open || issilicon(user))

/mob/living/bot/say(message)
	var/verb = "beeps"

	message = sanitize(message)

	..(message, null, verb)

/mob/living/bot/Bump(atom/A)
	if(on && botcard && istype(A, /obj/machinery/door))
		var/obj/machinery/door/D = A
		if(!istype(D, /obj/machinery/door/firedoor) && !istype(D, /obj/machinery/door/blast) && D.check_access(botcard))
			D.open()
	else
		..()

/mob/living/bot/emag_act(remaining_charges, mob/user)
	return 0

/mob/living/bot/proc/handleAI()
	if(length(ignore_list))
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
			if(patrol_path && length(patrol_path))
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
		if(!length(target_path) || get_turf(target) != target_path[length(target_path)])
			calcTargetPath()
		if(makeStep(target_path))
			frustration = 0
		else if(max_frustration)
			++frustration
	return

/mob/living/bot/proc/handleFrustrated(targ)
	obstacle = targ ? target_path[1] : patrol_path[1]
	target_path = list()
	patrol_path = list()
	return

/mob/living/bot/proc/lookForTargets()
	return

/mob/living/bot/proc/confirmTarget(atom/A)
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

/mob/living/bot/proc/makeStep(list/path)
	if(!length(path))
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
	set_light(light_strength, 0.5)
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
/turf/proc/CardinalTurfsWithAccess(obj/item/card/id/ID)
	var/L[] = new()

	//	for(var/turf/simulated/t in oview(src,1))

	for(var/d in GLOB.cardinal)
		var/turf/simulated/T = get_step(src, d)
		if(istype(T) && !T.density)
			if(!LinkBlockedWithAccess(src, T, ID))
				L.Add(T)
	return L


// Returns true if a link between A and B is blocked
// Movement through doors allowed if ID has access
/proc/LinkBlockedWithAccess(turf/A, turf/B, obj/item/card/id/ID)

	if(isnull(A) || isnull(B)) return 1
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
		if(O.density && !istype(O, /obj/machinery/door) && !(O.atom_flags & ATOM_FLAG_CHECKS_BORDER))
			return 1

	return 0

// Returns true if direction is blocked from loc
// Checks doors against access with given ID
/proc/DirBlockedWithAccess(turf/loc,dir,obj/item/card/id/ID)
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
