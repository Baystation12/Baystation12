/obj/item/inflatable
	name = "inflatable"
	w_class = ITEM_SIZE_NORMAL
	icon = 'icons/obj/inflatable.dmi'
	var/deploy_path = null

	atmos_canpass = CANPASS_DENSITY

/obj/item/inflatable/attack_self(mob/user)
	if(!deploy_path)
		return
	playsound(loc, 'sound/items/zip.ogg', 75, 1)
	to_chat(user, "<span class='notice'>You inflate \the [src].</span>")
	var/obj/structure/inflatable/R = new deploy_path(user.loc)
	src.transfer_fingerprints_to(R)
	R.add_fingerprint(user)
	qdel(src)


/obj/item/inflatable/wall
	name = "inflatable wall"
	desc = "A folded membrane which rapidly expands into a large cubical shape on activation."
	icon_state = "folded_wall"
	deploy_path = /obj/structure/inflatable/wall

/obj/item/inflatable/door/
	name = "inflatable door"
	desc = "A folded membrane which rapidly expands into a simple door on activation."
	icon_state = "folded_door"
	deploy_path = /obj/structure/inflatable/door

/obj/structure/inflatable
	name = "inflatable"
	desc = "An inflated membrane. Do not puncture."
	density = 1
	anchored = 1
	opacity = 0
	icon = 'icons/obj/inflatable.dmi'
	icon_state = "wall"

	var/undeploy_path = null
	var/health = 50.0

/obj/structure/inflatable/wall
	name = "inflatable wall"
	undeploy_path = /obj/item/inflatable/wall

/obj/structure/inflatable/New(location)
	..()
	update_nearby_tiles(need_rebuild=1)

/obj/structure/inflatable/Destroy()
	update_nearby_tiles()
	return ..()

/obj/structure/inflatable/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	return 0

/obj/structure/inflatable/bullet_act(var/obj/item/projectile/Proj)
	var/proj_damage = Proj.get_structure_damage()
	if(!proj_damage) return

	health -= proj_damage
	..()
	if(health <= 0)
		deflate(1)
	return

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

/obj/structure/inflatable/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(!istype(W) || istype(W, /obj/item/weapon/inflatable_dispenser)) return

	if((W.damtype == BRUTE || W.damtype == BURN) && W.can_puncture())
		..()
		if(hit(W.force))
			visible_message("<span class='danger'>[user] pierces [src] with [W]!</span>")
	return

/obj/structure/inflatable/proc/hit(var/damage, var/sound_effect = 1)
	health = max(0, health - damage)
	if(sound_effect)
		playsound(loc, 'sound/effects/Glasshit.ogg', 75, 1)
	if(health <= 0)
		deflate(1)
		return 1
	return 0

/obj/structure/inflatable/CtrlClick()
	hand_deflate()

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
			qdel(src)

/obj/structure/inflatable/verb/hand_deflate()
	set name = "Deflate"
	set category = "Object"
	set src in oview(1)

	if(isobserver(usr) || usr.restrained() || !usr.Adjacent(src))
		return

	verbs -= /obj/structure/inflatable/verb/hand_deflate
	deflate()

/obj/structure/inflatable/attack_generic(var/mob/user, var/damage, var/attack_verb)
	health -= damage
	attack_animation(user)
	if(health <= 0)
		user.visible_message("<span class='danger'>[user] [attack_verb] open the [src]!</span>")
		spawn(1) deflate(1)
	else
		user.visible_message("<span class='danger'>[user] [attack_verb] at [src]!</span>")
	return 1

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
	else if(istype(user, /obj/mecha))
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
	isSwitchingStates = 1
	flick("door_closing",src)
	sleep(10)
	set_density(1)
	set_opacity(0)
	state = 0
	update_icon()
	isSwitchingStates = 0

/obj/structure/inflatable/door/update_icon()
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
