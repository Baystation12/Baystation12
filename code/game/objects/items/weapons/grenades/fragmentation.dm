//Fragmentation grenade projectile
/obj/item/projectile/bullet/pellet/fragment
	damage = 6
	range_step = 2

	base_spread = 0 //hit any target zone randomly
	spread_step = 0
	
	//step_delay = 10
	silenced = 1
	//hitscan = 1
	muzzle_type = null

/obj/item/projectile/bullet/pellet/fragment/Move()
	. = ..()
	
	//Allow mobs that are prone close to the starting turf a chance to get hit, too
	
	if(. && isturf(loc))
		var/distance = get_dist(loc, starting)
		var/chance = max(100 - (distance - 1)*20, 0)
		if(prob(chance))
			for(var/mob/living/M in loc)
				if(Bump(M)) //Bump will make sure we don't hit a mob multiple times
					return


/obj/item/weapon/grenade/frag
	name = "fragmentation grenade"
	desc = "A military fragmentation grenade, designed to explode in a deadly shower of fragments."
	
	var/num_fragments = 7 //fragments per projectile
	var/fragment_damage = 15
	var/damage_step = 1 //projectiles lose a fragment each time they travel this distance. Can be a non-integer.
	
	var/silenced = 0
	
	//Higher values means projectile spread is more even but more projectiles are created.
	//The actual number of projectile objects is spread_range*8
	var/spread_range = 4 //32 projectiles. With spread_range=4 and num_fragments=7, a frag grenade produces 224 fragments.

#define LOCATE_COORDS(X, Y, Z) locate(between(1, X, world.maxx), between(1, Y, world.maxy), Z)
/obj/item/weapon/grenade/frag/prime()
	..()
	
	var/turf/O = get_turf(src)
	if(!O) return
	
	explosion(O, -1, 1, 2, 1, 0)
	
	for(var/i in -spread_range to spread_range)
		var/turf/T1 = LOCATE_COORDS(O.x+i, O.y+spread_range, O.z)
		launch_projectile(O, T1)
		
		var/turf/T2 = LOCATE_COORDS(O.x+i, O.y-spread_range, O.z)
		launch_projectile(O, T2)
	
	for(var/j in 1-spread_range to spread_range-1)
		var/turf/T1 = LOCATE_COORDS(O.x+spread_range, O.y+j, O.z)
		launch_projectile(O, T1)
		
		var/turf/T2 = LOCATE_COORDS(O.x-spread_range, O.y+j, O.z)
		launch_projectile(O, T2)
	
	qdel(src)

/obj/item/weapon/grenade/frag/proc/launch_projectile(var/turf/source, var/turf/target)
	var/obj/item/projectile/bullet/pellet/fragment/P = new(src)
	
	P.damage = fragment_damage
	P.pellets = num_fragments
	P.range_step = damage_step
	P.silenced = silenced
	P.shot_from = src.name
	
	var/location = loc //store our current loc since qdel will move the grenade to nullspace
	spawn(0)
		P.launch(target)
		if(!isturf(location))
			P.Bump(location)
		for(var/atom/movable/AM in source)
			P.Bump(AM)

	/*
	//the vector system doesn't play well with very large angle offsets, so generate projectiles along each of the 8 directions
	var/subarc_width = 45/(num_projectiles*2)
	var/fragments_per_projectile = round(num_fragments / (num_projectiles*8))
	
	for(var/launch_dir in alldirs)
		var/turf/target = get_edge_target_turf(T, launch_dir)
		for(var/i in 1 to num_projectiles)
			//keep the trajectory centered in the 45 deg arc
			var/launch_angle = (i-0.5)*subarc_width - 22.5
			
			var/obj/item/projectile/bullet/pellet/fragment/P = new(src)
			
			if(dispersion)
				P.dispersion = (subarc_width)/9 //randomly disperse within the projectile arc, so that there aren't any predictable blind spots
			P.damage = fragment_damage
			P.pellets = fragments_per_projectile
			P.range_step = damage_step
			P.silenced = silenced
			
			P.shot_from = src.name
			spawn(0)
				P.Move(T) //so that we hit people in the starting turf
				P.launch(target, ran_zone(), angle_offset = launch_angle)
	*/
	qdel(src)
