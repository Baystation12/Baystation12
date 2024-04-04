/obj/machinery/shield
	name = "emergency energy shield"
	desc = "An energy shield used to contain hull breaches."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield-old"
	density = TRUE
	opacity = 0
	anchored = TRUE
	unacidable = TRUE
	health_max = 200
	damage_hitsound = 'sound/effects/EMPulse.ogg'
	var/shield_generate_power = 7500	//how much power we use when regenerating
	var/shield_idle_power = 1500		//how much power we use when just being sustained.

/obj/machinery/shield/malfai
	name = "emergency forcefield"
	desc = "A weak forcefield which seems to be projected by the emergency atmosphere containment field."
	health_max = 100 // Half health, it's not suposed to resist much.

/obj/machinery/shield/malfai/Process()
	damage_health(1) // Slowly lose integrity over time

/obj/machinery/shield/New()
	src.set_dir(pick(1,2,3,4))
	..()
	update_nearby_tiles(need_rebuild=1)

/obj/machinery/shield/Destroy()
	set_opacity(0)
	set_density(0)
	update_nearby_tiles()
	..()

/obj/machinery/shield/CanPass(atom/movable/mover, turf/target, height, air_group)
	if(!height || air_group) return 0
	else return ..()

/obj/machinery/shield/post_health_change(health_mod, prior_health, damage_type)
	. = ..()
	if (health_dead())
		return
	if (health_mod < -1) // To prevent slow degradation proccing this constantly
		set_opacity(TRUE)
		addtimer(new Callback(src, /atom/proc/set_opacity, FALSE), 2 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)

/obj/machinery/shield/on_death()
	visible_message(SPAN_NOTICE("\The [src] dissipates!"))
	qdel(src)

/obj/machinery/shieldgen
	name = "emergency shield projector"
	desc = "Used to seal minor hull breaches."
	icon = 'icons/obj/machines/shield_generator.dmi'
	icon_state = "shieldoff"
	density = TRUE
	opacity = 0
	anchored = FALSE
	req_access = list(access_engine)
	health_max = 100
	var/active = 0
	var/malfunction = 0 //Malfunction causes parts of the shield to slowly dissapate
	var/list/deployed_shields = list()
	var/list/regenerating = list()
	var/is_open = 0 //Whether or not the wires are exposed
	var/locked = 0
	var/check_delay = 60	//periodically recheck if we need to rebuild a shield
	use_power = POWER_USE_OFF
	idle_power_usage = 0
	obj_flags = OBJ_FLAG_ANCHORABLE

/obj/machinery/shieldgen/Destroy()
	collapse_shields()
	..()

/obj/machinery/shieldgen/proc/shields_up()
	if(active) return 0 //If it's already turned on, how did this get called?

	src.active = 1
	update_icon()

	create_shields()

	var/new_idle_power_usage = 0
	for(var/obj/machinery/shield/shield_tile in deployed_shields)
		new_idle_power_usage += shield_tile.shield_idle_power
	change_power_consumption(new_idle_power_usage, POWER_USE_IDLE)
	update_use_power(POWER_USE_IDLE)

/obj/machinery/shieldgen/proc/shields_down()
	if(!active) return 0 //If it's already off, how did this get called?

	src.active = 0
	update_icon()

	collapse_shields()

	update_use_power(POWER_USE_OFF)

/obj/machinery/shieldgen/proc/create_shields()
	for(var/turf/target_tile in range(8, src))
		if ((istype(target_tile,/turf/space)|| istype(target_tile, /turf/simulated/open)) && !(locate(/obj/machinery/shield) in target_tile))
			if (malfunction && prob(33) || !malfunction)
				var/obj/machinery/shield/S = new/obj/machinery/shield(target_tile)
				deployed_shields += S
				use_power_oneoff(S.shield_generate_power)

	for(var/turf/above in range(8, GetAbove(src)))//Probably a better way to do this.
		if ((istype(above,/turf/space)|| istype(above, /turf/simulated/open)) && !(locate(/obj/machinery/shield) in above))
			if (malfunction && prob(33) || !malfunction)
				var/obj/machinery/shield/A = new/obj/machinery/shield(above)
				deployed_shields += A
				use_power_oneoff(A.shield_generate_power)

/obj/machinery/shieldgen/proc/collapse_shields()
	for(var/obj/machinery/shield/shield_tile in deployed_shields)
		qdel(shield_tile)

