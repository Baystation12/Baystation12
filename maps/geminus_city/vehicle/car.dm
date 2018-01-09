/obj/vehicle/car
	name = "car"
	dir = 4

	health = 300
	maxhealth = 300
	fire_dam_coeff = 0.7
	brute_dam_coeff = 0.5
	powered = 1
	locked = 0
	charge_use = 0
	bound_width = 64
	bound_height = 64

	var/obj/item/weapon/key/car/key
	var/trunk_open = 0
	var/trunk_welded = 0
	var/lastbumped

	engine_start = 'sound/vehicles/ignition.ogg'
	engine_fail = 'sound/vehicles/wontstart.ogg'

/obj/item/weapon/key/car
	name = "key"
	desc = "A keyring with a small steel key, and a yellow fob reading \"Choo Choo!\". DON'T ASK."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "train_keys"
	w_class = 1

//-------------------------------------------
// Standard procs
//-------------------------------------------

/obj/vehicle/car/New()
	..()
	cell = new /obj/item/weapon/stock_parts/cell/high(src)
	key = new(src)
	populate_action_buttons()
	populate_verbs()

/obj/vehicle/car/Destroy()
	if(load) unload(load, "driver")
	if(passenger) unload(passenger, "passenger")
	if(trunk) unload(trunk, "trunk")
	headlights_off()
	return ..()

/obj/vehicle/car/Move(var/turf/destination)
	if(on && cell.charge < charge_use)
		turn_off()
		if(load)
			to_chat(load,"<span class='warning'>The engine briefly whines, then drones to a stop.</span>")
	if(on && health <= 10)
		turn_off()
		if(load)
			to_chat(load,"<span class='warning'>The engine makes a loud clanking noise before going quiet.</span>")
	if(!on)
		return 0

		//||space check ~no flying space cars sorry
	if(on && istype(destination, /turf/space))
		return 0

		//||move
	if(..())
		return 1
	else
		return 0

/obj/vehicle/car/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/key/car))
		if(!key)
			user.drop_item()
			W.forceMove(src)
			key = W
			verbs += /obj/vehicle/car/verb/remove_key
		return
	..()

