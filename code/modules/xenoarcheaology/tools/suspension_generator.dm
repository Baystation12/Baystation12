/obj/machinery/suspension_gen
	name = "suspension field generator"
	desc = "It has stubby legs bolted up against it's body for stabilising."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "suspension2"
	density = 1
	req_access = list(access_research)
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	active_power_usage = 5 KILOWATTS
	var/obj/item/weapon/card/id/auth_card
	var/locked = 1
	var/obj/effect/suspension_field/suspension_field

/obj/machinery/suspension_gen/Process()
	if(suspension_field)
		if(stat & NOPOWER)
			deactivate()
			return

		var/turf/T = get_turf(suspension_field)
		var/victims = 0
		for(var/mob/living/M in T)
			M.weakened = max(M.weakened, 3)
			victims++
			if(prob(5))
				to_chat(M, "<span class='warning'>[pick("You feel tingly","You feel like floating","It is hard to speak","You can barely move")].</span>")
		if(victims)
			use_power_oneoff(active_power_usage * victims)

		for(var/obj/item/I in T)
			if(!suspension_field.contents.len)
				suspension_field.icon_state = "energynet"
				suspension_field.overlays += "shield2"
			I.forceMove(suspension_field)

/obj/machinery/suspension_gen/interact(var/mob/user)
	var/dat = "<b>Multi-phase mobile suspension field generator MK II \"Steadfast\"</b><br>"
	var/obj/item/weapon/cell/cell = get_cell()
	if(cell)
		var/colour = "red"
		var/percent = cell.percent()
		if(percent > 66)
			colour = "green"
		else if(percent > 33)
			colour = "orange"
		dat += "<b>Energy cell</b>: <font color='[colour]'>[percent]%</font><br>"
	else
		dat += "<b>Energy cell</b>: None<br>"
	if(auth_card)
		dat += "<A href='?src=\ref[src];ejectcard=1'>\[[auth_card]\]<a><br>"
		if(!locked)
			dat += "<b><A href='?src=\ref[src];toggle_field=1'>[suspension_field ? "Disable" : "Enable"] field</a></b><br>"
		else
			dat += "<br>"
	else
		dat += "<A href='?src=\ref[src];insertcard=1'>\[------\]<a><br>"
		if(!locked)
			dat += "<b><A href='?src=\ref[src];toggle_field=1'>[suspension_field ? "Disable" : "Enable"] field</a></b><br>"
		else
			dat += "Enter your ID to begin.<br>"

	dat += "<hr>"
	dat += "<hr>"
	dat += "<font color='blue'><b>Always wear safety gear and consult a field manual before operation.</b></font><br>"
	if(!locked)
		dat += "<A href='?src=\ref[src];lock=1'>Lock console</A><br>"
	else
		dat += "<br>"
	dat += "<A href='?src=\ref[src];refresh=1'>Refresh console</A><br>"
	dat += "<A href='?src=\ref[src];close=1'>Close console</A>"
	show_browser(user, dat, "window=suspension;size=500x400")
	onclose(user, "suspension")

/obj/machinery/suspension_gen/OnTopic(var/mob/user, href_list)
	if(href_list["toggle_field"])
		if(!suspension_field)
			var/obj/item/weapon/cell/cell = get_cell()
			if(cell.charge > 0)
				if(anchored)
					activate()
				else
					to_chat(user, "<span class='warning'>You are unable to activate [src] until it is properly secured on the ground.</span>")
		else
			deactivate()
		. = TOPIC_REFRESH
	else if(href_list["insertcard"])
		var/obj/item/I = user.get_active_hand()
		if (istype(I, /obj/item/weapon/card))
			if(!user.unEquip(I, src))
				return
			auth_card = I
			if(attempt_unlock(I, user))
				to_chat(user, "<span class='info'>You insert [I], the console flashes \'<i>Access granted.</i>\'</span>")
			else
				to_chat(user, "<span class='warning'>You insert [I], the console flashes \'<i>Access denied.</i>\'</span>")
		. = TOPIC_REFRESH
	else if(href_list["ejectcard"])
		if(auth_card)
			if(ishuman(user))
				user.put_in_hands(auth_card)
				auth_card = null
			else
				auth_card.forceMove(loc)
				auth_card = null
		. = TOPIC_REFRESH
	else if(href_list["lock"])
		locked = 1
		. = TOPIC_REFRESH
	else if(href_list["close"])
		close_browser(user, "window=suspension")
		return TOPIC_HANDLED

	if(. == TOPIC_REFRESH)
		interact(user)

/obj/machinery/suspension_gen/interface_interact(var/mob/user)
	interact(user)
	return TRUE

/obj/machinery/suspension_gen/components_are_accessible(path)
	return !locked && !suspension_field && ..()

