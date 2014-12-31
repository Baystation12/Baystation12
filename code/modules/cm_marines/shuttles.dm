/**********************Shuttle Computers**************************/

var/marine_a_shuttle_tickstomove = 10
var/marine_b_shuttle_tickstomove = 10
var/marine_a_shuttle_moving = 0
var/marine_b_shuttle_moving = 0
var/marine_a_shuttle_location = 0
var/marine_b_shuttle_location = 0

proc/move_marine_a_shuttle()
	if(marine_a_shuttle_moving)	return
	marine_a_shuttle_moving = 1
	spawn(marine_a_shuttle_tickstomove*10)
		var/area/fromArea
		var/area/toArea
		if (marine_a_shuttle_location == 1)
			fromArea = locate(/area/shuttle/marine_a/station)
			toArea = locate(/area/shuttle/marine_a/sulaco)

		else
			fromArea = locate(/area/shuttle/marine_a/sulaco)
			toArea = locate(/area/shuttle/marine_a/station)

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
		if (marine_a_shuttle_location)
			marine_a_shuttle_location = 0
		else
			marine_a_shuttle_location = 1

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

		marine_a_shuttle_moving = 0
	return

proc/move_marine_b_shuttle()
	if(marine_b_shuttle_moving)	return
	marine_b_shuttle_moving = 1
	spawn(marine_b_shuttle_tickstomove*10)
		var/area/fromArea
		var/area/toArea
		if (marine_b_shuttle_location == 1)
			fromArea = locate(/area/shuttle/marine_b/station)
			toArea = locate(/area/shuttle/marine_b/sulaco)
		else
			fromArea = locate(/area/shuttle/marine_b/sulaco)
			toArea = locate(/area/shuttle/marine_b/station)

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
		if (marine_b_shuttle_location)
			marine_b_shuttle_location = 0
		else
			marine_b_shuttle_location = 1

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

		marine_b_shuttle_moving = 0
	return

/obj/machinery/computer/marine_a_shuttle
	name = "marine transport shuttle one console"
	icon = 'icons/obj/computer.dmi'
	icon_state = "shuttle"
	req_access = list(access_security)
	circuit = "/obj/item/weapon/circuitboard/marine_a_shuttle"
	var/hacked = 0
	var/location = 0
	var/disabled = 0

/obj/machinery/computer/marine_a_shuttle/attack_paw(user as mob)
	if(..(user))
		return

	if(world.time < 32000)
		user << "\red You can not use this yet. Please wait another [round((32000-world.time)/600)] minutes before trying again."
		return
	if(istype(user,/mob/living/carbon/alien) && !istype(user,/mob/living/carbon/alien/humanoid/queen))
		user << "\red You can't understand the markings. Only the queen can access this"
		return
	if(disabled)
		user << "This shuttle has been disabled."
		return
	src.add_fingerprint(usr)
	var/dat

	dat = "<center>Marine Transport Shuttle Two Control<hr>"

	if(marine_b_shuttle_moving)
		dat += "Location: <font color='red'>Moving</font> <br>"
	else
		dat += "Location: [mining_shuttle_location ? "Station" : "Sulaco"] <br>"

	dat += "<b><A href='?src=\ref[src];move=[1]'>Send</A></b></center>"


	user << browse("[dat]", "window=miningshuttle;size=200x150")



/obj/machinery/computer/marine_a_shuttle/attack_hand(user as mob)
	if(..(user))
		return

	if(disabled)
		user << "This shuttle has been disabled."
		return

	src.add_fingerprint(usr)
	var/dat

	dat = "<center>Marine Transport Shuttle One Control<hr>"

	if(marine_a_shuttle_moving)
		dat += "Location: <font color='red'>Moving</font> <br>"
	else
		dat += "Location: [mining_shuttle_location ? "Station" : "Sulaco"] <br>"

	dat += "<b><A href='?src=\ref[src];move=[1]'>Send</A></b></center>"


	user << browse("[dat]", "window=miningshuttle;size=200x150")

