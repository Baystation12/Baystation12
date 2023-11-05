/obj/machinery/suspension_gen
	name = "suspension field generator"
	desc = "It has stubby bolts bolted up against its tracks for stabilizing."
	icon = 'icons/obj/machines/research/suspension_generator.dmi'
	icon_state = "suspension"
	density = TRUE
	construct_state = /singleton/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	active_power_usage = 5 KILOWATTS
	machine_name = "suspension generator"
	machine_desc = "Projects a pacifying energy field, used to hold xenofauna (among other things) for safe study."
	var/obj/suspension_field/suspension_field
	obj_flags = OBJ_FLAG_ANCHORABLE

/obj/machinery/suspension_gen/Process()
	if(suspension_field)
		updateDialog()
		if(!is_powered())
			deactivate()
			return

		var/turf/T = get_turf(suspension_field)
		var/victims = 0
		for(var/mob/living/M in T)
			M.weakened = max(M.weakened, 3)
			victims++
			if(prob(5))
				to_chat(M, SPAN_WARNING("[pick("You feel tingly","You feel like floating","It is hard to speak","You can barely move")]."))
		if(victims)
			use_power_oneoff(active_power_usage * victims)

		for(var/obj/item/I in T)
			if(!length(suspension_field.contents))
				suspension_field.icon_state = "energynet"
				suspension_field.AddOverlays("shield2")
			I.forceMove(suspension_field)

/obj/machinery/suspension_gen/interact(mob/user)
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
		dat += "<b>Energy cell</b>: [SPAN_COLOR("[colour]", "[percent]%")]<br>"
	else
		dat += "<b>Energy cell</b>: None<br>"
	dat += "<b><A href='?src=\ref[src];toggle_field=1'>[suspension_field ? "Disable" : "Enable"] field</a></b><br>"
	dat += "<hr>"
	dat += "<hr>"
	dat += "[SPAN_COLOR("cyan", "<b>Always wear safety gear and consult a field manual before operation.</b>")]<br>"
	dat += "<A href='?src=\ref[src];close=1'>Close console</A>"
	var/datum/browser/popup = new(user, "suspension", "Suspension Generator", 500, 400)
	popup.set_content(dat)
	popup.open()
	onclose(user, "suspension")

/obj/machinery/suspension_gen/OnTopic(mob/user, href_list)
	if(href_list["toggle_field"])
		if(!suspension_field)
			var/obj/item/cell/cell = get_cell()
			if(cell.charge > 0)
				if(anchored)
					activate()
				else
					to_chat(user, SPAN_WARNING("You are unable to activate [src] until it is properly secured on the ground."))
		else
			deactivate()
		. = TOPIC_REFRESH
	else if(href_list["close"])
		close_browser(user, "window=suspension")
		return TOPIC_HANDLED

	if(. == TOPIC_REFRESH)
		interact(user)

/obj/machinery/suspension_gen/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/suspension_gen/components_are_accessible(path)
	return !suspension_field && ..()

/obj/machinery/suspension_gen/cannot_transition_to(state_path)
	if(suspension_field)
		return SPAN_NOTICE("Turn \the [src] off first.")
	return ..()

/obj/machinery/suspension_gen/can_anchor(obj/item/tool, mob/user, silent)
	if (suspension_field)
		to_chat(user, SPAN_WARNING("You are unable to wrench \the [src] while it is active!"))
		return FALSE
	return ..()

/obj/machinery/suspension_gen/post_anchor_change()
	if (anchored)
		desc = "Its tracks are securely held in place with securing bolts."
		icon_state = "suspension_wrenched"
	else
		desc = "It has stubby bolts bolted up against its tracks for stabilizing."
		icon_state = "suspension"
	..()

//checks for whether the machine can be activated or not should already have occurred by this point
/obj/machinery/suspension_gen/proc/activate()
	var/turf/T = get_turf(get_step(src,dir))
	var/collected = 0

	for(var/mob/living/M in T)
		M.weakened += 5
		M.visible_message(SPAN_NOTICE("[icon2html(M, viewers(get_turf(M)))] [M] begins to float in the air!"),"You feel tingly and light, but it is difficult to move.")

	suspension_field = new(T)
	src.visible_message(SPAN_NOTICE("[icon2html(src, viewers(get_turf(src)))] [src] activates with a low hum."))
	icon_state = "suspension_on"
	playsound(loc, 'sound/machines/quiet_beep.ogg', 40)
	update_icon()


	for(var/obj/item/I in T)
		I.forceMove(suspension_field)
		collected++

	if(collected)
		suspension_field.icon_state = "energynet"
		suspension_field.AddOverlays("shield2")
		src.visible_message(SPAN_NOTICE("[icon2html(suspension_field, viewers(get_turf(src)))] [suspension_field] gently absconds [collected > 1 ? "something" : "several things"]."))
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
		to_chat(M, SPAN_INFO("You no longer feel like floating."))
		M.weakened = min(M.weakened, 3)

	src.visible_message(SPAN_NOTICE("[icon2html(src, viewers(get_turf(src)))] [src] deactivates with a gentle shudder."))
	qdel(suspension_field)
	suspension_field = null
	icon_state = "suspension_wrenched"
	playsound(loc, 'sound/machines/quiet_beep.ogg', 40)
	update_use_power(POWER_USE_IDLE)
	update_icon()

/obj/machinery/suspension_gen/Destroy()
	deactivate()
	return ..()

/obj/machinery/suspension_gen/verb/rotate_ccw()
	set src in view(1)
	set name = "Rotate suspension gen (counter-clockwise)"
	set category = "Object"

	if(anchored)
		to_chat(usr, SPAN_WARNING("You cannot rotate [src], it has been firmly fixed to the floor."))
	else
		set_dir(turn(dir, 90))

/obj/machinery/suspension_gen/verb/rotate_cw()
	set src in view(1)
	set name = "Rotate suspension gen (clockwise)"
	set category = "Object"

	if(anchored)
		to_chat(usr, SPAN_WARNING("You cannot rotate [src], it has been firmly fixed to the floor."))
	else
		set_dir(turn(dir, -90))

/obj/machinery/suspension_gen/on_update_icon()
	ClearOverlays()
	if(panel_open)
		AddOverlays("suspension_panel")
	. = ..()

/obj/suspension_field
	name = "energy field"
	icon = 'icons/effects/effects.dmi'
	anchored = TRUE
	density = TRUE

/obj/suspension_field/Destroy()
	for(var/atom/movable/I in src)
		I.dropInto(loc)
	return ..()