/obj/machinery/suspension_gen/cannot_transition_to(state_path)
	if(locked)
		return SPAN_NOTICE("Unlock \the [src] first.")
	if(suspension_field)
		return SPAN_NOTICE("Turn \the [src] off first.")
	return ..()

/obj/machinery/suspension_gen/attackby(obj/item/weapon/W, mob/user)
	if(component_attackby(W, user))
		return TRUE
	else if(isWrench(W))
		if(!suspension_field)
			if(anchored)
				anchored = 0
			else
				anchored = 1
			to_chat(user, "<span class='info'>You wrench the stabilising legs [anchored ? "into place" : "up against the body"].</span>")
			if(anchored)
				desc = "It is resting securely on four stubby legs."
			else
				desc = "It has stubby legs bolted up against it's body for stabilising."
		else
			to_chat(user, "<span class='warning'>You are unable to secure [src] while it is active!</span>")
	else if(istype(W, /obj/item/weapon/card))
		var/obj/item/weapon/card/I = W
		if(!auth_card)
			if(attempt_unlock(I, user))
				to_chat(user, "<span class='info'>You swipe [I], the console flashes \'<i>Access granted.</i>\'</span>")
			else
				to_chat(user, "<span class='warning'>You swipe [I], console flashes \'<i>Access denied.</i>\'</span>")
		else
			to_chat(user, "<span class='warning'>Remove [auth_card] first.</span>")

/obj/machinery/suspension_gen/proc/attempt_unlock(var/obj/item/weapon/card/C, var/mob/user)
	if(!panel_open)
		if(istype(C, /obj/item/weapon/card/emag))
			C.resolve_attackby(src, user)
		else if(istype(C, /obj/item/weapon/card/id) && check_access(C))
			locked = 0
		if(!locked)
			return 1

/obj/machinery/suspension_gen/emag_act(var/remaining_charges, var/mob/user)
	if(locked)
		locked = 0
		req_access.Cut()
		return 1

//checks for whether the machine can be activated or not should already have occurred by this point
/obj/machinery/suspension_gen/proc/activate()
	var/turf/T = get_turf(get_step(src,dir))
	var/collected = 0

	for(var/mob/living/M in T)
		M.weakened += 5
		M.visible_message("<span class='notice'>\icon[M] [M] begins to float in the air!</span>","You feel tingly and light, but it is difficult to move.")

	suspension_field = new(T)
	src.visible_message("<span class='notice'>\icon[src] [src] activates with a low hum.</span>")
	icon_state = "suspension3"

	for(var/obj/item/I in T)
		I.forceMove(suspension_field)
		collected++

	if(collected)
		suspension_field.icon_state = "energynet"
		suspension_field.overlays += "shield2"
		src.visible_message("<span class='notice'>\icon[suspension_field] [suspension_field] gently absconds [collected > 1 ? "something" : "several things"].</span>")
	else
		if(istype(T,/turf/simulated/mineral) || istype(T,/turf/simulated/wall))
			suspension_field.icon_state = "shieldsparkles"
		else
			suspension_field.icon_state = "shield2"
	update_use_power(POWER_USE_ACTIVE)

/obj/machinery/suspension_gen/proc/deactivate()
	//drop anything we picked up
	var/turf/T = get_turf(suspension_field)

	for(var/mob/living/M in T)
		to_chat(M, "<span class='info'>You no longer feel like floating.</span>")
		M.weakened = min(M.weakened, 3)

	src.visible_message("<span class='notice'>\icon[src] [src] deactivates with a gentle shudder.</span>")
	qdel(suspension_field)
	suspension_field = null
	icon_state = "suspension2"
	update_use_power(POWER_USE_IDLE)

/obj/machinery/suspension_gen/Destroy()
	deactivate()
	return ..()

/obj/machinery/suspension_gen/verb/rotate_ccw()
	set src in view(1)
	set name = "Rotate suspension gen (counter-clockwise)"
	set category = "Object"

	if(anchored)
		to_chat(usr, "<span class='warning'>You cannot rotate [src], it has been firmly fixed to the floor.</span>")
	else
		set_dir(turn(dir, 90))

/obj/machinery/suspension_gen/verb/rotate_cw()
	set src in view(1)
	set name = "Rotate suspension gen (clockwise)"
	set category = "Object"

	if(anchored)
		to_chat(usr, "<span class='warning'>You cannot rotate [src], it has been firmly fixed to the floor.</span>")
	else
		set_dir(turn(dir, -90))

/obj/effect/suspension_field
	name = "energy field"
	icon = 'icons/effects/effects.dmi'
	anchored = 1
	density = 1

/obj/effect/suspension_field/Destroy()
	for(var/atom/movable/I in src)
		I.dropInto(loc)
	return ..()
