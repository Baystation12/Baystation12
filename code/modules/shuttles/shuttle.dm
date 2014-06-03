//These lists are populated in /obj/machinery/computer/shuttle_control/New()
//Shuttle controller is instantiated in master_controller.dm.

var/global/datum/shuttle_controller/shuttles

/datum/shuttle_controller //This isn't really a controller...
	var/list/locations = list()
	var/list/delays = list()
	var/list/moving = list()
	var/list/areas_offsite = list()
	var/list/areas_station = list()

/datum/shuttle_controller/New()

	..()

	// Admin shuttles.
	locations["Centcom"] = 1
	delays["Centcom"] = 0
	moving["Centcom"] = 0
	areas_offsite["Centcom"] = locate(/area/shuttle/transport1/centcom)
	areas_station["Centcom"] = locate(/area/shuttle/transport1/station)

	locations["Administration"] = 1
	delays["Administration"] = 0
	moving["Administration"] = 0
	areas_offsite["Administration"] = locate(/area/shuttle/administration/centcom)
	areas_station["Administration"] = locate(/area/shuttle/administration/station)

	locations["Alien"] = 0
	delays["Alien"] = 0
	moving["Alien"] = 0
	areas_offsite["Alien"] = locate(/area/shuttle/alien/base)
	areas_station["Alien"] = locate(/area/shuttle/alien/mine)

	// Public shuttles.
	locations["Engineering"] = 1
	delays["Engineering"] = 10
	moving["Engineering"] = 0
	areas_offsite["Engineering"] = locate(/area/shuttle/constructionsite/site)
	areas_station["Engineering"] =  locate(/area/shuttle/constructionsite/station)

	locations["Mining"] = 0
	delays["Mining"] = 10
	moving["Mining"] = 0
	areas_offsite["Mining"] = locate(/area/shuttle/mining/outpost)
	areas_station["Mining"] = locate(/area/shuttle/mining/station)

	locations["Research"] = 0
	delays["Research"] = 10
	moving["Research"] = 0
	areas_offsite["Research"] = locate(/area/shuttle/research/outpost)
	areas_station["Research"] = locate(/area/shuttle/research/station)

/obj/machinery/computer/shuttle_control
	name = "shuttle console"
	icon = 'icons/obj/computer.dmi'
	icon_state = "shuttle"
	req_access = list(access_engine)
	circuit = "/obj/item/weapon/circuitboard/engineering_shuttle"

	var/shuttle_tag  // Used to coordinate data in shuttle controller.
	var/hacked = 0   // Has been emagged, no access restrictions.

/obj/machinery/computer/shuttle_control/attack_hand(user as mob)

	if(..(user))
		return
	src.add_fingerprint(user)
	var/dat

	dat = "<center>[shuttle_tag] Shuttle Control<hr>"

	if(shuttles.moving[shuttle_tag])
		dat += "Location: <font color='red'>Moving</font> <br>"
	else
		dat += "Location: [shuttles.locations[shuttle_tag] ? "Offsite" : "Station"] <br>"

	dat += "<b><A href='?src=\ref[src];move=[1]'>Send</A></b></center>"


	user << browse("[dat]", "window=[shuttle_tag]shuttlecontrol;size=200x150")

/obj/machinery/computer/shuttle_control/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	src.add_fingerprint(usr)
	if(href_list["move"])
		if (!shuttles.moving[shuttle_tag])
			usr << "\blue [shuttle_tag] Shuttle recieved message and will be sent shortly."
			move_shuttle(shuttle_tag)
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

	if(!shuttle_tag || isnull(shuttles.locations[shuttle_tag]))
		return

	if(shuttles.moving[shuttle_tag] == 1) return
	shuttles.moving[shuttle_tag] = 1

	spawn(shuttles.delays[shuttle_tag]*10)

		var/list/dstturfs = list()
		var/throwy = world.maxy

		var/area/area_going_to = (shuttles.locations[shuttle_tag] == 1 ? shuttles.areas_station[shuttle_tag] : shuttles.areas_offsite[shuttle_tag])
		var/area/area_coming_from = (shuttles.locations[shuttle_tag] == 1 ? shuttles.areas_offsite[shuttle_tag] : shuttles.areas_station[shuttle_tag])

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

		shuttles.locations[shuttle_tag] = !shuttles.locations[shuttle_tag]

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

		shuttles.moving[shuttle_tag] = 0

	return