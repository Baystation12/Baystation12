
/turf/unsimulated/floor/desert
	name = "sand"
	icon = 'icons/turf/desert.dmi'
	icon_state = "desert"

/turf/unsimulated/floor/desert/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if(!W || !user)
		return 0

	var/list/usable_tools = list(
		/obj/item/weapon/shovel,
		/obj/item/weapon/pickaxe/diamonddrill,
		/obj/item/weapon/pickaxe/drill,
		/obj/item/weapon/pickaxe/borgdrill
		)

	var/valid_tool
	for(var/valid_type in usable_tools)
		if(istype(W,valid_type))
			valid_tool = 1
			break

	if(valid_tool)
		if (dug)
			to_chat(user, "<span class='warning'>This area has already been dug.</span>")
			return

		var/turf/T = user.loc
		if (!(istype(T)))
			return

		to_chat(user, "<span class='info'>You start digging.</span>")
		playsound(user.loc, 'sound/effects/rustle1.ogg', 50, 1)

		if(!do_after(user,40)) return

		to_chat(user, "<span class='info'>You dug a hole.</span>")
		dug = 1
		new/obj/item/weapon/ore/glass(src)
		icon_state = "desert_dug"

	else
		..(W,user)
	return

/turf/unsimulated/floor/desert2
	name = "sand"
	icon = 'icons/turf/desert.dmi'
	icon_state = "desert7"

/turf/unsimulated/floor/desert2/New()
	. = ..()
	icon_state = "desert[rand(7,7)]"

/turf/unsimulated/floor/sand_mars
	name = "sand"
	icon = 'code/modules/halo/icons/turfs/mars.dmi'
	icon_state = "7"

/turf/unsimulated/floor/sand_mars/New()
	..()
	icon_state = "[rand(2,7)]"

/turf/unsimulated/floor/sand_moon
	name = "sand"
	icon = 'code/modules/halo/icons/turfs/Ground.dmi'
	icon_state = "moon"

/turf/unsimulated/floor/sand_moon/New()
	..()
	icon_state = "[rand(0,12)]"

/turf/unsimulated/floor/desert4
	name = "sand"
	icon = 'code/modules/halo/icons/turfs/natureicons.dmi'
	icon_state = "sand"

/turf/unsimulated/floor/sand_asteroid
	name = "sand"
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"

/turf/unsimulated/floor/seafloor
	name = "sand"
	icon = 'code/modules/halo/icons/turfs/seafloor.dmi'
	icon_state = "seafloor"

/turf/unsimulated/floor/desert7
	name = "sand"
	icon = 'code/modules/halo/icons/turfs/seafloor.dmi'
	icon_state = "sand"