/obj/vehicle/car/Bump(atom/Obstacle)
	if(!emagged)
		if(!bumped)
			for(var/mob/O in hearers(1, src))
				O.show_message("<span class='game say'><span class='name'>[src]</span> calmly chimes, \"<span class='automated'>Imminent collision detected. Safety engaged, powering down...</span>\"</span>",2)
			stop_short()
			turn_off()
			bumped = 1
		return
	if(istype(Obstacle, /turf/simulated/wall))
		if(!bumped)
			stop_short()
			for(var/mob/O in hearers(1, src))
				O.show_message("<span class='warning'>The [src]'s engine goes out.</span>",2)
			turn_off()
			src.take_damage(5 / move_delay)
			bumped = 1
		return

	if(!istype(Obstacle, /atom/movable))
		return
	var/atom/movable/A = Obstacle

	if(!A.anchored)
		var/turf/T = get_step(A, dir)
		if(isturf(T))
			A.Move(T)	//||bump things away when hit

	if(istype(A, /mob/living))
		var/mob/living/M = A
		var/mob/living/D = load
		visible_message("<span class='danger'>[src] knocks over [M]!</span>")
		M.apply_effects(5, 5)				//||knock people down if you hit them
		M.apply_damages(20 / move_delay)	//||and do damage according to how fast the car is going
		if(istype(load, /mob/living/carbon/human))
			to_chat(D,"<span class='userdanger'>You hit [M]!</span>")
			add_logs(D, M, "hit", src)
			msg_admin_attack("[D.name] ([D.ckey]) hit [M.name] ([M.ckey]) with [src]. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)")
		return

	if(istype(A, /obj/vehicle/car/))
		var/obj/vehicle/car/C = A
		var/mob/living/D = load
		visible_message("<span class='danger'>[src] crashes into [C]!</span>")
		C.take_damage(20 / move_delay)	//||and do damage according to how fast the car is going
		src.take_damage(15 / move_delay)	//||and do damage according to how fast the car is going
		if(istype(C.load, /mob/living/carbon/human))
			var/mob/living/L = C.load
			to_chat(D,"<span class='userdanger'>You hit [C]!</span>")
			add_logs(D, L, "hit","[load]'s [C]", src)
			msg_admin_attack("[D.name] ([D.ckey]) hit [L.name]([L.ckey])'s \the [C] with [src]. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)")
		return

	if(istype(A, /obj/structure))
		if(istype(A, /obj/structure/barricade/wooden))
			var/obj/structure/barricade/wooden/B = A
			playsound(src.loc, 'sound/effects/woodcrash.ogg', 80, 0, 11025)
			B.dismantle()
			src.take_damage(1)
			return

		else if(istype(A, /obj/structure/window/))
			var/obj/structure/window/W = A
			W.hit(10)
			src.take_damage(2)
			for(var/mob/living/M in buckled_mobs)
				shake_camera(M, 3, 1)
			return
		else if(istype(A, /obj/structure/grille))
			var/obj/structure/grille/G = A
			playsound(src.loc, 'sound/effects/grillehit.ogg', 80, 1)
			G.health = 0
			G.healthcheck()
			src.take_damage(2)
			return
		else if(istype(A, /obj/structure/table/glasstable))
			var/obj/structure/table/glasstable/G = A
			G.shatter()
			src.take_damage(1)  //||crashing the car into things repeatedly is generally a bad idea
			return
		else if(istype(A, /obj/structure/table/wooden))
			var/obj/structure/table/wooden/T = A
			if(istype(T, /obj/structure/table/rack))
				return
			playsound(src.loc, 'sound/effects/woodcrash.ogg', 80, 0, 11025)
			qdel(T)
			src.take_damage(1)
			return
		else if(istype(A, /obj/structure/table/rack))
			var/obj/structure/table/rack/R = A
			qdel(R)
			src.take_damage(1)
			return
		else if(istype(A, /obj/structure/table))
			var/obj/structure/table/T = A
			playsound(src.loc, 'sound/effects/woodcrash.ogg', 80, 0, 11025)
			qdel(T)
			src.take_damage(1)
			return

		if(lastbumped != Obstacle) to_chat(load,"<span class='userdanger'>You crash [src] into the [A]!</span>")
		src.take_damage(1)
		return

	if(istype(A, /obj/machinery/door/window/))
		var/obj/machinery/door/window/W = A
		W.take_damage(80)
		src.take_damage(5)
		for(var/mob/living/M in buckled_mobs)
			shake_camera(M, 3, 1)
		return

/obj/vehicle/car/proc/take_damage(damage)
	src.health -= damage
	if(prob(10))
		new /obj/effect/decal/cleanable/blood/oil(src.loc)
	spawn(1) healthcheck()
	return 1

/obj/vehicle/car/bullet_act()
	return 	//for now return, to prevent taser shots from killing cars until projectile code is refactored


/obj/vehicle/car/container_resist()
	var/mob/living/user = usr
	var/breakout_time = 2 //2 minutes by default

	if( trunk_open )
		return  //Trunk's open, no point in resisting.

	//okay, so the trunk is shut... resist!!!
	user.changeNext_move(CLICK_CD_BREAKOUT)
	user.last_special = world.time + CLICK_CD_BREAKOUT
	to_chat(user,"<span class='notice'>You lean against the roof of [src]'s trunk and start forcing it open. (this will take about [breakout_time] minutes.)</span>")
	for(var/mob/O in hearers(src))
		to_chat(O,"<span class='warning'>You hear a banging sound coming from [src]'s trunk!</span>")
	if(do_after(user,(breakout_time*60*10), target = src)) //minutes * 60seconds * 10deciseconds
		if(!user || user.stat != CONSCIOUS || user.loc != src || trunk_open )
			return
		//we check after a while whether there is a point of resisting anymore and whether the user is capable of resisting

		trunk_welded = 0
		user.visible_message("<span class='danger'>[user] successfully broke out of [src]'s trunk!</span>", "<span class='notice'>You successfully break out of [src]'s trunk!</span>")
		unload(trunk, "trunk")
		trunk_opened()
	else
		to_chat(user,"<span class='warning'>You fail to break out of [src]'s trunk!</span>")

