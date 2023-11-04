/obj/item/device/drone_designator
	name = "drone telemetry designator"
	desc = "A small, handheld tool used to transmit location data to a transport drone."
	icon = 'icons/obj/tools/drone_control.dmi'
	icon_state = "pad_designator"
	var/network = null
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_PLASTIC = 60, MATERIAL_GLASS = 200)
	origin_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)

/obj/item/device/drone_designator/examine(mob/user, distance)
	. = ..()
	if (network)
		to_chat(user, "It is connected to the '[network]' network.")
	else
		to_chat(user, "The device hasn't been linked to a transport network.")

/obj/item/device/drone_designator/proc/recursive_validate_contents(atom/A, depth = 1)
	if(depth >= 4)
		return TRUE
	if(istype(A, /obj/machinery/stasis_cage))
		return TRUE //This is fine
	if(istype(A,/mob/living))
		return FALSE

	for(var/atom/B as anything in A)
		if(!recursive_validate_contents(B, depth + 1))
			return FALSE

	return TRUE

/obj/item/device/drone_designator/proc/validate_target(obj/target, mob/user)
	if (!istype(target))
		return FALSE
	if (target.anchored)
		to_chat(user, SPAN_WARNING("\The [target] is anchored to the ground!"))
		return FALSE
	if (target.buckled_mob)
		to_chat(user, SPAN_WARNING("There is a living being buckled to \the [target]."))
		return FALSE
	if (!recursive_validate_contents(target))
		to_chat(user, SPAN_WARNING("There is an unsecured lifeform inside \the [target]."))
		return FALSE
	return TRUE

/obj/item/device/drone_designator/proc/perform_pickup(obj/target, mob/user)
	var/datum/local_network/lan = network ? GLOB.multilevel_local_networks[network] : null
	if (lan)
		var/list/drone_pads = lan.get_devices(/obj/machinery/drone_pad)
		for(var/obj/machinery/drone_pad/pad in drone_pads)
			if(pad.attempt_to_transport(target, user, src))
				return
		to_chat(user, SPAN_WARNING("It would seem there are no available drones to process this request!"))
	else
		to_chat(user, SPAN_WARNING("The network is not responding..."))

/obj/item/device/drone_designator/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if (!network)
		to_chat(user, SPAN_WARNING("\The [src] has not been connected to any network!"))
		return
	var/turf/T = target.loc
	if (!istype(T))
		return
	var/area/A = T.loc
	if (!(istype(A) && A.area_flags & AREA_FLAG_EXTERNAL))
		to_chat(user, SPAN_WARNING("You should probably try to use this outside."))
		return
	if (validate_target(target, user))
		var/datum/beam/B = user.Beam(BeamTarget = T, icon_state = "n_beam", maxdistance = get_dist(user, T), beam_type = /obj/ebeam)
		user.visible_message(SPAN_NOTICE("\The [user] points \the [src] at \the [target]."))
		playsound(src,'sound/effects/scanbeep.ogg',30,0)
		if(do_after(user, 2 SECONDS, target, (DO_PUBLIC_UNIQUE & ~DO_USER_SAME_HAND) | DO_MOVE_CHECKS_TURFS))
			QDEL_NULL(B)
			if(!validate_target(target, user)) //Repeat checks
				return

			perform_pickup(target, user)
			return
		QDEL_NULL(B)

/datum/transport_flight
	var/turf/origin = null
	var/obj/payload = null
	var/time_of_arrival = 0

