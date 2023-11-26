
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

	poster_type = given_poster_type || poster_type
	if(!poster_type)
		poster_type = pick(subtypesof(/singleton/poster) - list(/singleton/poster/torch, /singleton/poster/contraband_only))
	..()

/obj/item/contraband/poster/Initialize()
	var/list/posters = subtypesof(/singleton/poster)
	var/serial_number = posters.Find(poster_type)
	name += " - No. [serial_number]"

	return ..()

//Places the poster on a wall
/obj/item/contraband/poster/afterattack(atom/A, mob/user, adjacent, clickparams)
	if (!adjacent)
		return

	//must place on a wall and user must not be inside a closet/exosuit/whatever
	var/turf/W = A
	if(!isturf(W))
		return

	if (!W.is_wall() || !isturf(user.loc))
		to_chat(user, SPAN_WARNING("You can't place this here!"))
		return

	var/placement_dir = get_dir(user, W)
	if (!(placement_dir in GLOB.cardinal))
		to_chat(user, SPAN_WARNING("You must stand directly in front of the wall you wish to place that on."))
		return

	if (ArePostersOnWall(W))
		to_chat(user, SPAN_NOTICE("There is already a poster there!"))
		return

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

//############################## THE ACTUAL DECALS ###########################

/obj/structure/sign/poster
	name = "poster"
	desc = "A large piece of space-resistant printed paper."
	icon = 'icons/obj/structures/contraband.dmi'
	icon_state = "random_poster"
	anchored = TRUE
	var/poster_type
	var/ruined = 0
	var/torch_poster = FALSE //for torch-specific content

/obj/structure/sign/poster/bay_9
	poster_type = /singleton/poster/bay_9

/obj/structure/sign/poster/bay_50
	poster_type = /singleton/poster/bay_50

/obj/structure/sign/poster/torch
	poster_type = /singleton/poster/torch
	torch_poster = TRUE

/obj/structure/sign/poster/New(newloc, placement_dir = null, give_poster_type = null)
	..(newloc)

	if(!poster_type)
		if(give_poster_type)
			poster_type = give_poster_type
		else
			poster_type = pick(subtypesof(/singleton/poster) - typesof(/singleton/poster/torch) - typesof(/singleton/poster/contraband_only))
	if(torch_poster)
		poster_type = pick(subtypesof(/singleton/poster/torch))
	set_poster(poster_type)

	switch (placement_dir)
		if (NORTH)
			pixel_x = 0
			pixel_y = 32
		if (SOUTH)
			pixel_x = 0
			pixel_y = -32
		if (EAST)
			pixel_x = 32
			pixel_y = 0
		if (WEST)
			pixel_x = -32
			pixel_y = 0

/obj/structure/sign/poster/proc/set_poster(poster_type)
	var/singleton/poster/design = GET_SINGLETON(poster_type)
	SetName("[initial(name)] - [design.name]")
	desc = "[initial(desc)] [design.desc]"
	icon_state = design.icon_state

/obj/structure/sign/poster/use_tool(obj/item/tool, mob/user, list/click_params)
	// Screwdriver - Block interaction
	if (isScrewdriver(tool))
		USE_FEEDBACK_FAILURE("You must use wirecutters to remove \the [src].")
		return TRUE

	// Wirecutters - Remove poster
	if (isWirecutter(tool))
		playsound(src, 'sound/items/Wirecutter.ogg', 50, TRUE)
		if (ruined)
			user.visible_message(
				SPAN_NOTICE("\The [user] removes the remnants of \the [src] with \a [tool]."),
				SPAN_NOTICE("You remove the remnants of \the [src] with \the [tool].")
			)
			qdel_self()
		else
			user.visible_message(
				SPAN_NOTICE("\The [user] removes \the [src] with \a [tool]."),
				SPAN_NOTICE("You remove \the [src] with \the [tool].")
			)
			roll_and_drop(user.loc)
		return TRUE

	return ..()


/obj/structure/sign/poster/attack_hand(mob/user as mob)

	if(ruined)
		return

	if(alert("Do I want to rip the poster from the wall?","You think...","Yes","No") == "Yes")

		if(ruined || !user.Adjacent(src))
			return

		visible_message(SPAN_WARNING("\The [user] rips \the [src] in a single, decisive motion!") )
		playsound(src.loc, 'sound/items/poster_ripped.ogg', 100, 1)
		ruined = 1
		icon_state = "poster_ripped"
		SetName("ripped poster")
		desc = "You can't make out anything from the poster's original print. It's ruined."
		add_fingerprint(user)

/obj/structure/sign/poster/proc/roll_and_drop(turf/newloc)
	var/obj/item/contraband/poster/poster_item = new/obj/item/contraband/poster(newloc, poster_type)
	transfer_fingerprints_to(poster_item)
	qdel_self()

/singleton/poster
	// Name suffix. Poster - [name]
	var/name=""
	// Description suffix
	var/desc=""
	var/icon_state=""
