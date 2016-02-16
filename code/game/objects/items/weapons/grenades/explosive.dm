//obj/item/weapon/grenade/explosive
	//desc = "A fragmentation grenade, optimized for harming personnel without causing massive structural damage."
	//name = "frag grenade"
	//icon = 'icons/obj/grenade.dmi'
	//det_time = 50
	//icon_state = "frggrenade"
	//item_state = "frggrenade"
	//origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 3)

//obj/item/weapon/grenade/explosive/prime()
//	..()
	//spawn(0)
		//explosion(src.loc,-1,-1,2)	//If you're within two tiles of the grenade, you get hit twice, which tends to do 50+ brute and cause fractures.
		//explosion(src.loc,-1,-1,3)	//This is preferable to increasing the severity, so we don't decap with frags.
		//qdel(src)
	//return

//Explosive grenade projectile, borrowed from fragmentation grenade code.
/obj/item/projectile/bullet/pellet/fragment
	damage = 10
	range_step = 2

	base_spread = 0 //causes it to be treated as a shrapnel explosion instead of cone
	spread_step = 20

	silenced = 1 //embedding messages are still produced so it's kind of weird when enabled.
	no_attack_log = 1
	muzzle_type = null

/obj/item/weapon/grenade/explosive
	name = "fragmentation grenade"
	desc = "A fragmentation grenade, optimized for harming personnel without causing massive structural damage."
	icon_state = "frggrenade"
	item_state = "frggrenade"

	var/num_fragments = 50  //total number of fragments produced by the grenade
	var/fragment_damage = 10
	var/damage_step = 2      //projectiles lose a fragment each time they travel this distance. Can be a non-integer.
	var/explosion_size = 2   //size of the center explosion

	//The radius of the circle used to launch projectiles. Lower values mean less projectiles are used but if set too low gaps may appear in the spread pattern
	var/spread_range = 7
	loadable = null

/obj/item/weapon/grenade/explosive/prime()
	..()

	var/turf/O = get_turf(src)
	if(!O) return

	if(explosion_size)
		explosion(O, -1, -1, 2, round(explosion_size/2), 0)

	var/list/target_turfs = getcircle(O, spread_range)
	var/fragments_per_projectile = round(num_fragments/target_turfs.len)

	for(var/turf/T in target_turfs)
		var/obj/item/projectile/bullet/pellet/fragment/P = new (O)

		P.damage = fragment_damage
		P.pellets = fragments_per_projectile
		P.range_step = damage_step
		P.shot_from = src.name

		P.launch(T)

		//var/cone = new /obj/item/weapon/caution/cone (T)
		//spawn(100) qdel(cone)

		//Make sure to hit any mobs in the source turf
		for(var/mob/living/M in O)
			//lying on a frag grenade while the grenade is on the ground causes you to absorb most of the shrapnel.
			//you will most likely be dead, but others nearby will be spared the fragments that hit you instead.
			if(M.lying && isturf(src.loc))
				P.attack_mob(M, 0, 0)
			else
				P.attack_mob(M, 0, 100) //otherwise, allow a decent amount of fragments to pass

	qdel(src)
