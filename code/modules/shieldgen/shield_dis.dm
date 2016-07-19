/obj/item/device/shield_disrupter
	name = "shield disrupter"
	desc = "It temporarily reverses the polarity of shield bubbles."
	icon_state = "shield1"
	var/recharging = FALSE
	var/static/icon/flick_icon

/obj/item/device/shield_disrupter/attack_self(var/mob/user)
	if(recharging)
		user << "<span class='warning'>\The [src] is still recharging.</span>"
		return
	playsound(src, 'sound/effects/EMPulse.ogg', 50)
	disrupt_shields()
	recharging = TRUE
	update_icon()
	spawn(30 SECONDS)
		recharging = FALSE
		update_icon()

/obj/item/device/shield_disrupter/update_icon(var/mob/user)
	if(recharging)
		icon_state = "shield0"
	else
		icon_state = initial(icon_state)

#define GET_DIST(A) max(1, get_dist(T, A))
/obj/item/device/shield_disrupter/proc/disrupt_shields()
	var/turf/T = get_turf(src)
	for(var/obj/O in range(3, T))
		var/do_flick = FALSE
		if(istype(O, /obj/effect/energy_field))
			var/obj/effect/energy_field/ef = O
			var/distance = GET_DIST(ef)
			var/stress = ef.strength/(distance**2)
			ef.Stress(stress)
			if(distance > 1) // A distance less than or equal to 1 always destroys the shield, no need to flick then
				do_flick = TRUE
		else if(istype(O, /obj/machinery/shieldwall))
			var/obj/machinery/shieldwall/sw = O
			sw.ex_act(GET_DIST(sw))
			do_flick = TRUE

		if(do_flick)
			if(!flick_icon)
				flick_icon = icon('icons/effects/effects.dmi',"at_shield2")
			flick(flick_icon, O)
#undef GET_DIST
