var/engineering_shuttle_tickstomove = 10
var/engineering_shuttle_moving = 0
var/engineering_shuttle_location = 1 //Starts at the construction site.

proc/move_engineering_shuttle()
	if(engineering_shuttle_moving)	return
	engineering_shuttle_moving = 1
	spawn(engineering_shuttle_tickstomove*10)
		var/area/fromArea
		var/area/toArea
		if (engineering_shuttle_location == 1)
			fromArea = locate(/area/shuttle/constructionsite/site)
			toArea = locate(/area/shuttle/constructionsite/station)

		else
			fromArea = locate(/area/shuttle/constructionsite/station)
			toArea = locate(/area/shuttle/constructionsite/site)

		var/list/dstturfs = list()
		var/throwy = world.maxy

		for(var/turf/T in toArea)
			dstturfs += T
			if(T.y < throwy)
				throwy = T.y

		for(var/turf/T in dstturfs)
			var/turf/D = locate(T.x, throwy - 1, 1)
			for(var/atom/movable/AM as mob|obj in T)
				AM.Move(D)
			if(istype(T, /turf/simulated))
				del(T)

		for(var/mob/living/carbon/bug in toArea)
			bug.gib()

		for(var/mob/living/simple_animal/pest in toArea)
			pest.gib()

		fromArea.move_contents_to(toArea)
		if (engineering_shuttle_location)
			engineering_shuttle_location = 0
		else
			engineering_shuttle_location = 1

		for(var/mob/M in toArea)
			if(M.client)
				spawn(0)
					if(M.buckled)
						shake_camera(M, 3, 1)
					else
						shake_camera(M, 10, 1)
			if(istype(M, /mob/living/carbon))
				if(!M.buckled)
					M.Weaken(3)

		engineering_shuttle_moving = 0
	return

/obj/machinery/computer/engineering_shuttle
	name = "engineering shuttle console"
	icon = 'icons/obj/computer.dmi'
	icon_state = "shuttle"
	req_access = list(access_engine)
	circuit = "/obj/item/weapon/circuitboard/engineering_shuttle"
	var/hacked = 0
	var/location = 0

/obj/machinery/computer/engineering_shuttle/attack_hand(user as mob)
	if(..(user))
		return
	src.add_fingerprint(usr)
	var/dat

	dat = "<center>Engineering Shuttle Control<hr>"

	if(engineering_shuttle_moving)
		dat += "Location: <font color='red'>Moving</font> <br>"
	else
		dat += "Location: [engineering_shuttle_location ? "Outpost" : "Station"] <br>"

	dat += "<b><A href='?src=\ref[src];move=[1]'>Send</A></b></center>"


	user << browse("[dat]", "window=engineeringshuttle;size=200x150")

/obj/machinery/computer/engineering_shuttle/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	src.add_fingerprint(usr)
	if(href_list["move"])
		if (!engineering_shuttle_moving)
			usr << "\blue Shuttle recieved message and will be sent shortly."
			move_engineering_shuttle()
		else
			usr << "\blue Shuttle is already moving."

	updateUsrDialog()

/obj/machinery/computer/engineering_shuttle/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if (istype(W, /obj/item/weapon/card/emag))
		src.req_access = list()
		hacked = 1
		usr << "You fried the consoles ID checking system. It's now available to everyone!"
	else
		..()