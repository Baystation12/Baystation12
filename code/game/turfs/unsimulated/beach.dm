/turf/unsimulated/beach
	name = "Beach"
	icon = 'icons/misc/beach.dmi'

/turf/unsimulated/beach/sand
	name = "Sand"
	icon_state = "sand"

/turf/unsimulated/beach/coastline
	name = "Coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"

/turf/unsimulated/beach/water
	name = "Water"
	icon_state = "water"
	var/recent_splash = 0
	//var/list/splish_sound = list() //footstep sounds

/turf/unsimulated/beach/water/New()
	..()
	overlays += image("icon"='icons/misc/beach.dmi',"icon_state"="water2","layer"=MOB_LAYER+0.1)

/turf/unsimulated/beach/water/Entered(atom/movable/M as mob|obj)
	..()
//	if(istype(M, /mob/living/carbon/human/H))
//		if(recent_splash)
//			return
//		recent_splash = 1
		//playsound(usr.loc, splish_sound, 50, 1)
//		spawn(1)
//			recent_splash = 0


/turf/unsimulated/water
	name = "water"
	icon_state = "water"
	icon = 'icons/misc/beach.dmi'

/turf/unsimulated/water/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/reagent_containers))
		src.visible_message("<span class='info'>[user] begins filling [W] with water.</span>")
		if(do_after(user, 30))
			//var/obj/item/weapon/reagent_containers/container = W
			W.reagents.add_reagent(/datum/reagent/water, 1000)

/turf/unsimulated/water/Enter(atom/movable/O, atom/oldloc)
	if(isliving(O))
		return 0

	. = ..()

	if(istype(O, /obj/effect))
		return .

	spawn(10)
		if(O.loc == src)
			src.visible_message("<span class='notice'>[O] sinks beneath the surface of [src].</span>")
			qdel(O)

	return ..()