//-------------------------------------------
// Car procs
//-------------------------------------------

/obj/vehicle/car/turn_on()
	if(!key)
		return
	if(health <= 10)
		return
	else
		..()

/obj/vehicle/car/turn_off()
	..()

/obj/vehicle/car/proc/trunk_closed()

	trunk_open = 0

	verbs -= /obj/vehicle/car/close_trunk
	verbs -= /obj/vehicle/car/open_trunk
	if(!trunk_open)
		verbs += /obj/vehicle/car/open_trunk
	else
		verbs += /obj/vehicle/car/close_trunk

	for(var/obj/screen/vehicle_action/trunktoggle/A in action_buttons)
		A.icon_state = "trunk[trunk_open]"
		A.name = "[trunk_open ? "Shut" : "Open"] Trunk"

	if(usr) usr.update_action_buttons()

	return 1

/obj/vehicle/car/proc/trunk_opened()

	trunk_open = 1

	verbs -= /obj/vehicle/car/close_trunk
	verbs -= /obj/vehicle/car/open_trunk

	if(trunk_open)
		verbs += /obj/vehicle/car/close_trunk
	else
		verbs += /obj/vehicle/car/open_trunk

	for(var/obj/screen/vehicle_action/trunktoggle/A in action_buttons)
		A.icon_state = "trunk[trunk_open]"
		A.name = "[trunk_open ? "Shut" : "Open"] Trunk"

	if(usr) usr.update_action_buttons()

	return 1

/obj/vehicle/car/swap(mob/M)
	if(M == load)
		if(passenger)
			to_chat(M,"<span class='warning'>The passenger's seat is already occupied!</span>")
			return
		unload(M, "driver")
		load(M, "passenger")
		to_chat(M,"<span class='notice'>You climb into the passenger's seat.</span>")
		update_dir_car_overlays()
		return
	if(M == passenger)
		unload(M, "passenger")
		if(load)
			to_chat(M,"<span class='warning'>The driver's seat is already occupied!</span>")
			return
		load(M, "driver")
		to_chat(M,"<span class='notice'>You climb into the driver's seat.</span>")
		update_dir_car_overlays()
		return

/obj/vehicle/car/headlights_on()
	if(!key)
		return
	else
		..()

/obj/vehicle/car/proc/stop_short() //whiplash!
	var/pixel_x_diff = 0
	var/pixel_y_diff = 0
	switch(dir)
		if(NORTH)
			pixel_y_diff = 10
			pixel_x_diff = pick(-1,1)
		if(SOUTH)
			pixel_y_diff = -10
			pixel_x_diff = pick(-1,1)
		if(EAST)
			pixel_x_diff = 10
			pixel_y_diff = pick(-1,1)
		if(WEST)
			pixel_x_diff = -10
			pixel_y_diff = pick(-1,1)
	if(passenger && ismob(passenger))
		var/mob/living/carbon/human/H = passenger
		animate(H, pixel_x = passenger_offset_x + pixel_x_diff, pixel_y = passenger_offset_y + pixel_y_diff, time = 5, loop = 1, easing = ELASTIC_EASING)
		H.adjustBruteLossByPart(3,"head")
		to_chat(H,"<span class='userdanger'>Your head bangs against the dashboard!</span>")
		shake_camera(H, 3, 1)
	if(load && ismob(load))
		var/mob/living/carbon/human/H = load
		animate(H, pixel_x = mob_offset_x + pixel_x_diff, pixel_y = mob_offset_y + pixel_y_diff, time = 5, loop = 1, easing = ELASTIC_EASING)
		H.adjustBruteLossByPart(3,"head")
		to_chat(H,"<span class='userdanger'>Your head bangs against the dashboard!</span>")
		shake_camera(H, 3, 1)
	if(trunk && ismob(trunk))
		var/mob/living/carbon/human/H = trunk
		if(trunk_open)
			to_chat(H,"<span class='userdanger'>You fall out of the trunk!</span>")
			H.take_overall_damage(3,0)
			shake_camera(H, 3, 1)
			unload(H, "trunk")
			H.Weaken(3)
		else
			to_chat(H,"<span class='userdanger'>Your body slams against something!</span>")
			H.take_overall_damage(1,0)
			shake_camera(H, 3, 1)
			for(var/mob/O in hearers(src))
				to_chat(O,"<span class='warning'>You hear a loud thud. It sounded like it was coming from [src]'s trunk!</span>")

