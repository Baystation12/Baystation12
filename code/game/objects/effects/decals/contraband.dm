
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
	var/serial_number = 0


/obj/item/weapon/contraband/poster/New(turf/loc, var/given_serial = 0)
	if(given_serial == 0)
		serial_number = rand(1, poster_designs.len)
	else
		serial_number = given_serial
	name += " - No. [serial_number]"
	..(loc)

//Places the poster on a wall
/obj/item/weapon/contraband/poster/afterattack(var/atom/A, var/mob/user, var/adjacent, var/clickparams)
	if (!adjacent)
		return

	//must place on a wall and user must not be inside a closet/mecha/whatever
	var/turf/W = A
	if (!iswall(W) || !isturf(user.loc))
		to_chat(user, "<span class='warning'>You can't place this here!</span>")
		return

	var/placement_dir = get_dir(user, W)
	if (!(placement_dir in GLOB.cardinal))
		to_chat(user, "<span class='warning'>You must stand directly in front of the wall you wish to place that on.</span>")
		return

	//just check if there is a poster on or adjacent to the wall
	var/stuff_on_wall = 0
	if (locate(/obj/structure/sign/poster) in W)
		stuff_on_wall = 1

	//crude, but will cover most cases. We could do stuff like check pixel_x/y but it's not really worth it.
	for (var/dir in GLOB.cardinal)
		var/turf/T = get_step(W, dir)
		if (locate(/obj/structure/sign/poster) in T)
			stuff_on_wall = 1
			break

	if (stuff_on_wall)
		to_chat(user, "<span class='notice'>There is already a poster there!</span>")
		return

	to_chat(user, "<span class='notice'>You start placing the poster on the wall...</span>")//Looks like it's uncluttered enough. Place the poster.


	var/obj/structure/sign/poster/P = new(user.loc, placement_dir=get_dir(user, W), serial=serial_number)

	flick("poster_being_set", P)
	//playsound(W, 'sound/items/poster_being_created.ogg', 100, 1) //why the hell does placing a poster make printer sounds?

	var/oldsrc = src //get a reference to src so we can delete it after detaching ourselves
	src = null
	spawn(17)
		if(!P) return

		if(iswall(W) && user && P.loc == user.loc) //Let's check if everything is still there
			to_chat(user, "<span class='notice'>You place the poster!</span>")
		else
			P.roll_and_drop(P.loc)

	qdel(oldsrc)	//delete it now to cut down on sanity checks afterwards. Agouri's code supports rerolling it anyway

//############################## THE ACTUAL DECALS ###########################

/obj/structure/sign/poster
	name = "poster"
	desc = "A large piece of space-resistant printed paper."
	icon = 'icons/obj/contraband.dmi'
	anchored = 1
	var/serial_number	//Will hold the value of src.loc if nobody initialises it
	var/poster_type		//So mappers can specify a desired poster
	var/ruined = 0

/obj/structure/sign/poster/New(var/newloc, var/placement_dir=null, var/serial=null)
	..(newloc)

	if(!serial)
		serial = rand(1, poster_designs.len) //use a random serial if none is given

	serial_number = serial
	var/datum/poster/design = poster_designs[serial_number]
	set_poster(design)

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

/obj/structure/sign/poster/Initialize()
	if (poster_type)
		var/path = ispath(poster_type) ? poster_type : text2path(poster_type)
		var/datum/poster/design = new path
		set_poster(design)
	. = ..()

/obj/structure/sign/poster/proc/set_poster(var/datum/poster/design)
	name = "[initial(name)] - [design.name]"
	desc = "[initial(desc)] [design.desc]"
	icon_state = design.icon_state // poster[serial_number]

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
		name = "ripped poster"
		desc = "You can't make out anything from the poster's original print. It's ruined."
		add_fingerprint(user)

/obj/structure/sign/poster/proc/roll_and_drop(turf/newloc)
	var/obj/item/weapon/contraband/poster/P = new(src, serial_number)
	P.loc = newloc
	src.loc = P
	qdel(src)

/datum/poster
	// Name suffix. Poster - [name]
	var/name=""
	// Description suffix
	var/desc=""
	var/icon_state=""
