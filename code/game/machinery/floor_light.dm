var/list/floor_light_cache = list()
GLOBAL_LIST_INIT(floor_lights, list())
/obj/machinery/floor_light
	name = "floor light"
	icon = 'icons/obj/machines/floor_light.dmi'
	icon_state = "base"
	desc = "A backlit floor panel."
	plane = ABOVE_TURF_PLANE
	layer = ABOVE_TILE_LAYER
	anchored = 0
	use_power = 2
	idle_power_usage = 2
	active_power_usage = 20
	power_channel = LIGHT
	matter = list(DEFAULT_WALL_MATERIAL = 250, "glass" = 250)

	var/on
	var/pressure_sensor = TRUE
	var/uses_shutoff_timer = FALSE
	var/shutoff_timer = 0 SECONDS
	var/damaged
	var/default_light_range = 4
	var/default_light_power = 2
	var/default_light_colour = "#ffffff"
//For networking.
	var/ID
	var/supplied //Set to true if unneeding to be added to a network. Basically used to keep the network proc from running in a loop.

/obj/machinery/floor_light/prebuilt
	anchored = 1

/obj/machinery/floor_light/Initialize()
	. = ..()
	GLOB.floor_lights += src
	ID = pick(1,99999) //This is probably excessive, but I don't think iterating through the list each time would be preferable.
	if(anchored)
		create_network()
/obj/machinery/floor_light/proc/create_network()
	if(supplied)
		return
	for(var/obj/machinery/floor_light/F in range(2))
		if(F.ID == ID)
			return
		else
			F.ID = ID
			F.supplied = TRUE
			supplied = TRUE
			F.create_network()

/obj/machinery/floor_light/attackby(var/obj/item/W, var/mob/user)
	if(isScrewdriver(W))
		anchored = !anchored
		visible_message("<span class='notice'>\The [user] has [anchored ? "attached" : "detached"] \the [src].</span>")
		if(anchored)
			supplied = FALSE
			create_network()
	else if(isMultitool(W))
		configure(user)
	else if(isWelder(W) && (damaged || (stat & BROKEN)))
		var/obj/item/weapon/weldingtool/WT = W
		if(!WT.remove_fuel(0, user))
			to_chat(user, "<span class='warning'>\The [src] must be on to complete this task.</span>")
			return
		playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
		if(!do_after(user, 20, src))
			return
		if(!src || !WT.isOn())
			return
		visible_message("<span class='notice'>\The [user] has repaired \the [src].</span>")
		stat &= ~BROKEN
		damaged = null
		update_brightness()
	else if(W.force && user.a_intent == "hurt")
		attack_hand(user)
	return

/obj/machinery/floor_light/attack_hand(var/mob/user)

	if(user.a_intent == I_HURT && !issmall(user))
		if(!isnull(damaged) && !(stat & BROKEN))
			visible_message("<span class='danger'>\The [user] smashes \the [src]!</span>")
			playsound(src, "shatter", 70, 1)
			stat |= BROKEN
		else
			visible_message("<span class='danger'>\The [user] attacks \the [src]!</span>")
			playsound(src.loc, 'sound/effects/Glasshit.ogg', 75, 1)
			if(isnull(damaged)) damaged = 0
		update_brightness()
		return
	else
		toggle_active()

/obj/machinery/floor_light/proc/toggle_active(mob/user, var/force_off)
	if(!anchored)
		to_chat(user, "<span class='warning'>\The [src] must be screwed down first.</span>")
		return

	if(stat & BROKEN)
		to_chat(user, "<span class='warning'>\The [src] is too damaged to be functional.</span>")
		return

	if(stat & NOPOWER)
		to_chat(user, "<span class='warning'>\The [src] is unpowered.</span>")
		return

	if(force_off)
		on = FALSE
		update_brightness()
		return
	on = !on
	if(on)
		use_power = 2
	else if(uses_shutoff_timer && shutoff_timer)
		sleep(shutoff_timer)
	update_brightness()


