/obj/item/device/radio/beacon
	name = "tracking beacon"
	desc = "A beacon used by a teleporter."
	icon_state = "beacon"
	item_state = "signaler"
	origin_tech = list(TECH_BLUESPACE = 1)

	var/code = "electronic"
	var/functioning = TRUE

/obj/item/device/radio/beacon/hear_talk()
	return

/obj/item/device/radio/beacon/send_hear()
	return null

/obj/item/device/radio/beacon/emp_act(severity)
	if(functioning && severity >= 1)
		fry()
	..()

/obj/item/device/radio/beacon/emag_act(remaining_charges, user, emag_source)
	if(functioning)
		fry()

/obj/item/device/radio/beacon/proc/fry()
	functioning = FALSE
	visible_message(SPAN_WARNING("\The [src] pops and cracks, and a thin wisp of dark smoke rises from the vents."), range = 2)
	update_icon()
	for(var/obj/machinery/computer/teleporter/T in SSmachines.machinery)
		if(T.locked == src)
			T.target_lost()

/obj/item/device/radio/beacon/on_update_icon()
	if(!functioning)
		icon_state = "[initial(icon_state)]_dead"
	else
		icon_state = "[initial(icon_state)]"

/obj/item/device/radio/beacon/verb/alter_signal(newcode as text)
	set name = "Alter Beacon's Signal"
	set category = "Object"
	set src in usr

	var/mob/user = usr
	if (!user.incapacitated())
		code = newcode
		add_fingerprint(user)

/obj/item/device/radio/beacon/anchored
	icon_state = "floor_beacon"
	anchored = TRUE
	w_class = ITEM_SIZE_HUGE
	randpixel = 0
	
	var/repair_fail_chance = 35

/obj/item/device/radio/beacon/anchored/Initialize()
	. = ..()
	var/turf/T = get_turf(src)
	hide(hides_under_flooring() && !T.is_plating())

/obj/item/device/radio/beacon/anchored/attackby(obj/item/I, mob/living/user)
	..()
	if(istype(I, /obj/item/stack/nanopaste))
		var/obj/item/stack/nanopaste/S = I
		if(b_stat)
			if(S.use(1))
				to_chat(user, SPAN_NOTICE("You pour some of \the [S] over \the [src]'s circuitry."))
				if(prob(repair_fail_chance))
					flick("[initial(icon_state)]", src)
					visible_message(SPAN_WARNING("The [src]'s lights come back on briefly, then die out again."), range = 2)
				else
					visible_message(SPAN_NOTICE("\The [src]'s lights come back on."), range = 2)
					functioning = TRUE
					repair_fail_chance += pick(5, 10, 10, 15)
					update_icon()
			else
				to_chat(user, SPAN_WARNING("There's not enough of \the [S] left to fix \the [src]."))
		else
			to_chat(user, SPAN_WARNING("You can't work on \the [src] until its been opened up."))