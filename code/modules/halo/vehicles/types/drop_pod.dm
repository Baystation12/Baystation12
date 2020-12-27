#define POD_FAIL_CHANCE 1 //This is the chance a drop-pod will fail on impact and auto-eject the user + exploding.

/obj/vehicles/drop_pod
	name = "SOEIV Drop Pod"
	desc = "A Single Occupant Exoatmospheric Insertion Vehicle for deployment of personnel or equipment from high orbit insertion onto a planet."
	icon = 'code/modules/halo/vehicles/types/ODST_Droppod.dmi'
	icon_state = "SOEIV" //Icon state should be set to the closed version of the pod.

	density = 1

	plane = ABOVE_HUMAN_PLANE
	layer = ABOVE_HUMAN_LAYER

	occupants = list(0,0)

	vehicle_size = ITEM_SIZE_VEHICLE_SMALL
	capacity_flag = ITEM_SIZE_VEHICLE_SMALL

	comp_prof = /datum/component_profile/drop_pod

	exposed_positions = list()

	var/faction_tag = "UNSC"

	var/list/species_offsets = list("Human" = "0,7")

	var/launched = 0

	var/drop_accuracy = 3 //The accuracy in tiles (+ or - from drop point)

	var/launch_arm_time = 2.5 SECONDS

	var/pod_range = 14 //Range of pod in overmap tiles
	var/obj/effect/overmap/om_targ

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
	for(var/turf/l in dview(drop_point,drop_accuracy))
		if(istype(l,/turf/simulated/floor))
			valid_points += l
		if(istype(l,/turf/unsimulated/floor))
			valid_points += l
	if(isnull(valid_points) || valid_points.len == 0)
		error("DROP POD FAILED TO LAUNCH: COULD NOT FIND ANY VALID DROP-POINTS")
		return
	return pick(valid_points)

/obj/vehicles/drop_pod/proc/get_drop_point()
	var/list/valid_points = list()
	var/beacons_present = 0
	for(var/obj/effect/landmark/drop_pod_landing/l in world)
		valid_points += l
	for(var/obj/item/drop_pod_beacon/b in world)
		if(b.is_active == 1 && b.faction_tag == faction_tag)
			if(!beacons_present) //If we've not already realised we have beacons, remove all normal drop-pod markers from pick-choice.
				valid_points.Cut()
				visible_message("<span class = 'notice'>Electronic Locator beacon detected. Overriding landing systems.</span>")
			beacons_present = 1
			valid_points += b.loc
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

	if(world.time < ticker.mode.ship_lockdown_until)
		to_chat(usr,"<span class = 'notice'>[src] is still finalising deployment preparations!</span>")
		return

	var/turf/drop_turf = get_drop_turf(get_drop_point())
	if(isnull(drop_turf))
		to_chat(usr,"<span class = 'notice'>No valid drop-turfs available.</span>")
		return

	proc_launch_pod(usr,drop_turf)

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

	if(prob(POD_FAIL_CHANCE))
		on_death()//do death effects
		return
	//explosion(drop_turf,-1,0,2,5)
	playsound(src, 'sound/effects/bamf.ogg', 100, 1)

	for(var/turf/simulated/floor/F in src.locs)
		F.break_tile_to_plating()

/obj/vehicles/drop_pod/relaymove() //We're a drop pod, we don't move normally.
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

	var/list/potential_om_targ = get_overmap_targets()
	if(isnull(potential_om_targ) || potential_om_targ.len == 0)
		to_chat(usr,"<span class = 'notice'>No valid overmap targets in range ([pod_range] tiles).</span>")
		return
	var/om_user_choice = input("Select Target Object","Target Object Selection","Cancel") as null|anything in potential_om_targ
	if(!om_user_choice || om_user_choice == "Cancel")
		to_chat(usr,"<span class = 'notice'>Launch target selection cancelled</span>")
		return
	om_targ = potential_om_targ[om_user_choice]

	var/turf/drop_turf = get_drop_turf(get_drop_point(usr,om_targ))
	if(isnull(drop_turf))
		to_chat(usr,"<span class = 'notice'>No valid drop-turfs available.</span>")
		return

	proc_launch_pod(usr,drop_turf)