/obj/machinery/drone_pad
	name = "transport drone landing pad"
	desc = "A small pad for transport drones to deposit their payloads at."
	icon = 'icons/obj/machines/landing_pad.dmi'
	icon_state = "pad_base"
	anchored = TRUE
	density = FALSE
	layer = ABOVE_CATWALK_LAYER
	base_type = /obj/machinery/drone_pad
	construct_state = /singleton/machine_construction/default/panel_closed
	uncreated_component_parts = null
	active_power_usage = 0 KILOWATTS
	machine_name = "transport drone landing pad"
	machine_desc = "A small pad for transport drones to deposit their payloads."
	var/initial_id_tag = null
	var/datum/transport_flight/current_flight = null
	var/active_timer = null
	var/tile_travel_time = 15 SECONDS
	stat_immune = MACHINE_STAT_NOPOWER | MACHINE_STAT_NOSCREEN | MACHINE_STAT_NOINPUT
	maximum_component_parts = list(/obj/item/stock_parts = 6) //Circuit + 4 scanners + 1 crystal

/obj/machinery/drone_pad/Destroy()
	. = ..()
	if (active_timer)
		deltimer(active_timer)
		active_timer = null
	if (current_flight)
		//Fail, just drop the thing where it came from,
		current_flight.payload.forceMove(current_flight.origin)
		QDEL_NULL(current_flight)

/obj/machinery/drone_pad/on_update_icon()
	. = ..()
	ClearOverlays()
	if (current_flight)
		AddOverlays(list(
			emissive_appearance(icon, "pad_incoming"),
			image(icon, "pad_incoming")
		))
	else
		var/datum/extension/local_network_member/transport = get_extension(src, /datum/extension/local_network_member)
		var/network = transport ? transport.id_tag : null
		if (network && operable())
			AddOverlays(emissive_appearance(icon, "pad_waiting"))
			AddOverlays(image(icon, "pad_waiting"))
	if(panel_open)
		AddOverlays(image(icon, "pad_maintenance"))

/obj/machinery/drone_pad/examine(mob/user, distance)
	. = ..()
	var/datum/extension/local_network_member/transport = get_extension(src, /datum/extension/local_network_member)
	var/network = transport.id_tag
	if (network)
		to_chat(user, "It is connected to the '[network]' network.")
	else
		to_chat(user, "The device hasn't been linked to a transport network.")

	if (current_flight)
		to_chat(user, "There is a drone en route to this pad. The drone is [ time_to_readable(current_flight.time_of_arrival - world.time) ] away.")

/obj/machinery/drone_pad/proc/pickup_animation(obj/target)
	var/image/object = new
	object.appearance = target
	object.loc = target.loc
	var/image/drone = image('icons/obj/machines/landing_pad.dmi', target.loc, "pad_drone")
	drone.plane = DEFAULT_PLANE
	drone.layer = ABOVE_PROJECTILE_LAYER
	drone.alpha = 10
	drone.pixel_y = world.icon_size * 3


	flick_overlay(object, GLOB.clients, 5 SECONDS)
	flick_overlay(drone, GLOB.clients, 5 SECONDS)

	//Animate drone descending to pick up crate
	animate(
		drone,
		alpha = 255,
		pixel_y = 0,
		time = 3 SECONDS,
		easing = CIRCULAR_EASING|EASE_OUT
	)
	animate(alpha = 0, pixel_y = world.icon_size * 3, time = 2 SECONDS, easing = BACK_EASING|EASE_IN)
	//Wait for drone animation then animate the object too
	animate(object, time = 3 SECONDS)
	animate(alpha = 0, pixel_y = world.icon_size * 3, time = 2 SECONDS, easing = BACK_EASING|EASE_IN)

/obj/machinery/drone_pad/proc/landing_animation(obj/target, turf/location)
	var/image/object = new
	object.appearance = target
	object.loc = location
	object.pixel_y = world.icon_size * 3
	object.alpha = 10
	var/image/drone = image('icons/mob/robots_flying.dmi', location, "drone-standard")
	drone.plane = DEFAULT_PLANE
	drone.layer = ABOVE_PROJECTILE_LAYER
	drone.alpha = 10
	drone.pixel_y = world.icon_size * 3


	flick_overlay(object, GLOB.clients, 5 SECONDS)
	flick_overlay(drone, GLOB.clients, 5 SECONDS)

	//Animate drone descending to pick up crate
	animate(
		drone,
		alpha = 255,
		pixel_y = 0,
		time = 3 SECONDS,
		easing = CIRCULAR_EASING|EASE_OUT
	)
	animate(alpha = 0, pixel_y = world.icon_size * 3, time = 2 SECONDS, easing = QUAD_EASING|EASE_IN)
	//Wait for drone animation then animate the object too
	animate(object, pixel_y = 0, alpha = 255, time = 3 SECONDS, easing = CIRCULAR_EASING|EASE_OUT)

