/obj/item/inflatable
	name = "inflatable"
	w_class = ITEM_SIZE_NORMAL
	icon = 'icons/obj/inflatable.dmi'
	var/deploy_path = null
	var/inflatable_health

/obj/item/inflatable/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!deploy_path)
		return
	if (loc != user)
		return
	var/turf/T = get_turf(target)
	if (!user.TurfAdjacent(T))
		return
	var/obstruction = T.get_obstruction()
	if (obstruction)
		to_chat(user, SPAN_WARNING("\The [english_list(obstruction)] is blocking that spot."))
		return
	user.visible_message(
		SPAN_ITALIC("\The [user] starts inflating \an [src]."),
		SPAN_ITALIC("You start inflating \the [src]."),
		SPAN_ITALIC("You can hear rushing air."),
		range = 5
	)
	if (!do_after(user, 1 SECOND))
		return
	obstruction = T.get_obstruction()
	if (obstruction)
		to_chat(user, SPAN_WARNING("\The [english_list(obstruction)] is blocking that spot."))
		return
	user.visible_message(
		SPAN_ITALIC("\The [user] finishes inflating \an [src]."),
		SPAN_NOTICE("You inflate \the [src]."),
		range = 5
	)
	playsound(loc, 'sound/items/zip.ogg', 75, 1)
	var/obj/structure/inflatable/R = new deploy_path(T)
	transfer_fingerprints_to(R)
	R.add_fingerprint(user)
	if(inflatable_health)
		R.health = inflatable_health
	qdel(src)

/obj/item/inflatable/wall
	name = "inflatable wall"
	desc = "A folded membrane which rapidly expands into a large cubical shape on activation."
	icon_state = "folded_wall"
	deploy_path = /obj/structure/inflatable/wall

/obj/item/inflatable/door
	name = "inflatable door"
	desc = "A folded membrane which rapidly expands into a simple door on activation."
	icon_state = "folded_door"
	item_state = "folded_door"
	deploy_path = /obj/structure/inflatable/door

/obj/structure/inflatable
	name = "inflatable"
	desc = "An inflated membrane. Do not puncture."
	density = 1
	anchored = 1
	opacity = 0
	icon = 'icons/obj/inflatable.dmi'
	icon_state = "wall"
	atmos_canpass = CANPASS_DENSITY

	var/undeploy_path = null
	var/health = 10
	var/taped

	var/max_pressure_diff = RIG_MAX_PRESSURE
	var/max_temp = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/structure/inflatable/wall
	name = "inflatable wall"
	undeploy_path = /obj/item/inflatable/wall
	atmos_canpass = CANPASS_NEVER

/obj/structure/inflatable/New(location)
	..()
	update_nearby_tiles(need_rebuild=1)

/obj/structure/inflatable/Initialize()
	. = ..()
	START_PROCESSING(SSobj,src)

/obj/structure/inflatable/Destroy()
	update_nearby_tiles()
	STOP_PROCESSING(SSobj,src)
	return ..()

/obj/structure/inflatable/Process()
	check_environment()

/obj/structure/inflatable/proc/check_environment()
	var/min_pressure = INFINITY
	var/max_pressure = 0
	var/max_local_temp = 0

	for(var/check_dir in GLOB.cardinal)
		var/turf/T = get_step(get_turf(src), check_dir)
		var/datum/gas_mixture/env = T.return_air()
		var/pressure = env.return_pressure()
		min_pressure = min(min_pressure, pressure)
		max_pressure = max(max_pressure, pressure)
		max_local_temp = max(max_local_temp, env.temperature)

	if(prob(50) && (max_pressure - min_pressure > max_pressure_diff || max_local_temp > max_temp))
		take_damage(1)
		if(health == round(0.7*initial(health)))
			visible_message(SPAN_WARNING("\The [src] is taking damage!"))
		if(health == round(0.3*initial(health)))
			visible_message(SPAN_WARNING("\The [src] is barely holding up!"))