/obj/vehicles/drop_pod/overmap/proc/get_overmap_targets()
	var/list/potential_om_targ = list()
	for(var/obj/effect/overmap/sector/o in (range(pod_range,map_sectors["[z]"]) - map_sectors["[z]"]))
		potential_om_targ["[o.name]"] = o
	return potential_om_targ

/obj/vehicles/drop_pod/overmap/get_drop_point(var/mob/user,var/obj/effect/overmap/om_targ)
	var/list/valid_points = list()
	var/beacons_present = 0
	for(var/obj/item/drop_pod_beacon/b in world)
		if(!(b.loc.z  in om_targ.map_z))
			continue
		if(b.is_active == 1)
			if(!beacons_present) //If we've not already realised we have beacons, remove all normal drop-pod markers from pick-choice.
				valid_points.Cut()
				visible_message("<span class = 'notice'>Electronic Locator beacon detected. Overriding landing systems.</span>")
			beacons_present = 1
			valid_points += b.loc
	if(valid_points.len > 0)
		return pick(valid_points)

	//does this overmap object have predefined drop pod locations?
	for(var/obj/effect/landmark/drop_pod_landing/D in world)
		if(!(D.loc.z  in om_targ.map_z))
			continue
		var/area/A = get_area(D)
		var/entry_name = A.name
		var/entry_num = 1
		while(valid_points[entry_name])
			entry_num++
			entry_name = "[A.name] ([entry_num])"
		valid_points[entry_name] = get_turf(D)

	var/turf/target_turf
	if(valid_points.len)
		var/chosen_name = input(user,"Pick a location to land the [name]","[name] Landing Selection") as null|anything in valid_points
		if(chosen_name)
			target_turf = get_turf(valid_points[chosen_name])
	else
		//choose from the standard list of targettable areas
		var/list/chosen_area = om_targ.map_bounds
		if(om_targ.targeting_locations.len > 0)
			var/chosen_loc_name = input(user,"Pick a location to land the [name]","[name] Landing Selection") as null|anything in om_targ.targeting_locations
			chosen_area = om_targ.targeting_locations[chosen_loc_name]
		target_turf = locate(rand(chosen_area[1],chosen_area[3]),rand(chosen_area[2],chosen_area[4]),pick(om_targ.map_z))

	return target_turf

/obj/vehicles/drop_pod/overmap/post_drop_effects(var/turf/drop_turf)
	var/obj/effect/overmap/our_om_obj = map_sectors["[drop_turf.z]"]
	if(!isnull(our_om_obj))
		var/landing_depth = our_om_obj.map_z.Find(drop_turf.z)
		if(prob(POD_FAIL_CHANCE * landing_depth))
			on_death()//do death effects
			return
	. = ..()

/datum/component_profile/drop_pod
	gunner_weapons = list()
	pos_to_check = "gunner" //Allows for overriding position checks for equip/firing of mounted weapon.
	vital_components = newlist(/obj/item/vehicle_component/health_manager/drop_pod) //Vital components, engine, thrusters etc.

/obj/item/vehicle_component/health_manager/drop_pod
	integrity = 200
	resistances = list("bullet"= 25,"energy"= 25,"emp"= 25,"bomb" = 25)		//very little armour

/obj/structure/drop_pod_launchbay
	name = "Drop Pod Launch Bay"
	desc = "Machinery to secure and launch a drop pod."
	icon = 'code/modules/halo/vehicles/types/ODST_Droppod.dmi'
	icon_state = "launch_bay"

	density = 0
	anchored = 1

/obj/effect/landmark/drop_pod_landing
	name = "Drop Pod landing Marker"
	icon = 'code/modules/halo/vehicles/types/landmark.dmi'
	icon_state = "droppod"