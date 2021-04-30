/obj/machinery/suspension_gen
	name = "suspension field generator"
	desc = "It has stubby legs bolted up against it's body for stabilising."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "suspension2"
	density = TRUE
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	active_power_usage = 5 KILOWATTS
	machine_name = "suspension generator"
	machine_desc = "Projects a pacifying energy field, used to hold xenofauna (among other things) for safe study."
	var/obj/effect/suspension_field/suspension_field

/obj/machinery/suspension_gen/Process()
	if(suspension_field)
		updateDialog()
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
	user.set_machine(src)
	var/dat = "<b>Multi-phase mobile suspension field generator MK II \"Steadfast\"</b><br>"
	var/obj/item/cell/cell = get_cell()
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
	dat += "<b><A href='?src=\ref[src];toggle_field=1'>[suspension_field ? "Disable" : "Enable"] field</a></b><br>"
	dat += "<hr>"
	dat += "<hr>"
	dat += "<font style='color: cyan;'><b>Always wear safety gear and consult a field manual before operation.</b></font><br>"
	dat += "<A href='?src=\ref[src];close=1'>Close console</A>"
	var/datum/browser/popup = new(user, "suspension", "Suspension Generator", 500, 400)
	popup.set_content(dat)
	popup.open()
	onclose(user, "suspension")

/obj/machinery/suspension_gen/OnTopic(var/mob/user, href_list)
	if(href_list["toggle_field"])
		if(!suspension_field)
			var/obj/item/cell/cell = get_cell()
			if(cell.charge > 0)
				if(anchored)
					activate()
				else
					to_chat(user, "<span class='warning'>You are unable to activate [src] until it is properly secured on the ground.</span>")
		else
			deactivate()
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
	return !suspension_field && ..()

/obj/machinery/suspension_gen/cannot_transition_to(state_path)
	if(suspension_field)
		return SPAN_NOTICE("Turn \the [src] off first.")
	return ..()

/obj/machinery/suspension_gen/attackby(obj/item/W, mob/user)
	if(component_attackby(W, user))
		return TRUE
	else if(isWrench(W))
		if(!suspension_field)
			anchored = !anchored
			to_chat(user, "<span class='info'>You wrench the stabilising legs [anchored ? "into place" : "up against the body"].</span>")
			if(anchored)
				desc = "It is resting securely on four stubby legs."
			else
				desc = "It has stubby legs bolted up against it's body for stabilising."
		else
			to_chat(user, "<span class='warning'>You are unable to secure [src] while it is active!</span>")

//checks for whether the machine can be activated or not should already have occurred by this point
/obj/machinery/suspension_gen/proc/activate()
	var/turf/T = get_turf(get_step(src,dir))
	var/collected = 0

	for(var/mob/living/M in T)
		M.weakened += 5
		M.visible_message("<span class='notice'>[icon2html(M, viewers(get_turf(M)))] [M] begins to float in the air!</span>","You feel tingly and light, but it is difficult to move.")

	suspension_field = new(T)
	src.visible_message("<span class='notice'>[icon2html(src, viewers(get_turf(src)))] [src] activates with a low hum.</span>")
	icon_state = "suspension3"

	for(var/obj/item/I in T)
		I.forceMove(suspension_field)
		collected++

	if(collected)
		suspension_field.icon_state = "energynet"
		suspension_field.overlays += "shield2"
		src.visible_message("<span class='notice'>[icon2html(suspension_field, viewers(get_turf(src)))] [suspension_field] gently absconds [collected > 1 ? "something" : "several things"].</span>")
	else
		if(istype(T,/turf/simulated/mineral) || istype(T,/turf/simulated/wall))
			suspension_field.icon_state = "shieldsparkles"
		else
			suspension_field.icon_state = "shield2"
	update_use_power(POWER_USE_ACTIVE)

/obj/machinery/suspension_gen/proc/deactivate()
	set waitfor = FALSE
	//drop anything we picked up
	var/turf/T = get_turf(suspension_field)

	for(var/mob/living/M in T)
		to_chat(M, "<span class='info'>You no longer feel like floating.</span>")
		M.weakened = min(M.weakened, 3)

	src.visible_message("<span class='notice'>[icon2html(src, viewers(get_turf(src)))] [src] deactivates with a gentle shudder.</span>")
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
	anchored = TRUE
	density = TRUE

/obj/effect/suspension_field/Destroy()
	for(var/atom/movable/I in src)
		I.dropInto(loc)
	return ..()
