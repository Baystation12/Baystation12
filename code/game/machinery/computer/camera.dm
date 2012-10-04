//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31


/obj/machinery/computer/security
	name = "Security Cameras"
	desc = "Used to access the various cameras on the station."
	icon_state = "cameras"
	circuit = "/obj/item/weapon/circuitboard/security"
	var/obj/machinery/camera/current = null
	var/last_pic = 1.0
	var/network = "SS13"
	var/mapping = 0//For the overview file, interesting bit of code.


	attack_ai(var/mob/user as mob)
		return attack_hand(user)


	attack_paw(var/mob/user as mob)
		return attack_hand(user)


	check_eye(var/mob/user as mob)
		if ((get_dist(user, src) > 1 || !( user.canmove ) || user.blinded || !( current ) || !( current.status )) && (!istype(user, /mob/living/silicon)))
			return null
		user.reset_view(current)
		return 1


	attack_hand(var/mob/user as mob)
		if (src.z > 6)
			user << "\red <b>Unable to establish a connection</b>: \black You're too far away from the station!"
			return
		if(stat & (NOPOWER|BROKEN))	return

		if(!isAI(user))
			user.machine = src

		var/list/L = list()
		for (var/obj/machinery/camera/C in cameranet.cameras)
			L.Add(C)

		camera_sort(L)

		var/list/D = list()
		D["Cancel"] = "Cancel"
		for(var/obj/machinery/camera/C in L)
			if(C.network == network)
				D[text("[][]", C.c_tag, (C.status ? null : " (Deactivated)"))] = C

		var/t = input(user, "Which camera should you change to?") as null|anything in D
		if(!t)
			user.machine = null
			return 0

		var/obj/machinery/camera/C = D[t]

		if(t == "Cancel")
			user.machine = null
			return 0

		if(C)
			if ((get_dist(user, src) > 1 || user.machine != src || user.blinded || !( user.canmove ) || !( C.can_use() )) && (!istype(user, /mob/living/silicon/ai)))
				if(!C.can_use() && !isAI(user))
					src.current = null
				return 0
			else
				if(isAI(user))
					var/mob/living/silicon/ai/A = user
					A.eyeobj.setLoc(get_turf(C))
					A.client.eye = A.eyeobj
				else
					src.current = C
					use_power(50)

				spawn(5)
					attack_hand(user)
		return



/obj/machinery/computer/security/telescreen
	name = "Telescreen"
	desc = "Used for watching an empty arena."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "telescreen"
	network = "thunder"
	density = 0
	circuit = null

/obj/machinery/computer/security/telescreen/entertainment
	name = "entertainment monitor"
	desc = "Damn, they better have /tg/thechannel on these things."
	icon = 'icons/obj/status_display.dmi'
	icon_state = "entertainment"
	network = "thunder"
	density = 0
	circuit = null


/obj/machinery/computer/security/wooden_tv
	name = "Security Cameras"
	desc = "An old TV hooked into the stations camera network."
	icon_state = "security_det"


/obj/machinery/computer/security/mining
	name = "Outpost Cameras"
	desc = "Used to access the various cameras on the outpost."
	icon_state = "miningcameras"
	network = "MINE"
	circuit = "/obj/item/weapon/circuitboard/mining"
