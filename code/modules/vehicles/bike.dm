/obj/vehicle/bike/
	name = "space-bike"
	desc = "Space wheelies! Woo! "
	icon = 'icons/obj/bike.dmi'
	icon_state = "bike_back_off"
	dir = SOUTH

	load_item_visible = 1
	mob_offset_y = 7

	health = 100
	maxhealth = 100

	fire_dam_coeff = 0.6
	brute_dam_coeff = 0.5

	var/datum/effect/effect/system/ion_trail_follow/ion
	var/kickstand = 1

/obj/vehicle/bike/New()
	..()
	ion = new /datum/effect/effect/system/ion_trail_follow()
	ion.set_up(src)
	turn_off()
	overlays += image('icons/obj/bike.dmi', "bike_front_off", MOB_LAYER + 1)

/obj/vehicle/bike/verb/toggle()
	set name = "Toggle Engine"
	set category = "Vehicle"
	set src in view(0)

	if(usr.incapacitated()) return

	if(!on)
		turn_on()
		src.visible_message("\The [src] rumbles to life.", "You hear something rumble deeply.")
	else
		turn_off()
		src.visible_message("\The [src] putters before turning off.", "You hear something putter slowly.")

/obj/vehicle/bike/verb/kickstand()
	set name = "Toggle Kickstand"
	set category = "Vehicle"
	set src in view(0)

	if(usr.incapacitated()) return

	if(kickstand)
		src.visible_message("You put up \the [src]'s kickstand.")
	else
		if(istype(src.loc,/turf/space))
			usr << "<span class='warning'> You don't think kickstands work in space...</span>"
			return
		src.visible_message("You put down \the [src]'s kickstand.")
		if(pulledby)
			pulledby.stop_pulling()

	kickstand = !kickstand
	anchored = (kickstand || on)

/obj/vehicle/bike/load(var/atom/movable/C)
	var/mob/living/M = C
	if(!istype(C)) return 0
	if(M.buckled || M.restrained() || !Adjacent(M) || !M.Adjacent(src))
		return 0
	return ..(M)

/obj/vehicle/bike/MouseDrop_T(var/atom/movable/C, mob/user as mob)
	if(!load(C))
		user << "<span class='warning'> You were unable to load \the [C] onto \the [src].</span>"
		return

/obj/vehicle/bike/attack_hand(var/mob/user as mob)
	if(user == load)
		unload(load)
		user << "You unbuckle yourself from \the [src]"


/obj/vehicle/bike/attackby(var/obj/item/weapon/W, var/mob/M)
	//we want people to be able to place other people on the bikes. For now.
/obj/vehicle/bike/relaymove(mob/user, direction)
	if(user != load || !on)
		return
	return Move(get_step(src, direction))

/obj/vehicle/bike/Move(var/turf/destination)
	if(kickstand) return


	//these things like space, not turf. Dragging shouldn't weigh you down.
	if(istype(destination,/turf/space) || pulledby)
		move_delay = 1
	else
		move_delay = 10
	return ..()

/obj/vehicle/bike/turn_on()
	ion.start()
	anchored = 1

	update_icon()

	if(pulledby)
		pulledby.stop_pulling()
	..()
/obj/vehicle/bike/turn_off()
	ion.stop()
	anchored = kickstand

	update_icon()

	..()

/obj/vehicle/bike/bullet_act(var/obj/item/projectile/Proj)
	if(buckled_mob && prob(40))
		buckled_mob.bullet_act(Proj)
		return
	..()

/obj/vehicle/bike/update_icon()
	overlays.Cut()

	if(on)
		overlays += image('icons/obj/bike.dmi', "bike_front_on", MOB_LAYER + 1)
		icon_state = "bike_back_on"
	else
		overlays += image('icons/obj/bike.dmi', "bike_front_off", MOB_LAYER + 1)
		icon_state = "bike_back_off"

	..()


/obj/vehicle/bike/Destroy()
	qdel(ion)

	..()