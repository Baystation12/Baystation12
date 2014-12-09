//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31
#define DOOR_OPEN_LAYER 2.7		//Under all objects if opened. 2.7 due to tables being at 2.6
#define DOOR_CLOSED_LAYER 3.1	//Above most items if closed

/obj/machinery/door
	name = "Door"
	desc = "It opens and closes."
	icon = 'icons/obj/doors/Doorint.dmi'
	icon_state = "door1"
	anchored = 1
	opacity = 1
	density = 1
	layer = DOOR_OPEN_LAYER
	var/open_layer = DOOR_OPEN_LAYER
	var/closed_layer = DOOR_CLOSED_LAYER

	var/secondsElectrified = 0
	var/visible = 1
	var/p_open = 0
	var/operating = 0
	var/autoclose = 0
	var/glass = 0
	var/normalspeed = 1
	var/heat_proof = 0 // For glass airlocks/opacity firedoors
	var/air_properties_vary_with_direction = 0
	var/maxhealth = 300
	var/health
	var/min_force = 10 //minimum amount of force needed to damage the door with a melee weapon
	var/hitsound = 'sound/weapons/smash.ogg' //sound door makes when hit with a weapon

	//Multi-tile doors
	dir = EAST
	var/width = 1

/obj/machinery/door/New()
	. = ..()
	if(density)
		layer = closed_layer
		explosion_resistance = initial(explosion_resistance)
		update_heat_protection(get_turf(src))
	else
		layer = open_layer
		explosion_resistance = 0


	if(width > 1)
		if(dir in list(EAST, WEST))
			bound_width = width * world.icon_size
			bound_height = world.icon_size
		else
			bound_width = world.icon_size
			bound_height = width * world.icon_size

	health = maxhealth

	update_nearby_tiles(need_rebuild=1)
	return


/obj/machinery/door/Del()
	density = 0
	update_nearby_tiles()
	..()
	return

//process()
	//return

/obj/machinery/door/Bumped(atom/AM)
	if(p_open || operating) return
	if(ismob(AM))
		var/mob/M = AM
		if(world.time - M.last_bumped <= 10) return	//Can bump-open one airlock per second. This is to prevent shock spam.
		M.last_bumped = world.time
		if(!M.restrained() && !M.small)
			bumpopen(M)
		return

	if(istype(AM, /obj/machinery/bot))
		var/obj/machinery/bot/bot = AM
		if(src.check_access(bot.botcard))
			if(density)
				open()
		return

	if(istype(AM, /obj/mecha))
		var/obj/mecha/mecha = AM
		if(density)
			if(mecha.occupant && (src.allowed(mecha.occupant) || src.check_access_list(mecha.operation_req_access)))
				open()
			else
				flick("door_deny", src)
		return
	if(istype(AM, /obj/structure/stool/bed/chair/wheelchair))
		var/obj/structure/stool/bed/chair/wheelchair/wheel = AM
		if(density)
			if(wheel.pulling && (src.allowed(wheel.pulling)))
				open()
			else
				flick("door_deny", src)
		return
	return


/obj/machinery/door/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group) return 0
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return !opacity
	return !density


/obj/machinery/door/proc/bumpopen(mob/user as mob)
	if(operating)	return
	if(user.last_airflow > world.time - vsc.airflow_delay) //Fakkit
		return
	src.add_fingerprint(user)
	if(!src.requiresID())
		user = null

	if(density)
		if(allowed(user))	open()
		else				flick("door_deny", src)
	return

/obj/machinery/door/meteorhit(obj/M as obj)
	src.open()
	return

/obj/machinery/door/bullet_act(var/obj/item/projectile/Proj)
	..()

	//Tasers and the like should not damage doors. Nor should TOX, OXY, CLONE, etc damage types
	if(!(Proj.damage_type == BRUTE || Proj.damage_type == BURN))
		return

	if(Proj.damage)
		take_damage(Proj.damage)

/obj/machinery/door/hitby(AM as mob|obj)

	..()
	visible_message("\red <B>[src.name] was hit by [AM].</B>")
	var/tforce = 0
	if(ismob(AM))
		tforce = 15
	else
		tforce = AM:throwforce
	playsound(src.loc, hitsound, 100, 1)
	take_damage(tforce)
	//..() //Does this really need to be here twice? The parent proc doesn't even do anything yet. - Nodrak
	return

/obj/machinery/door/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/door/attack_hand(mob/user as mob)
	return src.attackby(user, user)

/obj/machinery/door/attack_tk(mob/user as mob)
	if(requiresID() && !allowed(null))
		return
	..()

/obj/machinery/door/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/device/detective_scanner))
		return
	if(src.operating || isrobot(user))	return //borgs can't attack doors open because it conflicts with their AI-like interaction with them.
	src.add_fingerprint(user)
	if(!Adjacent(user))
		user = null
	if(!src.requiresID())
		user = null
	if(istype(I, /obj/item/stack/sheet/metal))
		if(stat & BROKEN)
			user << "\blue [src.name] is damaged beyond repair and must be reconstructed!"
			return
		if(health >= maxhealth)
			user << "\blue Nothing to fix!"
			return
		var/obj/item/stack/sheet/metal/metalstack = I
		var/health_per_sheet = 50
		var/initialhealth = health
		src.health = min(maxhealth, health + 100, health + (metalstack.amount * health_per_sheet))
		user.visible_message("\The [user] patches some dents on \the [src] with \the [metalstack].")
		metalstack.use(round((health - initialhealth)/health_per_sheet))
		return

	if(src.density && ((operable() && istype(I, /obj/item/weapon/card/emag)) || istype(I, /obj/item/weapon/melee/energy/blade)))
		flick("door_spark", src)
		sleep(6)
		open()
		operating = -1
		return 1
	//psa to whoever coded this, there are plenty of objects that need to call attack() on doors without bludgeoning them.
	if(src.density && istype(I, /obj/item/weapon) && user.a_intent == "hurt" && !istype(I, /obj/item/weapon/card))
		var/obj/item/weapon/W = I
		if(W.damtype == BRUTE || W.damtype == BURN)
			if(W.force < min_force)
				user.visible_message("\red <B>\The [user] hits \the [src] with \the [W] with no visible effect.</B>" )
			else
				user.visible_message("\red <B>\The [user] forcefully slams \the [src] with \the [W]!</B>" )
				playsound(src.loc, hitsound, 100, 1)
				take_damage(W.force)
		return
	if(src.allowed(user) && operable())
		if(src.density)
			open()
		else
			close()
		return
	if(src.density && !(stat & (NOPOWER|BROKEN)))
		flick("door_deny", src)
	return