//-------------------------------------------
// Interaction procs
//-------------------------------------------

/obj/vehicle/car/relaymove(mob/user, direction)
	if(user != load)
		return 0

	if(Move(get_step(src, direction)))
		return 1
	return 0

/obj/vehicle/car/examine(mob/user)
	if(!..(user, 1))
		return

	if(!istype(usr, /mob/living/carbon/human))
		return

	to_chat(user,"The power light is [on ? "on" : "off"].\nThere are[key ? "" : " no"] keys in the ignition.")
	to_chat(user,"The charge meter reads [cell? round(cell.percent(), 0.01) : 0]%")
	to_chat(user,"Car integrity is at [health? round(100.0*health/maxhealth, 0.01) : 0]%")
	if(trunk_open)
		to_chat(user,"<span class='notice'>The trunk has been left open.</span>")

//-------------------------------------------------------
// Verbs
//-------------------------------------------------------

/obj/vehicle/car/start_engine()
	set name = "Start engine"
	set category = "Vehicle"
	set src in view(0)

	if(usr.stat || usr.restrained() || usr.stunned || usr.lying || (usr == trunk))
		return

	if(!istype(usr, /mob/living/carbon/human))
		return

	if(on)
		to_chat(usr,"<span class='warning'>The engine is already running.</span>")
		return

	if(!spam_flag)
		spam_flag = 1
		cooldowntime = 30
		turn_on()
		if (on)
			playsound(src.loc, engine_start, 80, 0, 10)
			to_chat(usr,"<span class='notice'>You start [src]'s engine.</span>")
			spawn(cooldowntime)
				spam_flag = 0
		else
			if(cell.charge < charge_use)
				to_chat(usr,"<span class='warning'>[src] is out of power.</span>")
			else
				spam_flag = 1
				cooldowntime = 50
				to_chat(usr,"<span class='warning'>[src]'s engine won't start.</span>")
				playsound(src.loc, engine_fail, 80, 0, 10)
				spawn(cooldowntime)
					spam_flag = 0

/obj/vehicle/car/stop_engine()
	set name = "Stop engine"
	set category = "Vehicle"
	set src in view(0)

	if(usr.stat || usr.restrained() || usr.stunned || usr.lying || (usr == trunk))
		return

	if(!istype(usr, /mob/living/carbon/human))
		return

	if(!on)
		to_chat(usr,"<span class='warning'>The engine is already stopped.</span>")
		return

	turn_off()
	if (!on)
		to_chat(usr,"<span class='notice'>You stop [src]'s engine.</span>")

/obj/vehicle/car/verb/remove_key()
	set name = "Remove key"
	set category = "Vehicle"
	set src in view(0)

	if(usr.stat || usr.restrained() || usr.stunned || usr.lying || (usr == trunk))
		return

	if(!istype(usr, /mob/living/carbon/human))
		return

	if(!key || (load && load != usr))
		return

	if(on)
		turn_off()

	key.loc = usr.loc
	if(!usr.get_active_hand())
		usr.put_in_hands(key)
	key = null

	verbs -= /obj/vehicle/car/verb/remove_key

