<<<<<<< HEAD
//config stuff
#define SYNDICATE_DOCKZ 5          //Z-level of the Dock.
#define SYNDICATE_STATIONZ 1       //Z-level of the Station.
#define SYNDICATE_MOVETIME 150	//Time to station is milliseconds.
#define SYNDICATE_STATION_AREATYPE "/area/syndicate_station/start" //Type of for station
#define SYNDICATE_DOCK_AREATYPE 0	//Type of area for dock

var/syndicate_station_moving_to_station = 0
var/syndicate_station_moving_to_space = 0
var/syndicate_station_at_station = 0
var/syndicate_station_can_send = 1
var/syndicate_station_time = 0
var/syndicate_station_timeleft = 0
var/area/syndicate_loc = null
var/syndicate_out_of_moves = 0
var/bomb_set = 1

/obj/machinery/computer/syndicate_station
	name = "Syndicate Station Terminal"
	icon = 'icons/obj/computer.dmi'
	icon_state = "syndishuttle"
	req_access = list()
	var/temp = null
	var/hacked = 0
	var/allowedtocall = 0
	var/syndicate_break = 0

/proc/syndicate_begin()
	switch(rand(1,6))
		if(1)
			syndicate_loc = locate(/area/syndicate_station/one)
		if(2)
			syndicate_loc = locate(/area/syndicate_station/two)
		if(3)
			syndicate_loc = locate(/area/syndicate_station/three)
		if(4)
			syndicate_loc = locate(/area/syndicate_station/four)
		if(5)
			syndicate_loc = locate(/area/syndicate_station/five)
		if(6)
			syndicate_loc = locate(/area/syndicate_station/six)

/proc/syndicate_process()
	while(syndicate_station_time - world.timeofday > 0)
		var/ticksleft = syndicate_station_time - world.timeofday

		if(ticksleft > 1e5)
			syndicate_station_time = world.timeofday + 10	// midnight rollover


		syndicate_station_timeleft = (ticksleft / 10)
		sleep(5)
	syndicate_station_moving_to_station = 0
	syndicate_station_moving_to_space = 0

	switch(syndicate_station_at_station)
		if(0)
			syndicate_station_at_station = 1
			if (syndicate_station_moving_to_station || syndicate_station_moving_to_space) return

			if (!syndicate_can_move())
				usr << "\red The syndicate shuttle is unable to leave."
				return

			var/area/start_location = locate(/area/syndicate_station/start)
			var/area/end_location = syndicate_loc

			var/list/dstturfs = list()
			var/throwy = world.maxy

			for(var/turf/T in end_location)
				dstturfs += T
				if(T.y < throwy)
					throwy = T.y

						// hey you, get out of the way!
			for(var/turf/T in dstturfs)
							// find the turf to move things to
				var/turf/D = locate(T.x, throwy - 1, 1)
							//var/turf/E = get_step(D, SOUTH)
				for(var/atom/movable/AM as mob|obj in T)
					AM.Move(D)
				if(istype(T, /turf/simulated))
					del(T)

			start_location.move_contents_to(end_location)
			bomb_set = 0



		if(1)
			syndicate_station_at_station = 0
			if (syndicate_station_moving_to_station || syndicate_station_moving_to_space) return

			if (!syndicate_can_move())
				usr << "\red The syndicate shuttle is unable to leave."
				return

			var/area/start_location = syndicate_loc
			var/area/end_location = locate(/area/syndicate_station/start)

			var/list/dstturfs = list()
			var/throwy = world.maxy

			for(var/turf/T in end_location)
				dstturfs += T
				if(T.y < throwy)
					throwy = T.y

						// hey you, get out of the way!
			for(var/turf/T in dstturfs)
							// find the turf to move things to
				var/turf/D = locate(T.x, throwy - 1, 1)
							//var/turf/E = get_step(D, SOUTH)
				for(var/atom/movable/AM as mob|obj in T)
					AM.Move(D)
				if(istype(T, /turf/simulated))
					del(T)

			start_location.move_contents_to(end_location)
			syndicate_out_of_moves = 1

