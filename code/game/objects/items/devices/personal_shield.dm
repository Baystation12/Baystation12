/obj/item/device/personal_shield
	name = "personal shield"
	desc = "Truly a life-saver: this device protects its user from being hit by objects moving very, very fast, as long as it holds a charge."
	icon = 'icons/obj/batterer.dmi'
	icon_state = "battereroff"
	slot_flags = SLOT_BELT
	var/open = FALSE
	var/obj/item/cell/power_cell = /obj/item/cell/high
	var/shield_type = /obj/aura/personal_shield/device
	var/shield_power_cost = 1000
	var/obj/aura/personal_shield/device/shield

	VAR_PRIVATE/currently_stored_power = 0
	VAR_PRIVATE/max_stored_power = 3000
	VAR_PRIVATE/restored_power_per_tick = 5
	VAR_PRIVATE/enable_when_powered = FALSE

/obj/item/device/personal_shield/Initialize()
	. = ..()
	if(ispath(power_cell))
		power_cell = new power_cell(src)
		currently_stored_power = power_cell.use(max_stored_power)

/obj/item/device/personal_shield/Destroy()
	QDEL_NULL(shield)
	if(!ispath(power_cell))
		QDEL_NULL(power_cell)
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/device/personal_shield/Process(wait)
	if(!power_cell?.charge || currently_stored_power >= max_stored_power)
		return PROCESS_KILL
	var/amount_to_restore = min(restored_power_per_tick * wait, max_stored_power - currently_stored_power)
	currently_stored_power += power_cell.use(amount_to_restore)

	if(enable_when_powered && currently_stored_power >= shield_power_cost)
		turn_on(get_holder_of_type(src, /mob))

/obj/item/device/personal_shield/examine(mob/user, distance)
	. = ..()
	if(open)
		if(power_cell)
			to_chat(user, "There is \a [power_cell] in \the [src].")
		else
			to_chat(user, "There is no cell in \the [src].")
	to_chat(user, "The internal capacitor currently has [round(currently_stored_power/max_stored_power * 100)]% charge.")

/obj/item/device/personal_shield/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/cell))
		if(!open)
			to_chat(user, SPAN_WARNING("\The [src] needs to be open first."))
		else if(power_cell)
			to_chat(user, SPAN_WARNING("\The [src] already has a battery."))
		else if(user.unEquip(W, src))
			user.visible_message("\The [user] installs \the [W] into \the [src].", SPAN_NOTICE("You install \the [W] into \the [src]."))
			power_cell = W
			START_PROCESSING(SSobj, src)
			update_icon()
	if(isScrewdriver(W))
		playsound(src, 'sound/items/Screwdriver.ogg', 15, 1)
		user.visible_message("\The [user] [open ? "screws" : "unscrews"] the top of \the [src].", SPAN_NOTICE("You [open ? "screw" : "unscrew"] the top of \the [src]."))
		open = !open
		update_icon()

/obj/item/device/personal_shield/attack_self(var/mob/living/user)
	if (open && power_cell)
		user.visible_message("\The [user] shakes \the [power_cell] out of \the [src].", SPAN_NOTICE("You shake \the [power_cell] out of \the [src]."))
		turn_off()
		power_cell.dropInto(user.loc)
		on_remove_cell()
	else
		toggle(user)

/obj/item/device/personal_shield/attack_hand(var/mob/living/user)
	if(open && (loc == user))
		if(power_cell)
			user.visible_message("\The [user] removes \the [power_cell] from \the [src].", SPAN_NOTICE("You remove \the [power_cell] from \the [src]."))
			turn_off()
			user.put_in_active_hand(power_cell)
			on_remove_cell()
		else
			to_chat(user, SPAN_WARNING("There's no battery in \the [src]."))
	else . = ..()

/obj/item/device/personal_shield/proc/on_remove_cell()
	power_cell = null
	currently_stored_power = 0
	enable_when_powered = FALSE
	update_icon()

/obj/item/device/personal_shield/dropped(var/mob/user)
	turn_off()
	. = ..()

/obj/item/device/personal_shield/equipped(var/mob/user, var/slot)
	if(slot != slot_belt && slot != slot_l_hand && slot != slot_r_hand)
		turn_off()
	. = ..()

/obj/item/device/personal_shield/emp_act(severity)
	if(power_cell)
		power_cell.emp_act(severity)
		if(shield)
			visible_message(SPAN_DANGER("\The [src] explodes!"))
			explosion(src, -1, -1, 1, 2)
			qdel(src)
	else
		..()


/obj/item/device/personal_shield/proc/turn_on(var/mob/user)
	enable_when_powered = FALSE
	if(shield || open || !user)
		return
	if(!power_cell)
		to_chat(user, SPAN_WARNING("\The [src] doesn't have a power supply."))
		return
	if(currently_stored_power < shield_power_cost)
		to_chat(user, SPAN_WARNING("\The [src]'s internal capacitor does not have enough charge."))
		return
	shield = new shield_type(user, src)
	update_name()
	update_icon()

/obj/item/device/personal_shield/proc/turn_off(var/mob/user)
	if(!shield)
		return
	QDEL_NULL(shield)
	update_name()
	update_icon()

/obj/item/device/personal_shield/proc/toggle(var/mob/user)
	if(shield)
		turn_off(user)
	else
		turn_on(user)

/obj/item/device/personal_shield/AltClick(mob/user)
	if (loc == user)
		toggle(user)
	else
		. = ..()

/obj/item/device/personal_shield/proc/take_charge()
	if(!actual_take_charge())
		turn_off()
		return FALSE
	return TRUE

/obj/item/device/personal_shield/proc/actual_take_charge()
	if(!power_cell)
		return FALSE
	if(currently_stored_power < shield_power_cost)
		return FALSE

	currently_stored_power -= shield_power_cost
	START_PROCESSING(SSobj, src)

	if(currently_stored_power < shield_power_cost)
		enable_when_powered = TRUE
		return FALSE
	return TRUE

/obj/item/device/personal_shield/on_update_icon()
	..()
	if(shield)
		icon_state = "batterer"
	else
		if(open)
			icon_state = "battereropen[power_cell ? "full" : "empty"]"
		else
			icon_state = "battereroff"

/obj/item/device/personal_shield/proc/update_name()
	if(shield)
		SetName("activated [initial(name)]")
	else
		SetName(initial(name))
