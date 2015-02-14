/turf/simulated/wall
	name = "wall"
	desc = "A huge chunk of metal used to seperate rooms."
	icon = 'icons/turf/walls.dmi'
	var/mineral = "metal"
	var/rotting = 0

	var/damage = 0
	var/damage_cap = 150 //Wall will break down to girders if damage reaches this point

	var/damage_overlay
	var/global/damage_overlays[8]

	var/max_temperature = 1800 //K, walls will take damage if they're next to a fire hotter than this

	opacity = 1
	density = 1
	blocks_air = 1

	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m plasteel wall

	var/walltype = "metal"

/turf/simulated/wall/bullet_act(var/obj/item/projectile/Proj)

	// Tasers and stuff? No thanks. Also no clone or tox damage crap.
	if(!(Proj.damage_type == BRUTE || Proj.damage_type == BURN))
		return

	//cap the amount of damage, so that things like emitters can't destroy walls in one hit.
	var/damage = min(Proj.damage, 100)

	take_damage(damage)
	return

/turf/simulated/wall/hitby(AM as mob|obj, var/speed=THROWFORCE_SPEED_DIVISOR)
	..()
	if(ismob(AM))
		return

	var/tforce = AM:throwforce * (speed/THROWFORCE_SPEED_DIVISOR)
	if (tforce < 15)
		return

	take_damage(tforce)

/turf/simulated/wall/Del()
	for(var/obj/effect/E in src) if(E.name == "Wallrot") del E
	..()

/turf/simulated/wall/ChangeTurf(var/newtype)
	for(var/obj/effect/E in src) if(E.name == "Wallrot") del E
	for(var/obj/effect/plant/plant in range(1)) plant.wake_up()
	..(newtype)

//Appearance

/turf/simulated/wall/examine(mob/user)
	. = ..(user)

	if(!damage)
		user << "<span class='notice'>It looks fully intact.</span>"
	else
		var/dam = damage / damage_cap
		if(dam <= 0.3)
			user << "<span class='warning'>It looks slightly damaged.</span>"
		else if(dam <= 0.6)
			user << "<span class='warning'>It looks moderately damaged.</span>"
		else
			user << "<span class='danger'>It looks heavily damaged.</span>"

	if(rotting)
		user << "<span class='warning'>There is fungus growing on [src].</span>"

/turf/simulated/wall/proc/update_icon()
	if(!damage_overlays[1]) //list hasn't been populated
		generate_overlays()

	if(!damage)
		overlays.Cut()
		return

	var/overlay = round(damage / damage_cap * damage_overlays.len) + 1
	if(overlay > damage_overlays.len)
		overlay = damage_overlays.len

	if(damage_overlay && overlay == damage_overlay) //No need to update.
		return

	overlays.Cut()
	overlays += damage_overlays[overlay]
	damage_overlay = overlay

	return

/turf/simulated/wall/proc/generate_overlays()
	var/alpha_inc = 256 / damage_overlays.len

	for(var/i = 1; i <= damage_overlays.len; i++)
		var/image/img = image(icon = 'icons/turf/walls.dmi', icon_state = "overlay_damage")
		img.blend_mode = BLEND_MULTIPLY
		img.alpha = (i * alpha_inc) - 1
		damage_overlays[i] = img

//Damage

/turf/simulated/wall/proc/take_damage(dam)
	if(dam)
		damage = max(0, damage + dam)
		update_damage()
	return

/turf/simulated/wall/proc/update_damage()
	var/cap = damage_cap
	if(rotting)
		cap = cap / 10

	if(damage >= cap)
		dismantle_wall()
	else
		update_icon()

	return

/turf/simulated/wall/adjacent_fire_act(turf/simulated/floor/adj_turf, datum/gas_mixture/adj_air, adj_temp, adj_volume)
	if(adj_temp > max_temperature)
		take_damage(log(RAND_F(0.9, 1.1) * (adj_temp - max_temperature)))

	return ..()

