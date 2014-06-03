//These lists are populated in /obj/machinery/computer/shuttle_control/New()
//TODO: Integrate these into a shuttle controller.
var/list/global/shuttle_locations = list()
var/list/global/shuttle_delays = list()
var/list/global/shuttle_moving = list()

/obj/machinery/computer/shuttle_control
	name = "shuttle console"
	icon = 'icons/obj/computer.dmi'
	icon_state = "shuttle"
	req_access = list(access_engine)
	circuit = "/obj/item/weapon/circuitboard/engineering_shuttle"

	var/shuttle_tag  // Used to coordinate data in global lists.
	var/area/offsite // Off-station destination.
	var/area/station // Station destination.
	var/hacked = 0   // Has been emagged, no access restrictions.
	var/location = 0 // The location that the shuttle begins the game at.
	var/delay = 10   // The number of seconds of delay on each shuttle movement.

/obj/machinery/computer/shuttle_control/New()
	..()

	if(!shuttle_tag)
		del(src)
		return

	if(isnull(shuttle_locations[shuttle_tag])) shuttle_locations[shuttle_tag] = location
	if(isnull(shuttle_delays[shuttle_tag])) shuttle_delays[shuttle_tag] = delay
	if(isnull(shuttle_moving[shuttle_tag])) shuttle_moving[shuttle_tag] = 0

/obj/machinery/computer/shuttle_control/attack_hand(user as mob)


	if(..(user))
		return
	src.add_fingerprint(user)
	var/dat

	dat = "<center>[shuttle_tag] Shuttle Control<hr>"

	if(shuttle_moving[shuttle_tag])
		dat += "Location: <font color='red'>Moving</font> <br>"
	else
		dat += "Location: [shuttle_locations[shuttle_tag] ? "Offsite" : "Station"] <br>"

	dat += "<b><A href='?src=\ref[src];move=[1]'>Send</A></b></center>"


	user << browse("[dat]", "window=[shuttle_tag]shuttlecontrol;size=200x150")

/obj/machinery/computer/shuttle_control/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	src.add_fingerprint(usr)
	if(href_list["move"])
		if (!shuttle_moving[shuttle_tag])
			usr << "\blue [shuttle_tag] Shuttle recieved message and will be sent shortly."
			move_shuttle(shuttle_tag,offsite,station)
		else
			usr << "\blue [shuttle_tag] Shuttle is already moving."

	updateUsrDialog()

/obj/machinery/computer/shuttle_control/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if (istype(W, /obj/item/weapon/card/emag))
		src.req_access = list()
		hacked = 1
		usr << "You short out the console's ID checking system. It's now available to everyone!"
	else
		..()

proc/move_shuttle(var/shuttle_tag,var/area/offsite,var/area/station)

	if(!shuttle_tag || isnull(shuttle_locations[shuttle_tag]))
		return

	if(shuttle_moving[shuttle_tag] == 1) return
	shuttle_moving[shuttle_tag] = 1

	spawn(shuttle_delays[shuttle_tag]*10)

		var/list/dstturfs = list()
		var/throwy = world.maxy

		var/area/area_going_to = (shuttle_locations[shuttle_tag] == 1 ? station : offsite)
		var/area/area_coming_from = (shuttle_locations[shuttle_tag] == 1 ? offsite : station)

		for(var/turf/T in area_going_to)
			dstturfs += T
			if(T.y < throwy)
				throwy = T.y

		for(var/turf/T in dstturfs)
			var/turf/D = locate(T.x, throwy - 1, 1)
			for(var/atom/movable/AM as mob|obj in T)
				AM.Move(D)
			if(istype(T, /turf/simulated))
				del(T)

		for(var/mob/living/carbon/bug in area_going_to)
			bug.gib()

		for(var/mob/living/simple_animal/pest in area_going_to)
			pest.gib()

		area_coming_from.move_contents_to(area_going_to)

		shuttle_locations[shuttle_tag] = !shuttle_locations[shuttle_tag]

		for(var/mob/M in area_going_to)
			if(M.client)
				spawn(0)
					if(M.buckled)
						shake_camera(M, 3, 1)
					else
						shake_camera(M, 10, 1)
			if(istype(M, /mob/living/carbon))
				if(!M.buckled)
					M.Weaken(3)

		shuttle_moving[shuttle_tag] = 0

	return