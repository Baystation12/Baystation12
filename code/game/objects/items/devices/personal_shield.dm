/obj/item/device/personal_shield
	name = "personal shield"
	desc = "Truly a life-saver: this device protects its user from being hit by objects moving very, very fast, as long as it holds a charge."
	icon = 'icons/obj/device.dmi'
	icon_state = "battereroff"
	slot_flags = SLOT_BELT
	var/open = FALSE
	var/obj/item/weapon/cell/power = /obj/item/weapon/cell
	var/shield_type = /obj/aura/personal_shield/device
	var/shield_power_cost = 1000
	var/obj/aura/personal_shield/device/shield

/obj/item/device/personal_shield/Initialize()
	. = ..()
	if(ispath(power))
		power = new power(src)

/obj/item/device/personal_shield/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/weapon/cell))
		if(!open)
			to_chat(user, SPAN_WARNING("\The [src] needs to be open first."))
		else if(power)
			to_chat(user, SPAN_WARNING("\The [src] already has a battery."))
		else if(user.unEquip(W, src))
			user.visible_message("\The [user] installs \the [W] into \the [src].")
			power = W
			update_icon()
	if(isScrewdriver(W))
		playsound(src, 'sound/items/Screwdriver.ogg', 15, 1)
		user.visible_message("\The [user] [open ? "screws" : "unscrews"] the top to \the [src].")
		open = !open
		update_icon()

/obj/item/device/personal_shield/attack_self(var/mob/living/user)
	if(open)
		if(power)
			to_chat(user, SPAN_NOTICE("You remove \the [power] from \the [src]"))
			user.put_in_hands(power)
			power = null
			update_icon()
		else
			to_chat(user, SPAN_WARNING("There's no battery in \the [src]."))
	else
		toggle(user)

/obj/item/device/personal_shield/dropped(var/mob/user)
	turn_off()
	. = ..()

/obj/item/device/personal_shield/equipped(var/mob/user, var/slot)
	if(slot != slot_belt && slot != slot_l_hand && slot != slot_r_hand)
		turn_off()
	. = ..()

/obj/item/device/personal_shield/emp_act(severity)
	if(power)
		var/turf/T = get_turf(src)
		power.emp_act(severity)
		if(shield)
			visible_message(SPAN_DANGER("\The [src] explodes!"))
			power.forceMove(T)
			explosion(T, -1, -1, 1, 2)
			qdel(src)
	else
		..()


/obj/item/device/personal_shield/proc/turn_on(var/mob/user)
	if(shield || open)
		return
	if(!power)
		to_chat(user, SPAN_WARNING("\The [src] doesn't have a power supply."))
		return
	shield = new shield_type(user, src)
	update_icon()

/obj/item/device/personal_shield/proc/turn_off(var/mob/user)
	if(!shield)
		return
	QDEL_NULL(shield)
	update_icon()

/obj/item/device/personal_shield/proc/toggle(var/mob/user)
	if(shield)
		turn_off(user)
	else
		turn_on(user)

/obj/item/device/personal_shield/proc/take_charge()
	if(!actual_take_charge())
		turn_off()
		return FALSE
	return TRUE

/obj/item/device/personal_shield/proc/actual_take_charge()
	if(!power)
		return FALSE
	return power.checked_use(shield_power_cost)

/obj/item/device/personal_shield/on_update_icon()
	..()
	if(shield)
		icon_state = "batterer"
	else
		if(open)
			icon_state = "battereropen[power ? "full" : "empty"]"
		else
			icon_state = "battereroff"

/obj/item/device/personal_shield/Destroy()
	QDEL_NULL(shield)
	return ..()
