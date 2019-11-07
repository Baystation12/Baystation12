
//########################## CONTRABAND ;3333333333333333333 -Agouri ###################################################

/obj/item/weapon/contraband
	name = "contraband item"
	desc = "You probably shouldn't be holding this."
	icon = 'icons/obj/contraband.dmi'
	force = 0


/obj/item/weapon/contraband/poster
	name = "rolled-up poster"
	desc = "The poster comes with its own automatic adhesive mechanism, for easy pinning to any vertical surface."
	icon_state = "rolled_poster"
	var/poster_type

/obj/item/weapon/contraband/poster/New(var/maploading, var/given_poster_type)
	if(given_poster_type && !ispath(given_poster_type, /decl/poster))
		CRASH("Invalid poster type: [log_info_line(given_poster_type)]")

	poster_type = given_poster_type || poster_type
	if(!poster_type)
		poster_type = pick(subtypesof(/decl/poster))
	..()

/obj/item/weapon/contraband/poster/Initialize()
	var/list/posters = subtypesof(/decl/poster)
	var/serial_number = posters.Find(poster_type)
	name += " - No. [serial_number]"

	return ..()

//Places the poster on a wall
/obj/item/weapon/contraband/poster/afterattack(var/atom/A, var/mob/user, var/adjacent, var/clickparams)
	if (!adjacent)
		return

	//must place on a wall and user must not be inside a closet/exosuit/whatever
	var/turf/W = A
	if (!W.is_wall() || !isturf(user.loc))
		to_chat(user, "<span class='warning'>You can't place this here!</span>")
		return

	var/placement_dir = get_dir(user, W)
	if (!(placement_dir in GLOB.cardinal))
		to_chat(user, "<span class='warning'>You must stand directly in front of the wall you wish to place that on.</span>")
		return

	if (ArePostersOnWall(W))
		to_chat(user, "<span class='notice'>There is already a poster there!</span>")
		return

	user.visible_message("<span class='notice'>\The [user] starts placing a poster on \the [W].</span>","<span class='notice'>You start placing the poster on \the [W].</span>")

	var/obj/structure/sign/poster/P = new (user.loc, placement_dir, poster_type)
	qdel(src)
	flick("poster_being_set", P)
	// Time to place is equal to the time needed to play the flick animation
	if(do_after(user, 28, W) && W.is_wall() && !ArePostersOnWall(W, P))
		user.visible_message("<span class='notice'>\The [user] has placed a poster on \the [W].</span>","<span class='notice'>You have placed the poster on \the [W].</span>")
	else
		// We cannot rely on user being on the appropriate turf when placement fails
		P.roll_and_drop(get_step(W, turn(placement_dir, 180)))

/obj/item/weapon/contraband/poster/proc/ArePostersOnWall(var/turf/W, var/placed_poster)
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
	icon = 'icons/obj/contraband.dmi'
	anchored = 1
	var/poster_type
	var/ruined = 0

/obj/structure/sign/poster/bay_9
	poster_type = /decl/poster/bay_9

/obj/structure/sign/poster/bay_50
	poster_type = /decl/poster/bay_50

/obj/structure/sign/poster/New(var/newloc, var/placement_dir = null, var/give_poster_type = null)
	..(newloc)

	if(!poster_type)
		if(give_poster_type)
			poster_type = give_poster_type
		else
			poster_type = pick(subtypesof(/decl/poster))
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

/obj/structure/sign/poster/proc/set_poster(var/poster_type)
	var/decl/poster/design = decls_repository.get_decl(poster_type)
	SetName("[initial(name)] - [design.name]")
	desc = "[initial(desc)] [design.desc]"
	icon_state = design.icon_state

/obj/structure/sign/poster/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(isWirecutter(W))
		playsound(loc, 'sound/items/Wirecutter.ogg', 100, 1)
		if(ruined)
			to_chat(user, "<span class='notice'>You remove the remnants of the poster.</span>")
			qdel(src)
		else
			to_chat(user, "<span class='notice'>You carefully remove the poster from the wall.</span>")
			roll_and_drop(user.loc)
		return


/obj/structure/sign/poster/attack_hand(mob/user as mob)

	if(ruined)
		return

	if(alert("Do I want to rip the poster from the wall?","You think...","Yes","No") == "Yes")

		if(ruined || !user.Adjacent(src))
			return

		visible_message("<span class='warning'>\The [user] rips \the [src] in a single, decisive motion!</span>" )
		playsound(src.loc, 'sound/items/poster_ripped.ogg', 100, 1)
		ruined = 1
		icon_state = "poster_ripped"
		SetName("ripped poster")
		desc = "You can't make out anything from the poster's original print. It's ruined."
		add_fingerprint(user)

/obj/structure/sign/poster/proc/roll_and_drop(turf/newloc)
	new/obj/item/weapon/contraband/poster(newloc, poster_type)
	qdel(src)

/decl/poster
	// Name suffix. Poster - [name]
	var/name=""
	// Description suffix
	var/desc=""
	var/icon_state=""
