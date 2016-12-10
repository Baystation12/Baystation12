/mob/living/bot/cleanbot
	name = "Cleanbot"
	desc = "A little cleaning robot, he looks so excited!"
	icon_state = "cleanbot0"
	req_one_access = list(access_janitor, access_robotics)
	botcard_access = list(access_janitor, access_maint_tunnels)

	locked = 0 // Start unlocked so roboticist can set them to patrol.

	var/obj/effect/decal/cleanable/target
	var/list/path = list()
	var/list/patrol_path = list()
	var/list/ignorelist = list()

	var/obj/cleanbot_listener/listener = null
	var/beacon_freq = 1445 // navigation beacon frequency
	var/signal_sent = 0
	var/closest_dist
	var/next_dest
	var/next_dest_loc

	var/cleaning = 0
	var/screwloose = 0
	var/oddbutton = 0
	var/should_patrol = 0
	var/blood = 1
	var/list/target_types = list()

	var/maximum_search_range = 7

/mob/living/bot/cleanbot/New()
	..()
	get_targets()

	listener = new /obj/cleanbot_listener(src)
	listener.cleanbot = src

	if(radio_controller)
		radio_controller.add_object(listener, beacon_freq, filter = RADIO_NAVBEACONS)

/mob/living/bot/cleanbot/Destroy()
	. = ..()
	path = null
	patrol_path = null
	target = null
	ignorelist = null

/mob/living/bot/cleanbot/proc/handle_target()
	if(loc == target.loc)
		if(!cleaning)
			UnarmedAttack(target)
			return 1
	if(!path.len)
//		spawn(0)
		path = AStar(loc, target.loc, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 30, id = botcard)
		if(!path)
			visible_message("\The [src] can't reach \the [target.name] and is giving up for now.")
			log_debug("[src] can't reach [target.name] ([target.x], [target.y])")
			ignorelist |= weakref(target)
			target = null
			path = list()
		return
	if(path.len)
		step_to(src, path[1])
		path -= path[1]
		return 1
	return

/mob/living/bot/cleanbot/Life()
	..()

	if(!on)
		ignorelist = list()
		return

	if(ignorelist.len && prob(2))
		ignorelist -= pick(ignorelist)

	if(client)
		return
	if(cleaning)
		return

	if(!screwloose && !oddbutton && prob(5))
		visible_message("\The [src] makes an excited beeping booping sound!")

	if(screwloose && prob(5)) // Make a mess
		if(istype(loc, /turf/simulated))
			var/turf/simulated/T = loc
			T.wet_floor()

	if(oddbutton && prob(5)) // Make a big mess
		visible_message("Something flies out of [src]. He seems to be acting oddly.")
		var/obj/effect/decal/cleanable/blood/gibs/gib = new /obj/effect/decal/cleanable/blood/gibs(loc)
		var/weakref/g = weakref(gib)
		ignorelist += g
		spawn(600)
			ignorelist -= g

		// Find a target

	if(pulledby) // Don't wiggle if someone pulls you
		patrol_path = list()
		return

	var/found_spot
	search_loop:
		for(var/i=0, i <= maximum_search_range, i++)
			cleanable_loop:
				for(var/obj/effect/decal/cleanable/D in view(i, src))
					for(var/item in ignorelist)
						var/weakref/wr = item
						if(wr.resolve() == D)
							continue cleanable_loop
					if(!turf_is_targetable(get_turf(D)))
						continue
					for(var/T in target_types)
						if(istype(D, T))
							patrol_path = list()
							target = D
							found_spot = handle_target()
							if (found_spot)
								break search_loop
							else
								target = null
								continue // no need to check the other types


	if(!found_spot && !target) // No targets in range
		if(!patrol_path || !patrol_path.len)
			if(!signal_sent || signal_sent > world.time + 200) // Waited enough or didn't send yet
				var/datum/radio_frequency/frequency = radio_controller.return_frequency(beacon_freq)
				if(!frequency)
					return

				closest_dist = 9999
				next_dest = null
				next_dest_loc = null

				var/datum/signal/signal = new()
				signal.source = src
				signal.transmission_method = 1
				signal.data = list("findbeakon" = "patrol")
				frequency.post_signal(src, signal, filter = RADIO_NAVBEACONS)
				signal_sent = world.time
			else
				if(next_dest)
					next_dest_loc = listener.memorized[next_dest]
					if(next_dest_loc)
						patrol_path = AStar(loc, next_dest_loc, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 120, id = botcard, exclude = null)
						signal_sent = 0
		else
			if(pulledby) // Don't wiggle if someone pulls you
				patrol_path = list()
				return
			if(patrol_path[1] == loc)
				patrol_path -= patrol_path[1]
			var/moved = step_towards(src, patrol_path[1])
			if(moved)
				patrol_path -= patrol_path[1]



/mob/living/bot/cleanbot/UnarmedAttack(var/obj/effect/decal/cleanable/D, var/proximity)
	if(!..())
		return

	if(!istype(D))
		return

	if(D.loc != loc)
		return

	cleaning = 1
	visible_message("\The [src] begins to clean up \the [D]")
	update_icons()
	var/cleantime = istype(D, /obj/effect/decal/cleanable/dirt) ? 10 : 50
	if(do_after(src, cleantime, progress = 0))
		if(istype(loc, /turf/simulated))
			var/turf/simulated/f = loc
			f.dirt = 0
		if(!D)
			return
		qdel(D)
		if(D == target)
			target = null
	cleaning = 0
	update_icons()