/obj/machinery/floor_light/Process()
	..()
	var/need_update
	if((!anchored || broken()) && on)
		use_power = 0
		on = 0
		need_update = 1
	else if(use_power && !on)
		use_power = 0
		need_update = 1
	if(need_update)
		update_brightness()

/obj/machinery/floor_light/Crossed(var/atom/A)
	if(!on && anchored && pressure_sensor && isliving(A))
		toggle_active(A)

/obj/machinery/floor_light/Uncrossed(var/atom/A)
	if(on && uses_shutoff_timer && pressure_sensor && isliving(A))
		toggle_active(A)

/obj/machinery/floor_light/proc/update_brightness()
	if(on && use_power == 2)
		if(light_range != default_light_range || light_power != default_light_power || light_color != default_light_colour)
			set_light(default_light_range, default_light_power, default_light_colour)
	else
		use_power = 0
		if(light_range || light_power)
			set_light(0)

	active_power_usage = ((light_range + light_power) * 10)
	update_icon()

/obj/machinery/floor_light/update_icon()
	overlays.Cut()
	if(use_power && !broken())
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

/obj/machinery/floor_light/proc/broken()
	return (stat & (BROKEN|NOPOWER))

#define CONFIRM_CONDITIONS(A) \
	if(A.incapacitated() || !(locate(/obj/item/device/multitool/) in A) || !(A in range(2)))\
		return
/obj/machinery/floor_light/proc/configure(mob/user)
	var/I
	I = input("What would you like to change?", "[src] configuration", I) in list("Toggle pressure sensor", "Toggle light deavtivation timer", "Configure timer length", "Cancel")
	var/msg = "" //Mesage broken into multiple lines for code readability.
	switch(I)

		if("Toggle pressure sensor")
			CONFIRM_CONDITIONS(user)
			pressure_sensor = !pressure_sensor
			msg +="<span class = 'notice'>You [pressure_sensor ? "enable" : "disable"] the [src]'s pressure sensor.</span>"
			if(uses_shutoff_timer)
				msg += "<span class = 'notice'> It will deactivate after [shutoff_timer ? "[shutoff_timer / 10] seconds of" : ""] being stepped off of.</span>"

		if("Toggle light deavtivation timer")
			CONFIRM_CONDITIONS(user)
			uses_shutoff_timer = !uses_shutoff_timer
			msg += "<span class = 'notice'>You [uses_shutoff_timer ? "enable" : "disable"] the [src]'s shutoff timer.</span>"
			if(pressure_sensor)
				msg += "<span class = 'notice'> It will deactivate [shutoff_timer ? "after [shutoff_timer] second(s) of" : ""] being stepped off of.</span>"

		if("Configure timer length")
			CONFIRM_CONDITIONS(user)
			var/T
			T = input("Input timer length in seconds.", "Set timer", T) as num
			msg += "<span class = 'notice'>Shutoff timer set to [T] second(s).</span>"
			shutoff_timer = T*10 //deciseconds into seconds.
		if("Cancel")
			return
	if(msg)
		to_chat(user, msg)
	for(var/obj/machinery/floor_light/F in GLOB.floor_lights)
		if(F.ID == ID)
			F.pressure_sensor = pressure_sensor
			F.uses_shutoff_timer = uses_shutoff_timer
			F.shutoff_timer = shutoff_timer
			toggle_active(user, TRUE)




/obj/machinery/floor_light/ex_act(severity)
	switch(severity)
		if(1)
			qdel(src)
		if(2)
			if (prob(50))
				qdel(src)
			else if(prob(20))
				stat |= BROKEN
			else
				if(isnull(damaged))
					damaged = 0
		if(3)
			if (prob(5))
				qdel(src)
			else if(isnull(damaged))
				damaged = 0
	return

/obj/machinery/floor_light/Destroy()
	var/area/A = get_area(src)
	if(A)
		on = 0
	. = ..()

#undef CONFIRM_CONDITIONS