/obj/machinery/drone_pad/proc/finish_moving()
	landing_animation(current_flight.payload, src.loc)
	addtimer(new Callback(current_flight.payload, /atom/movable/proc/forceMove, src.loc), 3 SECONDS)
	QDEL_NULL(current_flight)
	update_icon()

/obj/machinery/drone_pad/proc/attempt_to_transport(obj/target, mob/user, obj/item/device/drone_designator/designator)
	if(inoperable())
		return FALSE

	if (current_flight)
		return FALSE
	else
		//Overmap travel necessary?
		var/obj/overmap/visitable/other = map_sectors["[target.z]"]
		var/obj/overmap/visitable/self = map_sectors["[src.z]"]
		//Start animation
		pickup_animation(target)

		target.forceMove(null) //Move to nullspace until arrival
		current_flight = new()
		current_flight.origin = target.loc
		current_flight.payload = target
		var/flight_time = 10 SECONDS //At least 10 seconds to get there, regardless

		if (other && self && (other.z == self.z)) //Can visitables even not be in same overmap level?
			flight_time += get_dist(other, self) * tile_travel_time
		current_flight.time_of_arrival = world.time +  flight_time

		designator.audible_message(SPAN_NOTICE("<b>\The [designator]</b> pings, Request acknowledged. Drone en route. Delivery expected in T - [ (flight_time) / (1 SECOND)] seconds."))
		audible_message(SPAN_NOTICE("<b>\The [src]</b> pings, Incoming payload. Delivery expected in T - [(flight_time) / (1 SECOND)] seconds."))


		active_timer = addtimer(new Callback(src, .proc/finish_moving), flight_time, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_STOPPABLE)
		update_icon()
		return TRUE


/obj/machinery/drone_pad/Initialize()
	. = ..()
	set_extension(src, /datum/extension/local_network_member/multilevel)
	if (initial_id_tag)
		var/datum/extension/local_network_member/pointdefense = get_extension(src, /datum/extension/local_network_member)
		pointdefense.set_tag(null, initial_id_tag)
		update_icon()

/obj/machinery/drone_pad/use_tool(obj/item/tool, mob/user)
	var/datum/extension/local_network_member/transport = get_extension(src, /datum/extension/local_network_member)
	if (isMultitool(tool))
		transport.get_new_tag(user)
		update_icon()
		return TRUE

	var/obj/item/device/drone_designator/designator = tool
	if (istype(designator))
		if (!transport.id_tag)
			to_chat(user, SPAN_WARNING("\The [src] has not yet been set up."))
			playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 1, -3)
		else if (designator.network == transport.id_tag)
			to_chat(user, SPAN_WARNING("\The [tool] is already synchronized with this network."))
			playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 1, -3)
		else
			to_chat(user, SPAN_NOTICE("\The [tool] was synchronized with the [transport.id_tag] network."))
			designator.network = transport.id_tag
			playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1, -3)
		update_icon()
		return TRUE

	return ..()

/obj/machinery/drone_pad/RefreshParts()
	. = ..()
	// Calculates an average rating of components that affect shooting rate
	var/scanner_rate = total_component_rating_of_type(/obj/item/stock_parts/scanning_module)
	tile_travel_time = (15 SECONDS) * 4 / (scanner_rate ? scanner_rate : 1)
	update_icon()