/obj/structure/inflatable/examine(mob/user)
	. = ..()
	if(health >= initial(health))
		to_chat(user, SPAN_NOTICE("It's undamaged."))
	else if(health >= 0.5 * initial(health))
		to_chat(user, SPAN_WARNING("It's showing signs of damage."))
	else if(health >= 0)
		to_chat(user, SPAN_DANGER("It's heavily damaged!"))
	to_chat(user, SPAN_NOTICE("It's been duct taped in few places."))

/obj/structure/inflatable/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	return 0

/obj/structure/inflatable/bullet_act(var/obj/item/projectile/Proj)
	take_damage(Proj.get_structure_damage())
	if(health <= 0)
		return PROJECTILE_CONTINUE

/obj/structure/inflatable/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			deflate(1)
			return
		if(3.0)
			if(prob(50))
				deflate(1)
				return

/obj/structure/inflatable/attack_hand(mob/user as mob)
	add_fingerprint(user)
	return

/obj/structure/inflatable/attackby(obj/item/weapon/W, mob/user)
	if(!istype(W) || istype(W, /obj/item/weapon/inflatable_dispenser)) return

	if(istype(W, /obj/item/weapon/tape_roll) && health < initial(health) - 3)
		if(taped)
			to_chat(user, SPAN_NOTICE("\The [src] can't be patched any more with \the [W]!"))
			return TRUE
		else
			taped = TRUE
			to_chat(user, SPAN_NOTICE("You patch some damage in \the [src] with \the [W]!"))
			take_damage(-3)
			return TRUE
	else if((W.damtype == BRUTE || W.damtype == BURN) && (W.can_puncture() || W.force > 10))
		..()
		if(hit(W.force))
			visible_message("<span class='danger'>[user] pierces [src] with [W]!</span>")
	return

/obj/structure/inflatable/proc/hit(var/damage, var/sound_effect = 1)
	take_damage(damage)
	if(sound_effect)
		playsound(loc, 'sound/effects/Glasshit.ogg', 75, 1)
	return health <= 0

/obj/structure/inflatable/take_damage(damage)
	health = max(0, health - damage)
	if(health <= 0)
		deflate(1)

/obj/structure/inflatable/CtrlClick()
	return hand_deflate()

/obj/structure/inflatable/proc/deflate(var/violent=0)
	playsound(loc, 'sound/machines/hiss.ogg', 75, 1)
	if(violent)
		visible_message("[src] rapidly deflates!")
		var/obj/item/inflatable/torn/R = new /obj/item/inflatable/torn(loc)
		src.transfer_fingerprints_to(R)
		qdel(src)
	else
		if(!undeploy_path)
			return
		visible_message("\The [src] slowly deflates.")
		spawn(50)
			var/obj/item/inflatable/R = new undeploy_path(src.loc)
			src.transfer_fingerprints_to(R)
			R.inflatable_health = health
			qdel(src)

/obj/structure/inflatable/verb/hand_deflate()
	set name = "Deflate"
	set category = "Object"
	set src in oview(1)

	if(isobserver(usr) || usr.restrained() || !usr.Adjacent(src))
		return FALSE

	verbs -= /obj/structure/inflatable/verb/hand_deflate
	deflate()
	return TRUE

/obj/structure/inflatable/attack_generic(var/mob/user, var/damage, var/attack_verb)
	health -= damage
	attack_animation(user)
	if(health <= 0)
		user.visible_message("<span class='danger'>[user] [attack_verb] open the [src]!</span>")
		spawn(1) deflate(1)
	else
		user.visible_message("<span class='danger'>[user] [attack_verb] at [src]!</span>")
	return 1

/obj/structure/inflatable/CanFluidPass(var/coming_from)
	return !density

/obj/structure/inflatable/door //Based on mineral door code
	name = "inflatable door"
	density = 1
	anchored = 1
	opacity = 0

	icon_state = "door_closed"
	undeploy_path = /obj/item/inflatable/door

	var/state = 0 //closed, 1 == open
	var/isSwitchingStates = 0

