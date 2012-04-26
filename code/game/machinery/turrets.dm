/area/turret_protected
	name = "Turret Protected Area"
	var/list/turretTargets = list()

/area/turret_protected/proc/subjectDied(target)
	if (istype(target, /mob))
		if (!istype(target, /mob/living/silicon))
			if (target:stat)
				if (target in turretTargets)
					src.Exited(target)


/area/turret_protected/Entered(O)
	..()
	if(master && master != src)
		return master.Entered(O)
//	world << "[O] entered[src.x],[src.y],[src.z]"

	if (istype(O, /mob/living/carbon))
		if (!(O in turretTargets))
			turretTargets += O
	else if (istype(O, /obj/mecha))
		var/obj/mecha/M = O
		if (M.occupant)
			if (!(M in turretTargets))
				turretTargets += M
	return 1

/area/turret_protected/Exited(O)
	if(master && master != src)
		return master.Exited(O)
//	world << "[O] exited [src.x],[src.y],[src.z]"
	if (istype(O, /mob))
		if (!istype(O, /mob/living/silicon))
			if (O in turretTargets)
				//O << "removing you from target list"
				turretTargets -= O
			//else
				//O << "You aren't in our target list!"

	else if (istype(O, /obj/mecha))
		if (O in turretTargets)
			turretTargets -= O
	..()
	return 1


/obj/machinery/turret
	name = "turret"
	icon = 'turrets.dmi'
	icon_state = "grey_target_prism"
	var/raised = 0
	var/enabled = 1
	anchored = 1
	layer = 3
	invisibility = 2
	density = 1
	var/lasers = 0
	var/lasertype = 1
		// 1 = lasers
		// 2 = cannons
		// 3 = pulse
		// 4 = change (HONK)
	var/health = 18
	var/id = ""
	var/obj/machinery/turretcover/cover = null
	var/popping = 0
	var/wasvalid = 0
	var/lastfired = 0
	var/shot_delay = 30 //3 seconds between shots
	var/datum/effect/effect/system/spark_spread/spark_system
	use_power = 1
	idle_power_usage = 50
	active_power_usage = 300
//	var/list/targets
	var/atom/movable/cur_target
	var/targeting_active = 0
	var/area/turret_protected/protected_area


/obj/machinery/turret/New()
	spark_system = new /datum/effect/effect/system/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)
//	targets = new
	..()
	return

/obj/machinery/turretcover
	name = "pop-up turret cover"
	icon = 'turrets.dmi'
	icon_state = "turretCover"
	anchored = 1
	layer = 3.5
	density = 0

/obj/machinery/turret/proc/isPopping()
	return (popping!=0)

/obj/machinery/turret/power_change()
	if(stat & BROKEN)
		icon_state = "grey_target_prism"
	else
		if( powered() )
			if (src.enabled)
				if (src.lasers)
					icon_state = "orange_target_prism"
				else
					icon_state = "target_prism"
			else
				icon_state = "grey_target_prism"
			stat &= ~NOPOWER
		else
			spawn(rand(0, 15))
				src.icon_state = "grey_target_prism"
				stat |= NOPOWER

/obj/machinery/turret/proc/setState(var/enabled, var/lethal)
	src.enabled = enabled
	src.lasers = lethal
	src.power_change()


/obj/machinery/turret/proc/get_protected_area()
	var/area/turret_protected/TP = get_area(src)
	if(istype(TP))
		if(TP.master && TP.master != TP)
			TP = TP.master
		return TP
	return

/obj/machinery/turret/proc/check_target(var/atom/movable/T as mob|obj)
	if(T && T in protected_area.turretTargets)
		if(!T in protected_area)
			protected_area.Exited(T)
			return 0 //If the guy is somehow not in the turret's area (teleportation), get them out the damn list. --NEO
		if(istype(T, /mob/living/carbon))
			var/mob/living/carbon/MC = T
			if(!MC.stat)
				if(!MC.lying || lasers)
					return 1
		else if(istype(T, /obj/mecha))
			var/obj/mecha/ME = T
			if(ME.occupant)
				return 1
	return 0

/obj/machinery/turret/proc/get_new_target()
	var/list/new_targets = new
	var/new_target
	for(var/mob/living/carbon/M in protected_area.turretTargets)
		if(!M.stat)
			if(!M.lying || lasers)
				new_targets += M
	for(var/obj/mecha/M in protected_area.turretTargets)
		if(M.occupant)
			new_targets += M
	if(new_targets.len)
		new_target = pick(new_targets)
	return new_target


