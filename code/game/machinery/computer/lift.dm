/obj/machinery/computer3/lift
	name = ""
	desc = "Allows you to select which floor you would like to go to."
	icon = 'icons/obj/computer.dmi'
	icon_state = "wallframe"
	show_keyboard = 0
	default_prog	= /datum/file/program/lift
	spawn_parts		= list(/obj/item/part/computer/lift) //NO HDD - the game is loaded on the circuitboard's OS slot

/obj/item/part/computer/lift

/datum/file/program/lift
	name = "Lift Control"
	desc = "Program to allow movement between floors"
	active_state = "power"
	var/currentfloor = null
	var/floor = null
	var/global/liftposition = 1
	var/global/ismoving = 1

/datum/file/program/lift/interact()
	currentfloor = computer.z
	switch(currentfloor)
		if (1)
			floor = " Civilian Level (1)"
		if (7)
			floor = " Command Level (2)"
		if (8)
			floor = " Basement Level (0)"
	if(!interactable())
		return
	var/dat// = topic_link(src,"close","Close")
	if (ismoving == 1)
		dat = "<center><h4>Lift currently moving..</b<</h4></center>"
	else
		dat = "<center><h4>You are currently on:<b>[floor]</b<</h4></center>"

	dat += "<br><center><h3>Control Panel</h3></center>"
	if (istype(computer.loc.loc, /area/lift))
		dat += "<center><b>[topic_link(src,"upwards","Go Upwards")] | [topic_link(src,"downwards","Go Downwards")] | [topic_link(src,"doors","Force Open Door")]"
	else
		dat += "<center><b>[topic_link(src,"call","Call Lift")]"
	dat += "</b></center>"

	popup.set_content(dat)
	popup.open()

/datum/file/program/lift/Topic(href, list/href_list)
	if(!interactable() || ..(href,href_list))
		return
	if (ismoving == 0)
		if ("upwards" in href_list)
			if(ismoving == 1)
				usr << "Lift is currently moving please wait and try again."
				return
			ismoving = 1
			var/area/start_location = null
			var/area/end_location = null
			if (computer.z == 7)
				usr << "You are already on the top floor"
				return
			if (computer.z == 8)
				start_location = locate(/area/lift/lower)
				end_location = locate(/area/lift/ground)
				liftposition = 1

			if (computer.z == 1)
				start_location = locate(/area/lift/ground)
				end_location = locate(/area/lift/upper)
				liftposition = 2

			for(var/obj/machinery/door/airlock/silver/lift/D in world)
				spawn(0)
					D.locked = 0
					D.close()
					D.locked = 1
					D.icon_state = "door_locked"

			spawn(50)

			start_location.move_contents_to(end_location, null, EAST)
			sleep(50)
			var/area/toplevel = locate(/area/lift/upper)
			for(var/turf/T in start_location)
				if(T.z == 8)
					T:ChangeTurf(/turf/simulated/floor)
					T.icon_state = "elevatorshaft"

			if (liftposition == 0)
				for(var/turf/T in toplevel)
					T:ChangeTurf(/turf/simulated/floor)
					T.icon_state = "elevatorshaft"
			if (liftposition == 1)
				for(var/turf/T in toplevel)
					T:ChangeTurf(/turf/simulated/floor/open)

			for(var/obj/machinery/door/airlock/D in range(4))
				spawn(0)
					D.locked = 0
					D.open()
					D.locked = 1

			for(var/mob/M in end_location)
				if(M.client)
					spawn(0)
						shake_camera(M, 4, 1) // buckled, not a lot of shaking
			computer.updateUsrDialog()
			interact()
			ismoving = 0

		else if ("downwards" in href_list)
			if(ismoving == 1)
				usr << "Lift is currently moving please wait and try again."
				return
			ismoving = 1
			var/area/start_location = null
			var/area/end_location = null
			if (computer.z == 7)
				start_location = locate(/area/lift/upper)
				end_location = locate(/area/lift/ground)
				liftposition = 1

			if (computer.z == 8)
				usr << "You are already on the bottom floor."
				return
			if (computer.z == 1)
				start_location = locate(/area/lift/ground)
				end_location = locate(/area/lift/lower)
				liftposition = 0

			for(var/obj/machinery/door/airlock/silver/lift/D in world)
				spawn(0)
					D.locked = 0
					D.close()
					D.locked = 1
					D.icon_state = "door_locked"
			for(var/mob/M in end_location)
				M << "An Elevator is coming down! It's going to crush you!"
				spawn(20)
					M.gib()

			spawn(50)
			start_location.move_contents_to(end_location, null, EAST)

			sleep(50)
			var/area/toplevel = locate(/area/lift/upper)
			if (liftposition == 0)
				for(var/turf/T in toplevel)
					T:ChangeTurf(/turf/simulated/floor)
					T.icon_state = "elevatorshaft"
			if (liftposition == 1)
				for(var/turf/T in toplevel)
					T:ChangeTurf(/turf/simulated/floor/open)

			for(var/obj/machinery/door/airlock/D in range(4))
				spawn(0)
					D.locked = 0
					D.open()
					D.locked = 1

			for(var/mob/M in end_location)
				if(M.client)
					spawn(0)
						shake_camera(M, 4, 1) // buckled, not a lot of shaking
			computer.updateUsrDialog()
			spawn(20)
			interact()
			ismoving = 0

		else if ("call" in href_list)
			if(ismoving == 1)
				usr << "Lift is currently moving, please wait and try again."
			var/area/start_location = null
			var/area/end_location = null
			if(liftposition == 0)
				if (computer.z == 1)
					start_location = locate(/area/lift/lower)
					end_location = locate(/area/lift/ground)
					liftposition = 1

				if (computer.z == 7)
					start_location = locate(/area/lift/lower)
					end_location = locate(/area/lift/upper)
					liftposition = 2
				else
					return

			if(liftposition == 1)
				if (computer.z == 8)
					start_location = locate(/area/lift/ground)
					end_location = locate(/area/lift/lower)
					liftposition = 0

				if (computer.z == 7)
					start_location = locate(/area/lift/ground)
					end_location = locate(/area/lift/upper)
					liftposition = 2

			if(liftposition == 2)
				if (computer.z == 8)
					start_location = locate(/area/lift/upper)
					end_location = locate(/area/lift/lower)
					liftposition = 1

				if (computer.z == 1)
					start_location = locate(/area/lift/upper)
					end_location = locate(/area/lift/ground)
					liftposition = 2

			for(var/obj/machinery/door/airlock/silver/lift/D in world)
				spawn(0)
					D.locked = 0
					D.close()
					D.locked = 1
					D.icon_state = "door_locked"
			for(var/mob/M in end_location)
				M << "An Elevator is coming down! It's going to crush you!"
				spawn(20)
					M.gib()

			spawn(50)
			start_location.move_contents_to(end_location, null, EAST)

			sleep(50)
			for(var/turf/T in start_location)
				T:ChangeTurf(/turf/simulated/floor)
				T.icon_state = "elevatorshaft"

			for(var/obj/machinery/door/airlock/D in range(4))
				spawn(0)
					D.locked = 0
					D.open()
					D.locked = 1

			for(var/mob/M in end_location)
				if(M.client)
					spawn(0)
						shake_camera(M, 4, 1) // buckled, not a lot of shaking
			computer.updateUsrDialog()
			spawn(20)
			interact()
			ismoving = 0


	if ("doors" in href_list) //Doors!
		for(var/obj/machinery/door/airlock/D in range(4))
			spawn(0)
				D.locked = 0
				D.open()
				D.locked = 1
		computer.updateUsrDialog()
		interact()