/turf/simulated/wall/proc/dismantle_wall(devastated=0, explode=0)
	if(istype(src,/turf/simulated/wall/r_wall))
		if(!devastated)
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			new /obj/structure/girder/reinforced(src)
			new /obj/item/stack/sheet/plasteel( src )
		else
			new /obj/item/stack/sheet/metal( src )
			new /obj/item/stack/sheet/metal( src )
			new /obj/item/stack/sheet/plasteel( src )
	else if(istype(src,/turf/simulated/wall/cult))
		if(!devastated)
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			new /obj/effect/decal/cleanable/blood(src)
			new /obj/structure/cultgirder(src)
		else
			new /obj/effect/decal/cleanable/blood(src)
			new /obj/effect/decal/remains/human(src)

	else
		if(!devastated)
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			new /obj/structure/girder(src)
			if (mineral == "metal")
				new /obj/item/stack/sheet/metal( src )
				new /obj/item/stack/sheet/metal( src )
			else
				var/M = text2path("/obj/item/stack/sheet/mineral/[mineral]")
				new M( src )
				new M( src )
		else
			if (mineral == "metal")
				new /obj/item/stack/sheet/metal( src )
				new /obj/item/stack/sheet/metal( src )
				new /obj/item/stack/sheet/metal( src )
			else
				var/M = text2path("/obj/item/stack/sheet/mineral/[mineral]")
				new M( src )
				new M( src )
				new /obj/item/stack/sheet/metal( src )

	for(var/obj/O in src.contents) //Eject contents!
		if(istype(O,/obj/structure/sign/poster))
			var/obj/structure/sign/poster/P = O
			P.roll_and_drop(src)
		else
			O.loc = src

	ChangeTurf(/turf/simulated/floor/plating)

/turf/simulated/wall/ex_act(severity)
	switch(severity)
		if(1.0)
			src.ChangeTurf(/turf/space)
			return
		if(2.0)
			if(prob(75))
				take_damage(rand(150, 250))
			else
				dismantle_wall(1,1)
		if(3.0)
			take_damage(rand(0, 250))
		else
	return

/turf/simulated/wall/blob_act()
	take_damage(rand(75, 125))
	return

// Wall-rot effect, a nasty fungus that destroys walls.
/turf/simulated/wall/proc/rot()
	if(!rotting)
		rotting = 1

		var/number_rots = rand(2,3)
		for(var/i=0, i<number_rots, i++)
			var/obj/effect/overlay/O = new/obj/effect/overlay( src )
			O.name = "Wallrot"
			O.desc = "Ick..."
			O.icon = 'icons/effects/wallrot.dmi'
			O.pixel_x += rand(-10, 10)
			O.pixel_y += rand(-10, 10)
			O.anchored = 1
			O.density = 1
			O.layer = 5
			O.mouse_opacity = 0

/turf/simulated/wall/proc/thermitemelt(mob/user as mob)
	if(mineral == "diamond")
		return
	var/obj/effect/overlay/O = new/obj/effect/overlay( src )
	O.name = "Thermite"
	O.desc = "Looks hot."
	O.icon = 'icons/effects/fire.dmi'
	O.icon_state = "2"
	O.anchored = 1
	O.density = 1
	O.layer = 5

	src.ChangeTurf(/turf/simulated/floor/plating)

	var/turf/simulated/floor/F = src
	F.burn_tile()
	F.icon_state = "wall_thermite"
	user << "<span class='warning'>The thermite starts melting through the wall.</span>"

	spawn(100)
		if(O)	del(O)
//	F.sd_LumReset()		//TODO: ~Carn
	return

/turf/simulated/wall/meteorhit(obj/M as obj)
	if (prob(15) && !rotting)
		dismantle_wall()
	else if(prob(70) && !rotting)
		ChangeTurf(/turf/simulated/floor/plating)
	else
		ReplaceWithLattice()
	return 0

/turf/simulated/wall
	var/hulk_destroy_prob = 40
	var/hulk_take_damage = 1
	var/rotting_destroy_touch = 1
	var/rotting_touch_message = "\blue The wall crumbles under your touch."

//Interactions
/turf/simulated/wall/attack_hand(mob/user as mob)
	if (HULK in user.mutations)
		if (prob(hulk_destroy_prob) || rotting)
			usr << text("\blue You smash through the wall.")
			usr.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))
			dismantle_wall(1)
			return 1
		else
			usr << text("\blue You punch the wall.")
			if(hulk_take_damage)
				take_damage(rand(25, 75))
			return 1

	if(rotting)
		user << rotting_touch_message
		if(rotting_destroy_touch)
			dismantle_wall()
			return 1

	if(..()) return 1

	user << "\blue You push the wall but nothing happens!"
	playsound(src, 'sound/weapons/Genhit.ogg', 25, 1)
	src.add_fingerprint(user)
	return 0

/turf/simulated/wall/attack_generic(var/mob/user, var/damage, var/attack_message, var/wallbreaker)

	if(!damage || !wallbreaker)
		user << "You push the wall but nothing happens."
		return

	if(istype(src,/turf/simulated/wall/r_wall) && !rotting)
		user << "This wall is far too strong for you to destroy."

	if(rotting || prob(40))
		user << "You smash through the wall!"
		spawn(1) dismantle_wall(1)
	else
		user << "You smash against the wall."
		take_damage(rand(25,75))
	return 1