/obj/structure/inflatable/door/attack_ai(mob/user as mob) //those aren't machinery, they're just big fucking slabs of a mineral
	if(isAI(user)) //so the AI can't open it
		return
	else if(isrobot(user)) //but cyborgs can
		if(get_dist(user,src) <= 1) //not remotely though
			return TryToSwitchState(user)

/obj/structure/inflatable/door/attack_hand(mob/user as mob)
	return TryToSwitchState(user)

/obj/structure/inflatable/door/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group)
		return state
	if(istype(mover, /obj/effect/beam))
		return !opacity
	return !density

/obj/structure/inflatable/door/proc/TryToSwitchState(atom/user)
	if(isSwitchingStates) return
	if(ismob(user))
		var/mob/M = user
		if(M.client)
			if(iscarbon(M))
				var/mob/living/carbon/C = M
				if(!C.handcuffed)
					SwitchState()
			else
				SwitchState()

/obj/structure/inflatable/door/proc/SwitchState()
	if(state)
		Close()
	else
		Open()
	update_nearby_tiles()

/obj/structure/inflatable/door/proc/Open()
	isSwitchingStates = 1
	flick("door_opening",src)
	sleep(10)
	set_density(0)
	set_opacity(0)
	state = 1
	update_icon()
	isSwitchingStates = 0

/obj/structure/inflatable/door/proc/Close()
	// If the inflatable is blocked, don't close
	for(var/turf/A in locs)
		var/turf/T = A
		var/obstruction = T.get_obstruction()
		if (obstruction)
			return

	isSwitchingStates = 1
	flick("door_closing",src)
	sleep(10)
	set_density(1)
	set_opacity(0)
	state = 0
	update_icon()
	isSwitchingStates = 0

/obj/structure/inflatable/door/on_update_icon()
	if(state)
		icon_state = "door_open"
	else
		icon_state = "door_closed"

/obj/structure/inflatable/door/deflate(var/violent=0)
	playsound(loc, 'sound/machines/hiss.ogg', 75, 1)
	if(violent)
		visible_message("[src] rapidly deflates!")
		var/obj/item/inflatable/door/torn/R = new /obj/item/inflatable/door/torn(loc)
		src.transfer_fingerprints_to(R)
		qdel(src)
	else
		visible_message("[src] slowly deflates.")
		spawn(50)
			var/obj/item/inflatable/door/R = new /obj/item/inflatable/door(loc)
			src.transfer_fingerprints_to(R)
			qdel(src)

/obj/item/inflatable/torn
	name = "torn inflatable wall"
	desc = "A folded membrane which rapidly expands into a large cubical shape on activation. It is too torn to be usable."
	icon = 'icons/obj/inflatable.dmi'
	icon_state = "folded_wall_torn"

	attack_self(mob/user)
		to_chat(user, "<span class='notice'>The inflatable wall is too torn to be inflated!</span>")
		add_fingerprint(user)

/obj/item/inflatable/door/torn
	name = "torn inflatable door"
	desc = "A folded membrane which rapidly expands into a simple door on activation. It is too torn to be usable."
	icon = 'icons/obj/inflatable.dmi'
	icon_state = "folded_door_torn"

	attack_self(mob/user)
		to_chat(user, "<span class='notice'>The inflatable door is too torn to be inflated!</span>")
		add_fingerprint(user)

/obj/item/weapon/storage/briefcase/inflatable
	name = "inflatable barrier box"
	desc = "Contains inflatable walls and doors."
	icon_state = "inf_box"
	item_state = "syringe_kit"
	w_class = ITEM_SIZE_LARGE
	max_storage_space = DEFAULT_LARGEBOX_STORAGE
	can_hold = list(/obj/item/inflatable)
	startswith = list(/obj/item/inflatable/door = 2, /obj/item/inflatable/wall = 3)
