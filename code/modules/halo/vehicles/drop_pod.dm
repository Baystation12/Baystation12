
/obj/vehicles/drop_pod
	name = "Drop Pod"
	desc = "A drop pod of unknown make, model and manufacturer."
	icon = 'code/modules/halo/structures/ODST_Droppod.dmi'
	icon_state = "SOEIV" //Icon state should be set to the closed version of the pod.

	density = 1

	plane = ABOVE_HUMAN_PLANE
	layer = ABOVE_HUMAN_LAYER

	occupants = list(0,0)

	vehicle_size = 32

	comp_prof =/datum/component_profile/drop_pod

	var/list/species_offsets = list("Human" = "0,7")

	var/launched = 0

	var/drop_accuracy = 3 //The accuracy in tiles (+ or - from drop point)

	var/launch_arm_time = 5 SECONDS

	var/pod_range = 3 //Range of pod in overmap tiles

/obj/vehicles/drop_pod/update_object_sprites()
	overlays.Cut()
	var/mob/living/carbon/human/h
	for(var/mob/m in occupants)
		if(occupants[m] == "driver")
			h = m
	if(isnull(h))
		return
	overlays.Cut()
	if(!species_offsets[h.species.name])
		overlays += h
		log_debug("WARNING: species [h.species.type] with name [h.species.name] entered a drop pod and couldn't find valid offsets!")
		return
	var/list/offsets = parse_offsets(h)
	var/image/occupant_image = image(h)
	occupant_image.plane = ABOVE_HUMAN_PLANE
	occupant_image.layer = VEHICLE_LOAD_LAYER
	occupant_image.pixel_x = offsets[1]
	occupant_image.pixel_y = offsets[2]
	overlays += occupant_image

/obj/vehicles/drop_pod/proc/parse_offsets(var/mob/living/carbon/human/h)
	var/list/offsets = splittext(species_offsets[h.species.name],",")
	for(var/i in offsets)
		offsets -= i
		offsets += text2num(i)
	return offsets

/obj/vehicles/drop_pod/proc/get_drop_turf(var/turf/drop_point)
	if(isnull(drop_point))
		visible_message("<span class = 'warning'>[src] blurts a warning: ERROR: NO AVAILABLE DROP-TARGETS.</span>")
		return
	var/list/valid_points = list()
	for(var/turf/t in view(drop_point,drop_accuracy))
		if(istype(t,/turf/simulated/wall))
			continue
		if(istype(t,/turf/unsimulated/wall))
			continue
		valid_points += t
	if(isnull(valid_points))
		error("DROP POD FAILED TO LAUNCH: COULD NOT FIND ANY VALID DROP-POINTS")
		return
	return pick(valid_points)

/obj/vehicles/drop_pod/proc/get_drop_point()
	var/list/valid_points = list()
	for(var/obj/effect/landmark/drop_pod_landing/l in world)
		valid_points += l
	if(isnull(valid_points) || valid_points.len == 0)
		log_error("ERROR: Drop pods placed on map but no /obj/effect/drop_pod_landing markers present!")
		return
	return pick(valid_points)

/obj/vehicles/drop_pod/proc/is_on_launchbay()
	for(var/obj/structure/drop_pod_launchbay/lb in loc.contents)
		return 1
	return 0

/obj/vehicles/drop_pod/verb/launch_pod()
	set name = "Launch Pod"
	set src in range(1)
	set category = "Vehicle"

	if(!is_on_launchbay())
		to_chat(usr,"<span class = 'notice'>[src] needs to be in a drop-bay to be launched.</span>")
		return

	if(launched)
		to_chat(usr,"<span class = 'notice'>[src] has already been launched once and cannot be launched again.</span>")
		return

	var/turf/drop_turf = get_drop_turf(get_drop_point())
	if(isnull(drop_turf))
		to_chat(usr,"<span class = 'notice'>No valid drop-turfs available.</span>")
		return

	proc_launch_pod(get_occupants_in_position("driver")[1],drop_turf)