/turf/simulated/wall/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if (!(istype(user, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		user << "<span class='warning'>You don't have the dexterity to do this!</span>"
		return

	//get the user's location
	if( !istype(user.loc, /turf) )	return	//can't do this stuff whilst inside objects and such

	if(rotting)
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
			user << "<span class='notice'>\The [src] crumbles away under the force of your [W.name].</span>"
			src.dismantle_wall(1)
			return

	//THERMITE related stuff. Calls src.thermitemelt() which handles melting simulated walls and the relevant effects
	if( thermite )
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

	var/turf/T = user.loc	//get user's location for delay checks

	//DECONSTRUCTION
	if( istype(W, /obj/item/weapon/weldingtool) )

		var/response = "Dismantle"
		if(damage)
			response = alert(user, "Would you like to repair or dismantle [src]?", "[src]", "Repair", "Dismantle")

		var/obj/item/weapon/weldingtool/WT = W

		if(WT.remove_fuel(0,user))
			if(response == "Repair")
				user << "<span class='notice'>You start repairing the damage to [src].</span>"
				playsound(src, 'sound/items/Welder.ogg', 100, 1)
				if(do_after(user, max(5, damage / 5)) && WT && WT.isOn())
					user << "<span class='notice'>You finish repairing the damage to [src].</span>"
					take_damage(-damage)

			else if(response == "Dismantle")
				user << "<span class='notice'>You begin slicing through the outer plating.</span>"
				playsound(src, 'sound/items/Welder.ogg', 100, 1)
				if(!do_after(user,100))
					return
				if(WT.isOn())
					user << "<span class='notice'>You remove the outer plating.</span>"
					dismantle_wall()
					for(var/mob/O in viewers(user, 5))
						O.show_message("<span class='warning'>The wall was sliced apart by [user]!</span>", 1, "<span class='warning'>You hear metal being sliced apart.</span>", 2)
					return
			return
		else
			user << "<span class='notice'>You need more welding fuel to complete this task.</span>"
			return

	else if( istype(W, /obj/item/weapon/pickaxe/plasmacutter) )

		user << "<span class='notice'>You begin slicing through the outer plating.</span>"
		playsound(src, 'sound/items/Welder.ogg', 100, 1)

		var/delay = 60
		if(mineral == "diamond")
			delay += 60

		if(!do_after(user,delay))
			return

		user << "<span class='notice'>You remove the outer plating.</span>"
		dismantle_wall()
		for(var/mob/O in viewers(user, 5))
			O.show_message("<span class='warning'>The wall was sliced apart by [user]!</span>", 1, "<span class='warning'>You hear metal being sliced apart.</span>", 2)
		return

	//DRILLING
	else if (istype(W, /obj/item/weapon/pickaxe/diamonddrill))

		user << "<span class='notice'>You begin to drill though the wall.</span>"

		var/delay = 60
		if(mineral == "diamond")
			delay += 60

		if(!do_after(user,delay))
			return

		user << "<span class='notice'>Your drill tears though the last of the reinforced plating.</span>"
		dismantle_wall()
		for(var/mob/O in viewers(user, 5))
			O.show_message("<span class='warning'>The wall was drilled through by [user]!</span>", 1, "<span class='warning'>You hear the grinding of metal.</span>", 2)
		return

	else if( istype(W, /obj/item/weapon/melee/energy/blade) )
		var/obj/item/weapon/melee/energy/blade/EB = W

		EB.spark_system.start()
		user << "<span class='notice'>You stab \the [EB] into the wall and begin to slice it apart.</span>"
		playsound(src, "sparks", 50, 1)

		sleep(70)
		if(mineral == "diamond")
			sleep(70)
		if( !istype(src, /turf/simulated/wall) || !user || !EB || !T )	return

		if( user.loc == T && user.get_active_hand() == W )
			EB.spark_system.start()
			playsound(src, "sparks", 50, 1)
			playsound(src, 'sound/weapons/blade1.ogg', 50, 1)
			dismantle_wall(1)
			for(var/mob/O in viewers(user, 5))
				O.show_message("<span class='warning'>The wall was sliced apart by [user]!</span>", 1, "<span class='warning'>You hear metal being sliced apart and sparks flying.</span>", 2)
		return

	else if(istype(W,/obj/item/apc_frame))
		var/obj/item/apc_frame/AH = W
		AH.try_build(src)
		return

	else if(istype(W,/obj/item/alarm_frame))
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

	else if(istype(W,/obj/item/rust_fuel_compressor_frame))
		var/obj/item/rust_fuel_compressor_frame/AH = W
		AH.try_build(src)
		return

	else if(istype(W,/obj/item/rust_fuel_assembly_port_frame))
		var/obj/item/rust_fuel_assembly_port_frame/AH = W
		AH.try_build(src)
		return

	else if(istype(W,/obj/item/weapon/rcd)) //I bitterly resent having to write this. ~Z
		return

	else if(istype(W, /obj/item/weapon/reagent_containers))
		return // They tend to have meaningful afterattack - let them apply it without destroying a rotting wall

	else
		return attack_hand(user)
	return
