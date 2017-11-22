
#define LAUNCH_ABORTED -1
#define LAUNCH_UNDERWAY -2


/obj/machinery/podcontrol
	name = "Assault Pod Controller"
	desc = "Controls the launching of the assault pod. One way only."
	icon = 'code/modules/halo/icons/computer.dmi'
	icon_state = "computer"
	density = 1
	anchored = 1
	var/launching = LAUNCH_ABORTED
	var/obj/land_point
	var/area/contained_area

/obj/machinery/podcontrol/New()
	..()
	overlays += icon(icon,"nav")
	contained_area = loc.loc

/obj/machinery/podcontrol/proc/get_and_set_land_point()
	var/obj/point = pick(get_valid_landings())
	point.name += "_[contained_area.name]"
	land_point = point

/obj/machinery/podcontrol/proc/calc_translation(var/obj/target)
	var/x_trans = target.x - x
	var/y_trans = target.y - y
	var/z_trans = target.z - z
	var/returnlist = list(x_trans,y_trans,z_trans)
	return returnlist

/obj/machinery/podcontrol/proc/get_valid_landings()
	var/list/valid_points = list()
	for(var/obj/effect/landmark/lm in world)
		if(lm.name == "UNSC_ASSAULT")
			valid_points += lm
	return valid_points

/obj/machinery/podcontrol/attack_hand(var/mob/user)
	//TODO: Move controls to UI based.
	if(launching == LAUNCH_UNDERWAY)
		return
	if(launching == LAUNCH_ABORTED)
		to_chat(user,"<span class='notice'>Launch Initiated. 20 seconds to launch.</span>")
		start_launch()
	else
		stop_launch()
		to_chat(user,"<span class='danger'>Launch Aborted!</span>")

/obj/machinery/podcontrol/proc/start_launch()
	GLOB.processing_objects += src
	launching = 20

/obj/machinery/podcontrol/proc/stop_launch()
	GLOB.processing_objects -= src
	launching = LAUNCH_ABORTED

/obj/machinery/podcontrol/proc/dest_item_move_or_del(var/turf/newloc)
	for(var/obj/O in newloc.contents)
		if(O.anchored) //Obliterate anything anchored down.
			qdel(O)
			continue
		step_away(O,newloc,4,64)

/obj/machinery/podcontrol/proc/check_if_turf_then_translate(var/i,var/turf/newloc)
	if(isturf(i)) //Turfs can't have their .loc set.
		var/turf/T = i
		new T.type(newloc)
		new contained_area.type(newloc) //Re-create the area too.
		new /area/space(i) //Change the area to space
		new /turf/space (i)//The turf too.
	else
		var/obj/O = i
		O.loc = newloc


/obj/machinery/podcontrol/proc/launch()
	get_and_set_land_point()
	if(isnull(land_point))
		visible_message("<span class = 'notice'>POD LAUNCH FAILURE</span>","<span class = 'notice'>You hear an angry beep</span>")
		return
	playsound(land_point, get_sfx("explosion"), 100, 1,, falloff = 1)
	var/translation = calc_translation(land_point)
	for(var/mob/m in view(7,land_point))
		to_chat(m,"<span class='danger'>A concussive blast throws everything aside!</span>") //Tell everyone things were thrown away.

	for(var/i in contained_area.contents)
		var/atom/I = i //Typecast to atom
		var/dest_x = I.x + translation[1]
		var/dest_y = I.y + translation[2]
		var/dest_z = I.z + translation[3]
		var/turf/newloc = locate(dest_x,dest_y,dest_z)

		dest_item_move_or_del(newloc)

		spawn(1) //A small delay to allow the items that were present before to be moved or deleted.
			check_if_turf_then_translate(i,newloc)

	qdel(land_point)
	land_point = null

/obj/machinery/podcontrol/process()
	if(launching == LAUNCH_ABORTED)
		return
	if(launching > 0)
		launching--
		return
	if(launching == 0)
		for(var/mob/M in view(7,src))
			to_chat(M,"<span class='notice'>ASSAULT POD DEPARTING!</span>")
		launching = LAUNCH_UNDERWAY
		spawn(20)
			launch()

/obj/effect/landmark/innie_bomb
	name = "innie bomb spawn"

/obj/payload/innie
	anchored = 1
	seconds_to_disarm = 30

/obj/payload/innie/set_anchor()
	return

#undef LAUNCH_ABORTED
#undef LAUNCH_UNDERWAY
