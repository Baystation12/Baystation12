/obj/machinery/computer/shuttle
	name = "Shuttle"
	desc = "For shuttle control."
	icon_state = "shuttle"
	var/auth_need = 3.0
	var/list/authorized = list(  )


	attackby(var/obj/item/weapon/card/W as obj, var/mob/user as mob)
		if(stat & (BROKEN|NOPOWER))	return
		if ((!( istype(W, /obj/item/weapon/card) ) || !( ticker ) || emergency_shuttle.location != 1 || !( user )))	return
		if (istype(W, /obj/item/weapon/card/id)||istype(W, /obj/item/device/pda))
			if (istype(W, /obj/item/device/pda))
				var/obj/item/device/pda/pda = W
				W = pda.id
			if (!W:access) //no access
				user << "The access level of [W:registered_name]\'s card is not high enough. "
				return

			var/list/cardaccess = W:access
			if(!istype(cardaccess, /list) || !cardaccess.len) //no access
				user << "The access level of [W:registered_name]\'s card is not high enough. "
				return

			if(!(access_heads in W:access)) //doesn't have this access
				user << "The access level of [W:registered_name]\'s card is not high enough. "
				return 0

			var/choice = alert(user, text("Would you like to (un)authorize a shortened launch time? [] authorization\s are still needed. Use abort to cancel all authorizations.", auth_need - authorized.len), "Shuttle Launch", "Authorize", "Repeal", "Abort")
			switch(choice)
				if("Authorize")
					authorized -= W:registered_name
					authorized += W:registered_name
					if (auth_need - authorized.len > 0)
						message_admins("[key_name_admin(user)] has authorized early shuttle launch")
						log_game("[user.ckey] has authorized early shuttle launch")
						world << text("\blue <B>Alert: [] authorizations needed until shuttle is launched early</B>", auth_need - authorized.len)
					else
						message_admins("[key_name_admin(user)] has launched the shuttle")
						log_game("[user.ckey] has launched the shuttle early")
						world << "\blue <B>Alert: Shuttle launch time shortened to 10 seconds!</B>"
						emergency_shuttle.settimeleft(10)
						authorized = list(  )

				if("Repeal")
					authorized -= W:registered_name
					world << text("\blue <B>Alert: [] authorizations needed until shuttle is launched early</B>", auth_need - authorized.len)

				if("Abort")
					world << "\blue <B>All authorizations to shorting time for shuttle launch have been revoked!</B>"
					authorized = list(  )

/*		else if (istype(W, /obj/item/weapon/card/emag))
			var/choice = alert(user, "Would you like to launch the shuttle?","Shuttle control", "Launch", "Cancel")
			switch(choice)
				if("Launch")
					world << "\blue <B>Alert: Shuttle launch time shortened to 10 seconds!</B>"
					emergency_shuttle.settimeleft( 10 )
				if("Cancel")
					return*/
		return
