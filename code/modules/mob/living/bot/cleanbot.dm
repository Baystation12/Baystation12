/mob/living/bot/cleanbot
	name = "Cleanbot"
	desc = "A little cleaning robot, he looks so excited!"
	icon_state = "cleanbot0"
	req_one_access = list(access_janitor, access_robotics)
	botcard_access = list(access_janitor, access_maint_tunnels)

	wait_if_pulled = 1
	min_target_dist = 0

	var/cleaning = 0
	var/screwloose = 0
	var/oddbutton = 0
	var/blood = 1
	var/list/target_types = list()

/mob/living/bot/cleanbot/New()
	..()
	get_targets()

/mob/living/bot/cleanbot/handleIdle()
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
		ignore_list += g
		spawn(600)
			ignore_list -= g

/mob/living/bot/cleanbot/lookForTargets()
	for(var/obj/effect/decal/cleanable/D in view(world.view, src)) // There was some odd code to make it start with nearest decals, it's unnecessary, this works
		if(confirmTarget(D))
			target = D
			return

/mob/living/bot/cleanbot/confirmTarget(var/obj/effect/decal/cleanable/D)
	if(!..())
		return 0
	for(var/T in target_types)
		if(istype(D, T))
			return 1
	return 0

/mob/living/bot/cleanbot/handleAdjacentTarget()
	if(get_turf(target) == src.loc)
		UnarmedAttack(target)

/mob/living/bot/cleanbot/UnarmedAttack(var/obj/effect/decal/cleanable/D, var/proximity)
	if(!..())
		return

	if(!istype(D))
		return

	if(D.loc != loc)
		return

	busy = 1
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
	busy = 0
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
	if(busy)
		icon_state = "cleanbot-c"
	else
		icon_state = "cleanbot[on]"

/mob/living/bot/cleanbot/GetInteractTitle()
	. = "<head><title>Cleanbot controls</title></head>"
	. += "<b>Automatic Cleaner v1.0</b>"

/mob/living/bot/cleanbot/GetInteractPanel()
	. = "Cleans blood: <a href='?src=\ref[src];command=blood'>[blood ? "Yes" : "No"]</a>"
	. += "<br>Patrol station: <a href='?src=\ref[src];command=patrol'>[will_patrol ? "Yes" : "No"]</a>"

/mob/living/bot/cleanbot/GetInteractMaintenance()
	. = "Odd looking screw twiddled: <a href='?src=\ref[src];command=screw'>[screwloose ? "Yes" : "No"]</a>"
	. += "<br>Weird button pressed: <a href='?src=\ref[src];command=oddbutton'>[oddbutton ? "Yes" : "No"]</a>"

/mob/living/bot/cleanbot/ProcessCommand(var/mob/user, var/command, var/href_list)
	..()
	if(CanAccessPanel(user))
		switch(command)
			if("blood")
				blood = !blood
				get_targets()
			if("patrol")
				will_patrol = !will_patrol
				patrol_path = null

	if(CanAccessMaintenance(user))
		switch(command)
			if("screw")
				screwloose = !screwloose
			if("oddbutton")
				oddbutton = !oddbutton

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
	target_types += /obj/effect/decal/cleanable/marker
	target_types += /obj/effect/decal/cleanable/liquid_fuel
	target_types += /obj/effect/decal/cleanable/mucus
	target_types += /obj/effect/decal/cleanable/dirt

	if(blood)
		target_types += /obj/effect/decal/cleanable/blood

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
