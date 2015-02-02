/obj/item/projectile/ion
	name = "ion bolt"
	icon_state = "ion"
	damage = 0
	damage_type = BURN
	nodamage = 1
	flag = "energy"


	on_hit(var/atom/target, var/blocked = 0)
		empulse(target, 1, 1)
		return 1


/obj/item/projectile/bullet/gyro
	name ="explosive bolt"
	icon_state= "bolter"
	damage = 50
	flag = "bullet"
	sharp = 1
	edge = 1

	on_hit(var/atom/target, var/blocked = 0)
		explosion(target, -1, 0, 2)
		return 1

/obj/item/projectile/temp
	name = "freeze beam"
	icon_state = "ice_2"
	damage = 0
	damage_type = BURN
	nodamage = 1
	flag = "energy"
	var/temperature = 300


	on_hit(var/atom/target, var/blocked = 0)//These two could likely check temp protection on the mob
		if(istype(target, /mob/living))
			var/mob/M = target
			M.bodytemperature = temperature
		return 1

/obj/item/projectile/meteor
	name = "meteor"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "smallf"
	damage = 0
	damage_type = BRUTE
	nodamage = 1
	flag = "bullet"

	Bump(atom/A as mob|obj|turf|area)
		if(A == firer)
			loc = A.loc
			return

		sleep(-1) //Might not be important enough for a sleep(-1) but the sleep/spawn itself is necessary thanks to explosions and metoerhits

		if(src)//Do not add to this if() statement, otherwise the meteor won't delete them
			if(A)

				A.meteorhit(src)
				playsound(src.loc, 'sound/effects/meteorimpact.ogg', 40, 1)

				for(var/mob/M in range(10, src))
					if(!M.stat && !istype(M, /mob/living/silicon/ai))\
						shake_camera(M, 3, 1)
				del(src)
				return 1
		else
			return 0

/obj/item/projectile/energy/floramut
	name = "alpha somatoray"
	icon_state = "energy"
	damage = 0
	damage_type = TOX
	nodamage = 1
	flag = "energy"

	on_hit(var/atom/target, var/blocked = 0)
		var/mob/living/M = target
		if(ishuman(target))
			var/mob/living/carbon/human/H = M
			if((H.species.flags & IS_PLANT) && (M.nutrition < 500))
				if(prob(15))
					M.apply_effect((rand(30,80)),IRRADIATE)
					M.Weaken(5)
					for (var/mob/V in viewers(src))
						V.show_message("\red [M] writhes in pain as \his vacuoles boil.", 3, "\red You hear the crunching of leaves.", 2)
				if(prob(35))
				//	for (var/mob/V in viewers(src)) //Public messages commented out to prevent possible metaish genetics experimentation and stuff. - Cheridan
				//		V.show_message("\red [M] is mutated by the radiation beam.", 3, "\red You hear the snapping of twigs.", 2)
					if(prob(80))
						randmutb(M)
						domutcheck(M,null)
					else
						randmutg(M)
						domutcheck(M,null)
				else
					M.adjustFireLoss(rand(5,15))
					M.show_message("\red The radiation beam singes you!")
				//	for (var/mob/V in viewers(src))
				//		V.show_message("\red [M] is singed by the radiation beam.", 3, "\red You hear the crackle of burning leaves.", 2)
		else if(istype(target, /mob/living/carbon/))
		//	for (var/mob/V in viewers(src))
		//		V.show_message("The radiation beam dissipates harmlessly through [M]", 3)
			M.show_message("\blue The radiation beam dissipates harmlessly through your body.")
		else
			return 1

/obj/item/projectile/energy/florayield
	name = "beta somatoray"
	icon_state = "energy2"
	damage = 0
	damage_type = TOX
	nodamage = 1
	flag = "energy"

	on_hit(var/atom/target, var/blocked = 0)
		var/mob/M = target
		if(ishuman(target)) //These rays make plantmen fat.
			var/mob/living/carbon/human/H = M
			if((H.species.flags & IS_PLANT) && (M.nutrition < 500))
				M.nutrition += 30
		else if (istype(target, /mob/living/carbon/))
			M.show_message("\blue The radiation beam dissipates harmlessly through your body.")
		else
			return 1


/obj/item/projectile/beam/mindflayer
	name = "flayer ray"

	on_hit(var/atom/target, var/blocked = 0)
		if(ishuman(target))
			var/mob/living/carbon/human/M = target
			M.adjustBrainLoss(20)
			M.hallucination += 20

/obj/item/projectile/icarus/pointdefense
	process()
		// should step down as:
		// 1000, 500, 333, 250, 200, 167, 142, 125, 111, 100, 90
		var/damage = 1000
		for(var/i in 2 to 12)
			var/obj/item/projectile/beam/in_chamber = new (src.loc)
			in_chamber.original = original
			in_chamber.starting = starting
			in_chamber.shot_from = shot_from
			in_chamber.silenced = silenced
			in_chamber.current = current
			in_chamber.yo = yo
			in_chamber.xo = xo
			in_chamber.damage = damage
			in_chamber.process()
			damage -= damage / i
			sleep(-1)

		// Let everyone know what hit them.
		var/obj/item/projectile/beam/in_chamber = new (src.loc)
		in_chamber.original = original
		in_chamber.name = "point defense laser"
		in_chamber.starting = starting
		in_chamber.shot_from = shot_from
		in_chamber.silenced = 0
		in_chamber.firer = "Icarus" // Never displayed, but we want this to display the hit message.
		in_chamber.current = current
		in_chamber.yo = yo
		in_chamber.xo = xo
		in_chamber.damage = 0
		in_chamber.process()
		spawn(1)
			del src

		return

/obj/item/projectile/icarus/guns
	process()
		var/turf/location = get_turf(src)
		//Find the world endge targetted.
		var/x = xo > 0 ? (world.maxx - location.x) / xo : xo < 0 ? (-location.x) / xo : 1.#INF
		var/y = yo > 0 ? (world.maxy - location.y) / yo : yo < 0 ? (-location.y) / yo : 1.#INF
		// Get the minimum number of steps using the rise/run shit.
		var/iterations = round(min(x,y)) - 1

		var/turf/target = locate(location.x + iterations * xo, location.y + iterations * yo, location.z)
		var/turf/start = get_step(location, get_dir(location, target))
		var/obj/effect/meteor/small/projectile = new (start) // Let's not squish the firer.
		projectile.dest = target
		projectile.name = "main gun projectile" // stealthy
		projectile.hits = 6
		projectile.detonation_chance = 99 // it's a missile/cannon round thing!

		spawn(0)
			projectile.throw_at(projectile.dest, 1.#INF, 5)
			walk_towards(projectile, projectile.dest, 1)

		spawn(1)
			del src

		return

/obj/item/projectile/icarus/torpedo
	//TODO