/obj/vehicle/powered
	name = "powered vehicle"

	var/on = FALSE
	var/open = FALSE // Maintenance panel
	var/locked = TRUE
	var/emagged = FALSE
	var/powered = FALSE //set if vehicle is powered and should use fuel when moving

	var/obj/item/weapon/cell/cell
	var/charge_use = 200


/obj/vehicle/powered/Move()
	if(on && powered && cell.charge < (charge_use * CELLRATE))
		turn_off()
		return FALSE

	. = ..()

	if (. && on && powered)
		cell.use(charge_use * CELLRATE)


/obj/vehicle/powered/attackby(obj/item/weapon/W, mob/user)
	if (isScrewdriver(W))
		if (locked)
			to_chat(user, SPAN_WARNING("\The [src]'s maintenance panel is locked and cannot be opened."))
			return
		open = !open
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] [open ? "opens" : "closes"] \the [src]'s maintenance panel with \the [W]."),
			SPAN_NOTICE("You [open ? "open" : "close"] \the [src]'s maintenance panel with \the [W].")
		)
		return

	if (isCrowbar(W))
		if (!open)
			to_chat(user, SPAN_WARNING("\The [src]'s maintenance panel is closed."))
			return
		if (!cell)
			to_chat(user, SPAN_WARNING("\The [src] does not have a power cell to remove."))
			return
		user.visible_message(
			SPAN_NOTICE("\The [user] pries \the [cell] out of \the [src] with \the [W]."),
			SPAN_NOTICE("You pry \the [cell] out of \the [src] with \the [W]."),
		)
		remove_cell(user)
		return

	if (isWelder(W))
		if (!open)
			to_chat(user, SPAN_WARNING("\The [src]'s maintenance panel must be open to perform repairs."))
			return
		..() // Welding stuff is handled in parent
		return

	if (istype(W, /obj/item/weapon/cell))
		if (!open)
			to_chat(user, SPAN_WARNING("\The [src]'s maintenance panel is closed."))
			return
		if (cell)
			to_chat(user, SPAN_WARNING("\The [src] already has \a [cell] installed."))
			return
		user.visible_message(
			SPAN_NOTICE("\The [user] inserts \the [W] into \the [src]."),
			SPAN_NOTICE("You insert \the [W] into \the [src].")
		)
		insert_cell(W, user)
		return

	..()


/obj/vehicle/powered/emp_act(severity)
	var/was_on = on
	stat |= EMPED
	var/obj/effect/overlay/pulse2 = new /obj/effect/overlay(loc)
	pulse2.icon = 'icons/effects/effects.dmi'
	pulse2.icon_state = "empdisable"
	pulse2.SetName("emp sparks")
	pulse2.anchored = 1
	pulse2.set_dir(pick(GLOB.cardinal))

	spawn(10)
		qdel(pulse2)

	if (on)
		turn_off()

	spawn(severity * 300)
		stat &= ~EMPED
		if (was_on)
			turn_on()


/obj/vehicle/powered/emag_act(var/remaining_charges, mob/user as mob)
	if (emagged)
		to_chat(user, SPAN_WARNING("\The [src] has already been bypassed."))
		return FALSE

	emagged = TRUE
	locked = FALSE
	to_chat(user, SPAN_WARNING("You bypass \the [src]'s controls."))

	return TRUE


/obj/vehicle/powered/explode()
	if (cell)
		if (prob(50))
			qdel(cell)
		else
			var/turf/T = get_turf(src)
			cell.forceMove(T)
			cell.update_icon()
		cell = null

	..()


/obj/vehicle/powered/proc/turn_on()
	if(stat)
		return FALSE
	if(powered && cell.charge < (charge_use * CELLRATE))
		return FALSE
	on = TRUE
	set_light(0.8, 1, 5)
	update_icon()
	visible_message(SPAN_NOTICE("\The [src] hums softly as it powers on."))
	return TRUE


/obj/vehicle/powered/proc/turn_off()
	on = FALSE
	set_light(0)
	update_icon()
	visible_message(SPAN_NOTICE("\The [src] grows quiet as it powers down."))


/obj/vehicle/powered/proc/powercheck()
	if (!cell && !powered)
		return

	if (!cell && powered)
		turn_off()
		return

	if (cell.charge < (charge_use * CELLRATE))
		turn_off()
		return

	if (cell && powered)
		turn_on()
		return


/obj/vehicle/powered/proc/insert_cell(obj/item/weapon/cell/C, mob/living/carbon/human/H)
	if (cell)
		return
	if (!istype(C))
		return
	if (!H.unEquip(C, src))
		return
	cell = C
	powercheck()


/obj/vehicle/powered/proc/remove_cell(mob/living/carbon/human/H)
	if (!cell)
		return
	H.put_in_hands(cell)
	cell = null
	powercheck()


/obj/vehicle/powered/RunOver(mob/M)
	if (emagged)
		// TODO Damage stuff here
