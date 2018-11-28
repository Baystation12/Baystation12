#define VEHICLE_CONNECT_DELAY 7.5 SECONDS
#define VEHICLE_ITEM_LOAD 3.0 SECONDS

/obj/vehicles/air
	name = "Dropship"
	desc = "A dropship."

	icon = 'code/modules/halo/shuttles/pelican.dmi'
	icon_state = "base"

	density = 1
	anchored = 1

	layer = ABOVE_HUMAN_LAYER
	plane = ABOVE_HUMAN_PLANE

	active = 0

	var/faction = null //The faction this vehicle belongs to. Setting this will restrict landing to faction-owned and Civilian points only

	var/takeoff_overlay_icon_state
	var/takeoff_sound
	var/crash_sound

	vehicle_size = 10//Way too big

/obj/vehicles/air/MouseDrop(var/obj/over_object)
	var/mob/user = usr
	if(!istype(over_object,/obj)) return
	if(istype(over_object,/obj/vehicles/air)) return
	if(over_object.anchored) return
	if(!Adjacent(user) || !user.Adjacent(over_object)) return
	user.visible_message("<span class = 'notice'>[user] starts loading [over_object] into [src]\'s storage.</span>")
	if(!do_after(user,VEHICLE_ITEM_LOAD,over_object))
		return
	if(istype(over_object,/obj/vehicles) || istype(over_object,/obj/mecha))
		user.visible_message("<span class = 'notice'>[user] attaches the [over_object] onto [src]\'s underside.</span>")
	else
		user.visible_message("<span class = 'notice'>[user] loads the [over_object] into [src]\'s storage..</span>")
	over_object.loc = pick(src.locs)
	comp_prof.cargo_transfer(over_object)

/obj/vehicles/air/proc/takeoff_vehicle(var/message_n_sound_override = 0)
	active = 1
	change_elevation(2)
	if(!message_n_sound_override)
		visible_message("<span class = 'warning'>[name]'s engines activate, propelling them into the air.</span>")
		if(takeoff_sound)
			playsound(src,takeoff_sound,100,0)
	var/takeoff_overlay = image(icon,takeoff_overlay_icon_state)
	overlays += takeoff_overlay
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	block_enter_exit = 1

/obj/vehicles/air/proc/land_vehicle(var/message_n_sound_override = 0)
	active = 0
	change_elevation(-2)
	if(!message_n_sound_override)
		visible_message("<span class = 'warning'>[name]'s engines power down, slowly bringing them to the ground.</span>")
		if(takeoff_sound)
			playsound(src,takeoff_sound,100,0)
	pass_flags = 0
	block_enter_exit = 0
	overlays.Cut()

/obj/vehicles/air/verb/takeoff_land()
	set name = "Takeoff/Land"
	set desc = "Takeoff or land."
	set category = "Vehicle"
	set src in range(1)

	if(!(usr in get_occupants_in_position("driver")))
		to_chat(usr,"<span class = 'notice'>You need to be the driver of [name] to do that!</span>")
		return
	if(active)
		land_vehicle()
	else
		takeoff_vehicle()

/obj/vehicles/air/proc/get_reachable_waypoints()
	return dropship_landing_controller.get_potential_landing_points(1,1,faction)

/obj/vehicles/air/proc/create_waypoint_list()
	var/list/landing_points_by_name = list()
	for(var/obj/O in get_reachable_waypoints())
		landing_points_by_name += O.name
	return landing_points_by_name

/obj/vehicles/air/proc/get_waypoint_from_name(var/wanted_name)
	for(var/obj/O in get_reachable_waypoints())
		if(O.name == wanted_name)
			return O
	return null

/obj/vehicles/air/proc/perform_move_sequence(var/obj/move_to_obj)
	if(isnull(move_to_obj))
		return
	var/move_to_loc = move_to_obj.loc
	loc = move_to_loc

/obj/vehicles/air/proc/proc_fly_to_waypoint()
	var/selected_landing_point = input("Choose a landing point.","Landing Point Selection","Cancel") in create_waypoint_list() + list("Cancel")
	if(selected_landing_point == "Cancel")
		return
	var/obj/selected_landing_point_obj = get_waypoint_from_name(selected_landing_point)
	perform_move_sequence(selected_landing_point_obj)

/obj/vehicles/air/verb/fly_to_waypoint()
	set name = "Fly to waypoint"
	set desc = "Fly to a waypoint. Used to traverse z-levels."
	set category = "Vehicle"
	set src in range(1)

	if(!(usr in get_occupants_in_position("driver")))
		to_chat(usr,"<span class = 'notice'>You need to be the driver of [name] to do that!</span>")
		return
	if(!active)
		to_chat(usr,"<span class = 'notice'>You need to be in the air to do that!.</span>")
		return
	proc_fly_to_waypoint()

/obj/vehicles/air/inactive_pilot_effects()
	//Crashing this vehicle with potential casualties.
	visible_message("<span class = 'danger'>[name] spirals towards the ground, driverless!</span>")
	for(var/mob/living/carbon/human/h in occupants)
		if(prob(33))
			visible_message("<span class = 'warning'>[h.name] is violently thrown from [src]</span>")
			exit_vehicle(h)
			h.forceMove(pick(view(5,src) - view(2,src))) //Let's not throw these people into the epicenter of the ensuing explosion.
			if(prob(5))
				//Make it hurt, badly.
				h.visible_message("<span class = 'danger'>[h.name] skids along [loc].</span>")
				h.adjustBruteLoss(rand(25,50))
			else
				h.visible_message("<span class = 'danger'>[h.name] slams into [loc].</span>")
				h.adjustBruteLoss(rand(5,20))
	land_vehicle(1)
	if(crash_sound)
		playsound(src,crash_sound,100,0)
	explosion(src.loc,-1,3,4,7)

/obj/vehicles/air/update_object_sprites()


#undef VEHICLE_CONNECT_DELAY