/obj/machinery/turret/process()
	if(stat & (NOPOWER|BROKEN))
		return
	if(src.cover==null)
		src.cover = new /obj/machinery/turretcover(src.loc)
	protected_area = get_protected_area()
	if(!enabled || !protected_area || protected_area.turretTargets.len<=0)
		if(!isDown() && !isPopping())
			popDown()
		return
	if(!check_target(cur_target)) //if current target fails target check
		cur_target = get_new_target() //get new target

	if(cur_target) //if it's found, proceed
//		world << "[cur_target]"
		if(!isPopping())
			if(isDown())
				popUp()
				use_power = 2
			else
				spawn()
					if(!targeting_active)
						targeting_active = 1
						target()
						targeting_active = 0
	else if(!isPopping())//else, pop down
		if(!isDown())
			popDown()
			use_power = 1
	return


/obj/machinery/turret/proc/target()
	while(src && enabled && !stat && check_target(cur_target))
		src.dir = get_dir(src, cur_target)
		shootAt(cur_target)
		sleep(shot_delay)
	return

/obj/machinery/turret/proc/shootAt(var/atom/movable/target)
	var/turf/T = get_turf(src)
	var/turf/U = get_turf(target)
	if (!T || !U)
		return
	var/obj/item/projectile/A
	if (src.lasers)
		switch(lasertype)
			if(1)
				A = new /obj/item/projectile/beam( loc )
			if(2)
				A = new /obj/item/projectile/beam/heavylaser( loc )
			if(3)
				A = new /obj/item/projectile/beam/pulse( loc )
			if(4)
				A = new /obj/item/projectile/change( loc )
		A.original = target.loc
		use_power(500)
	else
		A = new /obj/item/projectile/energy/electrode( loc )
		use_power(200)
	A.current = T
	A.yo = U.y - T.y
	A.xo = U.x - T.x
	spawn( 0 )
		A.fired()
	return


/obj/machinery/turret/proc/isDown()
	return (invisibility!=0)

/obj/machinery/turret/proc/popUp()
	if ((!isPopping()) || src.popping==-1)
		invisibility = 0
		popping = 1
		if (src.cover!=null)
			flick("popup", src.cover)
			src.cover.icon_state = "openTurretCover"
		spawn(10)
			if (popping==1) popping = 0

/obj/machinery/turret/proc/popDown()
	if ((!isPopping()) || src.popping==1)
		popping = -1
		if (src.cover!=null)
			flick("popdown", src.cover)
			src.cover.icon_state = "turretCover"
		spawn(10)
			if (popping==-1)
				invisibility = 2
				popping = 0

/obj/machinery/turret/bullet_act(var/obj/item/projectile/Proj)
	src.health -= Proj.damage
	..()
	if(prob(45) && Proj.damage > 0) src.spark_system.start()
	if (src.health <= 0)
		src.die()
	return

/obj/machinery/turret/attackby(obj/item/weapon/W, mob/user)//I can't believe no one added this before/N
	..()
	playsound(src.loc, 'smash.ogg', 60, 1)
	src.spark_system.start()
	src.health -= W.force * 0.5
	if (src.health <= 0)
		src.die()
	return

/obj/machinery/turret/emp_act(severity)
	switch(severity)
		if(1)
			enabled = 0
			lasers = 0
			power_change()
	..()

/obj/machinery/turret/ex_act(severity)
	if(severity < 3)
		src.die()

/obj/machinery/turret/proc/die()
	src.health = 0
	src.density = 0
	src.stat |= BROKEN
	src.icon_state = "destroyed_target_prism"
	if (cover!=null)
		del(cover)
	sleep(3)
	flick("explosion", src)
	spawn(13)
		del(src)

/obj/machinery/turretid
	name = "Turret deactivation control"
	icon = 'device.dmi'
	icon_state = "motion3"
	anchored = 1
	density = 0
	var/enabled = 1
	var/id = ""
	var/lethal = 0
	var/locked = 1
	var/control_area //can be area name, path or nothing.
	var/ailock = 0 // AI cannot use this
	req_access = list(access_ai_upload)
	var/similar_controls
	var/turrets

/obj/machinery/turretid/east
	pixel_x = 28

/obj/machinery/turretid/south
	pixel_y = -28

/obj/machinery/turretid/west
	pixel_x = -28

/obj/machinery/turretid/north
	pixel_y = 28