/mob/living/bot/cleanbot/explode()
	on = 0
	visible_message("<span class='danger'>[src] blows apart!</span>")
	var/turf/Tsec = get_turf(src)

	new /obj/item/weapon/reagent_containers/glass/bucket(Tsec)
	new /obj/item/device/assembly/prox_sensor(Tsec)
	if(prob(50))
		new /obj/item/robot_parts/l_arm(Tsec)

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(src)
	return

/mob/living/bot/cleanbot/update_icons()
	if(cleaning)
		icon_state = "cleanbot-c"
	else
		icon_state = "cleanbot[on]"

/mob/living/bot/cleanbot/turn_off()
	..()
	target = null
	path = list()
	patrol_path = list()

/mob/living/bot/cleanbot/attack_hand(var/mob/user)
	var/dat
	dat += "<TT><B>Automatic Station Cleaner v1.0</B></TT><BR><BR>"
	dat += "Status: <A href='?src=\ref[src];operation=start'>[on ? "On" : "Off"]</A><BR>"
	dat += "Behaviour controls are [locked ? "locked" : "unlocked"]<BR>"
	dat += "Maintenance panel is [open ? "opened" : "closed"]"
	if(!locked || issilicon(user))
		dat += "<BR>Cleans Blood: <A href='?src=\ref[src];operation=blood'>[blood ? "Yes" : "No"]</A><BR>"
		dat += "<BR>Patrol station: <A href='?src=\ref[src];operation=patrol'>[should_patrol ? "Yes" : "No"]</A><BR>"
	if(open && !locked)
		dat += "Odd looking screw twiddled: <A href='?src=\ref[src];operation=screw'>[screwloose ? "Yes" : "No"]</A><BR>"
		dat += "Weird button pressed: <A href='?src=\ref[src];operation=oddbutton'>[oddbutton ? "Yes" : "No"]</A>"

	user << browse("<HEAD><TITLE>Cleaner v1.0 controls</TITLE></HEAD>[dat]", "window=autocleaner")
	onclose(user, "autocleaner")
	return

/mob/living/bot/cleanbot/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	add_fingerprint(usr)
	switch(href_list["operation"])
		if("start")
			if(on)
				turn_off()
			else
				turn_on()
		if("blood")
			blood = !blood
			get_targets()
		if("patrol")
			should_patrol = !should_patrol
			patrol_path = null
		if("freq")
			var/freq = text2num(input("Select frequency for  navigation beacons", "Frequnecy", num2text(beacon_freq / 10))) * 10
			if (freq > 0)
				beacon_freq = freq
		if("screw")
			screwloose = !screwloose
			to_chat(usr, "<span class='notice'>You twiddle the screw.</span>")
		if("oddbutton")
			oddbutton = !oddbutton
			to_chat(usr, "<span class='notice'>You press the weird button.</span>")
	attack_hand(usr)

/mob/living/bot/cleanbot/emag_act(var/remaining_uses, var/mob/user)
	. = ..()
	if(!screwloose || !oddbutton)
		if(user)
			to_chat(user, "<span class='notice'>The [src] buzzes and beeps.</span>")
		oddbutton = 1
		screwloose = 1
		return 1

/mob/living/bot/cleanbot/proc/get_targets()
	target_types = list()

	target_types += /obj/effect/decal/cleanable/blood/oil
	target_types += /obj/effect/decal/cleanable/vomit
	target_types += /obj/effect/decal/cleanable/crayon
	target_types += /obj/effect/decal/cleanable/liquid_fuel
	target_types += /obj/effect/decal/cleanable/mucus
	target_types += /obj/effect/decal/cleanable/dirt

	if(blood)
		target_types += /obj/effect/decal/cleanable/blood

/* Radio object that listens to signals */

/obj/cleanbot_listener
	var/mob/living/bot/cleanbot/cleanbot = null
	var/list/memorized = list()

/obj/cleanbot_listener/receive_signal(var/datum/signal/signal)
	var/recv = signal.data["beacon"]
	var/valid = signal.data["patrol"]
	if(!recv || !valid || !cleanbot)
		return

	var/dist = get_dist(cleanbot, signal.source.loc)
	memorized[recv] = signal.source.loc

	if(dist < cleanbot.closest_dist) // We check all signals, choosing the closest beakon; then we move to the NEXT one after the closest one
		cleanbot.closest_dist = dist
		cleanbot.next_dest = signal.data["next_patrol"]

/* Assembly */

/obj/item/weapon/bucket_sensor
	desc = "It's a bucket. With a sensor attached."
	name = "proxy bucket"
	icon = 'icons/obj/aibots.dmi'
	icon_state = "bucket_proxy"
	force = 3.0
	throwforce = 10.0
	throw_speed = 2
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL
	var/created_name = "Cleanbot"

/obj/item/weapon/bucket_sensor/attackby(var/obj/item/O, var/mob/user)
	..()
	if(istype(O, /obj/item/robot_parts/l_arm) || istype(O, /obj/item/robot_parts/r_arm))
		user.drop_item()
		qdel(O)
		var/turf/T = get_turf(loc)
		var/mob/living/bot/cleanbot/A = new /mob/living/bot/cleanbot(T)
		A.name = created_name
		to_chat(user, "<span class='notice'>You add the robot arm to the bucket and sensor assembly. Beep boop!</span>")
		user.drop_from_inventory(src)
		qdel(src)

	else if(istype(O, /obj/item/weapon/pen))
		var/t = sanitizeSafe(input(user, "Enter new robot name", name, created_name), MAX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, usr) && src.loc != usr)
			return
		created_name = t
