//########################## CONTRABAND ;3333333333333333333 -Agouri ###################################################

/obj/item/contraband
	name = "contraband item"
	desc = "You probably shouldn't be holding this."
	icon = 'icons/obj/structures/contraband.dmi'
	force = 0

/obj/item/contraband/poster
	name = "rolled-up poster"
	desc = "The poster comes with its own automatic adhesive mechanism, for easy pinning to any vertical surface."
	icon_state = "rolled_poster"
	var/poster_type

/obj/item/contraband/poster/New(maploading, given_poster_type)
	if(given_poster_type && !ispath(given_poster_type, /singleton/poster))
		CRASH("Invalid poster type: [log_info_line(given_poster_type)]")

	poster_type = given_poster_type || poster_type || get_random_poster_type()
	..()

/obj/item/contraband/poster/Initialize()
	var/list/posters = subtypesof(/singleton/poster)
	var/serial_number = posters.Find(poster_type)
	name += " - No. [serial_number]"

	return ..()

//Places the poster on a wall
/obj/item/contraband/poster/use_after(turf/W, mob/living/user, click_parameters)
	if(!isturf(W))
		return FALSE

	if (!W.is_wall() || !isturf(user.loc))
		to_chat(user, SPAN_WARNING("You can't place this here!"))
		return TRUE

	var/placement_dir = get_dir(user, W)
	if (!(placement_dir in GLOB.cardinal))
		to_chat(user, SPAN_WARNING("You must stand directly in front of the wall you wish to place that on."))
		return TRUE

	if (ArePostersOnWall(W))
		to_chat(user, SPAN_NOTICE("There is already a poster there!"))
		return TRUE

	user.visible_message(SPAN_NOTICE("\The [user] starts placing a poster on \the [W]."),SPAN_NOTICE("You start placing the poster on \the [W]."))

	var/obj/structure/sign/poster/P = new (user.loc, placement_dir, poster_type)
	qdel(src)
	flick("poster_being_set", P)
	// Time to place is equal to the time needed to play the flick animation
	if(do_after(user, 2.8 SECONDS, W, DO_PUBLIC_UNIQUE) && W.is_wall() && !ArePostersOnWall(W, P))
		user.visible_message(SPAN_NOTICE("\The [user] has placed a poster on \the [W]."),SPAN_NOTICE("You have placed the poster on \the [W]."))
	else
		// We cannot rely on user being on the appropriate turf when placement fails
		P.roll_and_drop(get_step(W, turn(placement_dir, 180)))
	return TRUE

/obj/item/contraband/poster/proc/ArePostersOnWall(turf/W, placed_poster)
	//just check if there is a poster on or adjacent to the wall
	if (locate(/obj/structure/sign/poster) in W)
		return TRUE

	//crude, but will cover most cases. We could do stuff like check pixel_x/y but it's not really worth it.
	for (var/dir in GLOB.cardinal)
		var/turf/T = get_step(W, dir)
		var/poster = locate(/obj/structure/sign/poster) in T
		if (poster && placed_poster != poster)
			return TRUE

	return FALSE
