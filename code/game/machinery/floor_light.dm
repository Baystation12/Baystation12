var/global/list/floor_light_cache = list()

/obj/machinery/floor_light
	name = "floor light"
	icon = 'icons/obj/machines/floor_light.dmi'
	icon_state = "base"
	desc = "A backlit floor panel."
	layer = ABOVE_TILE_LAYER
	anchored = FALSE
	use_power = POWER_USE_ACTIVE
	idle_power_usage = 2
	active_power_usage = 20
	power_channel = LIGHT
	matter = list(MATERIAL_STEEL = 250, MATERIAL_GLASS = 250)
	obj_flags = OBJ_FLAG_ANCHORABLE

	var/damaged
	var/default_light_max_bright = 0.75
	var/default_light_inner_range = 1
	var/default_light_outer_range = 3
	var/default_light_colour = "#ffffff"


/obj/machinery/floor_light/Initialize()
	. = ..()
	update_use_power(use_power)
	queue_icon_update()


/obj/machinery/floor_light/mapped_off
	anchored = TRUE
	use_power = POWER_USE_OFF


/obj/machinery/floor_light/mapped_on
	anchored = TRUE
	use_power = POWER_USE_ACTIVE


/obj/machinery/floor_light/use_weapon(obj/item/weapon, mob/user, list/click_params)
	SHOULD_CALL_PARENT(FALSE) // Passthrough to attack_hand()
	return attack_hand(user)


/obj/machinery/floor_light/use_tool(obj/item/tool, mob/user, list/click_params)
	// Screwdriver - Dismantle
	if (isScrewdriver(tool))
		if (use_power)
			to_chat(user, SPAN_WARNING("\The [src] must be turned off before you can dismantle it."))
			return TRUE
		new /obj/item/stack/material/steel(get_turf(src), 1)
		new /obj/item/stack/material/glass(get_turf(src), 1)
		playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
		user.visible_message(
			SPAN_NOTICE("\The [user] dismantles \the [src] with \a [tool]."),
			SPAN_NOTICE("You dismantle \the [src] with \the [tool].")
		)
		qdel(src)
		return TRUE

	// Welder - Repair damage
	if (isWelder(tool))
		if (!damaged && !MACHINE_IS_BROKEN(src))
			to_chat(user, SPAN_WARNING("\The [src] isn't damaged."))
			return TRUE
		var/obj/item/weldingtool/welder = tool
		if (!welder.can_use(user, 5))
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] starts repairing \the [src] with \a [tool]."),
			SPAN_NOTICE("You start repairing \the [src] with \the [tool].")
		)
		playsound(src, 'sound/items/Welder.ogg', 50, 1)
		if (!do_after(user, 2 SECONDS, src, DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		if (!welder.remove_fuel(user, 5))
			return TRUE
		set_broken(FALSE)
		damaged = null
		user.visible_message(
			SPAN_NOTICE("\The [user] repairs \the [src] with \a [tool]."),
			SPAN_NOTICE("You repair \the [src] with \the [tool], expending 5 units of fuel.")
		)
		return TRUE

	return ..()


/obj/machinery/floor_light/physical_attack_hand(mob/user)
	if(user.a_intent == I_HURT && !issmall(user))
		if(!isnull(damaged) && !MACHINE_IS_BROKEN(src))
			visible_message(SPAN_DANGER("\The [user] smashes \the [src]!"))
			playsound(src, "shatter", 70, 1)
			set_broken(TRUE)
		else
			visible_message(SPAN_DANGER("\The [user] attacks \the [src]!"))
			playsound(src.loc, 'sound/effects/Glasshit.ogg', 75, 1)
			if(isnull(damaged)) damaged = 0
		return TRUE

/obj/machinery/floor_light/interface_interact(mob/user)
	if(!CanInteract(user, DefaultTopicState()))
		return FALSE
	if(!anchored)
		to_chat(user, SPAN_WARNING("\The [src] must be screwed down first."))
		return TRUE

	var/on = (use_power == POWER_USE_ACTIVE)
	update_use_power(on ? POWER_USE_OFF : POWER_USE_ACTIVE)
	visible_message(SPAN_NOTICE("\The [user] turns \the [src] [!on ? "on" : "off"]."))
	queue_icon_update()
	return TRUE


/obj/machinery/floor_light/set_broken(new_state)
	. = ..()
	if(. && MACHINE_IS_BROKEN(src))
		update_use_power(POWER_USE_OFF)


/obj/machinery/floor_light/power_change(new_state)
	. = ..()
	queue_icon_update()


/obj/machinery/floor_light/proc/update_brightness()
	if((use_power == POWER_USE_ACTIVE) && operable())
		if(light_outer_range != default_light_outer_range || light_max_bright != default_light_max_bright || light_color != default_light_colour)
			set_light(default_light_max_bright, default_light_inner_range, default_light_outer_range, l_color = default_light_colour)
			change_power_consumption((light_outer_range + light_max_bright) * 20, POWER_USE_ACTIVE)
	else
		if(light_outer_range || light_max_bright)
			set_light(0)

/obj/machinery/floor_light/on_update_icon()
	overlays.Cut()
	if((use_power == POWER_USE_ACTIVE) && operable())
		if(isnull(damaged))
			var/cache_key = "floorlight-[default_light_colour]"
			if(!floor_light_cache[cache_key])
				var/image/I = image("on")
				I.color = default_light_colour
				I.plane = plane
				I.layer = layer+0.001
				floor_light_cache[cache_key] = I
			overlays |= floor_light_cache[cache_key]
		else
			if(damaged == 0) //Needs init.
				damaged = rand(1,4)
			var/cache_key = "floorlight-broken[damaged]-[default_light_colour]"
			if(!floor_light_cache[cache_key])
				var/image/I = image("flicker[damaged]")
				I.color = default_light_colour
				I.plane = plane
				I.layer = layer+0.001
				floor_light_cache[cache_key] = I
			overlays |= floor_light_cache[cache_key]
	update_brightness()

/obj/machinery/floor_light/ex_act(severity)
	switch(severity)
		if(EX_ACT_DEVASTATING)
			qdel(src)
		if(EX_ACT_HEAVY)
			if (prob(50))
				qdel(src)
			else if(prob(20))
				set_broken(TRUE)
			else
				if(isnull(damaged))
					damaged = 0
		if(EX_ACT_LIGHT)
			if (prob(5))
				qdel(src)
			else if(isnull(damaged))
				damaged = 0
	return