/obj/machinery/computer/marine_a_shuttle/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	src.add_fingerprint(usr)
	if(href_list["move"])

		if (!marine_a_shuttle_moving)
			usr << "\blue Shuttle recieved message and will be sent shortly."
			move_marine_a_shuttle()
		else
			usr << "\blue Shuttle is already moving."

	updateUsrDialog()

/obj/machinery/computer/marine_a_shuttle/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if (istype(W, /obj/item/weapon/card/emag))
		src.req_access = list()
		hacked = 1
		usr << "You fried the consoles ID checking system. It's now available to everyone!"

	else if(istype(W, /obj/item/weapon/screwdriver))
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		if(do_after(user, 20))
			var/obj/structure/computerframe/A = new /obj/structure/computerframe( src.loc )
			var/obj/item/weapon/circuitboard/marine_a_shuttle/M = new /obj/item/weapon/circuitboard/marine_a_shuttle( A )
			for (var/obj/C in src)
				C.loc = src.loc
			A.circuit = M
			A.anchored = 1

			if (src.stat & BROKEN)
				user << "\blue The broken glass falls out."
				new /obj/item/weapon/shard( src.loc )
				A.state = 3
				A.icon_state = "3"
			else
				user << "\blue You disconnect the monitor."
				A.state = 4
				A.icon_state = "4"

			del(src)

/obj/machinery/computer/marine_b_shuttle
	name = "marine transport shuttle two console"
	icon = 'icons/obj/computer.dmi'
	icon_state = "shuttle"
	req_access = list(access_security)
	circuit = "/obj/item/weapon/circuitboard/marine_b_shuttle"
	var/hacked = 0
	var/location = 0
	var/disabled = 0

/obj/machinery/computer/marine_b_shuttle/attack_paw(user as mob)
	if(..(user))
		return

	if(world.time < 32000)
		user << "\red You can not use this yet. Please wait another [round((32000-world.time)/600)] minutes before trying again."
		return

	if(disabled)
		user << "This shuttle has been disabled."
		return

	src.add_fingerprint(usr)

	var/dat

	dat = "<center>Marine Transport Shuttle Two Control<hr>"

	if(marine_b_shuttle_moving)
		dat += "Location: <font color='red'>Moving</font> <br>"
	else
		dat += "Location: [mining_shuttle_location ? "Station" : "Sulaco"] <br>"

	dat += "<b><A href='?src=\ref[src];move=[1]'>Send</A></b></center>"


	user << browse("[dat]", "window=miningshuttle;size=200x150")


/obj/machinery/computer/marine_b_shuttle/attack_hand(user as mob)
	if(..(user))
		return

	if(disabled)
		user << "This shuttle has been disabled."
		return

	src.add_fingerprint(usr)
	var/dat

	dat = "<center>Marine Transport Shuttle Two Control<hr>"

	if(marine_b_shuttle_moving)
		dat += "Location: <font color='red'>Moving</font> <br>"
	else
		dat += "Location: [mining_shuttle_location ? "Station" : "Sulaco"] <br>"

	dat += "<b><A href='?src=\ref[src];move=[1]'>Send</A></b></center>"


	user << browse("[dat]", "window=miningshuttle;size=200x150")

/obj/machinery/computer/marine_b_shuttle/Topic(href, href_list)
	if(..())
		return

	usr.set_machine(src)
	src.add_fingerprint(usr)
	if(href_list["move"])

		if (!marine_b_shuttle_moving)
			usr << "\blue Shuttle recieved message and will be sent shortly."
			move_marine_b_shuttle()
		else
			usr << "\blue Shuttle is already moving."

	updateUsrDialog()

