/obj/item/projectile/bullet/pellet/fragment
	damage = 7
	range_step = 2 //controls damage falloff with distance. projectiles lose a "pellet" each time they travel this distance. Can be a non-integer.

	base_spread = 0 //causes it to be treated as a shrapnel explosion instead of cone
	spread_step = 20

	silenced = 1
	fire_sound = null
	no_attack_log = 1
	muzzle_type = null

/obj/item/projectile/bullet/pellet/fragment/strong
	damage = 15

/obj/item/weapon/grenade/frag
	name = "fragmentation grenade"
	desc = "A military fragmentation grenade, designed to explode in a deadly shower of fragments, while avoiding massive structural damage."
	icon_state = "frggrenade"
	loadable = FALSE
	item_worth = 300

	var/fragment_type = /obj/item/projectile/bullet/pellet/fragment
	var/num_fragments = 72  //total number of fragments produced by the grenade
	var/explosion_size = 2   //size of the center explosion

	//The radius of the circle used to launch projectiles. Lower values mean less projectiles are used but if set too low gaps may appear in the spread pattern
	var/spread_range = 7 //leave as is, for some reason setting this higher makes the spread pattern have gaps close to the epicenter

/obj/item/weapon/grenade/frag/detonate()
	set waitfor = 0
	..()

	var/turf/O = get_turf(src)
	if(!O) return

	if(explosion_size)
		on_explosion(O)

	var/list/target_turfs = getcircle(O, spread_range)
	var/fragments_per_projectile = round(num_fragments/target_turfs.len)

	for(var/turf/T in target_turfs)
		sleep(0)
		var/obj/item/projectile/bullet/pellet/fragment/P = new fragment_type(O)

		P.pellets = fragments_per_projectile
		P.shot_from = src.name

		P.launch(T)

		//Make sure to hit any mobs in the source turf
		for(var/mob/living/M in O)
			//lying on a frag grenade while the grenade is on the ground causes you to absorb most of the shrapnel.
			//you will most likely be dead, but others nearby will be spared the fragments that hit you instead.
			if(M.lying && isturf(src.loc))
				P.attack_mob(M, 0, 0)
			else
				P.attack_mob(M, 0, 100) //otherwise, allow a decent amount of fragments to pass

	qdel(src)

/obj/item/weapon/grenade/frag/proc/on_explosion(var/turf/O)
	if(explosion_size)
		explosion(O, -1, -1, explosion_size, round(explosion_size/2), 0)

/obj/item/weapon/grenade/frag/shell
	name = "fragmentation grenade"
	desc = "A light fragmentation grenade, designed to be fired from a launcher. It can still be activated and thrown by hand if necessary."
	icon_state = "fragshell"
	loadable = TRUE

	num_fragments = 50 //less powerful than a regular frag grenade

/obj/item/weapon/grenade/frag/high_yield
	name = "fragmentation bomb"
	desc = "Larger and heavier than a standard fragmentation grenade, this device is extremely dangerous. It cannot be thrown as far because of its weight."
	icon_state = "frag"
	loadable = FALSE

	w_class = 3
	throw_speed = 3
	throw_range = 5 //heavy, can't be thrown as far

	fragment_type = /obj/item/projectile/bullet/pellet/fragment/strong
	num_fragments = 200  //total number of fragments produced by the grenade
	explosion_size = 3

/obj/item/weapon/grenade/frag/high_yield/on_explosion(var/turf/O)
	if(explosion_size)
		explosion(O, -1, round(explosion_size/2), explosion_size, round(explosion_size/2), 0) //has a chance to blow a hole in the floor
