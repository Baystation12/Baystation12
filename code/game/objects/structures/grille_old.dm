/obj/structure/grille
	name = "grille"
	desc = "A flimsy lattice of metal rods, with screws to secure it to the floor."
	icon = 'icons/obj/structures.dmi'
	icon_state = "grille"
	density = 1
	anchored = 1
	flags = CONDUCT
	pressure_resistance = 5*ONE_ATMOSPHERE
	layer = 2.9
	explosion_resistance = 5
	var/health = 10
	var/destroyed = 0


/obj/structure/grille/ex_act(severity)
	del(src)

/obj/structure/grille/blob_act()
	del(src)

/obj/structure/grille/meteorhit(var/obj/M)
	del(src)


/obj/structure/grille/Bumped(atom/user)
	if(ismob(user)) shock(user, 70)

/obj/structure/grille/attack_hand(mob/user as mob)

	playsound(loc, 'sound/effects/grillehit.ogg', 80, 1)

	var/damage_dealt = 1
	var/attack_message = "kicks"
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(H))
			attack_message = "mangles"
			damage_dealt = 5

	if(shock(user, 70))
		return

	if(HULK in user.mutations)
		damage_dealt += 5
	else
		damage_dealt += 1

	attack_generic(user,damage_dealt,attack_message)

/obj/structure/grille/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	if(istype(mover) && mover.checkpass(PASSGRILLE))
		return 1
	else
		if(istype(mover, /obj/item/projectile))
			return prob(30)
		else
			return !density

/obj/structure/grille/bullet_act(var/obj/item/projectile/Proj)

	if(!Proj)	return

	//Tasers and the like should not damage grilles.
	if(Proj.damage_type == HALLOSS)
		return

	src.health -= Proj.damage*0.2
	healthcheck()
	return 0

/obj/structure/grille/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/stack/sheet/glass) || istype(W, /obj/item/stack/sheet/glass/cyborg))
		var/obj/item/stack/sheet/S = W
		if(S.get_amount() < 2) return ..()
		user << "<span class='notice'>Inserting glass into the frame...</span>"
		if (do_after(user,40))
			if (S.use(2))
				user << "<span class='notice'>You inserted the glass!!</span>"
				var/turf/Tsrc = get_turf(src)
				Tsrc.ChangeTurf(/turf/simulated/wall/g_wall)
				for(var/turf/simulated/wall/g_wall/X in Tsrc.loc)
					if(X)	X.add_hiddenprint(usr)
				del(src)
		return
	else if(istype(W, /obj/item/stack/sheet/glass/reinforced) || istype(W, /obj/item/stack/sheet/glass/reinforced/cyborg))
		var/obj/item/stack/sheet/S = W
		if(S.get_amount() < 2) return ..()
		user << "<span class='notice'>Insertingthe reinforced glass into the frame...</span>"
		if (do_after(user,40))
			if (S.use(2))
				user << "<span class='notice'>You inserted the reinforced glass!!</span>"
				var/turf/Tsrc = get_turf(src)
				Tsrc.ChangeTurf(/turf/simulated/wall/g_wall/reinforced)
				for(var/turf/simulated/wall/g_wall/reinforced/X in Tsrc.loc)
					if(X)	X.add_hiddenprint(usr)
				del(src)
		return

	if(iswirecutter(W))
		if(!shock(user, 100))
			playsound(loc, 'sound/items/Wirecutter.ogg', 100, 1)
			new /obj/item/stack/rods(loc, 2)
			del(src)
	else if((isscrewdriver(W)) && (istype(loc, /turf/simulated) || anchored))
		if(!shock(user, 90))
			playsound(loc, 'sound/items/Screwdriver.ogg', 100, 1)
			anchored = !anchored
			user.visible_message("<span class='notice'>[user] [anchored ? "fastens" : "unfastens"] the grille.</span>", \
								 "<span class='notice'>You have [anchored ? "fastened the grille to" : "unfastened the grill from"] the floor.</span>")
			return

//window placing begin
	else if(istype(W,/obj/item/stack/sheet/glass))
		var/obj/item/stack/sheet/glass/ST = W
		var/dir_to_set = 1
		if(loc == user.loc)
			dir_to_set = user.dir
		else
			if( ( x == user.x ) || (y == user.y) ) //Only supposed to work for cardinal directions.
				if( x == user.x )
					if( y > user.y )
						dir_to_set = 2
					else
						dir_to_set = 1
				else if( y == user.y )
					if( x > user.x )
						dir_to_set = 8
					else
						dir_to_set = 4
			else
				user << "<span class='notice'>You can't reach.</span>"
				return //Only works for cardinal direcitons, diagonals aren't supposed to work like this.
		for(var/obj/structure/window/WINDOW in loc)
			if(WINDOW.dir == dir_to_set)
				user << "<span class='notice'>There is already a window facing this way there.</span>"
				return
		user << "<span class='notice'>You start placing the window.</span>"
		if(do_after(user,20))
			for(var/obj/structure/window/WINDOW in loc)
				if(WINDOW.dir == dir_to_set)//checking this for a 2nd time to check if a window was made while we were waiting.
					user << "<span class='notice'>There is already a window facing this way there.</span>"
					return

			var/wtype = ST.created_window
			if (ST.use(1))
				var/obj/structure/window/WD = new wtype(loc, dir_to_set, 1)
				user << "<span class='notice'>You place the [WD] on [src].</span>"
				WD.update_icon()
		return
//window placing end

	else if(istype(W, /obj/item/weapon/shard))
		health -= W.force * 0.1
	else if(!shock(user, 70))
		playsound(loc, 'sound/effects/grillehit.ogg', 80, 1)
		switch(W.damtype)
			if("fire")
				health -= W.force
			if("brute")
				health -= W.force * 0.1
	healthcheck()
	..()
	return


/obj/structure/grille/proc/healthcheck()
	if(health <= 0)
		if(!destroyed)
			icon_state = "brokengrille"
			density = 0
			destroyed = 1
			new /obj/item/stack/rods(loc)

		else
			if(health <= -6)
				new /obj/item/stack/rods(loc)
				del(src)
				return
	return

// shock user with probability prb (if all connections & power are working)
// returns 1 if shocked, 0 otherwise

/obj/structure/grille/proc/shock(mob/user as mob, prb)

	if(!anchored || destroyed)		// anchored/destroyed grilles are never connected
		return 0
	if(!prob(prb))
		return 0
	if(!in_range(src, user))//To prevent TK and mech users from getting shocked
		return 0
	var/turf/T = get_turf(src)
	var/obj/structure/cable/C = T.get_cable_node()
	if(C)
		if(electrocute_mob(user, C, src))
			if(C.powernet)
				C.powernet.trigger_warning()
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(3, 1, src)
			s.start()
			return 1
		else
			return 0
	return 0

/obj/structure/grille/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(!destroyed)
		if(exposed_temperature > T0C + 1500)
			health -= 1
			healthcheck()
	..()

/obj/structure/grille/attack_generic(var/mob/user, var/damage, var/attack_verb)
	visible_message("<span class='danger'>[user] [attack_verb] the [src]!</span>")
	health -= damage
	spawn(1) healthcheck()
	return 1