/proc/syndicate_can_move()
	//world << "moving_to_station = [syndicate_station_moving_to_station]; moving_to_space = [syndicate_station_moving_to_space]; out_of_moves = [syndicate_out_of_moves]; bomb_set = [bomb_set]; "
	if(syndicate_station_moving_to_station || syndicate_station_moving_to_space) return 0
	if(syndicate_out_of_moves) return 0
	if(!bomb_set) return 0
	else return 1

/obj/machinery/computer/syndicate_station/attackby(I as obj, user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/syndicate_station/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/syndicate_station/attack_paw(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/syndicate_station/attackby(I as obj, user as mob)
	if(istype(I,/obj/item/weapon/card/emag))
		user << "\blue Nothing happens."
	else
		return src.attack_hand(user)

/obj/machinery/computer/syndicate_station/attack_hand(var/mob/user as mob)
	if(!src.allowed(user))
		user << "\red Access Denied."
		return

	if(syndicate_break)
		user << "\red Unable to locate shuttle."
		return

	if(..())
		return
	user.machine = src
	var/dat
	if (src.temp)
		dat = src.temp
	else
		dat += {"<BR><B>Syndicate Shuttle</B><HR>
		\nLocation: [syndicate_station_moving_to_station || syndicate_station_moving_to_space ? "Moving to station ([syndicate_station_timeleft] Secs.)":syndicate_station_at_station ? "Station":"Space"]<BR>
		[syndicate_station_moving_to_station || syndicate_station_moving_to_space ? "\n*Shuttle already called*<BR>\n<BR>":syndicate_station_at_station ? "\n<A href='?src=\ref[src];sendtospace=1'>Send to space</A><BR>\n<BR>":"\n<A href='?src=\ref[src];sendtostation=1'>Send to station</A><BR>\n<BR>"]
		\n<A href='?src=\ref[user];mach_close=computer'>Close</A>"}

	user << browse(dat, "window=computer;size=575x450")
	onclose(user, "computer")
	return

/obj/machinery/computer/syndicate_station/Topic(href, href_list)
	if(..())
		return

	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.machine = src

	if (href_list["sendtospace"])
		if(!syndicate_station_at_station|| syndicate_station_moving_to_station || syndicate_station_moving_to_space) return

		if (!syndicate_can_move())
			usr << "\red The syndicate shuttle is unable to leave."
			return

		usr << "\blue The syndicate shuttle will move in [(PRISON_MOVETIME/10)] seconds."

		src.temp += "Shuttle sent.<BR><BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
		src.updateUsrDialog()

		syndicate_station_moving_to_space = 1

		syndicate_station_time = world.timeofday + SYNDICATE_MOVETIME
		spawn(0)
			syndicate_process()

	else if (href_list["sendtostation"])
		if(syndicate_station_at_station || syndicate_station_moving_to_station || syndicate_station_moving_to_space) return

		if (!syndicate_can_move())
			usr << "\red The syndicate shuttle is unable to leave."
			return

		usr << "\blue The syndicate shuttle will move in [(SYNDICATE_MOVETIME/10)] seconds."

		src.temp += "Shuttle sent.<BR><BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
		src.updateUsrDialog()

		syndicate_station_moving_to_station = 1

		syndicate_station_time = world.timeofday + SYNDICATE_MOVETIME
		spawn(0)
			syndicate_process()

	else if (href_list["mainmenu"])
		src.temp = null

	src.add_fingerprint(usr)
	src.updateUsrDialog()
	return
=======
#define SYNDICATE_SHUTTLE_MOVE_TIME 240
#define SYNDICATE_SHUTTLE_COOLDOWN 200

/obj/machinery/computer/syndicate_station
	name = "syndicate shuttle terminal"
	icon = 'icons/obj/computer.dmi'
	icon_state = "syndishuttle"
	req_access = list()
	var/area/curr_location
	var/moving = 0
	var/lastMove = 0


/obj/machinery/computer/syndicate_station/New()
	curr_location= locate(/area/syndicate_station/start)


/obj/machinery/computer/syndicate_station/proc/syndicate_move_to(area/destination as area)
	if(moving)	return
	if(lastMove + SYNDICATE_SHUTTLE_COOLDOWN > world.time)	return
	var/area/dest_location = locate(destination)
	if(curr_location == dest_location)	return

	moving = 1
	lastMove = world.time

	if(curr_location.z != dest_location.z)
		var/area/transit_location = locate(/area/syndicate_station/transit)
		curr_location.move_contents_to(transit_location)
		curr_location = transit_location
		sleep(SYNDICATE_SHUTTLE_MOVE_TIME)

	curr_location.move_contents_to(dest_location)
	curr_location = dest_location
	moving = 0
	return 1


/obj/machinery/computer/syndicate_station/attackby(obj/item/I as obj, mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/syndicate_station/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/syndicate_station/attack_paw(mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/syndicate_station/attack_hand(mob/user as mob)
	if(!allowed(user))
		user << "<span class='notice'>Access Denied.</span>"
		return

	user.set_machine(src)

	var/dat = {"Location: [curr_location]<br>
	Ready to move[max(lastMove + SYNDICATE_SHUTTLE_COOLDOWN - world.time, 0) ? " in [max(round((lastMove + SYNDICATE_SHUTTLE_COOLDOWN - world.time) * 0.1), 0)] seconds" : ": now"]<br>
	<a href='?src=\ref[src];syndicate=1'>Syndicate Space</a><br>
	<a href='?src=\ref[src];station_nw=1'>North West of SS13</a> |
	<a href='?src=\ref[src];station_n=1'>North of SS13</a> |
	<a href='?src=\ref[src];station_ne=1'>North East of SS13</a><br>
	<a href='?src=\ref[src];station_sw=1'>South West of SS13</a> |
	<a href='?src=\ref[src];station_s=1'>South of SS13</a> |
	<a href='?src=\ref[src];station_se=1'>South East of SS13</a><br>
	<a href='?src=\ref[src];commssat=1'>South of the Communication Satellite</a> |
	<a href='?src=\ref[src];mining=1'>North East of the Mining Asteroid</a><br>
	<a href='?src=\ref[user];mach_close=computer'>Close</a>"}

	user << browse(dat, "window=computer;size=575x450")
	onclose(user, "computer")
	return


/obj/machinery/computer/syndicate_station/Topic(href, href_list)
	if(!isliving(usr))	return
	var/mob/living/user = usr

	if(in_range(src, user) || istype(user, /mob/living/silicon))
		user.set_machine(src)

	if(href_list["syndicate"])
		syndicate_move_to(/area/syndicate_station/start)
	else if(href_list["station_nw"])
		syndicate_move_to(/area/syndicate_station/northwest)
	else if(href_list["station_n"])
		syndicate_move_to(/area/syndicate_station/north)
	else if(href_list["station_ne"])
		syndicate_move_to(/area/syndicate_station/northeast)
	else if(href_list["station_sw"])
		syndicate_move_to(/area/syndicate_station/southwest)
	else if(href_list["station_s"])
		syndicate_move_to(/area/syndicate_station/south)
	else if(href_list["station_se"])
		syndicate_move_to(/area/syndicate_station/southeast)
	else if(href_list["commssat"])
		syndicate_move_to(/area/syndicate_station/commssat)
	else if(href_list["mining"])
		syndicate_move_to(/area/syndicate_station/mining)

	add_fingerprint(usr)
	updateUsrDialog()
	return

/obj/machinery/computer/syndicate_station/bullet_act(var/obj/item/projectile/Proj)
	visible_message("[Proj] ricochets off [src]!")	//let's not let them fuck themselves in the rear
>>>>>>> remotes/git-svn