/obj/machinery/computer/marine_b_shuttle/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if (istype(W, /obj/item/weapon/card/emag))
		src.req_access = list()
		hacked = 1
		usr << "You fried the consoles ID checking system. It's now available to everyone!"

	else if(istype(W, /obj/item/weapon/screwdriver))
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		if(do_after(user, 20))
			var/obj/structure/computerframe/A = new /obj/structure/computerframe( src.loc )
			var/obj/item/weapon/circuitboard/marine_b_shuttle/M = new /obj/item/weapon/circuitboard/marine_b_shuttle( A )
			for (var/obj/C in src)
				C.loc = src.loc
			A.circuit = M
			A.anchored = 1

			if (src.stat & BROKEN)
				user << "\blue The broken glass falls out."
				new /obj/item/weapon/shard( src.loc )
				A.state = 3
				A.icon_state = "3"
			else
				user << "\blue You disconnect the monitor."
				A.state = 4
				A.icon_state = "4"

			del(src)

/obj/item/weapon/circuitboard/marine_a_shuttle
	name = "Circuit board (Marine Transport Shuttle One)"
	build_path = "/obj/machinery/computer/marine_a_shuttle"
	origin_tech = "programming=2"

/obj/item/weapon/circuitboard/marine_b_shuttle
	name = "Circuit board (Marine Transport Shuttle Two)"
	build_path = "/obj/machinery/computer/marine_b_shuttle"
	origin_tech = "programming=2"

/******************************End*******************************/

/******************************Alien shuttle console*******************************/
var/alien_shuttle_moving = 0
var/alien_shuttle_location = 0
var/alien_shuttle_tickstomove = 10

proc/move_unknown_shuttle()
	var/area/fromArea
	var/area/toArea
	if (alien_shuttle_location == 1)
		fromArea = locate(/area/shuttle/alien/base)
		toArea = locate(/area/shuttle/alien/mine)
	else
		fromArea = locate(/area/shuttle/alien/mine)
		toArea = locate(/area/shuttle/alien/base)
	fromArea.move_contents_to(toArea)
	if (alien_shuttle_location)
		alien_shuttle_location = 0
	else
		alien_shuttle_location = 1
	return

/obj/machinery/computer/alien_shuttle
	name = "unknown console"
	icon = 'icons/obj/computer.dmi'
	icon_state = "shuttle"
	req_access = list()
	circuit = "/obj/item/weapon/circuitboard/marine_b_shuttle"
	var/hacked = 0
	var/location = 0
	var/disabled = 0


/obj/machinery/computer/alien_shuttle/bullet_act()
	return

/obj/machinery/computer/alien_shuttle/attack_paw(user as mob)
	if(disabled)
		user << "\red This shuttle has been disabled."
		return

	if(!istype(user, /mob/living/carbon/alien))
		user << "\red Your species can not use this console."
		return

	//if(world.time < 32000)
	//	user << "The shuttle engines are being prepared. Please wait another [round((32000-world.time)/600)] minutes before trying again."
	//	return

	if(..(user))
		return
	src.add_fingerprint(usr)
	var/dat

	dat = "<center>Unknown Transport Control<hr>"

	if(alien_shuttle_moving)
		dat += "Location: <font color='red'>Moving</font> <br>"
	else
		dat += "Location: [alien_shuttle_location ? "Station" : "Sulaco"] <br>"

	dat += "<b><A href='?src=\ref[src];move=[1]'>Send</A></b></center>"

	user << browse("[dat]", "window=miningshuttle;size=200x150")


/obj/machinery/computer/alien_shuttle/attack_hand(user as mob)
	if(!istype(user, /mob/living/carbon/alien))
		user << "\red Your species can not use this console."
		return

/obj/machinery/computer/alien_shuttle/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	src.add_fingerprint(usr)
	if(href_list["move"])

		if (!alien_shuttle_moving)
			usr << "\blue Shuttle recieved message and will be sent shortly."
			move_unknown_shuttle()
		else
			usr << "\blue Shuttle is already moving."

	updateUsrDialog()
