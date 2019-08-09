// Passenger compartment, for the very brave and stupid
/obj/item/missile_equipment/passenger
	name = "COMFMASTER Mk3 passenger compartment"
	desc = "A very tight and extremely uncomfortable pod that just barely fits in missiles. Can hold one passenger."
	icon_state = "passenger"

	var/hatch_open = FALSE

/obj/item/missile_equipment/passenger/proc/get_passenger()
	var/mob/passenger = null
	for(var/mob/M in src)
		passenger = M
		break
	return passenger

/obj/item/missile_equipment/passenger/MouseDrop_T(var/mob/target, var/mob/user)
	if(!ismob(target))
		return

	var/old_loc = target.loc
	if(!do_after(user, 2 SECONDS, src))
		return
	if(isnull(target) || target.loc != old_loc || target.anchored)
		return

	user.show_viewers(SPAN_DANGER("[user] stuffs [target] into \the [src]!"))
	target.forceMove(src)

/obj/item/missile_equipment/passenger/relaymove(var/mob/user)
	var/turf/T = get_turf(src)
	if(!T)
		return

	if(!hatch_open)
		to_chat(user, SPAN_DANGER("The hatch is locked! You can't get out!"))
		return

	to_chat(user, SPAN_WARNING("You break out of the passenger compartment!"))
	user.forceMove(T)

/obj/item/missile_equipment/passenger/attackby(var/obj/item/I, var/mob/user)
	if(isCrowbar(I))
		if(hatch_open)
			close_hatch()
		else
			open_hatch()

		to_chat(user, "You [hatch_open ? "open" : "close"] the entrance hatch of \the [src].")
		return

	..()

/obj/item/missile_equipment/passenger/on_missile_activated(var/obj/effect/overmap/projectile/P)
	P.set_enter_zs(TRUE)
	close_hatch()

/obj/item/missile_equipment/passenger/on_touch_map_edge(var/obj/effect/overmap/projectile/P)
	var/obj/structure/missile/M = loc
	if(!istype(M))
		return

	if(!M.active)
		eject_passenger()
	close_hatch()

/obj/item/missile_equipment/passenger/on_trigger()
	eject_passenger()

/obj/item/missile_equipment/passenger/proc/open_hatch()
	var/mob/passenger = get_passenger()
	if(isnull(passenger))
		return

	hatch_open = TRUE
	if(!isnull(passenger))
		to_chat(passenger, SPAN_NOTICE("You hear a sharp hiss as the entrance hatch swings open."))

/obj/item/missile_equipment/passenger/proc/close_hatch()
	var/mob/passenger = get_passenger()
	if(isnull(passenger))
		return

	hatch_open = FALSE
	if(!isnull(passenger))
		to_chat(passenger, SPAN_NOTICE("The entrance hatch snaps shut and seals tightly."))

/obj/item/missile_equipment/passenger/proc/eject_passenger()
	var/mob/passenger = get_passenger()
	if(isnull(passenger))
		return

	var/turf/location = get_turf(src)

	// Make some smoke for fanciness factor
	var/datum/effect/effect/system/smoke_spread/S = new/datum/effect/effect/system/smoke_spread()
	S.set_up(5, 0, location, null)
	S.start()

	passenger.forceMove(location)
	passenger.throw_at_random(FALSE, 2, 1)