/obj/vehicle/car/open_trunk()
	set name = "Trunk Open"
	set category = "Vehicle"
	set src in view(1)
	..()

	if(!key)
		return

	if(usr.stat || usr.restrained() || usr.stunned || usr.lying)
		return

	if(usr == trunk)
		container_resist()
		return

	if(!spam_flag)
		spam_flag = 1
		cooldowntime = 10
		if(trunk_opened())
			to_chat(usr,"<span class='notice'>You pop open the trunk.</span>")
			playsound(src.loc, 'sound/vehicles/boot-open.ogg', 100, 0, 22050)
			spawn(cooldowntime)
				spam_flag = 0

/obj/vehicle/car/close_trunk()
	set name = "Trunk Close"
	set category = "Vehicle"
	set src in view(1)
	..()

	if(usr.stat || usr.restrained() || usr.stunned || usr.lying)
		return

	if(!spam_flag)
		spam_flag = 1
		cooldowntime = 10
		if(trunk_closed())
			to_chat(usr,"<span class='notice'>You close the trunk.</span>")
			playsound(src.loc, 'sound/vehicles/boot-shut.ogg', 100, 0, 22050)
			spawn(cooldowntime)
				spam_flag = 0

/obj/vehicle/car/honk()
	set name = "Honk horn"
	set category = "Vehicle"
	set src in view(0)

	if(!istype(usr, /mob/living/carbon/human))
		return

	if(usr.stat || usr.restrained() || usr.stunned || usr.lying || (usr == trunk))
		return

	if(!on)
		to_chat(usr,"<span class='warning'>Turn on the engine.</span>")
		return

	honk_horn()
	to_chat(usr,"<span class='notice'>You honk the horn. Hmm...must be broken.</span>")


//-------------------------------------------
// Loading/unloading procs
//-------------------------------------------

/obj/vehicle/car/load(var/atom/movable/C, who)
	if(C == src)
		return 0

	if(!istype(C, /mob/living/carbon/human))
		to_chat(usr,"<span class='notice'>You load [C] into the trunk.</span>")
	switch(who)
		if("driver")
			if(load) return 0
		if("passenger")
			if(passenger) return 0
		if("trunk")
			if(trunk) return 0

	C.forceMove(loc)
	C.set_dir(dir)
	C.anchored = 1

	switch(who)
		if("driver")
			load = C
			if(load_item_visible)
				C.pixel_x += load_offset_x
				if(ismob(C))
					C.pixel_y += mob_offset_y
				else
					C.pixel_y += load_offset_y
				C.layer = layer + 0.1		//so it sits above the vehicle
				default_layer = C.layer
		if("passenger")
			passenger = C
			if(passenger_item_visible)
				C.pixel_x += passenger_offset_x
				if(ismob(C))
					C.pixel_y += mob_offset_y
				else
					C.pixel_y += passenger_offset_y
				C.layer = layer + 0.1		//so it sits above the vehicle
		if("trunk")
			trunk = C
			trunk.loc = src
			if(ismob(trunk))
				var/mob/M = trunk
				if(M.client)
					M.client.perspective = EYE_PERSPECTIVE
					M.client.eye = src

	for(var/obj/screen/vehicle_action/swaptoggle/A in action_buttons) //Update the swap action button
		if(load && passenger)
			A.icon_state = "swap0"
		else
			A.icon_state = "swap1"

	if(ismob(C))
		var/mob/M = C
		buckle_mob(C)
		buckled_mobs |= C
		switch(who)
			if("driver")
				M.pixel_y = src.load_offset_y
			if("passenger")
				M.pixel_y = src.passenger_offset_y
			if("trunk")
				M.pixel_y = src.load_offset_y
		M.update_canmove()
		M.update_action_buttons()

	return 1

