var/global/list/floor_light_cache = list()

/obj/machinery/floor_light
	name = "floor light"
	icon = 'icons/obj/machines/floor_light.dmi'
	icon_state = "base"
	desc = "A backlit floor panel."
	layer = ABOVE_TILE_LAYER
	anchored = FALSE
	use_power = POWER_USE_OFF
	idle_power_usage = 2
	active_power_usage = 20
	power_channel = LIGHT
	matter = list(MATERIAL_STEEL = 250, MATERIAL_GLASS = 250)
	health_max = 5
	damage_hitsound = 'sound/effects/Glasshit.ogg'

	var/damaged
	var/default_light_power = 0.75
	var/default_light_range = 3
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


/obj/machinery/floor_light/attackby(obj/item/W, mob/user)
	if(isScrewdriver(W))
		anchored = !anchored
		if(use_power)
			update_use_power(POWER_USE_OFF)
			queue_icon_update()
		visible_message(SPAN_NOTICE("\The [user] has [anchored ? "attached" : "detached"] \the [src]."))
	else if(isWelder(W) && (health_damaged() || MACHINE_IS_BROKEN(src)))
		var/obj/item/weldingtool/WT = W
		if(!WT.can_use(1, user))
			return
		playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
		if(!do_after(user, (W.toolspeed * 2) SECONDS, src, DO_REPAIR_CONSTRUCT))
			return
		if(!src || !WT.remove_fuel(1, user))
			return
		visible_message(SPAN_NOTICE("\The [user] has repaired \the [src]."))
		set_broken(FALSE)
		revive_health()
	else if(isWrench(W))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
		to_chat(user, SPAN_NOTICE("You dismantle the floor light."))
		new /obj/item/stack/material/steel(src.loc, 1)
		new /obj/item/stack/material/glass(src.loc, 1)
		qdel(src)
	return

/obj/machinery/floor_light/on_death()
	..()
	playsound(src, "shatter", 70, 1)
	visible_message(SPAN_DANGER("\The [src] is smashed into many pieces!"))

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
		if(light_range != default_light_range || light_power != default_light_power || light_color != default_light_colour)
			set_light(default_light_range, default_light_power, default_light_colour)
			change_power_consumption((light_range + light_power) * 20, POWER_USE_ACTIVE)
	else
		if(light_range || light_power)
			set_light(0)

/obj/machinery/floor_light/on_update_icon()
	ClearOverlays()
	if((use_power == POWER_USE_ACTIVE) && operable())
		if (!health_damaged())
			var/cache_key = "floorlight-[default_light_colour]"
			if(!floor_light_cache[cache_key])
				var/image/I = image("on")
				I.color = default_light_colour
				I.plane = plane
				I.layer = layer+0.001
				floor_light_cache[cache_key] = I
			AddOverlays(floor_light_cache[cache_key])
		else
			damaged = rand(1,4)
			var/cache_key = "floorlight-broken[damaged]-[default_light_colour]"
			if(!floor_light_cache[cache_key])
				var/image/I = image("flicker[damaged]")
				I.color = default_light_colour
				I.plane = plane
				I.layer = layer+0.001
				floor_light_cache[cache_key] = I
			AddOverlays(floor_light_cache[cache_key])
	if (MACHINE_IS_BROKEN(src))
		AddOverlays("broken")

	update_brightness()