/obj/machinery/door/proc/take_damage(var/damage)
	var/initialhealth = src.health
	src.health = max(0, src.health - damage)
	if(src.health <= 0 && initialhealth > 0)
		src.set_broken()
	else if(src.health < src.maxhealth / 4 && initialhealth >= src.maxhealth / 4)
		visible_message("\The [src] looks like it's about to break!" )
	else if(src.health < src.maxhealth / 2 && initialhealth >= src.maxhealth / 2)
		visible_message("\The [src] looks seriously damaged!" )
	else if(src.health < src.maxhealth * 3/4 && initialhealth >= src.maxhealth * 3/4)
		visible_message("\The [src] shows signs of damage!" )
	update_icon()
	return

/obj/machinery/door/proc/set_broken()
	stat |= BROKEN
	for (var/mob/O in viewers(src, null))
		if ((O.client && !( O.blinded )))
			O.show_message("[src.name] breaks!" )
	update_icon()
	return


/obj/machinery/door/blob_act()
	if(prob(40))
		del(src)
	return


/obj/machinery/door/emp_act(severity)
	if(prob(20/severity) && (istype(src,/obj/machinery/door/airlock) || istype(src,/obj/machinery/door/window)) )
		open()
	if(prob(40/severity))
		if(secondsElectrified == 0)
			secondsElectrified = -1
			spawn(300)
				secondsElectrified = 0
	..()


/obj/machinery/door/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
		if(2.0)
			if(prob(25))
				del(src)
			else
				take_damage(300)
		if(3.0)
			if(prob(80))
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(2, 1, src)
				s.start()
			else
				take_damage(150)
	return


/obj/machinery/door/update_icon()
	if(density)
		icon_state = "door1"
	else
		icon_state = "door0"
	return


/obj/machinery/door/proc/do_animate(animation)
	switch(animation)
		if("opening")
			if(p_open)
				flick("o_doorc0", src)
			else
				flick("doorc0", src)
		if("closing")
			if(p_open)
				flick("o_doorc1", src)
			else
				flick("doorc1", src)
		if("deny")
			flick("door_deny", src)
	return


/obj/machinery/door/proc/open()
	if(!density)		return 1
	if(operating > 0)	return
	if(!ticker)			return 0
	if(!operating)		operating = 1

	do_animate("opening")
	icon_state = "door0"
	src.SetOpacity(0)
	sleep(10)
	src.layer = open_layer
	src.density = 0
	explosion_resistance = 0
	update_icon()
	SetOpacity(0)
	update_nearby_tiles()

	if(operating)	operating = 0

	if(autoclose  && normalspeed)
		spawn(150)
			autoclose()
	if(autoclose && !normalspeed)
		spawn(5)
			autoclose()

	return 1


/obj/machinery/door/proc/close()
	if(density)	return 1
	if(operating > 0)	return
	operating = 1

	src.density = 1
	explosion_resistance = initial(explosion_resistance)
	src.layer = closed_layer
	do_animate("closing")
	sleep(10)
	update_icon()
	if(visible && !glass)
		SetOpacity(1)	//caaaaarn!
	operating = 0
	update_nearby_tiles()

	//I shall not add a check every x ticks if a door has closed over some fire.
	var/obj/fire/fire = locate() in loc
	if(fire)
		del fire
	return

/obj/machinery/door/proc/requiresID()
	return 1

/obj/machinery/door/update_nearby_tiles(need_rebuild)
	if(!air_master)
		return 0

	for(var/turf/simulated/turf in locs)
		update_heat_protection(turf)
		air_master.mark_for_update(turf)

	return 1

/obj/machinery/door/proc/update_heat_protection(var/turf/simulated/source)
	if(istype(source))
		if(src.density && (src.opacity || src.heat_proof))
			source.thermal_conductivity = DOOR_HEAT_TRANSFER_COEFFICIENT
		else
			source.thermal_conductivity = initial(source.thermal_conductivity)

/obj/machinery/door/proc/autoclose()
	var/obj/machinery/door/airlock/A = src
	if(!A.density && !A.operating && !A.locked && !A.welded && !(A.stat & (BROKEN|NOPOWER)) && A.autoclose)
		close()
	return

/obj/machinery/door/Move(new_loc, new_dir)
	//update_nearby_tiles()
	. = ..()
	if(width > 1)
		if(dir in list(EAST, WEST))
			bound_width = width * world.icon_size
			bound_height = world.icon_size
		else
			bound_width = world.icon_size
			bound_height = width * world.icon_size

	update_nearby_tiles()

/obj/machinery/door/morgue
	icon = 'icons/obj/doors/doormorgue.dmi'
