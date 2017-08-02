/obj/structure/closet/secure_closet
	name = "secure locker"
	desc = "It's a card-locked storage unit."
	icon = 'icons/obj/closet.dmi'
	icon_state = "secure1"
	density = 1
	opened = 0
	var/locked = 1
	var/broken = 0
	icon_closed = "secure"
	var/icon_locked = "secure1"
	icon_opened = "secureopen"
	var/icon_broken = "securebroken"
	var/icon_off = "secureoff"
	wall_mounted = 0 //never solid (You can always pass over it)
	health = 200

/obj/structure/closet/secure_closet/can_open()
	if(src.locked)
		return 0
	return ..()

/obj/structure/closet/secure_closet/close()
	if(..())
		if(broken)
			icon_state = src.icon_off
		return 1
	else
		return 0

/obj/structure/closet/secure_closet/emp_act(severity)
	for(var/obj/O in src)
		O.emp_act(severity)
	if(!broken)
		if(prob(50/severity))
			src.locked = !src.locked
			src.update_icon()
		if(prob(20/severity) && !opened)
			if(!locked)
				open()
			else
				src.req_access = list()
				src.req_access += pick(get_all_station_access())
	..()

/obj/structure/closet/secure_closet/proc/togglelock(mob/user as mob)
	if(!Adjacent(user))
		return
	if(src.opened)
		to_chat(user, "<span class='notice'>Close the locker first.</span>")
		return
	if(src.broken)
		to_chat(user, "<span class='warning'>The locker appears to be broken.</span>")
		return
	if(user.loc == src)
		to_chat(user, "<span class='notice'>You can't reach the lock from inside.</span>")
		return
	if(src.allowed(user))
		src.locked = !src.locked
		for(var/mob/O in viewers(user, 3))
			if((O.client && !( O.blinded )))
				to_chat(O, "<span class='notice'>The locker has been [locked ? null : "un"]locked by [user].</span>")
		update_icon()
	else
		to_chat(user, "<span class='notice'>Access Denied</span>")

/obj/structure/closet/secure_closet/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(src.opened || istype(W,/obj/item/weapon/packageWrap))
		..()
	else if(istype(W, /obj/item/weapon/melee/energy/blade))
		if(emag_act(INFINITY, user, "<span class='danger'>The locker has been sliced open by [user] with \an [W]</span>!", "<span class='danger'>You hear metal being sliced and sparks flying.</span>"))
			var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
			spark_system.set_up(5, 0, src.loc)
			spark_system.start()
			playsound(src.loc, 'sound/weapons/blade1.ogg', 50, 1)
			playsound(src.loc, "sparks", 50, 1)
	else
		togglelock(user)

/obj/structure/closet/secure_closet/AltClick(mob/user as mob)
	togglelock(user)

/obj/structure/closet/secure_closet/slice_into_parts(obj/item/weapon/weldingtool/WT, mob/user)
	to_chat(user, "<span class='notice'>\The [src] is too strong to be taken apart.</span>")
	return

/obj/structure/closet/secure_closet/emag_act(var/remaining_charges, var/mob/user, var/emag_source, var/visual_feedback = "", var/audible_feedback = "")
	if(!broken)
		broken = 1
		locked = 0
		desc = "It appears to be broken."
		icon_state = icon_off
		flick(icon_broken, src)

		if(visual_feedback)
			visible_message(visual_feedback, audible_feedback)
		else if(user && emag_source)
			visible_message("<span class='warning'>\The [src] has been broken by \the [user] with \an [emag_source]!</span>", "You hear a faint electrical spark.")
		else
			visible_message("<span class='warning'>\The [src] sparks and breaks open!</span>", "You hear a faint electrical spark.")
		return 1

/obj/structure/closet/secure_closet/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	if(src.locked)
		src.togglelock(user)
	else
		src.toggle(user)

/obj/structure/closet/secure_closet/verb/verb_togglelock()
	set src in oview(1) // One square distance
	set category = "Object"
	set name = "Toggle Lock"

	if(!usr.canmove || usr.stat || usr.restrained()) // Don't use it if you're not able to! Checks for stuns, ghost and restrain
		return

	if(ishuman(usr))
		src.add_fingerprint(usr)
		src.togglelock(usr)
	else
		to_chat(usr, "<span class='warning'>This mob type can't use this verb.</span>")

/obj/structure/closet/secure_closet/update_icon()//Putting the welded stuff in updateicon() so it's easy to overwrite for special cases (Fridges, cabinets, and whatnot)
	overlays.Cut()

	if(!opened)
		if(broken)
			icon_state = icon_off
		else if(locked)
			icon_state = icon_locked
		else
			icon_state = icon_closed
		if(welded)
			overlays += "welded"
	else
		icon_state = icon_opened

/obj/structure/closet/secure_closet/req_breakout()
	if(!opened && locked) return 1
	return ..() //It's a secure closet, but isn't locked.

/obj/structure/closet/secure_closet/break_open()
	desc += " It appears to be broken."
	broken = 1
	locked = 0
	..()
