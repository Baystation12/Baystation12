
/obj/structure/drop_pods
	name = "Drop Pod"
	desc = "A drop pod."
	icon = 'code/modules/halo/structures/ODST_Droppod.dmi'
	icon_state = "SOEIV" //Icon state should be set to the closed version of the pod.

	density = 1
	anchored = 1

	plane = ABOVE_HUMAN_PLANE
	layer = ABOVE_HUMAN_LAYER

	var/board_time = 5 //The time it takes to board this drop pod, in seconds.
	var/launch_time = 20 //Time it takes for the pod to launch, in seconds.

	var/list/species_offsets = list("Human" = "0,7")

	var/turf/drop_point //A turf which the pod will drop near.
	var/launched

/obj/structure/drop_pods/New()
	open_pod()

/obj/structure/drop_pods/verb/enter_pod()
	set name = "Enter Pod"
	set src in orange(1)

	proc_enter_pod(usr)

/obj/structure/drop_pods/proc/exit_pod()
	set name = "Exit Pod"
	set src in range(1)

	proc_exit_pod(usr)

/obj/structure/drop_pods/proc/launch_pod()
	set name = "Launch Pod"
	set src in range(1)

	proc_launch_pod()

/obj/structure/drop_pods/proc/get_occupant()
	for(var/mob/living/carbon/human/h in contents)
		return h

/obj/structure/drop_pods/proc/close_pod()
	icon_state = "[initial(icon_state)]"
	overlays.Cut()

/obj/structure/drop_pods/proc/open_pod()
	icon_state = "[initial(icon_state)]_open"
	apply_icon_and_offsets(get_occupant())

/obj/structure/drop_pods/proc/check_occupied(var/mob/h)
	if(get_occupant())
		to_chat(h,"<span class ='notice'>Someone's already in that [name]!</span>")
		return 1
	return 0

/obj/structure/drop_pods/proc/proc_enter_pod(var/mob/living/carbon/human/h)
	if(!istype(h))//Making sure the entering mob is a human.
		return
	if(check_occupied(h))
		return
	if(do_after(h,board_time SECONDS,src))
		if(check_occupied(h))
			return
		visible_message("<span class ='notice'>[h.name] enters the [name]</span>")
		contents += h
		verbs += /obj/structure/drop_pods/proc/exit_pod
		verbs += /obj/structure/drop_pods/proc/launch_pod
		close_pod()

/obj/structure/drop_pods/proc/proc_exit_pod(var/mob/living/carbon/human/h)
	if(!istype(h))//Making sure the entering mob is a human.
		return
	if(h != get_occupant())
		open_pod()
		var/mob/occupant = get_occupant()
		visible_message("<span class = 'danger'>[h.name] starts pulling [occupant.name] out of [name]</span>")
		if(do_after(h,board_time*2 SECONDS,src))
			contents -= occupant
			occupant.loc = loc
			occupant.reset_view()
			verbs -= /obj/structure/drop_pods/proc/exit_pod
			verbs -= /obj/structure/drop_pods/proc/launch_pod
		return	overlays.Cut()
	visible_message("<span class = 'danger'>[h.name] climbs out of the [name]</span>")
	contents -= h
	h.loc = loc
	h.reset_view()
	verbs -= /obj/structure/drop_pods/proc/exit_pod
	verbs -= /obj/structure/drop_pods/proc/launch_pod
	open_pod()
	overlays.Cut()

/obj/structure/drop_pods/proc/search_compatible_drop_points()
	var/list/valid_points = list()
	for(var/obj/effect/landmark/drop_pod_landing/l in world)
		valid_points += l
	if(isnull(valid_points))
		log_error("ERROR: Drop pods placed on map but no /obj/effect/drop_pod_landing markers present!")
		return
	drop_point = pick(valid_points)

/obj/structure/drop_pods/proc/calculate_droppoint()
	var/list/valid_points = list()
	if(!drop_point)
		search_compatible_drop_points()
	for(var/turf/t in view(drop_point,5))
		if(istype(t,/turf/simulated/floor))
			valid_points += t
		if(istype(t,/turf/unsimulated/floor))
			valid_points += t
	if(isnull(valid_points))
		return
	return pick(valid_points)

/obj/structure/drop_pods/proc/parse_offsets(var/mob/living/carbon/human/h)
	var/list/offsets = splittext(species_offsets[h.species.name],",")
	for(var/i in offsets)
		offsets -= i
		offsets += text2num(i)
	return offsets

/obj/structure/drop_pods/proc/apply_icon_and_offsets(var/mob/living/carbon/human/h)
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

/obj/structure/drop_pods/proc/pod_landing_effects()
	explosion(drop_point,0,0,2,5)

/obj/structure/drop_pods/proc/translate_pod()
	x = drop_point.x
	y = drop_point.y
	z = drop_point.z

/obj/structure/drop_pods/proc/proc_launch_pod(var/mob/h)
	if(launched)
		return to_chat(h,"<span class = 'notice'>You can't launch the [name] again!</span>")
	close_pod()
	var/mob/occupant = get_occupant()
	if(h != occupant)
		to_chat(h,"<span class = 'notice'>You need to be inside the [name] to do that.</span>")
	visible_message("<span class = 'danger'>[occupant.name] starts engaging the launch mechanisms for the [name]</span>")
	if(do_after(get_occupant(),launch_time SECONDS,src))
		visible_message("<span class = 'danger'>[occupant.name] engages the launch mechanisms for the [name]</span>")
		drop_point = calculate_droppoint()
		pod_landing_effects()
		translate_pod()
		launched = 1
		open_pod()

/obj/effect/landmark/drop_pod_landing
	name = "Drop Pod landing Marker"
	invisibility = 101

//Overmap-Capable drop pod //
/obj/structure/drop_pods/overmap/search_compatible_drop_points()
	var/list/valid_points = list()
	for(var/obj/effect/landmark/drop_pod_landing/l in world)
		valid_points += l
	if(isnull(valid_points))
		log_error("ERROR: Drop pods placed on map but no /obj/effect/drop_pod_landing markers present!")
		return
	for(var/obj/O in valid_points)
		if(map_sectors["[z]"] != map_sectors["[O.z]"])
			valid_points -= O
	if(isnull(valid_points))
		visible_message("<span class = 'warning'>[name] emits a warning: \"No safe drop trajectories availiable.\"</span>")
		drop_point = null
	else
		drop_point = pick(valid_points)