/obj/vehicles/drop_pod/proc/proc_launch_pod(var/mob/user,var/turf/drop_turf)
	visible_message("<span class = 'danger'>[user] starts arming [src]'s launch mechanism.</span>")
	if(!do_after(user, launch_arm_time, src)) return
	visible_message("<span class = 'danger'>[user] arms [src]'s launch mechanism.</span>")
	spawn(5) //For drama's sake.
		forceMove(drop_turf)
		launched = 1
		spawn(5) //Slight delay so player clients can update.
			post_drop_effects(drop_turf)

/obj/vehicles/drop_pod/proc/post_drop_effects(var/turf/drop_turf)
	explosion(drop_turf,0,0,2,5)

/obj/vehicles/drop_pod/Move() //We're a drop pod, we don't move normally.
	return

/obj/vehicles/drop_pod/overmap/launch_pod()
	set name = "Launch Pod"
	set src in range(1)
	set category = "Vehicle"

	if(!is_on_launchbay())
		to_chat(usr,"<span class = 'notice'>[src] needs to be in a drop-bay to be launched.</span>")
		return
	if(launched)
		to_chat(usr,"<span class = 'notice'>[src] has already been launched once and cannot be launched again.</span>")
		return

	var/list/potential_om_targ = list()
	for(var/obj/effect/overmap/o in (range(pod_range,map_sectors["[z]"]) - map_sectors["[z]"]))
		potential_om_targ["[o.name]"] = o
	if(isnull(potential_om_targ) || potential_om_targ.len == 0)
		to_chat(usr,"<span class = 'notice'>No valid overmap targets in range.</span>")
		return
	var/om_user_choice = input("Select Target Object","Target Object Selection","Cancel") in potential_om_targ + list("Cancel")
	if(om_user_choice == "Cancel")
		to_chat(usr,"<span class = 'notice'>Launch target selection cancelled</span>")
		return
	var/obj/effect/overmap/om_targ = potential_om_targ[om_user_choice]

	var/turf/drop_turf = get_drop_turf(get_drop_point(om_targ.map_z))
	if(isnull(drop_turf))
		to_chat(usr,"<span class = 'notice'>No valid drop-turfs available.</span>")
		return

	proc_launch_pod(get_occupants_in_position("driver")[1],drop_turf)

/obj/vehicles/drop_pod/overmap/get_drop_point(var/list/om_targ_zs)
	var/list/valid_points = list()
	for(var/obj/effect/landmark/drop_pod_landing/l in world)
		if(l.z in om_targ_zs)
			valid_points += l
	if(isnull(valid_points) || valid_points.len == 0)
		return null
	else
		return pick(valid_points)

/datum/component_profile/drop_pod

	gunner_weapons = list()
	pos_to_check = "gunner" //Allows for overriding position checks for equip/firing of mounted weapon.
	vital_components = newlist(/obj/item/vehicle_component/health_manager) //Vital components, engine, thrusters etc.
	cargo_capacity = 8 //The capacity of the cargo hold. Items increase the space taken by  base_storage_cost(w_class) formula used in inventory_sizes.dm.

/obj/item/vehicle_component/health_manager/drop_pod
	integrity = 100
	coverage = 100
	resistances = list("brute"= 100.0,"burn"= 100.0,"emp"= 100.0,"explosion" = 100.0) //Negates all damage. Let's pretend drop-pods are invincible.

/obj/structure/drop_pod_launchbay
	name = "Drop Pod Launch Bay"
	desc = "Machinery to secure and launch a drop pod."
	icon = 'code/modules/halo/structures/ODST_Droppod.dmi'
	icon_state = "launch_bay"

	density = 0
	anchored = 1

/obj/effect/landmark/drop_pod_landing
	name = "Drop Pod landing Marker"
	invisibility = 101