/obj/vehicle/car/unload(var/mob/user, who, var/direction)
	switch(who)
		if("driver")
			if(!load) return
		if("passenger")
			if(!passenger) return
		if("trunk")
			if(!trunk) return

	var/turf/dest = null

	//find a turf to unload to
	if(direction)	//if direction specified, unload in that direction
		dest = get_step(src, direction)
	else if(user)	//if a user has unloaded the vehicle, unload at their feet
		dest = get_turf(user)

	if(!dest)
		dest = get_step_to(src, get_step(src, turn(dir, 90))) //try unloading to the side of the vehicle first if neither of the above are present

	//if these all result in the same turf as the vehicle or nullspace, pick a new turf with open space
	if(!dest || dest == get_turf(src))
		var/list/options = new()
		for(var/test_dir in alldirs)
			var/new_dir = get_step_to(src, get_step(src, test_dir))
			switch(who)
				if("driver")
					if(new_dir && load.Adjacent(new_dir))
						options += new_dir
				if("passenger")
					if(new_dir && passenger.Adjacent(new_dir))
						options += new_dir
				if("trunk")
					if(new_dir && src.Adjacent(new_dir))
						options += new_dir
		if(options.len)
			dest = pick(options)
		else
			dest = get_turf(src)	//otherwise just dump it on the same turf as the vehicle

	if(!isturf(dest))	//if there still is nowhere to unload, cancel out since the vehicle is probably in nullspace
		return 0

	switch(who)
		if("driver")
			load.forceMove(dest)
			load.set_dir(get_dir(loc, dest))
			load.anchored = 0		//we can only load non-anchored items, so it makes sense to set this to false
			load.pixel_x = initial(load.pixel_x)
			load.pixel_y = initial(load.pixel_y)
			load.layer = initial(load.layer)

			if(ismob(load))
				for(var/mob/M in buckled_mobs)
					if(M == load)
						buckled_mob = M
						unbuckle_mob(load)
						buckled_mobs -= M
						M.update_action_buttons()

			load = null
		if("passenger")
			passenger.forceMove(dest)
			passenger.set_dir(get_dir(loc, dest))
			passenger.anchored = 0		//we can only load non-anchored items, so it makes sense to set this to false
			passenger.pixel_x = initial(passenger.pixel_x)
			passenger.pixel_y = initial(passenger.pixel_y)
			passenger.layer = initial(passenger.layer)

			if(ismob(passenger))
				for(var/mob/M in buckled_mobs)
					if(M == passenger)
						buckled_mob = M
						unbuckle_mob(passenger)
						buckled_mobs -= M
						M.update_action_buttons()
			passenger = null
		if("trunk")
			trunk.forceMove(dest)
			trunk.set_dir(get_dir(loc, dest))
			trunk.anchored = 0		//we can only load non-anchored items, so it makes sense to set this to false
			trunk.pixel_x = initial(trunk.pixel_x)
			trunk.pixel_y = initial(trunk.pixel_y)
			trunk.layer = initial(trunk.layer)
			//trunk.loc = src.loc

			if(ismob(trunk))
				for(var/mob/M in buckled_mobs)
					if(M == trunk)
						buckled_mob = M
						unbuckle_mob(trunk)
						buckled_mobs -= M
						if(M.client)
							M.client.eye = M.client.mob
							M.client.perspective = MOB_PERSPECTIVE
			trunk = null
	for(var/obj/screen/vehicle_action/swaptoggle/A in action_buttons) //Update the swap action button
		if(load && passenger)
			A.icon_state = "swap0"
		else
			A.icon_state = "swap1"

	if(user)
		user.update_action_buttons()

	return 1


//-------------------------------------------------------
// Stat update procs
//-------------------------------------------------------

/obj/vehicle/car/populate_action_buttons()

	action_buttons += new /obj/screen/vehicle_action/enginetoggle(null)
	action_buttons += new /obj/screen/vehicle_action/headlightstoggle(null)
	action_buttons += new /obj/screen/vehicle_action/trunktoggle(null)
	action_buttons += new /obj/screen/vehicle_action/swaptoggle(null)
	action_buttons += new /obj/screen/vehicle_action/horntoggle(null)

//|| Ensures the verbs are properly set
/obj/vehicle/car/populate_verbs()
	..()
	verbs -= /obj/vehicle/car/stop_engine
	verbs -= /obj/vehicle/car/start_engine
	verbs -= /obj/vehicle/car/close_trunk

/obj/vehicle/car/proc/update_dir_car_overlays()
	return