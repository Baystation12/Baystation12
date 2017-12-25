#include "../~objs/desert.dm"
#include "../~objs/rocks.dm"

/turf/unsimulated/floor/desert
	name = "desert sand"
	icon = 'icons/turf/desert.dmi'
	icon_state = "desert"
	var/dug = 0

/turf/unsimulated/floor/desert/New()
	. = ..()
	if(prob(83))
		icon_state = "desert[rand(0,4)]"

	if(prob(2))
		new /obj/effect/flora/desert(src)
		return .

	if(prob(1))
		new /obj/structure/tree/palm(src)
		return .

	if(prob(1))
		if(prob(50))
			new /obj/effect/rocks(src)
		else
			new /obj/effect/rocks/small(src)
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

/turf/unsimulated/floor/soil
	name = "soil"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rock-dark"

/turf/unsimulated/floor/wood
	name = "wooden floor"
	icon = 'icons/turf/flooring/wood.dmi'
	icon_state = "wood"

/turf/unsimulated/floor/dustymetal
	name = "sandy floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "asteroidfloor"
