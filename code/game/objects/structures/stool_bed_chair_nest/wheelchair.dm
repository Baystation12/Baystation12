/obj/structure/stool/bed/chair/wheelchair
	name = "wheelchair"
	desc = "You sit in this. Either by will or force."
	icon_state = "wheelchair"
	anchored = 0

	var/driving = 0
	var/mob/living/pulling = null


/obj/structure/stool/bed/chair/wheelchair/handle_rotation()
	overlays = null
	var/image/O = image(icon = 'icons/obj/objects.dmi', icon_state = "w_overlay", layer = FLY_LAYER, dir = src.dir)
	overlays += O
	if(buckled_mob)
		buckled_mob.dir = dir

/obj/structure/stool/bed/chair/wheelchair/relaymove(mob/user, direction)
	if(user.stat || user.stunned || user.weakened || user.paralysis || user.lying || user.restrained())
		if(user==pulling)
			pulling = null
			user.pulledby = null
			user << "\red You lost your grip!"
	else if(user.pulling)
		pulling = null
		user.pulledby = null
	else if(pulling && (get_dist(src, pulling) > 1))
		pulling = null
		user.pulledby = null
	else if(pulling && (get_dir(src.loc, pulling.loc) == direction))
		user << "\red You cannot go there."
	else if(pulling && buckled_mob && (buckled_mob == user))
		user << "\red You cannot drive while being pushed."
	else
		// Let's roll
		driving = 1
		var/turf/T = null
		//--1---Move occupant---1--//
		if(buckled_mob)
			buckled_mob.buckled = null
			step(buckled_mob, direction)
			buckled_mob.buckled = src
		//--2----Move driver----2--//
		if(pulling)
			T = pulling.loc
			if(get_dist(src, pulling) >= 1)
				step(pulling, get_dir(pulling.loc, src.loc))
		//--3--Move wheelchair--3--//
		step(src, direction)
		if(buckled_mob) // Make sure it stays beneath the occupant
			Move(buckled_mob.loc)
		dir = direction
		handle_rotation()
		if(pulling) // Driver
			if(pulling.loc == src.loc) // We moved onto the wheelchair? Revert!
				pulling.loc = T
			else
				spawn(0)
				pulling.dir = get_dir(pulling, src) // When everything is right, face the wheelchair
		driving = 0

/obj/structure/stool/bed/chair/wheelchair/Move()
	..()
	if(!driving && buckled_mob)
		buckled_mob.buckled = null
		buckled_mob.Move(src.loc)
		buckled_mob.buckled = src
		if (buckled_mob && (src.loc != buckled_mob.loc))
			unbuckle()
	handle_rotation()

/obj/structure/stool/bed/chair/wheelchair/attack_hand(mob/user as mob)
	if (pulling && (pulling == usr))
		MouseDrop(usr)
	else
		manual_unbuckle(user)
	return

/obj/structure/stool/bed/chair/wheelchair/MouseDrop(over_object, src_location, over_location)
	..()
	if(over_object == usr && in_range(src, usr))
		if(!ishuman(usr))	return
		if(usr == buckled_mob)
			usr << "\red You realize you are unable to push the wheelchair you sit in."
			return
		if(!pulling)
			pulling = usr
			usr.pulledby = src
			if(usr.pulling)
				usr.stop_pulling()
			usr.dir = get_dir(usr, src)
			usr << "You grip \the [name]'s handles."
		else
			if(usr != pulling)
				for(var/mob/O in viewers(pulling, null))
					O.show_message("\red [usr] breaks [pulling]'s grip on the wheelchair.", 1)
			else
				usr << "You let go of \the [name]'s handles."
			pulling.pulledby = null
			pulling = null
		return

/obj/structure/stool/bed/chair/wheelchair/buckle_mob(mob/M as mob, mob/user as mob)
	if(M == pulling)
		pulling = null
		usr.pulledby = null
	..()