/obj/machinery/turretid/New()
	..()
	spawn(10)		// allow map load
		turrets = list()
		for(var/obj/machinery/turret/T in world)
			if(T.id == id)
				turrets += T

		similar_controls = list() // On modifying a control, all the similar controls should change their icon_state as well
		for(var/obj/machinery/turretid/TC in world)
			if(TC.id == id && TC != src)
				similar_controls += TC

/obj/machinery/turretid/attackby(obj/item/weapon/W, mob/user)
	if(stat & BROKEN) return
	if (istype(user, /mob/living/silicon))
		return src.attack_hand(user)
	else // trying to unlock the interface
		if (src.allowed(usr))
			locked = !locked
			user << "You [ locked ? "lock" : "unlock"] the panel."
			if (locked)
				if (user.machine==src)
					user.machine = null
					user << browse(null, "window=turretid")
			else
				if (user.machine==src)
					src.attack_hand(usr)
		else
			user << "\red Access denied."

/obj/machinery/turretid/attack_ai(mob/user as mob)
	if(!ailock)
		return attack_hand(user)
	else
		user << "<span class='notice'>There seems to be a firewall preventing you from accessing this device.</span>"

/obj/machinery/turretid/attack_hand(mob/user as mob)
	if ( (get_dist(src, user) > 1 ))
		if (!istype(user, /mob/living/silicon))
			user << text("Too far away.")
			user.machine = null
			user << browse(null, "window=turretid")
			return

	user.machine = src
	var/loc = src.loc
	if (istype(loc, /turf))
		loc = loc:loc
	if (!istype(loc, /area))
		user << text("Turret badly positioned - loc.loc is [].", loc)
		return
	var/area/area = loc
	var/t = "<TT><B>Turret Control Panel</B> ([area.name])<HR>"

	if(src.locked && (!istype(user, /mob/living/silicon)))
		t += "<I>(Swipe ID card to unlock control panel.)</I><BR>"
	else
		t += text("Turrets [] - <A href='?src=\ref[];toggleOn=1'>[]?</a><br>\n", src.enabled?"activated":"deactivated", src, src.enabled?"Disable":"Enable")
		t += text("Currently set for [] - <A href='?src=\ref[];toggleLethal=1'>Change to []?</a><br>\n", src.lethal?"lethal":"stun repeatedly", src,  src.lethal?"Stun repeatedly":"Lethal")

	user << browse(t, "window=turretid")
	onclose(user, "turretid")


/obj/machinery/turret/attack_alien(mob/living/carbon/alien/humanoid/M as mob)
	if(!(stat & BROKEN))
		playsound(src.loc, 'slash.ogg', 25, 1, -1)
		for(var/mob/O in viewers(src, null))
			if ((O.client && !( O.blinded )))
				O.show_message(text("\red <B>[] has slashed at []!</B>", M, src), 1)
		src.health -= 15
		if (src.health <= 0)
			src.die()
	else
		M << "\green That object is useless to you."
	return

/obj/machinery/turretid/Topic(href, href_list)
	..()
	if (src.locked)
		if (!istype(usr, /mob/living/silicon))
			usr << "Control panel is locked!"
			return
	if (href_list["toggleOn"])
		src.enabled = !src.enabled
		src.updateTurrets()
	else if (href_list["toggleLethal"])
		src.lethal = !src.lethal
		src.updateTurrets()
	src.attack_hand(usr)

/obj/machinery/turretid/proc/updateTurrets()
	if(control_area)
		for (var/obj/machinery/turret/aTurret in get_area_all_atoms(control_area))
			aTurret.setState(enabled, lethal)
	src.update_icons()

/obj/machinery/turretid/proc/update_icons()
	if (src.enabled)
		if (src.lethal)
			src.icon_state = "motion1"
			for(var/obj/machinery/turretid/TC in src.similar_controls) //Change every similar control's icon as well
				TC.icon_state = "motion1"
		else
			src.icon_state = "motion3"
			for(var/obj/machinery/turretid/TC in src.similar_controls)
				TC.icon_state = "motion3"
	else
		src.icon_state = "motion0"
		for(var/obj/machinery/turretid/TC in src.similar_controls)
			TC.icon_state = "motion0"

	for (var/obj/machinery/turret/aTurret in turrets)
		aTurret.setState(enabled, lethal)

