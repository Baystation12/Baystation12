//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/structure/grille
	desc = "A piece of metal with evenly spaced gridlike holes in it. Blocks large object but lets small items, gas, or energy beams through. Strangely enough these grilles also lets meteors pass through them, whether they be small or huge station breaking death stones."
	name = "grille"
	icon = 'icons/obj/structures.dmi'
	icon_state = "grille"
	density = 1
	anchored = 1.0
	flags = FPRINT | CONDUCT
	pressure_resistance = 5*ONE_ATMOSPHERE
	layer = 2.9
	var/health = 10
	var/destroyed = 0
	explosion_resistance = 5

	ex_act(severity)
		switch(severity)
			if(1.0)
				del(src)
				return
			if(2.0)
				if(prob(50))
					del(src)
					return
			if(3.0)
				if(prob(25))
					src.health -= 11
					healthcheck()
		return


	blob_act()
		del(src)
		return

	Bumped(atom/user)
		if(ismob(user)) shock(user, 70)


	meteorhit(var/obj/M)
		if (M.icon_state == "flaming")
			src.health -= 2
			healthcheck()
		return


	attack_hand(var/mob/user)
		playsound(src.loc, 'sound/effects/grillehit.ogg', 80, 1)
		user.visible_message("[user.name] kicks the [src.name].", \
							"You kick the [src.name].", \
							"You hear a noise")
		if((HULK in usr.mutations) || (SUPRSTR in usr.augmentations))
			src.health -= 5
		else if(!shock(user, 70))
			src.health -= 3
		healthcheck()
		return


	attack_paw(var/mob/user)
		attack_hand(user)


	attack_alien(var/mob/user)
		if (istype(usr, /mob/living/carbon/alien/larva))	return
		playsound(src.loc, 'sound/effects/grillehit.ogg', 80, 1)
		user.visible_message("[user.name] mangles the [src.name].", \
							"You mangle the [src.name].", \
							"You hear a noise")
		if(!shock(usr, 70))
			src.health -= 5
			healthcheck()
			return

	attack_metroid(var/mob/user)
		if(!istype(usr, /mob/living/carbon/metroid/adult))	return
		playsound(src.loc, 'sound/effects/grillehit.ogg', 80, 1)
		user.visible_message("[user.name] smashes against the [src.name].", \
							"You smash against the [src.name].", \
							"You hear a noise")
		src.health -= rand(2,3)
		healthcheck()
		return

	attack_animal(var/mob/living/simple_animal/M as mob)
		if(M.melee_damage_upper == 0)	return
		playsound(src.loc, 'sound/effects/grillehit.ogg', 80, 1)
		M.visible_message("[M.name] smashes against the [src.name].", \
							"You smash against the [src.name].", \
							"You hear a noise")
		src.health -= M.melee_damage_upper
		healthcheck()
		return

	CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
		if(air_group || (height==0)) return 1
		if(istype(mover) && mover.checkpass(PASSGRILLE))
			return 1
		else
			if (istype(mover, /obj/item/projectile))
				return prob(30)
			else
				return !src.density


	attackby(obj/item/weapon/W, mob/user)
		if(iswirecutter(W))
			if(!shock(user, 100))
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
				src.health = 0
				if(!destroyed)
					src.health = -100
		else if ((isscrewdriver(W)) && (istype(src.loc, /turf/simulated) || src.anchored))
			if(!shock(user, 90))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
				src.anchored = !( src.anchored )
				user << (src.anchored ? "You have fastened the grille to the floor." : "You have unfastened the grill.")
				for(var/mob/O in oviewers())
					O << text("\red [user] [src.anchored ? "fastens" : "unfastens"] the grille.")
				return
		else if( istype(W,/obj/item/stack/sheet/rglass) || istype(W,/obj/item/stack/sheet/glass) )
			var/dir_to_set = 1
			if(src.loc == usr.loc)
				dir_to_set = usr.dir
			else
				if( ( src.x == usr.x ) || (src.y == usr.y) ) //Only supposed to work for cardinal directions.
					if( src.x == usr.x )
						if( src.y > usr.y )
							dir_to_set = 2
						else
							dir_to_set = 1
					else if( src.y == usr.y )
						if( src.x > usr.x )
							dir_to_set = 8
						else
							dir_to_set = 4
				else
					usr << "\red You can't reach there.."
					return //Only works for cardinal direcitons, diagonals aren't supposed to work like this.
			for(var/obj/structure/window/WINDOW in src.loc)
				if(WINDOW.dir == dir_to_set)
					usr << "\red There is already a window facing this way there."
					return
			usr << "\blue You start placing the window"
			if(do_after(user,20))
				if(!src) return //Grille destroyed while waiting
				for(var/obj/structure/window/WINDOW in src.loc)
					if(WINDOW.dir == dir_to_set)//checking this for a 2nd time to check if a window was made while we were waiting.
						usr << "\red There is already a window facing this way there."
						return
				var/obj/structure/window/WD
				if(istype(W,/obj/item/stack/sheet/rglass))
					WD = new/obj/structure/window(src.loc,1) //reinforced window
				else
					WD = new/obj/structure/window(src.loc,0) //normal window
				WD.dir = dir_to_set
				WD.ini_dir = dir_to_set
				WD.anchored = 0
				WD.state = 0
				var/obj/item/stack/ST = W
				ST.use(1)
				usr << "\blue You place the [WD] on the [src]"
			return
		else if(istype(W, /obj/item/weapon/shard))
			src.health -= W.force * 0.1
		else if(!shock(user, 70))
			playsound(src.loc, 'sound/effects/grillehit.ogg', 80, 1)
			switch(W.damtype)
				if("fire")
					src.health -= W.force
				if("brute")
					src.health -= W.force * 0.1
		src.healthcheck()
		..()
		return


	proc/healthcheck()
		if (src.health <= 0)
			if (!( src.destroyed ))
				src.icon_state = "brokengrille"
				src.density = 0
				src.destroyed = 1
				new /obj/item/stack/rods( src.loc )

			else
				if (src.health <= -10.0)
					new /obj/item/stack/rods( src.loc )
					//SN src = null
					del(src)
					return
		return

// shock user with probability prb (if all connections & power are working)
// returns 1 if shocked, 0 otherwise

	proc/shock(mob/user, prb)
		if(!anchored || destroyed)		// anchored/destroyed grilles are never connected
			return 0
		if(!prob(prb))
			return 0
		if(!in_range(src, usr))//To prevent TK and mech users from getting shocked
			return 0
		var/turf/T = get_turf(src)
		var/obj/structure/cable/C = T.get_cable_node()
		if(C)
			if (electrocute_mob(user, C, src))
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(5, 1, src)
				s.start()
				return 1
			else
				return 0
		return 0
