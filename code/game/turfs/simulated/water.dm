
/turf/simulated/floor/water
	name = "deep water"
	icon_state = "seadeep"
	icon = 'icons/misc/beach.dmi'
	var/deepwater = 1
	movement_delay = 15

/turf/simulated/floor/water/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/reagent_containers))
		src.visible_message("<span class='info'>[user] begins filling [W] with water.</span>")
		if(do_after(user, 30))
			//var/obj/item/weapon/reagent_containers/container = W
			W.reagents.add_reagent(/datum/reagent/water, 1000)

/turf/simulated/floor/water/Enter(atom/movable/O, atom/oldloc)
	if(deepwater && isliving(O))
		to_chat(O, "<span class='warning'>You flounder inside [src]!</span>")

	. = ..()

	if(deepwater && istype(O, /obj/effect))
		spawn(10)
			if(O.loc == src)
				src.visible_message("<span class='notice'>[O] sinks beneath the surface of [src].</span>")
				qdel(O)

/turf/simulated/floor/water/shallow
	name = "shallow water"
	desc = "Looks shallow enough to cross"
	icon_state = "seashallow"
	deepwater = 0
	movement_delay = 5
