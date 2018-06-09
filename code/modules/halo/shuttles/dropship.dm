
/obj/structure/dropship
	name = "Dropship"
	desc = "A dropship."

	icon = 'code/modules/halo/shuttles/pelican.dmi'
	icon_state = "base"

	density = 1
	anchored = 1

	layer = ABOVE_HUMAN_LAYER
	plane = ABOVE_HUMAN_PLANE
	var/faction = null //The faction this ship belongs to. Setting this will restrict landing to faction-owned and Civilian points only


	var/takeoff_overlay_icon_state
	var/takeoff_sound
	var/takeoff = 0 //Is the dropship currently undergoing takeoff procedures?

	var/max_occupants = 5 //The maximum amount of people who can fit inside the vehicle, including the pilot.
	var/list/occupants = list()

	var/mob/living/carbon/human/pilot

	var/enter_time = 5 //The time it takes to enter the vehicle.
	var/takeoff_time = 2//The time it takes to takeoff/land in seconds

	var/list/reachable_landing_locations = list()
	var/obj/target_location
	var/obj/effect/landmark/dropship_land_point/current_location

/obj/structure/dropship/proc/generate_current_landpoint()
	if(current_location)
		return
	for(var/turf/T in locs)
		for(var/obj/effect/landmark/dropship_land_point/L in T.contents)
			current_location = L
			L.occupied = 1

/obj/structure/dropship/proc/assign_pilot(var/mob/user,var/override)
	if(!pilot || override)
		unassign_pilot(pilot)
		to_chat(user,"<span class = 'notice'>You are now the pilot of the [name]</span>")
		pilot = user

/obj/structure/dropship/proc/unassign_pilot(var/mob/user)
	if(user)
		to_chat(user,"<span class ='notice'>You are no longer the pilot of the [name]</span>")
	pilot = null

/obj/structure/dropship/proc/do_enter_vehicle(var/mob/user)
	if(takeoff)
		to_chat(user,"<span class = 'warning'>You can't enter [name] whilst it's taking off!</span>")
		return
	if(occupants.len < max_occupants)
		occupants += user
		contents += user

/obj/structure/dropship/proc/do_exit_vehicle(var/mob/user)
	if(takeoff)
		to_chat(user,"<span class = 'warning'>You can't leave [name] whilst it's taking off!</span>")
		return
	occupants -= user
	contents -= user
	user.loc = src.loc

/obj/structure/dropship/verb/enter_vehicle()
	set name = "Enter Vehicle"
	set category = "Vehicle"
	set src in range(1)

	var/mob/user
	if(!user)
		user = usr
	if(!do_after(user,enter_time SECONDS,src))
		return
	do_enter_vehicle(user)
	if(!pilot)
		assign_pilot(user)

/obj/structure/dropship/verb/exit_vehicle()
	set name = "Exit Vehicle"
	set category = "Vehicle"
	set src in range(1)

	var/mob/user
	if(!user)
		user = usr
	if(!(user in occupants))
		to_chat(user,"<span class ='notice'>You need to be inside the vehicle to exit it.</span>")
		return
	if(pilot == user)
		unassign_pilot(user)
	do_exit_vehicle(user)

/obj/structure/dropship/verb/verb_change_landing_location()
	set name = "Set Landing Location"
	set category = "Vehicle"
	set src in range(1)

	if(usr != pilot)
		to_chat(usr,"<span class = 'notice'>You need to be the pilot of [name] to do that.</span>")
		return

	land_location_selection()

/obj/structure/dropship/verb/verb_launch_dropship()
	set name = "Launch Dropship"
	set category = "Vehicle"
	set src in range(1)

	if(usr != pilot)
		to_chat(usr,"<span class = 'notice'>You need to be the pilot of [name] to do that.</span>")
		return
	if(alert("Are you sure you want to launch [src]?",,"Yes","No") == "No")
		return

	perform_move_sequence()

//All Transit Related Procs//
/obj/structure/dropship/proc/update_reachable_landing()
	generate_current_landpoint()
	var/list/possible_land_locations = dropship_landing_controller.get_potential_landing_points(1,1,faction)
	reachable_landing_locations = possible_land_locations

/obj/structure/dropship/proc/change_landing_location(var/obj/new_land_location)
	target_location = new_land_location
	if(pilot)
		to_chat(pilot,"<span class = 'warning'>Landing target changed to [target_location.name]</span>")

/obj/structure/dropship/proc/create_landing_point_list()
	var/list/landing_points_by_name = list()
	for(var/obj/O in reachable_landing_locations)
		landing_points_by_name += O.name
	return landing_points_by_name

/obj/structure/dropship/proc/get_landing_point_from_name(var/wanted_name)
	for(var/obj/O in reachable_landing_locations)
		if(O.name == wanted_name)
			return O
	return null

/obj/structure/dropship/proc/land_location_selection(var/mob/user = pilot)
	update_reachable_landing()
	var/list/landing_point_list = create_landing_point_list()
	if(landing_point_list.len == 0)
		to_chat(user,"<span class = 'warning'>There are no valid landing points!</span>")
		return
	var/selected_landing_point_name = input(user,"Select a landing point","Landing Point Selection",null) as null|anything in landing_point_list
	var/obj/selected_landing_point = get_landing_point_from_name(selected_landing_point_name)
	change_landing_location(selected_landing_point)

/obj/structure/dropship/proc/perform_move_sequence(var/obj/move_to_obj = target_location)
	if(isnull(move_to_obj))
		return
	if(current_location)
		current_location.occupied = 0
	var/move_to_loc = move_to_obj.loc
	//playsound takeoff sound
	if(takeoff_sound)
		playsound(src,takeoff_sound,100,0)
	//apply takeoff overlay
	var/image/takeoff_overlay
	if(takeoff_overlay_icon_state)
		takeoff_overlay = image(icon,takeoff_overlay_icon_state)
		overlays += takeoff_overlay
	animate(src,alpha = 0,color = rgb(0,0,0),time = takeoff_time SECONDS)
	takeoff = 1
	current_location = move_to_obj
	current_location.occupied = 1
	spawn(takeoff_time SECONDS)
		loc = move_to_loc
		animate(src,alpha = 255,color = initial(color),time = takeoff_time SECONDS)
	spawn(takeoff_time SECONDS *2)
		takeoff = 0
		overlays -= takeoff_overlay
		qdel(takeoff_overlay)

/obj/structure/dropship/proc/check_valid_move(var/turf/land_point)
	var/obj/space_checker = new /obj/dropship_movement_placeholder (src)
	for(var/turf/T in space_checker.locs)
		if(!istype(T,/turf/simulated/floor) || !istype(T,/turf/unsimulated/floor))
			qdel(space_checker)
			return 0
	qdel(space_checker)
	return 1

/obj/dropship_movement_placeholder
	density = 0
	opacity = 0
	alpha = 0

/obj/dropship_movement_placeholder/New(var/obj/creator_dropship)
	bounds = creator_dropship.bounds