/obj/structure/turret/gun_turret
	name = "Gun Turret"
	density = 1
	anchored = 1
	var/cooldown = 20
	var/projectiles = 100
	var/projectiles_per_shot = 2
	var/deviation = 0.3
	var/list/exclude = list()
	var/atom/cur_target
	var/scan_range = 7
	var/health = 40
	var/list/scan_for = list("human"=0,"cyborg"=0,"mecha"=0,"alien"=1)
	var/on = 0
	icon = 'turrets.dmi'
	icon_state = "gun_turret"


	ex_act()
		del src
		return

	emp_act()
		del src
		return

	meteorhit()
		del src
		return

	proc/update_health()
		if(src.health<=0)
			del src
		return

	proc/take_damage(damage)
		src.health -= damage
		if(src.health<=0)
			del src
		return


	bullet_act(var/obj/item/projectile/Proj)
		src.take_damage(Proj.damage)
		..()
		return


	attack_hand(mob/user as mob)
		user.machine = src
		var/dat = {"<html>
						<head><title>[src] Control</title></head>
						<body>
						<b>Power: </b><a href='?src=\ref[src];power=1'>[on?"on":"off"]</a><br>
						<b>Scan Range: </b><a href='?src=\ref[src];scan_range=-1'>-</a> [scan_range] <a href='?src=\ref[src];scan_range=1'>+</a><br>
						<b>Scan for: </b>"}
		for(var/scan in scan_for)
			dat += "<div style=\"margin-left: 15px;\">[scan] (<a href='?src=\ref[src];scan_for=[scan]'>[scan_for[scan]?"Yes":"No"]</a>)</div>"

		dat += {"<b>Ammo: </b>[max(0, projectiles)]<br>
					</body>
					</html>"}
		user << browse(dat, "window=turret")
		onclose(user, "turret")
		return

	attack_ai(mob/user as mob)
		return attack_hand(user)


	attack_alien(mob/user as mob)
		user.visible_message("[user] slashes at [src]", "You slash at [src]")
		src.take_damage(15)
		return

	Topic(href, href_list)
		if(href_list["power"])
			src.on = !src.on
			if(src.on)
				spawn(50)
					if(src)
						src.process()
		if(href_list["scan_range"])
			src.scan_range = between(1,src.scan_range+text2num(href_list["scan_range"]),8)
		if(href_list["scan_for"])
			if(href_list["scan_for"] in scan_for)
				scan_for[href_list["scan_for"]] = !scan_for[href_list["scan_for"]]
		src.updateUsrDialog()
		return


	proc/validate_target(atom/target)
		if(get_dist(target, src)>scan_range)
			return 0
		if(istype(target, /mob))
			var/mob/M = target
			if(!M.stat && !M.lying)//ninjas can't catch you if you're lying
				return 1
		else if(istype(target, /obj/mecha))
			return 1
		return 0


	process()
		spawn while(on)
			if(projectiles<=0)
				on = 0
				return
			if(cur_target && !validate_target(cur_target))
				cur_target = null
			if(!cur_target)
				cur_target = get_target()
			fire(cur_target)
			sleep(cooldown)
		return

	proc/get_target()
		var/list/pos_targets = list()
		var/target = null
		if(scan_for["human"])
			for(var/mob/living/carbon/human/M in oview(scan_range,src))
				if(M.stat || M.lying || M in exclude)
					continue
				pos_targets += M
		if(scan_for["cyborg"])
			for(var/mob/living/silicon/M in oview(scan_range,src))
				if(M.stat || M.lying || M in exclude)
					continue
				pos_targets += M
		if(scan_for["mecha"])
			for(var/obj/mecha/M in oview(scan_range, src))
				if(M in exclude)
					continue
				pos_targets += M
		if(scan_for["alien"])
			for(var/mob/living/carbon/alien/M in oview(scan_range,src))
				if(M.stat || M.lying || M in exclude)
					continue
				pos_targets += M
		if(pos_targets.len)
			target = pick(pos_targets)
		return target


	proc/fire(atom/target)
		if(!target)
			cur_target = null
			return
		src.dir = get_dir(src,target)
		var/turf/targloc = get_turf(target)
		var/target_x = targloc.x
		var/target_y = targloc.y
		var/target_z = targloc.z
		targloc = null
		spawn	for(var/i=1 to min(projectiles, projectiles_per_shot))
			if(!src) break
			var/turf/curloc = get_turf(src)
			targloc = locate(target_x+GaussRandRound(deviation,1),target_y+GaussRandRound(deviation,1),target_z)
			if (!targloc || !curloc)
				continue
			if (targloc == curloc)
				continue
			playsound(src, 'Gunshot.ogg', 50, 1)
			var/obj/item/projectile/A = new /obj/item/projectile(curloc)
			src.projectiles--
			A.current = curloc
			A.yo = targloc.y - curloc.y
			A.xo = targloc.x - curloc.x
			A.fired()
			sleep(2)
		return
