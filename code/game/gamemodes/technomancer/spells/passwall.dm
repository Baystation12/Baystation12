/datum/technomancer/spell/passwall
	name = "Passwall"
	desc = "An uncommon function that allows the user to phase through matter (usually walls) in order to enter or exit a room.  Be careful you don't pass into \
	somewhere dangerous."
	enhancement_desc = "Cost per tile is halved."
	cost = 100
	obj_path = /obj/item/weapon/spell/passwall
	ability_icon_state = "tech_passwall"
	category = UTILITY_SPELLS

/obj/item/weapon/spell/passwall
	name = "passwall"
	desc = "No walls can hold you back."
	cast_methods = CAST_MELEE
	aspect = ASPECT_TELE
	var/maximum_distance = 20 //Measured in tiles.
	var/busy = 0

/obj/item/weapon/spell/passwall/on_melee_cast(atom/hit_atom, mob/user)
	if(busy)	//Prevent someone from trying to get two uses of the spell from one instance.
		return 0
	if(!allowed_to_teleport())
		to_chat(user,"<span class='warning'>You can't teleport here!</span>")
		return 0
//	if(isturf(hit_atom))

	var/turf/T = get_turf(hit_atom)		//Turf we touched.
	var/turf/our_turf = get_turf(user)	//Where we are.
	if(!T.density)
		if(!T.check_density())
			to_chat(user,"<span class='warning'>Perhaps you should try using passWALL on a wall, or other solid object.</span>")
			return 0
	var/direction = get_dir(our_turf, T)
	var/total_cost = 0
	var/turf/checked_turf = T			//Turf we're currently checking for density in the loop below.
	var/turf/found_turf = null			//Our destination, if one is found.
	var/i = maximum_distance

	visible_message("<span class='info'>[user] rests a hand on \the [hit_atom].</span>")
	busy = 1

	var/datum/effect/effect/system/spark_spread/spark_system = new()
	spark_system.set_up(5, 0, our_turf)

	while(i)
		checked_turf = get_step(checked_turf, direction) //Advance in the given direction
		total_cost += check_for_scepter() ? 400 : 800 //Phasing through matter's expensive, you know.
		i--
		if(!checked_turf.density) //If we found a destination (a non-dense turf), then we can stop.
			var/dense_objs_on_turf = 0
			for(var/atom/movable/stuff in checked_turf.contents) //Make sure nothing dense is where we want to go, like an airlock or window.
				if(stuff.density)
					dense_objs_on_turf = 1

			if(!dense_objs_on_turf) //If we found a non-dense turf with nothing dense on it, then that's our destination.
				found_turf = checked_turf
				break
		sleep(10)

	if(found_turf)
		if(user.loc != our_turf)
			to_chat(user,"<span class='warning'>You need to stand still in order to phase through \the [hit_atom].</span>")
			return 0
		if(pay_energy(total_cost) && !user.incapacitated() )
			visible_message("<span class='warning'>[user] appears to phase through \the [hit_atom]!</span>")
			to_chat(user,"<span class='info'>You find a destination on the other side of \the [hit_atom], and phase through it.</span>")
			spark_system.start()
			user.forceMove(found_turf)
			qdel(src)
			return 1
		else
			to_chat(user,"<span class='warning'>You don't have enough energy to phase through these walls!</span>")
			busy = 0
	else
		to_chat(user,"<span class='info'>You weren't able to find an open space to go to.</span>")
		busy = 0