/obj/machinery/shieldgen/power_change()
	. = ..()
	if(!. || !active) return
	if (!is_powered())
		collapse_shields()
	else
		create_shields()

/obj/machinery/shieldgen/Process()
	if (!active || (!is_powered()))
		return

	if(malfunction)
		if(length(deployed_shields) && prob(5))
			qdel(pick(deployed_shields))
	else
		if (check_delay <= 0)
			create_shields()

			var/new_power_usage = 0
			for(var/obj/machinery/shield/shield_tile in deployed_shields)
				new_power_usage += shield_tile.shield_idle_power

			if (new_power_usage != idle_power_usage)
				change_power_consumption(new_power_usage, POWER_USE_IDLE)

			check_delay = 60
		else
			check_delay--

/obj/machinery/shieldgen/post_health_change(health_mod, prior_health, damage_type)
	. = ..()
	queue_icon_update()
	if (get_current_health() <= 30)
		malfunction = TRUE

/obj/machinery/shieldgen/on_death()
	explosion(get_turf(src), 1, EX_ACT_LIGHT, 0, 0)
	qdel(src)

/obj/machinery/shieldgen/emp_act(severity)
	switch(severity)
		if(EMP_ACT_HEAVY)
			malfunction = 1
			locked = pick(0,1)
		if(EMP_ACT_LIGHT)
			if(prob(50))
				malfunction = 1
	..()

/obj/machinery/shieldgen/interface_interact(mob/user as mob)
	if(!CanInteract(user, DefaultTopicState()))
		return FALSE
	if(locked)
		to_chat(user, "The machine is locked, you are unable to use it.")
		return TRUE
	if(is_open)
		to_chat(user, "The panel must be closed before operating this machine.")
		return TRUE

	if (src.active)
		user.visible_message(SPAN_NOTICE("[icon2html(src, viewers(get_turf(src)))] [user] deactivated the shield generator."), \
			SPAN_NOTICE("[icon2html(src,user)] You deactivate the shield generator."), \
			"You hear heavy droning fade out.")
		src.shields_down()
	else
		if(anchored)
			user.visible_message(SPAN_NOTICE("[icon2html(src, viewers(get_turf(src)))] [user] activated the shield generator."), \
				SPAN_NOTICE("[icon2html(src, user)] You activate the shield generator."), \
				"You hear heavy droning.")
			src.shields_up()
		else
			to_chat(user, "The device must first be secured to the floor.")
	return TRUE

/obj/machinery/shieldgen/emag_act(remaining_charges, mob/user)
	if(!malfunction)
		malfunction = 1
		update_icon()
		return 1

/obj/machinery/shieldgen/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(isScrewdriver(W))
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
		if(is_open)
			to_chat(user, SPAN_NOTICE("You close the panel."))
			is_open = 0
		else
			to_chat(user, SPAN_NOTICE("You open the panel and expose the wiring."))
			is_open = 1
		return TRUE

	else if(isCoil(W) && malfunction && is_open)
		var/obj/item/stack/cable_coil/coil = W
		to_chat(user, SPAN_NOTICE("You begin to replace the wires."))
		//if(do_after(user, min(60, round( ((maxhealth/health)*10)+(malfunction*10) ))) //Take longer to repair heavier damage
		if(do_after(user, 3 SECONDS, src, DO_PUBLIC_UNIQUE))
			if (coil.use(1))
				revive_health()
				malfunction = 0
				to_chat(user, SPAN_NOTICE("You repair the [src]!"))
		return TRUE

	if (istype(W, /obj/item/card/id) || istype(W, /obj/item/modular_computer/pda))
		if(allowed(user))
			locked = !locked
			to_chat(user, "The controls are now [src.locked ? "locked." : "unlocked."]")
		else
			to_chat(user, SPAN_WARNING("Access denied."))
		return TRUE

	return ..()

/obj/machinery/shieldgen/can_anchor(obj/item/tool, mob/user, silent)
	if(locked)
		to_chat(user, "The bolts are covered, unlocking this would retract the covers.")
		return FALSE
	return ..()

/obj/machinery/shieldgen/post_anchor_change()
	if (!anchored && active)
		shields_down()
	..()

/obj/machinery/shieldgen/on_update_icon()
	if(active && is_powered())
		src.icon_state = malfunction ? "shieldonbr":"shieldon"
	else
		src.icon_state = malfunction ? "shieldoffbr":"shieldoff"
	return
