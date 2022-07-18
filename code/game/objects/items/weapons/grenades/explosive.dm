/obj/item/projectile/bullet/pellet/fragment
	damage = 30
	range_step = 2 //controls damage falloff with distance. projectiles lose a "pellet" each time they travel this distance. Can be a non-integer.

	base_spread = 0 //causes it to be treated as a shrapnel explosion instead of cone
	spread_step = 40

	silenced = TRUE
	fire_sound = null
	no_attack_log = TRUE
	muzzle_type = null
	embed = TRUE

/obj/item/projectile/bullet/pellet/fragment/strong
	damage = 60

/obj/item/grenade/frag
	name = "fragmentation grenade"
	desc = "A military fragmentation grenade, designed to explode in a deadly shower of fragments, while avoiding massive structural damage."
	icon_state = "frggrenade"

	var/list/fragment_types = list(/obj/item/projectile/bullet/pellet/fragment = 1)
	var/num_fragments = 72  //total number of fragments produced by the grenade
	var/explosion_size = 2   //size of the center explosion

	//The radius of the circle used to launch projectiles. Lower values mean less projectiles are used but if set too low gaps may appear in the spread pattern
	var/spread_range = 7 //leave as is, for some reason setting this higher makes the spread pattern have gaps close to the epicenter

/obj/item/grenade/frag/detonate(mob/living/user)
	..()

	var/turf/O = get_turf(src)
	if(!O) return

	if(explosion_size)
		on_explosion(O)

	src.fragmentate(O, num_fragments, spread_range, fragment_types)

	qdel(src)


/obj/proc/fragmentate(var/turf/T=get_turf(src), var/fragment_number = 30, var/spreading_range = 5, var/list/fragtypes=list(/obj/item/projectile/bullet/pellet/fragment))
	set waitfor = 0
	var/list/target_turfs = getcircle(T, spreading_range)
	var/fragments_per_projectile = round(fragment_number/target_turfs.len)

	for(var/turf/O in target_turfs)
		sleep(0)
		var/fragment_type = pickweight(fragtypes)
		var/obj/item/projectile/bullet/pellet/fragment/P = new fragment_type(T)
		P.pellets = fragments_per_projectile
		P.shot_from = src.name
		P.hitchance_mod = 50

		P.launch(O)

		// Handle damaging whatever the grenade's inside. Currently only checks for mobs.
		if (loc != get_turf(src))
			var/recursion_limit = 3 // Prevent infinite loops
			var/atom/current_check = src
			while (recursion_limit)
				current_check = current_check.loc
				if (isturf(current_check))
					break
				if (ismob(current_check))
					P.attack_mob(current_check, 0, 25)
				recursion_limit--

		//Make sure to hit any mobs in the source turf
		for(var/mob/living/M in T)
			//lying on a frag grenade while the grenade is on the ground causes you to absorb most of the shrapnel.
			//you will most likely be dead, but others nearby will be spared the fragments that hit you instead.
			if(M.lying && isturf(src.loc))
				P.attack_mob(M, 0, 5)
			else
				P.attack_mob(M, 0, 50)

/obj/item/grenade/frag/proc/on_explosion(var/turf/O)
	if(explosion_size)
		explosion(O, -1, -1, explosion_size, round(explosion_size/2), 0)

/obj/item/grenade/frag/shell
	name = "fragmentation grenade"
	desc = "A light fragmentation grenade, designed to be fired from a launcher. It can still be activated and thrown by hand if necessary."
	icon_state = "fragshell"

	num_fragments = 50 //less powerful than a regular frag grenade

/obj/item/grenade/frag/high_yield
	name = "fragmentation bomb"
	desc = "Larger and heavier than a standard fragmentation grenade, this device is extremely dangerous. It cannot be thrown as far because of its weight."
	icon_state = "frag"

	w_class = ITEM_SIZE_NORMAL
	throw_speed = 3
	throw_range = 5 //heavy, can't be thrown as far

	fragment_types = list(/obj/item/projectile/bullet/pellet/fragment=1,/obj/item/projectile/bullet/pellet/fragment/strong=4)
	num_fragments = 144  //total number of fragments produced by the grenade
	explosion_size = 3

/obj/item/grenade/frag/high_yield/on_explosion(var/turf/O)
	if(explosion_size)
		explosion(O, -1, round(explosion_size/2), explosion_size, round(explosion_size/2), 0) //has a chance to blow a hole in the floor

/obj/item/grenade/frag/makeshift
	name = "improvised explosive device"
	desc = "An aluminum can with a wire fuse leading inside of it. Partially guaranteed to blow your mind AND hands!"
	icon_state = "ghetto"
	arm_sound = 'sound/effects/flare.ogg'

	num_fragments = 10  // Its a /can/ , not nearly as strong as an industrially produced grenade.
	explosion_size = 1

	det_time = 5

	var/shrapnel_reinforced = 0 //But, with some patience, you can make it worth your time.

	var/possible_reinforcements = list(
		/obj/item/ammo_casing,
		/obj/item/material/coin,
		/obj/item/material/shard,
		/obj/item/reagent_containers/syringe,
		/obj/item/pen,
		/obj/item/material/knife/table,
		/obj/item/material/kitchen/utensil
		)

/obj/item/grenade/frag/makeshift/Initialize()
	det_time = rand(5,100) // Fuse is randomized.
	. = ..()

/obj/item/grenade/frag/makeshift/attackby(obj/item/W, mob/user)
	if(isScrewdriver(W)) //overrides the act to screwdrive a grenade to set its fuse.
		to_chat(user, SPAN_WARNING("You can't adjust the timer on \the [src]!"))
		return TRUE
	if (ispath(possible_reinforcements))
		if(shrapnel_reinforced<10) //you can only add 10 items inside the can
			user.visible_message(
				SPAN_WARNING("\The [user] pries \the [src] open and drops \a [W] inside."),
				SPAN_DANGER("You open \the [src], carefully adding \a [W] before sealing the lid again."),
				SPAN_WARNING("You hear a metallic crack, followed by clinking.")
			)
			num_fragments += rand(3,7) // add 3 to 7 pellets. If you're /REALLY/ lucky, you'll end up with something similar to a standard grenade
			shrapnel_reinforced += 1
			qdel(W)
		else
			to_chat(user, SPAN_WARNING("You can't add any more items to \the [src]!"))
		return TRUE
	return ..()