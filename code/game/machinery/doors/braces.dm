// KEYCARD - Can be paired with a brace to instantly unlock it.
/obj/item/weapon/brace_keycard
	name = "brace keycard"
	desc = "A small keycard that seems to fit into an airlock brace's card slot."
	w_class = 2
	var/obj/item/weapon/airlock_brace/brace = null
	icon = 'icons/obj/card.dmi'
	icon_state = "guest_invalid"




// MAINTENANCE JACK - Acts as an universal keycard, but works with a 15-30s delay
/obj/item/weapon/crowbar/brace_jack
	name = "maintenance jack"
	desc = "A special crowbar that can be used to safely remove airlock braces from airlocks."
	w_class = 3
	icon = 'icons/obj/items.dmi'
	icon_state = "maintenance_jack"
	force = 8 //It has a hammer head, should probably do some more damage. - Cirra
	throwforce = 10




// BRACE - Can be installed on airlock to reinforce it and keep it closed.
/obj/item/weapon/airlock_brace
	name = "airlock brace"
	desc = "A sturdy device that can be attached to an airlock to reinforce it and provide additional security."
	w_class = 4
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "brace_open"
	var/cur_health
	var/max_health = 450
	var/obj/machinery/door/airlock/airlock = null
	var/list/keycards = list()


/obj/item/weapon/airlock_brace/examine(var/mob/user)
	..()
	user << examine_health()


// This is also called from airlock's examine, so it's a different proc to prevent code copypaste.
/obj/item/weapon/airlock_brace/proc/examine_health()
	switch(health_percentage())
		if(-100 to 25)
			return "<span class='danger'>\The [src] looks seriously damaged, and probably won't last much more.</span>"
		if(25 to 50)
			return "<span class='notice'>\The [src] looks damaged.</span>"
		if(50 to 75)
			return "\The [src] looks slightly damaged."
		if(75 to 99)
			return "\The [src] has few dents."
		if(99 to INFINITY)
			return "\The [src] is in excellent condition."


/obj/item/weapon/airlock_brace/update_icon()
	if(airlock)
		icon_state = "brace_closed"
	else
		icon_state = "brace_open"


/obj/item/weapon/airlock_brace/New()
	..()
	cur_health = max_health


/obj/item/weapon/airlock_brace/Destroy()
	for(var/obj/item/weapon/brace_keycard/C in keycards)
		C.brace = null
		keycards.Remove(C)
	keycards = null
	if(airlock)
		airlock.brace = null
		airlock = null
	..()


/obj/item/weapon/airlock_brace/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if (istype(W, /obj/item/weapon/brace_keycard))
		var/obj/item/weapon/brace_keycard/C = W
		if(!airlock)
			C.brace = src
			keycards |= C
			user << "You swipe \the [C] through \the [src]. A small green light blinks on \the [C]."
		else
			if(C.brace == src)
				user << "You swipe \the [C] through \the [src]."
				if(do_after(user, 10, airlock))
					user << "\The [src] clicks few times and detaches itself from \the [airlock]!"
					unlock_brace(usr)
			else
				user << "You swipe \the [C] through \the [src], but it does not react."
		return

	if (istype(W, /obj/item/weapon/crowbar/brace_jack))
		if(!airlock)
			return
		var/obj/item/weapon/crowbar/brace_jack/C = W
		user << "You begin forcibly removing \the [src] with \the [C]."
		if(do_after(user, rand(150,300), airlock))
			user << "You finish removing \the [src]."
			unlock_brace(user)
		return

	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/C = W
		if(cur_health == max_health)
			user << "\The [src] does not require repairs."
			return
		if(C.remove_fuel(0,user))
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			cur_health = min(cur_health + rand(80,120), max_health)
			if(cur_health == max_health)
				user << "You repair some dents on \the [src]. It is in perfect condition now."
			else
				user << "You repair some dents on \the [src]."


/obj/item/weapon/airlock_brace/proc/take_damage(var/amount)
	cur_health = between(0, cur_health - amount, max_health)
	if(!cur_health)
		if(airlock)
			airlock.visible_message("<span class='danger'>\The [src] breaks off of \the [airlock]!</span>")
		unlock_brace(null)
		qdel(src)


/obj/item/weapon/airlock_brace/proc/unlock_brace(var/mob/user)
	if(!airlock)
		return
	if(user)
		user.put_in_hands(src)
		airlock.visible_message("\The [user] removes \the [src] from \the [airlock]!")
	else
		forceMove(get_turf(src))
	airlock.brace = null
	airlock.update_icon()
	airlock = null
	update_icon()


/obj/item/weapon/airlock_brace/proc/health_percentage()
	if(!max_health)
		return 0
	return (cur_health / max_health) * 100