#define FAUX_STEFAN_BOLTZMANN  1e-8 //tweaked stefan-boltzmann constant to give the sights a meaningful range


/obj/effect/visionoverlay
	alpha = 0
	var/atom/owner
	var/following
	anchored = TRUE

/obj/effect/visionoverlay/proc/linkup(mob/parent)
	if (isvirtualmob(parent)) //we do this because otherwise mobs in other things will cause recursive move event checks
		var/mob/observer/virtual/virtual_parent = parent
		owner = virtual_parent.host
	else
		owner = parent
	if(!(owner && parent))
		Destroy(src) // sanity check
		return
	if(!(owner.loc && parent.loc))
		Destroy(src) // sanity check
		return
	start_following(parent)
	forceMove(get_turf(parent.loc))
	dir = parent.dir
	process_appearance()

/obj/effect/visionoverlay/Process()
	. = ..()
	process_appearance()

//copied straight from observer code

/obj/effect/visionoverlay/Destroy()
	stop_following()
	. = ..()

/obj/effect/visionoverlay/proc/stop_following()
	if(!following)
		return
	GLOB.destroyed_event.unregister(following, src)
	GLOB.moved_event.unregister(following, src)
	GLOB.dir_set_event.unregister(following, src)
	following = null

/obj/effect/visionoverlay/proc/start_following(atom/target)
	stop_following()
	following = target
	GLOB.destroyed_event.register(target, src, .proc/stop_following)
	GLOB.moved_event.register(target, src, .proc/keep_following)
	if (isvirtualmob(target)) //virtual mobs actually don't update direction quick enough, we need to track the actual mob's direction
		var/mob/observer/virtual/virtual_target = target
		GLOB.dir_set_event.register(virtual_target.host, src, /atom/proc/recursive_dir_set)
		following = virtual_target.host
	else
		GLOB.dir_set_event.register(target, src, /atom/proc/recursive_dir_set)
	keep_following(new_loc = get_turf(following))

/obj/effect/visionoverlay/proc/keep_following(atom/movable/moving_instance, atom/old_loc, atom/new_loc)
	forceMove(get_turf(new_loc))

/obj/effect/visionoverlay/proc/process_appearance()
	if (owner)
		dir = owner.dir
	else	//if we have no owner we should stop existing quick
		Destroy(src)
	update_icon()

/obj/effect/visionoverlay/thermal
	layer = MAIN_THERMAL_LAYER
	plane = THERMALS_PLANE
	var/warmth = 0
	var/room_temp = 4 //vacuum temperature, roughly

/obj/effect/visionoverlay/thermal/process_appearance()
	if (owner)
		appearance = owner.appearance
		color = list( //make everything white, because otherwise color differences will get things confused.
			1, 1, 1,
			1, 1, 1,
			1, 1, 1
		)
		room_temp = 4
		warmth = owner.get_warmth()
		if (istype(owner, /obj/machinery/atmospherics))
			var/obj/machinery/atmospherics/atmos_machine = owner
			if(atmos_machine.icon_manager)
				icon = atmos_machine.icon_manager.get_atmos_icon(owner.name, owner.dir, "white", "")
		if (isturf(owner.loc)) //ideally it's based on temperature difference from surroundings
			var/air = (owner.loc).return_air()
			if (air)
				var/datum/gas_mixture/surroundings = air
				room_temp = surroundings.temperature
			alpha = clamp((warmth**4 - room_temp**4)*FAUX_STEFAN_BOLTZMANN, 0, 255) //boltzmann's law, sort of
		else
			alpha = 0
		update_icon()
	plane = THERMALS_PLANE
	layer = MAIN_THERMAL_LAYER
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE //we need to manually set this, along with quite a few other things, because the appearance var contains quite a lot of unwanted things
	infra_luminosity = 8
	. = ..()