/obj/machinery/computer/shuttle/departure
	name = "\improper Departure Shuttle Control Computer"
	desc = "Controls when the shuttle leaves for CentCom."
	icon_state = "shuttle"
	var/next_departure = 0
	var/departure_time = null
	var/querying_mobs = 0
	var/list/queried_mobs = list()

	New()
		next_departure = (world.timeofday + 6000)
		if(next_departure >= 864000)
			next_departure -= 864000
		return ..()

	attack_hand(mob/user as mob)
		if(..())
			return
		if(get_time())
			user << "The shuttle is refueling.  Please wait [time2text(get_time(),"mm:ss")] minutes."
			return
		if(!isnull(departure_time) || querying_mobs)
			user << "The shuttle is already departing.  Departure in [time2text(count_down(),"mm:ss")] minutes."
			return
		switch(alert("Would you like to return to Central Command?","Departure Shuttle Control","Yes","No"))
			if("No")
				return
			if("Yes")
				departure_time = (world.timeofday + 600 > 864000 ? (864000 - world.timeofday) + 600 : world.timeofday + 600)
				world << "<hr><b>Alert!  Departure Shuttle launching in [time2text(count_down(),"mm:ss")] minutes!</b></hr>"
				spawn depart()

	proc/get_time()
		if(next_departure < world.timeofday && (world.timeofday + next_departure) >= 864000)
			return 864000 - (world.timeofday + next_departure)
		else if (next_departure > world.timeofday)
			return next_departure - world.timeofday
		else
			return 0

	proc/count_down()
		if(departure_time < world.timeofday && (world.timeofday + departure_time) >= 864000)
			return 864000 - (world.timeofday + departure_time)
		else if (departure_time > world.timeofday)
			return departure_time - world.timeofday
		else
			return 0

	proc/depart()
		var/list/message_tracker = list(0,50,300,600)
		var/obj/item/device/radio/intercom/announcer = new /obj/item/device/radio/intercom(null)
		while(count_down())
			var/timeleft = count_down()
			if(round(timeleft,10) in message_tracker)
				announcer.autosay("states, \"[time2text(timeleft, "mm:ss")] minutes until launch!\"", "Departure Shuttle Computer")
				message_tracker.Remove(round(timeleft,10))
				if(round(timeleft,10) == 0)
					break
			sleep(5)
		del(announcer)
		querying_mobs = 1
		var/area/shuttle = get_area(src)
		if(!shuttle || !istype(shuttle, /area/shuttle/departure))
			message_admins("WARNING!  Departure shuttle cannot be found!  Cancelling...")
			return
		for(var/obj/machinery/door/D in shuttle)
			spawn(0)
				D.close()
				D.operating = -1 //Emags closed.  Hackish.
		for(var/mob/living/M in shuttle)
			if((!M.client /*&& */) || (M.client && M.client.inactivity >= 6000)) //AFK for 10 minutes or more.
				queried_mobs += "1"
//			else if(!M.client) //AFK for not enough time, votes to stay.
//				queried_mobs += 0
			else
				queried_mobs += "0"
				spawn query_mob(M, queried_mobs.len)//ASk if they want to leave.
		var/time_to_wait = world.timeofday + 300
		if(time_to_wait > 864000)
			time_to_wait -= 864000
		while(time_to_wait + world.timeofday < 864000 || world.timeofday < time_to_wait)
			if(queried_mobs.Find("0"))
				sleep(5)
			else
				break
		querying_mobs = 0
		if(!queried_mobs.Find("0"))
			for(var/mob/living/M in shuttle)
				remove_manifest(M)
				M.timeofdeath = world.timeofday - 24000 //Let them respawn in 20 minutes
				if(M.timeofdeath < 0)
					M.timeofdeath += 864000
				if(M.client)
					M << "\red <b>You may respawn in 20 minutes.</b>"
				del(M)
		else
			world << "<hr>Departure Shuttle launch canceled.</hr>"
		queried_mobs = list()
		for(var/obj/machinery/door/D in shuttle)
			spawn(0)
				D.operating = 0
		departure_time = null
		next_departure = (world.timeofday + 6000)
		if(next_departure >= 864000)
			next_departure -= 864000

	proc/query_mob(var/mob/living/M as mob, var/index)
		switch(alert(M,"Do you wish to leave the game for good?","OOC Query via Departure Shuttle","Yes","NO"))
			if("Yes")
				if(querying_mobs)
					queried_mobs[index] = "1"
				else
					M << "Too late!"
			if("NO")
				if(!querying_mobs)
					M << "Too late to choose!"
		return

	proc/remove_manifest(var/mob/living/M as mob)
		if (data_core)
			for(var/datum/data/record/G in data_core.general)
				if(G.fields["name"] == M.original_name)
					data_core.general.Remove(G)
					del(G)
					break
			for(var/datum/data/record/G in data_core.medical)
				if(G.fields["name"] == M.original_name)
					data_core.medical.Remove(G)
					del(G)
					break
			for(var/datum/data/record/G in data_core.security)
				if(G.fields["name"] == M.original_name)
					data_core.security.Remove(G)
					del(G)
					break
		return