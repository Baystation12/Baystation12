
/area/planet/daynight
	name = "\improper Planet"
	icon_state = "away"
	ambience = list(\
		'sound/effects/wind/wind_2_1.ogg',\
		'sound/effects/wind/wind_2_2.ogg',\
		'sound/effects/wind/wind_3_1.ogg',\
		'sound/effects/wind/wind_4_1.ogg',\
		'sound/effects/wind/wind_4_2.ogg',\
		'sound/effects/wind/wind_5_1.ogg'\
		)

/turf/unsimulated/floor/desert
	name = "desert sand"
	icon = 'icons/turf/desert.dmi'
	icon_state = "desert"
	dynamic_lighting = 1
	var/dug = 0

/turf/unsimulated/floor/desert/New()
	. = ..()
	if(prob(83))
		icon_state = "desert[rand(0,4)]"

	if(prob(2))
		new /obj/structure/tree/palm(src)
		return .

	if(prob(2))
		new /obj/effect/desertflora(src)
		return .

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
			user.show_message("\red This area has already been dug")
			return

		var/turf/T = user.loc
		if (!(istype(T)))
			return

		user.show_message("\red You start digging.")
		playsound(user.loc, 'sound/effects/rustle1.ogg', 50, 1)

		if(!do_after(user,40)) return

		user.show_message("\blue You dug a hole.")
		dug = 1
		new/obj/item/weapon/ore/glass(src)
		icon_state = "desert_dug"

	else
		..(W,user)
	return

/turf/unsimulated/floor/soil
	name = "soil"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rock-dark"
	dynamic_lighting = 1
