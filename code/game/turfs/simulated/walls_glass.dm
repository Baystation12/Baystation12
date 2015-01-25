/turf/simulated/wall/g_wall
	name = "glass window"
	desc = "A few panes of glass inserted into a metal frame."
	icon_state = "g_wall"
	opacity = 0
	density = 1

	damage = 0
	damage_cap = 80
	max_temperature = 1800

	walltype = "gwall"

	var/d_state = 0


/turf/simulated/wall/g_wall/update_damage()
	var/cap = damage_cap
	if(rotting)
		cap = cap / 10

	if(damage >= cap)
		dismantle_wall( 1, 0 )
	else
		update_icon()

	return


/turf/simulated/wall/g_wall/attack_tk(mob/user as mob)
	user.visible_message("<span class='notice'>Something knocks on [src].</span>")
	playsound(loc, 'sound/effects/Glasshit.ogg', 50, 1)
	return

/turf/simulated/wall/g_wall/attack_hand(mob/user as mob)
	if (HULK in user.mutations)
		if (prob(10) || rotting)
			usr << text("\blue You shatter the glass wall!")
			usr.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))
			dismantle_wall(1, 0)
			return
		else
			usr << text("\blue Your punch cracks the glass!.")
			take_damage( 20 )

	if(rotting)
		user << "\blue This glass wall is a little too flexible."

	if (usr.a_intent == "hurt")
		playsound(src, 'sound/effects/glassknock.ogg', 80, 1)
		usr.visible_message("\red [usr.name] bangs against the [src.name]!", \
							"\red You bang against the [src.name]!", \
							"You hear a banging sound.")
	else
		playsound(src, 'sound/effects/glassknock.ogg', 80, 1)
		usr.visible_message("[usr.name] knocks on the [src.name].", \
							"You knock on the [src.name].", \
							"You hear a knocking sound.")

	src.add_fingerprint(user)
	return

/turf/simulated/wall/g_wall/proc/attack_weapon(obj/item/W as obj, mob/user as mob)
	var/obj/item/weapon/L = W
	if(L.force <= 0) return
	take_damage( L.force )

	if(damage >= damage_cap)
		user.visible_message("<span class='danger'>[user] smashes through the [src]!</span>")
		dismantle_wall( 1, 0 )
	else	//for nicer text~
		user.visible_message("<span class='danger'>[user] hits the [src] with the [W.name]!</span>")
		playsound(user, 'sound/effects/Glasshit.ogg', 100, 1)

	return

/turf/simulated/wall/g_wall/proc/slam_mob( obj/item/W as obj, mob/user as mob )
	if(!istype(W)) return//I really wish I did not need this
	if (istype(W, /obj/item/weapon/grab) && get_dist(src,user)<2)
		var/obj/item/weapon/grab/G = W
		if(istype(G.affecting,/mob/living))
			var/mob/living/M = G.affecting
			var/state = G.state
			del(W)	//gotta delete it here because if window breaks, it won't get deleted
			switch (state)
				if(1)
					M.visible_message("<span class='warning'>[user] slams [M] against \the [src]!</span>")
					M.apply_damage(7)
					take_damage( 7 )
				if(2)
					M.visible_message("<span class='danger'>[user] bashes [M] against \the [src]!</span>")
					if (prob(50))
						M.Weaken(1)
					M.apply_damage(10)
					take_damage( 10 )
				if(3)
					M.visible_message("<span class='danger'><big>[user] crushes [M] against \the [src]!</big></span>")
					M.Weaken(5)
					M.apply_damage(20)
					take_damage( 20 )
			return

	return

/turf/simulated/wall/g_wall/proc/fungi_inter( obj/item/W as obj, mob/user as mob )
	if(istype(W, /obj/item/weapon/weldingtool) )
		var/obj/item/weapon/weldingtool/WT = W
		if( WT.remove_fuel(0,user) )
			user << "<span class='notice'>You burn away the fungi with \the [WT].</span>"
			playsound(src, 'sound/items/Welder.ogg', 10, 1)
			for(var/obj/effect/E in src) if(E.name == "Wallrot")
				del E
			rotting = 0
			return
	else if(!is_sharp(W) && W.force >= 10 || W.force >= 20)
		user << "<span class='notice'>\The [src] collapses under the force of your [W.name].</span>"
		src.dismantle_wall()
		return

	return


	//THERMITE related stuff. Calls src.thermitemelt() which handles melting simulated walls and the relevant effects
/turf/simulated/wall/g_wall/proc/thermite_inter( obj/item/W as obj, mob/user as mob )
	if( istype(W, /obj/item/weapon/weldingtool) )
		var/obj/item/weapon/weldingtool/WT = W
		if( WT.remove_fuel(0,user) )
			thermitemelt(user)
			return

	else if(istype(W, /obj/item/weapon/pickaxe/plasmacutter))
		thermitemelt(user)
		return

	else if( istype(W, /obj/item/weapon/melee/energy/blade) )
		var/obj/item/weapon/melee/energy/blade/EB = W

		EB.spark_system.start()
		user << "<span class='notice'>You slash \the [src] with \the [EB]; the thermite ignites!</span>"
		playsound(src, "sparks", 50, 1)
		playsound(src, 'sound/weapons/blade1.ogg', 50, 1)

		thermitemelt(user)
		return

	return


/turf/simulated/wall/g_wall/proc/deconstruction( obj/item/W as obj, mob/user as mob )
	var/turf/T = user.loc	//get user's location for delay checks

	switch(d_state)
		if(0)
			if (istype(W, /obj/item/weapon/screwdriver))
				playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
				src.d_state = 1

				user << "<span class='notice'>You remove the fastening screws.</span>"
				return

		if(1)
			if (istype(W, /obj/item/weapon/screwdriver))
				playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
				src.d_state = 0

				user << "<span class='notice'>You tighten the fastening screws.</span>"
				return
			else if (istype(W, /obj/item/weapon/crowbar))
				user << "<span class='notice'>You try to pry the glass from the frame...</span>"

				sleep(40)

				if( !istype(src, /turf/simulated/wall/g_wall) || !user || !W || !T )	return

				if( user.loc == T && user.get_active_hand() == W )
					user << "<span class='notice'>You pry the glass from the frame!</span>"
					dismantle_wall()
				return
	return


// Energy blade interactions
/turf/simulated/wall/g_wall/proc/EB_inter( obj/item/W as obj, mob/user as mob )
	user << "<span class='notice'>You begin to cut a hole through the glass...</span>"
	sleep( 200 )
	user << "<span class='notice'>You cut a hole in the glass!</span>"
	dismantle_wall( 1, 0 )
	return


/turf/simulated/wall/g_wall/proc/drill_inter( obj/item/W as obj, mob/user as mob )
	var/turf/T = user.loc	//get user's location for delay checks

	user << "<span class='notice'>The glass begins to creak and break as you drill into it.</span>"

	sleep(60)
	if( !istype(src, /turf/simulated/wall/g_wall) || !user || !W || !T )	return

	if( user.loc == T && user.get_active_hand() == W )
		user << "<span class='notice'>Your drill shatters the sheet of glass!</span>"
		dismantle_wall( 1, 0 )

	return


/turf/simulated/wall/g_wall/proc/repair_inter( obj/item/W as obj, mob/user as mob )
	var/obj/item/stack/sheet/glass/MS = W

	sleep( 100 )	//time taken to repair is proportional to the damage! (max 10 seconds)
	user << "<span class='notice'>You remove some of the broken panes and replace them with new ones. \a [MS].</span>"

	MS.amount = MS.amount-1
	damage = 0
	update_damage()

	return


/turf/simulated/wall/g_wall/proc/reinforce( obj/item/W as obj, mob/user as mob )
	var/obj/item/stack/rods/MS = W
	if( MS.amount >= 2 )
		MS.amount = MS.amount-2
		if( MS.amount == 0 )
			del MS
		user << "<span class='notice'>You add a reinforcing frame.</span>"

		 /turf/simulated/wall/g_wall/ChangeState()
		..(/turf/simulated/wall/g_wall/reinforced)
	else
		user << "<span class='notice'>Not enough metal rods to reinforce the glass.</span>"
	return


/turf/simulated/wall/g_wall/attackby(obj/item/W as obj, mob/user as mob)
	// For attacking it with any item
	if( user.a_intent == "hurt" || user.a_intent == "disarm" ) // For attacking the window with
		attack_weapon( W, user )
		return

	// For slamming other people into the wall
	if( user.a_intent == "grab" )
		slam_mob( W, user )
		return

	// Attacking with empty hand
	if(( user.hand == "0" && user.r_hand == null ) || ( user.hand == "1" && user.l_hand == null ))
		attack_hand( user )
		return

	if( W.flags & NOBLUDGEON ) return

	// deconstruction
	deconstruction( W, user )

	// silly monkies
	if ( !(istype(user, /mob/living/carbon/human ) || ticker) && ticker.mode.name != "monkey")
		user << "<span class='warning'>You don't have the dexterity to do this!</span>"
		return

	//get that user's location
	if( !istype( user.loc, /turf ))	return	//can't do this stuff whilst inside objects and such

	// Rot interactions
	if(rotting)
		fungi_inter( W, user )
		return

	// Thermite interactions
	else if( thermite )
		thermite_inter( W, user )

	else if(istype(W, /obj/item/weapon/melee/energy/blade))
		EB_inter( W, user )

	// drilling
	if (istype(W, /obj/item/weapon/pickaxe/diamonddrill))
		drill_inter( W, user )
		return

	// repairing
	else if( istype(W, /obj/item/stack/sheet/glass))
		repair_inter( W, user )
		return

	// reinforcing the glass
	else if( istype(W, /obj/item/stack/rods))
		reinforce( W, user )

	// Other general wall-type things below
	else if( istype(W,/obj/item/apc_frame) )
		var/obj/item/apc_frame/AH = W
		AH.try_build(src)
		return

	else if( istype(W,/obj/item/alarm_frame) )
		var/obj/item/alarm_frame/AH = W
		AH.try_build(src)
		return

	else if(istype(W,/obj/item/firealarm_frame))
		var/obj/item/firealarm_frame/AH = W
		AH.try_build(src)
		return

	else if(istype(W,/obj/item/light_fixture_frame))
		var/obj/item/light_fixture_frame/AH = W
		AH.try_build(src)
		return

	else if(istype(W,/obj/item/light_fixture_frame/small))
		var/obj/item/light_fixture_frame/small/AH = W
		AH.try_build(src)
		return

	//Poster stuff
	else if(istype(W,/obj/item/weapon/contraband/poster))
		place_poster(W,user)
		return

	return